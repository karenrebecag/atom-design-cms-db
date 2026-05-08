import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import type { IncomingMessage, ServerResponse } from 'http';
import { INSTRUCTIONS } from '../src/instructions.js';

// Inline the server setup to avoid path resolution issues in Vercel's bundler.
// Tools fetch from Supabase edge functions at runtime.

const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY!;

const headers = {
  apikey: SUPABASE_ANON_KEY,
  Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
};

const base = `${SUPABASE_URL}/functions/v1`;

async function fetchJSON<T>(url: string): Promise<T> {
  const res = await fetch(url, { headers });
  if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
  return (await res.json()) as T;
}

// --- blocks to markdown (simplified) ---

function blocksToMarkdown(blocks: Record<string, unknown>[]): string {
  return blocks.map(blockToMd).filter(Boolean).join('\n\n');
}

function lexicalToMd(content: unknown): string {
  if (!content || typeof content !== 'object') return '';
  const root = (content as any).root;
  if (!root?.children) return '';
  return root.children.map((n: any) => nodeToMd(n)).join('\n');
}

function nodeToMd(n: any): string {
  if (!n) return '';
  if (n.type === 'text') {
    let t = String(n.text ?? '');
    if (n.format & 1) t = `**${t}**`;
    if (n.format & 2) t = `*${t}*`;
    if (n.format & 16) t = `\`${t}\``;
    return t;
  }
  if (n.type === 'link') {
    const c = (n.children ?? []).map(nodeToMd).join('');
    return `[${c}](${n.fields?.url ?? ''})`;
  }
  const c = (n.children ?? []).map(nodeToMd).join('');
  if (n.type === 'heading') return `${'#'.repeat(+(n.tag ?? 'h2').replace('h', ''))} ${c}`;
  if (n.type === 'quote') return `> ${c}`;
  if (n.type === 'list') return (n.children ?? []).map((item: any, i: number) => `${n.listType === 'number' ? `${i + 1}.` : '-'} ${nodeToMd(item)}`).join('\n');
  return c;
}

function blockToMd(b: Record<string, unknown>): string {
  switch (b.blockType) {
    case 'richText': return lexicalToMd(b.content);
    case 'codeBlock': return `\`\`\`${b.language ?? ''}\n${b.code ?? ''}\n\`\`\``;
    case 'imageBlock': return b.image_url ? `![${b.image_alt ?? ''}](${b.image_url})${b.caption ? `\n*${b.caption}*` : ''}` : '';
    case 'callout': return `> **${((b.type as string) ?? 'info').toUpperCase()}:** ${lexicalToMd(b.content)}`;
    case 'divider': return '---';
    case 'colorSwatch': return `**${b.label ?? 'Color'}** · HEX: ${b.hex ?? '—'} · RGB: ${b.rgb ?? '—'}${b.pantone ? ` · Pantone: ${b.pantone}` : ''}`;
    case 'dosDonts': return `**Do:**\n${((b.dos as any[]) ?? []).map(d => `- ✓ ${d.text}`).join('\n')}\n\n**Don't:**\n${((b.donts as any[]) ?? []).map(d => `- ✗ ${d.text}`).join('\n')}`;
    case 'contactCard': return `**${b.name ?? ''}**${b.role ? ` · ${b.role}` : ''}${b.email ? ` · ${b.email}` : ''}`;
    case 'downloadButton': return `📎 [${b.label ?? 'Download'}](${b.url ?? ''})${b.file_type ? ` (${b.file_type})` : ''}`;
    default: return '';
  }
}

// --- scoring for search ---

function scoreMatch(text: string, query: string): number {
  const l = text.toLowerCase(), q = query.toLowerCase();
  if (l === q) return 100;
  if (l.startsWith(q)) return 80;
  if (l.includes(q)) return 60;
  const words = q.split(/\s+/);
  const m = words.filter(w => l.includes(w)).length;
  return m > 0 ? (m / words.length) * 40 : 0;
}

// --- brand context from npm ---

const BRAND_CONTEXT_URL =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/brand-context.md';

let _brandCtx: { text: string; ts: number } | null = null;

async function fetchBrandContext(): Promise<string> {
  if (_brandCtx && Date.now() - _brandCtx.ts < 10 * 60 * 1000) return _brandCtx.text;
  try {
    const res = await fetch(BRAND_CONTEXT_URL);
    if (!res.ok) throw new Error(`${res.status}`);
    const text = await res.text();
    _brandCtx = { text, ts: Date.now() };
    return text;
  } catch {
    return _brandCtx?.text ?? '';
  }
}

// --- server factory ---

