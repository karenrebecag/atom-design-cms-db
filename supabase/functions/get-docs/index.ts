import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
  );

  const url = new URL(req.url);
  const slug = url.searchParams.get("slug");

  // Single doc by slug
  if (slug) {
    const { data: doc, error } = await supabase
      .from("docs")
      .select("id, title, slug, description, category_id, parent_id, order, sidebar_label, show_in_sidebar, _status, created_at, updated_at")
      .eq("slug", slug)
      .eq("_status", "published")
      .single();

    if (error || !doc) {
      return new Response(
        JSON.stringify({ error: "Doc not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    // Fetch all block types for this doc
    const blockTables = [
      { table: "docs_blocks_rich_text", type: "richText" },
      { table: "docs_blocks_code_block", type: "codeBlock" },
      { table: "docs_blocks_image_block", type: "imageBlock" },
      { table: "docs_blocks_callout", type: "callout" },
      { table: "docs_blocks_steps", type: "steps" },
      { table: "docs_blocks_card_grid", type: "cardGrid" },
      { table: "docs_blocks_table", type: "table" },
      { table: "docs_blocks_divider", type: "divider" },
    ];

    const blocks: Record<string, unknown>[] = [];

    for (const { table, type } of blockTables) {
      const { data } = await supabase
        .from(table)
        .select("*")
        .eq("_parent_id", doc.id)
        .order("_order");

      if (data && data.length > 0) {
        for (const block of data) {
          blocks.push({ ...block, blockType: type });
        }
      }
    }

    // Sort all blocks by _order
    blocks.sort((a, b) => (a._order as number) - (b._order as number));

    return new Response(
      JSON.stringify({ doc, blocks }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // List all published docs
  const { data: docs, error } = await supabase
    .from("docs")
    .select("id, title, slug, description, category_id, parent_id, order, sidebar_label, show_in_sidebar, _status")
    .eq("_status", "published")
    .order("order");

  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ docs }),
    { headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
