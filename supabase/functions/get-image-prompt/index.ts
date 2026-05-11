import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-service-key",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  // Auth: require service key — this endpoint is NOT public
  const serviceKey = Deno.env.get("RESTRICTED_CONTENT_SECRET");
  const providedKey = req.headers.get("x-service-key");
  if (!serviceKey || providedKey !== serviceKey) {
    return new Response(
      JSON.stringify({ error: "Unauthorized" }),
      { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // POST: fill template with provided values
  if (req.method === "POST") {
    const body = await req.json();
    const { prompt_name, values } = body;

    if (!prompt_name || !values) {
      return new Response(
        JSON.stringify({ error: "prompt_name and values required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const { data, error } = await supabase
      .from("image_prompts")
      .select("template, variables")
      .eq("name", prompt_name)
      .maybeSingle();

    if (error || !data) {
      return new Response(
        JSON.stringify({ error: "Prompt not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    let filled = data.template;
    const vars = data.variables as Record<string, { default?: string }>;

    for (const [key, meta] of Object.entries(vars)) {
      const value = values[key] ?? meta.default ?? `[${key}]`;
      filled = filled.replace(new RegExp(`\\[${key}\\]`, "g"), value);
    }

    return new Response(
      JSON.stringify({ prompt: filled }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // GET by name: returns single prompt with template + variables
  const url = new URL(req.url);
  const name = url.searchParams.get("name");
  const category = url.searchParams.get("category");

  if (name) {
    const { data, error } = await supabase
      .from("image_prompts")
      .select("*")
      .eq("name", name)
      .maybeSingle();

    if (error || !data) {
      return new Response(
        JSON.stringify({ error: "Prompt not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ prompt: data }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // LIST: all prompts or filtered by category
  const query = supabase
    .from("image_prompts")
    .select("id, name, category, variables, created_at")
    .order("category");

  if (category) {
    query.eq("category", category);
  }

  const { data, error } = await query;

  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ prompts: data }),
    { headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