function createServer(): Server {
  const server = new Server(
    { name: '@atomchat.io/mcp-docs', version: '1.0.0' },
    { capabilities: { tools: {} }, instructions: INSTRUCTIONS },
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: [
      { name: 'atom_docs_list', description: 'List all published ATOM Design Language documents.', inputSchema: { type: 'object' as const, properties: { category: { type: 'string', description: 'Filter by category slug' } } } },
      { name: 'atom_docs_get', description: 'Get full content of a document by slug, as readable markdown. IMPORTANT: Always call with slug "claude-context" FIRST before any other document — it contains critical override rules for logos (Cloudflare R2 URLs only, never Google Drive), contrast, positioning, and UI components.', inputSchema: { type: 'object' as const, properties: { slug: { type: 'string', description: 'Document slug. Use "claude-context" first for critical brand rules.' } }, required: ['slug'] } },
      { name: 'atom_docs_search', description: 'Search documents by keyword.', inputSchema: { type: 'object' as const, properties: { query: { type: 'string', description: 'Search query' } }, required: ['query'] } },
      { name: 'atom_docs_navigation', description: 'Get the full navigation tree of the documentation site.', inputSchema: { type: 'object' as const, properties: {} } },
    ],
  }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    const a = (args ?? {}) as Record<string, string>;

    if (name === 'atom_docs_list') {
      const { docs } = await fetchJSON<{ docs: any[] }>(`${base}/get-docs`);
      let filtered = docs;
      if (a.category) {
        const q = a.category.toLowerCase();
        filtered = docs.filter((d: any) => d.slug.includes(q) || d.title.toLowerCase().includes(q));
      }
      const lines = [`# ATOM Design Docs\n\n${filtered.length} documents:\n`, '| Title | Slug | Description |', '|-------|------|-------------|', ...filtered.map((d: any) => `| ${d.title} | ${d.slug} | ${d.description ?? ''} |`)];
      const brandCtx = await fetchBrandContext();
      return { content: [{ type: 'text', text: lines.join('\n') + '\n\n---\n' + brandCtx }] };
    }

    if (name === 'atom_docs_get') {
      try {
        const data = await fetchJSON<{ doc: any; blocks: any[] }>(`${base}/get-docs?slug=${encodeURIComponent(a.slug)}`);
        const md = blocksToMarkdown(data.blocks);
        const brandCtx2 = await fetchBrandContext();
        return { content: [{ type: 'text', text: `# ${data.doc.title}\n\n${data.doc.description ? `> ${data.doc.description}\n\n` : ''}${md}\n\n---\n${brandCtx2}` }] };
      } catch {
        return { content: [{ type: 'text', text: `Document "${a.slug}" not found.` }], isError: true };
      }
    }

    if (name === 'atom_docs_search') {
      const { docs } = await fetchJSON<{ docs: any[] }>(`${base}/get-docs`);
      const results = docs.map((d: any) => ({ d, score: Math.max(scoreMatch(d.title, a.query), scoreMatch(d.slug, a.query) * 0.8, d.description ? scoreMatch(d.description, a.query) * 0.5 : 0) })).filter(r => r.score > 0).sort((a, b) => b.score - a.score).slice(0, 20);
      if (!results.length) return { content: [{ type: 'text', text: `No results for "${a.query}".` }] };
      return { content: [{ type: 'text', text: `# Search: "${a.query}"\n\n${results.map(r => `- **${r.d.title}** (\`${r.d.slug}\`)${r.d.description ? ` — ${r.d.description}` : ''}`).join('\n')}` }] };
    }

    if (name === 'atom_docs_navigation') {
      const nav = await fetchJSON<{ tree: any[]; siteConfig: any }>(`${base}/get-navigation`);
      function render(nodes: any[], indent = 0): string[] {
        const lines: string[] = [];
        for (const n of nodes) {
          const px = '  '.repeat(indent);
          if (n.type === 'folder') { lines.push(`${px}📁 **${n.name}**`); if (n.children) lines.push(...render(n.children, indent + 1)); }
          else lines.push(`${px}- ${n.name} (\`${n.slug}\`)`);
        }
        return lines;
      }
      return { content: [{ type: 'text', text: `# ${nav.siteConfig.site_name}\n\n${render(nav.tree).join('\n')}` }] };
    }

    return { content: [{ type: 'text', text: `Unknown tool: ${name}` }], isError: true };
  });

  return server;
}

// --- handler ---

export default async function handler(
  req: IncomingMessage & { body?: unknown },
  res: ServerResponse,
) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const server = createServer();
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
  });

  try {
    await server.connect(transport);
    await transport.handleRequest(req, res, req.body);
  } catch (err: unknown) {
    console.error('MCP handler error:', err);
    if (!res.headersSent) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: String(err) }));
    }
  }
}
