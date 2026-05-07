const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  throw new Error(
    'Missing SUPABASE_URL or SUPABASE_ANON_KEY environment variables',
  );
}

const headers = {
  apikey: SUPABASE_ANON_KEY,
  Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
};

interface CacheEntry<T> {
  data: T;
  timestamp: number;
}

const TTL = 5 * 60 * 1000; // 5 minutes
const cache = new Map<string, CacheEntry<unknown>>();

async function fetchWithCache<T>(url: string): Promise<T> {
  const entry = cache.get(url);
  if (entry && Date.now() - entry.timestamp < TTL) {
    return entry.data as T;
  }

  const res = await fetch(url, { headers });
  if (!res.ok) {
    throw new Error(`Edge function error: ${res.status} ${res.statusText}`);
  }

  const data = (await res.json()) as T;
  cache.set(url, { data, timestamp: Date.now() });
  return data;
}

export interface Doc {
  id: number;
  title: string;
  slug: string;
  description: string | null;
  category_id: number;
  parent_id: number | null;
  order: number;
  sidebar_label: string | null;
  show_in_sidebar: boolean;
  _status: string;
}

export interface Block {
  id: string;
  blockType: string;
  _order: number;
  [key: string]: unknown;
}

export interface DocWithBlocks {
  doc: Doc;
  blocks: Block[];
}

export interface NavNode {
  name: string;
  slug: string;
  icon?: string;
  type: 'folder' | 'page';
  url?: string;
  children?: NavNode[];
}

export interface NavigationResponse {
  tree: NavNode[];
  siteConfig: { site_name: string; site_description?: string };
}

const base = `${SUPABASE_URL}/functions/v1`;

export async function fetchDocs(): Promise<Doc[]> {
  const data = await fetchWithCache<{ docs: Doc[] }>(`${base}/get-docs`);
  return data.docs;
}

export async function fetchDocBySlug(
  slug: string,
): Promise<DocWithBlocks | null> {
  try {
    return await fetchWithCache<DocWithBlocks>(
      `${base}/get-docs?slug=${encodeURIComponent(slug)}`,
    );
  } catch {
    return null;
  }
}

export async function fetchNavigation(): Promise<NavigationResponse> {
  return fetchWithCache<NavigationResponse>(`${base}/get-navigation`);
}
