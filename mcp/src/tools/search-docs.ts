import { fetchDocs } from '../client.js';

export const searchDocsSchema = {
  type: 'object' as const,
  properties: {
    query: {
      type: 'string',
      description: 'Search query (e.g. "logo", "color", "tipografía", "contacto")',
    },
  },
  required: ['query'],
};

function scoreMatch(text: string, query: string): number {
  const lower = text.toLowerCase();
  const q = query.toLowerCase();

  if (lower === q) return 100;
  if (lower.startsWith(q)) return 80;
  if (lower.includes(q)) return 60;

  const words = q.split(/\s+/);
  const matched = words.filter((w) => lower.includes(w)).length;
  if (matched > 0) return (matched / words.length) * 40;

  return 0;
}

export async function handleSearchDocs(args: unknown) {
  const { query } = args as { query: string };

  if (!query || query.trim().length === 0) {
    return {
      content: [{ type: 'text' as const, text: 'Please provide a search query.' }],
      isError: true,
    };
  }

  const docs = await fetchDocs();

  const results = docs
    .map((doc) => {
      const titleScore = scoreMatch(doc.title, query);
      const slugScore = scoreMatch(doc.slug, query) * 0.8;
      const descScore = doc.description ? scoreMatch(doc.description, query) * 0.5 : 0;
      const score = Math.max(titleScore, slugScore, descScore);
      return { doc, score };
    })
    .filter((r) => r.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, 20);

  if (results.length === 0) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `No documents found for "${query}". Use atom_docs_list to see all available documents.`,
        },
      ],
    };
  }

  const lines = [
    `# Search: "${query}"`,
    '',
    `${results.length} results:`,
    '',
    ...results.map((r) => {
      const desc = r.doc.description ? ` — ${r.doc.description}` : '';
      return `- **${r.doc.title}** (\`${r.doc.slug}\`)${desc}`;
    }),
    '',
    'Use `atom_docs_get` with a slug to read the full document.',
  ];

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') }],
  };
}
