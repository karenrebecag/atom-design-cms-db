import { createClient } from "jsr:@supabase/supabase-js@2";

// Payload guarda los casos de uso en una tabla hija; se aplanan a `use_cases: string[]` para que la
// respuesta siga siendo la que leían los conectores cuando la fuente era `image_prompts`.
const USE_CASES_EMBED = "prompt_templates_use_cases(value, _order)";

type UseCaseRow = { value: string; _order: number };

function conUseCases<T extends { prompt_templates_use_cases?: UseCaseRow[] }>(row: T) {
  const { prompt_templates_use_cases: filas = [], ...resto } = row;
  const use_cases = [...filas].sort((a, b) => a._order - b._order).map((f) => f.value);
  return { ...resto, use_cases };
}

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
      .from("prompt_templates")
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

  // GET: by name, use_case, or list
  const url = new URL(req.url);
  const name = url.searchParams.get("name");
  const useCase = url.searchParams.get("use_case");
  const category = url.searchParams.get("category");

  // Match by use_case — lightweight lookup, returns name + use_cases only
  if (useCase) {
    const { data, error } = await supabase
      .from("prompt_templates")
      .select(`name, category, ${USE_CASES_EMBED}`)
      .order("id");

    const matches = (data ?? []).map(conUseCases).filter((p) => p.use_cases.includes(useCase));

    if (error || matches.length === 0) {
      return new Response(
        JSON.stringify({ error: `No prompt found for use case "${useCase}"`, available_use_cases: "Use GET without params to list all" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ matches }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  if (name) {
    const { data, error } = await supabase
      .from("prompt_templates")
      .select(`id, name, category, template, variables, created_at, updated_at, ${USE_CASES_EMBED}`)
      .eq("name", name)
      .maybeSingle();

    if (error || !data) {
      return new Response(
        JSON.stringify({ error: "Prompt not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ prompt: conUseCases(data) }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // LIST: all prompts or filtered by category
  const query = supabase
    .from("prompt_templates")
    .select(`id, name, category, created_at, ${USE_CASES_EMBED}`)
    .order("category")
    .order("id");

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
    JSON.stringify({ prompts: (data ?? []).map(conUseCases) }),
    { headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
