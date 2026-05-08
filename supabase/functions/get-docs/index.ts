import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const ALLOWED_ORIGIN = "https://brand.atomchat.io";

const corsHeaders = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGIN,
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-restricted-access",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const url = new URL(req.url);
  const slug = url.searchParams.get("slug");

  // Single doc by slug
  if (slug) {
    const { data: doc, error } = await supabase
      .from("docs")
      .select("id, title, slug, description, category_id, parent_id, order, sidebar_label, show_in_sidebar, restricted, _status, created_at, updated_at")
      .eq("slug", slug)
      .eq("_status", "published")
      .limit(1)
      .maybeSingle();

    if (error || !doc) {
      return new Response(
        JSON.stringify({ error: "Doc not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    // Restricted docs: require secret header to serve blocks
    if (doc.restricted) {
      const restrictedSecret = Deno.env.get("RESTRICTED_CONTENT_SECRET");
      const providedSecret = req.headers.get("x-restricted-access");
      if (!restrictedSecret || providedSecret !== restrictedSecret) {
        return new Response(
          JSON.stringify({ doc, blocks: [], restricted: true }),
          { headers: { ...corsHeaders, "Content-Type": "application/json" } },
        );
      }
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
      { table: "docs_blocks_color_swatch", type: "colorSwatch" },
      { table: "docs_blocks_dos_donts", type: "dosDonts" },
      { table: "docs_blocks_download_button", type: "downloadButton" },
      { table: "docs_blocks_contact_card", type: "contactCard" },
      { table: "docs_blocks_nav_link", type: "navLink" },
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

    // Hydrate imageBlock and contactCard blocks with media URLs via Payload API
    const imageBlocks = blocks.filter(
      (b) => (b.blockType === "imageBlock" || b.blockType === "contactCard") && b.image_id,
    );
    if (imageBlocks.length > 0) {
      const cmsUrl = Deno.env.get("CMS_URL") ?? "https://brand-admin.atomchat.io";
      const imageIds = imageBlocks.map((b) => b.image_id as string);
      const idsParam = imageIds.join(",");

      try {
        const res = await fetch(
          `${cmsUrl}/api/media?where[id][in]=${idsParam}&limit=${imageIds.length}&depth=0`,
        );
        const json = await res.json();
        const mediaById: Record<string, Record<string, unknown>> = {};
        for (const m of json.docs ?? []) {
          mediaById[String(m.id)] = m;
        }

        for (const block of imageBlocks) {
          const media = mediaById[String(block.image_id)];
          if (media) {
            const rawUrl = media.url as string | undefined;
            block.image_url = rawUrl?.startsWith("http") ? rawUrl : `${cmsUrl}${rawUrl}`;
            block.image_alt = media.alt;
            block.image_width = media.width;
            block.image_height = media.height;
          }
        }
      } catch (_err) {
        // Non-fatal: images will be missing but doc still renders
      }
    }

    // Hydrate sub-items for steps blocks
    for (const block of blocks) {
      if (block.blockType === "steps") {
        const { data: stepsData } = await supabase
          .from("docs_blocks_steps_steps")
          .select("*")
          .eq("_parent_id", block.id)
          .order("_order");
        block.steps = stepsData ?? [];
      }
    }

    // Hydrate sub-items for dosDonts blocks
    for (const block of blocks) {
      if (block.blockType === "dosDonts") {
        const [dosRes, dontsRes] = await Promise.all([
          supabase.from("docs_blocks_dos_donts_dos").select("*").eq("_parent_id", block.id).order("_order"),
          supabase.from("docs_blocks_dos_donts_donts").select("*").eq("_parent_id", block.id).order("_order"),
        ]);
        block.dos = dosRes.data ?? [];
        block.donts = dontsRes.data ?? [];
      }
    }

    // Hydrate sub-items for table blocks (headers + rows with cells)
    for (const block of blocks) {
      if (block.blockType === "table") {
        const [headersRes, rowsRes] = await Promise.all([
          supabase.from("docs_blocks_table_headers").select("id, label, _order").eq("_parent_id", block.id).order("_order"),
          supabase.from("docs_blocks_table_rows").select("id, _order").eq("_parent_id", block.id).order("_order"),
        ]);
        block.headers = headersRes.data ?? [];

        const rows = rowsRes.data ?? [];
        if (rows.length > 0) {
          const rowIds = rows.map((r: Record<string, unknown>) => r.id as string);
          const { data: cells } = await supabase
            .from("docs_blocks_table_rows_cells")
            .select("id, value, _order, _parent_id")
            .in("_parent_id", rowIds)
            .order("_order");

          const cellsByRow: Record<string, { value: string; _order: number }[]> = {};
          for (const cell of cells ?? []) {
            const pid = cell._parent_id as string;
            if (!cellsByRow[pid]) cellsByRow[pid] = [];
            cellsByRow[pid].push({ value: cell.value as string, _order: cell._order as number });
          }
          block.rows = rows.map((r: Record<string, unknown>) => ({
            _order: r._order,
            cells: (cellsByRow[r.id as string] ?? []).sort((a, b) => a._order - b._order),
          }));
        } else {
          block.rows = [];
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
    .select("id, title, slug, description, category_id, parent_id, order, sidebar_label, show_in_sidebar, restricted, _status")
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
