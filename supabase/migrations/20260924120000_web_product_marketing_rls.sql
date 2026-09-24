-- RLS de webmarketing y productmarketing, el mismo criterio que marketing (H8):
-- metadatos publicados, categorías públicas, bloques solo si el doc está
-- publicado y no es restricted. Se salta una base cuya tabla todavía no existe,
-- para poder aplicar esto antes o después del push de Payload.

DO $$
DECLARE
  bases text[] := ARRAY['webmarketing', 'productmarketing'];
  base text;
  first_level text[] := ARRAY[
    'rich_text', 'code_block', 'image_block', 'callout', 'steps',
    'card_grid', 'table', 'divider', 'color_swatch', 'dos_donts',
    'download_button', 'contact_card', 'nav_link'
  ];
  nested_child text[] := ARRAY[
    'steps_steps', 'card_grid_cards', 'table_headers', 'table_rows',
    'dos_donts_dos', 'dos_donts_donts'
  ];
  nested_parent text[] := ARRAY[
    'steps', 'card_grid', 'table', 'table',
    'dos_donts', 'dos_donts'
  ];
  suf text;
  i int;
  blocks text;
  parent_blocks text;
  doc_table text;
BEGIN
  FOREACH base IN ARRAY bases LOOP
    doc_table := base;
    IF to_regclass('public.' || doc_table) IS NULL THEN
      CONTINUE;
    END IF;

    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', doc_table);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_published_' || base, doc_table);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (_status = %L)',
      'anon_read_published_' || base, doc_table, 'published'
    );

    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', base || '_categories');
    EXECUTE format(
      'DROP POLICY IF EXISTS %I ON public.%I',
      'anon_read_' || base || '_categories',
      base || '_categories'
    );
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (true)',
      'anon_read_' || base || '_categories',
      base || '_categories'
    );

    FOREACH suf IN ARRAY first_level LOOP
      blocks := base || '_blocks_' || suf;
      EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', blocks);
      EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_' || base || '_' || suf, blocks);
      EXECUTE format(
        'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (EXISTS (SELECT 1 FROM public.%I d WHERE d.id = _parent_id AND d._status = %L AND d.restricted IS NOT TRUE))',
        'anon_read_' || base || '_' || suf, blocks, doc_table, 'published'
      );
    END LOOP;

    FOR i IN 1 .. array_length(nested_child, 1) LOOP
      blocks := base || '_blocks_' || nested_child[i];
      parent_blocks := base || '_blocks_' || nested_parent[i];
      EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', blocks);
      EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_' || base || '_' || nested_child[i], blocks);
      EXECUTE format(
        'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (EXISTS (SELECT 1 FROM public.%I p JOIN public.%I d ON d.id = p._parent_id WHERE p.id = %I._parent_id AND d._status = %L AND d.restricted IS NOT TRUE))',
        'anon_read_' || base || '_' || nested_child[i],
        blocks,
        parent_blocks,
        doc_table,
        blocks,
        'published'
      );
    END LOOP;

    blocks := base || '_blocks_table_rows_cells';
    EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', blocks);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_' || base || '_table_rows_cells', blocks);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (EXISTS (SELECT 1 FROM public.%I r JOIN public.%I t ON t.id = r._parent_id JOIN public.%I d ON d.id = t._parent_id WHERE r.id = %I._parent_id AND d._status = %L AND d.restricted IS NOT TRUE))',
      'anon_read_' || base || '_table_rows_cells',
      blocks,
      base || '_blocks_table_rows',
      base || '_blocks_table',
      doc_table,
      blocks,
      'published'
    );

    EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', '_' || base || '_v');
    FOREACH suf IN ARRAY (first_level || nested_child || ARRAY['table_rows_cells']) LOOP
      EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', '_' || base || '_v_blocks_' || suf);
    END LOOP;
  END LOOP;
END $$;
