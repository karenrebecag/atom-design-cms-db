import type { IncomingMessage, ServerResponse } from 'http';

const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY!;
const SERVICE_KEY = process.env.RESTRICTED_CONTENT_SECRET!;

const supaHeaders = {
  apikey: SUPABASE_ANON_KEY,
  Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
  'Content-Type': 'application/json',
};

const base = `${SUPABASE_URL}/functions/v1`;

function json(res: ServerResponse, data: unknown, status = 200) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

function lexicalToText(content: any): string {
  if (!content?.root?.children) return '';
  return content.root.children.map((n: any) => nodeToText(n)).filter(Boolean).join('\n');
}

function nodeToText(n: any): string {
  if (!n) return '';
  if (n.type === 'text') return n.text ?? '';
  const c = (n.children ?? []).map(nodeToText).join('');
  if (n.type === 'heading') return `${'#'.repeat(+(n.tag ?? 'h2').replace('h', ''))} ${c}`;
  if (n.type === 'listitem') return `- ${c}`;
  return c;
}

function blockToCompact(b: any): string {
  switch (b.blockType) {
    case 'richText': return lexicalToText(b.content);
    case 'callout': return `> ${lexicalToText(b.content)}`;
    case 'colorSwatch': return `${b.label}: ${b.hex}${b.usage ? ` (${b.usage})` : ''}`;
    case 'dosDonts': return `Do: ${(b.dos ?? []).map((d: any) => d.text).join('; ')}\nDon't: ${(b.donts ?? []).map((d: any) => d.text).join('; ')}`;
    case 'downloadButton': return `[${b.label}](${b.url})`;
    case 'divider': return '---';
    default: return '';
  }
}

export default async function handler(req: IncomingMessage & { body?: any }, res: ServerResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  const url = new URL(req.url ?? '/', `https://${req.headers.host}`);
  const path = url.pathname.replace('/gpt', '').replace(/^\//, '') || 'help';

  try {
    // GET /gpt/docs — compact list of all docs
    if (path === 'docs' && !url.searchParams.get('slug')) {
      const r = await fetch(`${base}/get-docs`, { headers: supaHeaders });
      const d = await r.json() as { docs: any[] };
      return json(res, d.docs.map((doc: any) => ({
        slug: doc.slug,
        title: doc.title,
        description: (doc.description ?? '').slice(0, 120),
      })));
    }

    // GET /gpt/docs?slug=colores — single doc as markdown
    if (path === 'docs' && url.searchParams.get('slug')) {
      const slug = url.searchParams.get('slug')!;
      const r = await fetch(`${base}/get-docs?slug=${encodeURIComponent(slug)}`, { headers: supaHeaders });
      if (!r.ok) return json(res, { error: 'not found' }, 404);
      const d = await r.json() as { doc: any; blocks: any[] };
      const md = d.blocks.map(blockToCompact).filter(Boolean).join('\n\n');
      return json(res, {
        title: d.doc.title,
        slug: d.doc.slug,
        content: md.slice(0, 90000),
      });
    }

    // GET /gpt/nav — compact navigation tree
    if (path === 'nav') {
      const r = await fetch(`${base}/get-navigation`, { headers: supaHeaders });
      const d = await r.json() as { tree: any[] };
      function flatten(nodes: any[], cat = ''): { slug: string; title: string; category: string }[] {
        const out: any[] = [];
        for (const n of nodes) {
          if (n.type === 'folder') out.push(...flatten(n.children ?? [], n.name));
          else out.push({ slug: n.slug, title: n.name, category: cat });
        }
        return out;
      }
      return json(res, flatten(d.tree));
    }

    // GET /gpt/image-prompt?use_case=linkedin-post — find template
    if (path === 'image-prompt' && req.method === 'GET') {
      const useCase = url.searchParams.get('use_case');
      if (!useCase) return json(res, { error: 'use_case required' }, 400);
      const r = await fetch(`${base}/get-image-prompt?use_case=${encodeURIComponent(useCase)}`, {
        headers: { ...supaHeaders, 'x-service-key': SERVICE_KEY },
      });
      if (!r.ok) return json(res, { error: 'no template for this use case' }, 404);
      return json(res, await r.json());
    }

    // POST /gpt/image-prompt — fill template
    if (path === 'image-prompt' && req.method === 'POST') {
      let body = req.body;
      if (typeof body === 'string') body = JSON.parse(body);
      if (!body?.prompt_name || !body?.values) {
        return json(res, { error: 'need prompt_name and values' }, 400);
      }
      const r = await fetch(`${base}/get-image-prompt`, {
        method: 'POST',
        headers: { ...supaHeaders, 'x-service-key': SERVICE_KEY },
        body: JSON.stringify(body),
      });
      if (!r.ok) return json(res, { error: 'fill failed' }, 500);
      return json(res, await r.json());
    }

    return json(res, {
      endpoints: {
        'GET /gpt/docs': 'List all docs (compact)',
        'GET /gpt/docs?slug=colores': 'Get single doc as markdown',
        'GET /gpt/nav': 'Navigation tree (flat)',
        'GET /gpt/image-prompt?use_case=linkedin-post': 'Find image template',
        'POST /gpt/image-prompt': 'Fill template { prompt_name, values }',
      },
    });
  } catch (err) {
    return json(res, { error: String(err) }, 500);
  }
}
