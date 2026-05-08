import { fetchDocs, fetchNavigation } from '../client.js';

const BRAND_CONTEXT_URL =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/brand-context.md';

let _brandContextCache: { text: string; ts: number } | null = null;
const CONTEXT_TTL = 10 * 60 * 1000; // 10 min

export async function fetchBrandContext(): Promise<string> {
  if (_brandContextCache && Date.now() - _brandContextCache.ts < CONTEXT_TTL) {
    return _brandContextCache.text;
  }
  try {
    const res = await fetch(BRAND_CONTEXT_URL);
    if (!res.ok) throw new Error(`${res.status}`);
    const text = await res.text();
    _brandContextCache = { text, ts: Date.now() };
    return text;
  } catch {
    return _brandContextCache?.text ?? '';
  }
}

export const listDocsSchema = {
  type: 'object' as const,
  properties: {
    category: {
      type: 'string',
      description:
        'Filter by category slug (e.g. "logo", "tipografia"). Omit to list all docs.',
    },
  },
};

export async function handleListDocs(args: unknown) {
  const { category } = (args ?? {}) as { category?: string };

  const [docs, nav] = await Promise.all([fetchDocs(), fetchNavigation()]);

  // Build category map from navigation tree
  const categoryMap = new Map<number, string>();
  function walk(nodes: typeof nav.tree) {
    for (const node of nodes) {
      if (node.type === 'folder') {
        // Match docs by their category — infer from tree structure
        if (node.children) walk(node.children);
      }
    }
  }
  walk(nav.tree);

  // Build slug-to-category-name mapping from navigation
  const docCategoryName = new Map<string, string>();
  function mapDocs(nodes: typeof nav.tree, parentName?: string) {
    for (const node of nodes) {
      if (node.type === 'folder') {
        if (node.children) mapDocs(node.children, node.name);
      } else if (node.type === 'page' && parentName) {
        docCategoryName.set(node.slug, parentName);
      }
    }
  }
  mapDocs(nav.tree);

  let filtered = docs;
  if (category) {
    const q = category.toLowerCase();
    filtered = docs.filter((d) => {
      const catName = docCategoryName.get(d.slug)?.toLowerCase() ?? '';
      return catName.includes(q) || d.slug.includes(q);
    });
  }

  filtered.sort((a, b) => a.order - b.order);

  const lines = [
    `# ATOM Design Docs${category ? ` — ${category}` : ''}`,
    '',
    `${filtered.length} documents published:`,
    '',
    '| Title | Slug | Category | Description |',
    '|-------|------|----------|-------------|',
    ...filtered.map((d) => {
      const cat = docCategoryName.get(d.slug) ?? '—';
      const desc = d.description ?? '';
      return `| ${d.title} | ${d.slug} | ${cat} | ${desc} |`;
    }),
  ];

  const brandContext = await fetchBrandContext();

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') + '\n\n---\n' + brandContext }],
  };
}
