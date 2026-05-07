-- ============================================================
-- Restore RLS read policies lost during schema pull.
-- Uses CREATE POLICY IF NOT EXISTS pattern via DO blocks.
-- ============================================================

-- Published docs only
DO $$ BEGIN
  CREATE POLICY "anon_read_published_docs"
    ON public.docs FOR SELECT TO anon, authenticated
    USING (_status = 'published');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Categories: fully public
DO $$ BEGIN
  CREATE POLICY "anon_read_categories"
    ON public.categories FOR SELECT TO anon, authenticated
    USING (true);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Media: fully public
DO $$ BEGIN
  CREATE POLICY "anon_read_media"
    ON public.media FOR SELECT TO anon, authenticated
    USING (true);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Site config: fully public
DO $$ BEGIN
  CREATE POLICY "anon_read_site_config"
    ON public.site_config FOR SELECT TO anon, authenticated
    USING (true);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- First-level block tables
DO $$ BEGIN
  CREATE POLICY "anon_read_rich_text"
    ON public.docs_blocks_rich_text FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_code_block"
    ON public.docs_blocks_code_block FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_image_block"
    ON public.docs_blocks_image_block FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_callout"
    ON public.docs_blocks_callout FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_steps"
    ON public.docs_blocks_steps FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_card_grid"
    ON public.docs_blocks_card_grid FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_table"
    ON public.docs_blocks_table FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_divider"
    ON public.docs_blocks_divider FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Sub-block tables
DO $$ BEGIN
  CREATE POLICY "anon_read_steps_steps"
    ON public.docs_blocks_steps_steps FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs_blocks_steps p WHERE p.id = docs_blocks_steps_steps._parent_id));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_card_grid_cards"
    ON public.docs_blocks_card_grid_cards FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs_blocks_card_grid p WHERE p.id = docs_blocks_card_grid_cards._parent_id));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_table_headers"
    ON public.docs_blocks_table_headers FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs_blocks_table p WHERE p.id = docs_blocks_table_headers._parent_id));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_table_rows"
    ON public.docs_blocks_table_rows FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs_blocks_table p WHERE p.id = docs_blocks_table_rows._parent_id));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "anon_read_table_rows_cells"
    ON public.docs_blocks_table_rows_cells FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs_blocks_table_rows p WHERE p.id = docs_blocks_table_rows_cells._parent_id));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
