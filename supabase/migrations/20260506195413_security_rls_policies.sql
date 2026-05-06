-- ============================================================
-- ATOM Design CMS — RLS + Policies
-- ============================================================
-- Payload connects as postgres (bypasses RLS).
-- This blocks anon/authenticated from writing, and only
-- exposes published content for reading.
-- ============================================================

-- 1. Enable RLS on all tables
DO $$
DECLARE
  tbl RECORD;
BEGIN
  FOR tbl IN
    SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', tbl.tablename);
  END LOOP;
END $$;

-- 2. Read policies for public content

-- Published docs only
CREATE POLICY "anon_read_published_docs"
  ON public.docs FOR SELECT TO anon, authenticated
  USING (_status = 'published');

-- Categories, media, site_config: fully public
CREATE POLICY "anon_read_categories"
  ON public.categories FOR SELECT TO anon, authenticated
  USING (true);

CREATE POLICY "anon_read_media"
  ON public.media FOR SELECT TO anon, authenticated
  USING (true);

CREATE POLICY "anon_read_site_config"
  ON public.site_config FOR SELECT TO anon, authenticated
  USING (true);

-- First-level block tables: _parent_id is integer, docs.id is integer
CREATE POLICY "anon_read_rich_text"
  ON public.docs_blocks_rich_text FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_code_block"
  ON public.docs_blocks_code_block FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_image_block"
  ON public.docs_blocks_image_block FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_callout"
  ON public.docs_blocks_callout FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_steps"
  ON public.docs_blocks_steps FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_card_grid"
  ON public.docs_blocks_card_grid FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_table"
  ON public.docs_blocks_table FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_divider"
  ON public.docs_blocks_divider FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

-- Sub-block tables: qualify _parent_id to avoid ambiguity with parent table
CREATE POLICY "anon_read_steps_steps"
  ON public.docs_blocks_steps_steps FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_steps p WHERE p.id = docs_blocks_steps_steps._parent_id));

CREATE POLICY "anon_read_card_grid_cards"
  ON public.docs_blocks_card_grid_cards FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_card_grid p WHERE p.id = docs_blocks_card_grid_cards._parent_id));

CREATE POLICY "anon_read_table_headers"
  ON public.docs_blocks_table_headers FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_table p WHERE p.id = docs_blocks_table_headers._parent_id));

CREATE POLICY "anon_read_table_rows"
  ON public.docs_blocks_table_rows FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_table p WHERE p.id = docs_blocks_table_rows._parent_id));

CREATE POLICY "anon_read_table_rows_cells"
  ON public.docs_blocks_table_rows_cells FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_table_rows p WHERE p.id = docs_blocks_table_rows_cells._parent_id));

-- 3. Table comments
COMMENT ON TABLE public.docs IS 'Documentation pages — Payload CMS';
COMMENT ON TABLE public.categories IS 'Sidebar sections and subsections';
COMMENT ON TABLE public.media IS 'Uploaded images and visual assets';
COMMENT ON TABLE public.users IS 'CMS admin/editor accounts';
COMMENT ON TABLE public.site_config IS 'Global site configuration';
COMMENT ON TABLE public._docs_v IS 'Document version history';
