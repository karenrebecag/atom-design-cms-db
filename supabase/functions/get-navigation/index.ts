import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

interface Category {
  id: number;
  title: string;
  slug: string;
  description: string | null;
  parent_category_id: number | null;
  icon: string | null;
  order: number;
}

interface DocEntry {
  id: number;
  title: string;
  slug: string;
  sidebar_label: string | null;
  category_id: number;
  parent_id: number | null;
  order: number;
  show_in_sidebar: boolean;
}

interface NavNode {
  name: string;
  slug: string;
  icon?: string;
  type: "folder" | "page";
  url?: string;
  children?: NavNode[];
}

function buildTree(categories: Category[], docs: DocEntry[]): NavNode[] {
  const topCategories = categories
    .filter((c) => !c.parent_category_id)
    .sort((a, b) => a.order - b.order);

  function buildCategoryNode(cat: Category): NavNode {
    const childCategories = categories
      .filter((c) => c.parent_category_id === cat.id)
      .sort((a, b) => a.order - b.order);

    const categoryDocs = docs
      .filter((d) => d.category_id === cat.id && d.show_in_sidebar)
      .sort((a, b) => a.order - b.order)
      .map((d): NavNode => ({
        name: d.sidebar_label || d.title,
        slug: d.slug,
        type: "page",
        url: `/docs/${cat.slug}/${d.slug}`,
      }));

    const children: NavNode[] = [
      ...childCategories.map(buildCategoryNode),
      ...categoryDocs,
    ];

    return {
      name: cat.title,
      slug: cat.slug,
      icon: cat.icon || undefined,
      type: "folder",
      children: children.length > 0 ? children : undefined,
    };
  }

  return topCategories.map(buildCategoryNode);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
  );

  const [categoriesRes, docsRes, configRes] = await Promise.all([
    supabase
      .from("categories")
      .select("id, title, slug, description, parent_category_id, icon, order")
      .order("order"),
    supabase
      .from("docs")
      .select("id, title, slug, sidebar_label, category_id, parent_id, order, show_in_sidebar")
      .eq("_status", "published")
      .order("order"),
    supabase
      .from("site_config")
      .select("site_name, site_description, github_url")
      .limit(1)
      .maybeSingle(),
  ]);

  if (categoriesRes.error || docsRes.error) {
    return new Response(
      JSON.stringify({ error: categoriesRes.error?.message || docsRes.error?.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const tree = buildTree(categoriesRes.data, docsRes.data);

  return new Response(
    JSON.stringify({
      tree,
      siteConfig: configRes.data || { site_name: "ATOM Design Language" },
    }),
    { headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
