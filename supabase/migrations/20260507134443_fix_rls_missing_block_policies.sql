-- ============================================================
-- Fix missing RLS read policies for block tables not covered
-- in the original security_rls_policies migration.
-- ============================================================

CREATE POLICY "anon_read_color_swatch"
  ON public.docs_blocks_color_swatch FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_dos_donts"
  ON public.docs_blocks_dos_donts FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_dos_donts_dos"
  ON public.docs_blocks_dos_donts_dos FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_dos_donts p WHERE p.id = docs_blocks_dos_donts_dos._parent_id));

CREATE POLICY "anon_read_dos_donts_donts"
  ON public.docs_blocks_dos_donts_donts FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs_blocks_dos_donts p WHERE p.id = docs_blocks_dos_donts_donts._parent_id));

CREATE POLICY "anon_read_download_button"
  ON public.docs_blocks_download_button FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));

CREATE POLICY "anon_read_contact_card"
  ON public.docs_blocks_contact_card FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
