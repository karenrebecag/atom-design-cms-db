-- ============================================================
-- Propósito: cierra H7 y H8 (auditoría 2026-09-11).
--
-- H7: las policies anon_read_* de docs_blocks_* (primer nivel y
-- anidadas) solo comprobaban que el doc padre estuviera
-- `published`, sin mirar `restricted`. La anon key es pública (va
-- en el JS del front), así que cualquiera podía leer por PostgREST
-- el cuerpo de un doc restringido saltándose la cabecera que exige
-- `get-docs`. Se recrean con `AND d.restricted IS NOT TRUE`.
--
-- H8: las tablas que crea el `push` de Drizzle nacen sin RLS
-- (legibles enteras, borradores incluidos, con la sola anon key)
-- hasta que se aplica una policy. Por eso `marketing*` activa RLS
-- y sus policies en la misma migración que las tablas, y el bloque
-- entero se salta sin fallar si `marketing` todavía no existe
-- (el runbook de K2 aplica el push y esta migración en la misma
-- sentada, pero esta migración se puede desplegar antes).
-- ============================================================

-- ============================================================
-- H7 — docs_blocks_*: 13 tablas de primer nivel + 7 anidadas.
-- Idempotente: DROP POLICY IF EXISTS antes de cada CREATE.
-- ============================================================

-- Primer nivel: _parent_id apunta directo a docs.id.
DROP POLICY IF EXISTS "anon_read_rich_text" ON public.docs_blocks_rich_text;
CREATE POLICY "anon_read_rich_text"
  ON public.docs_blocks_rich_text FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_code_block" ON public.docs_blocks_code_block;
CREATE POLICY "anon_read_code_block"
  ON public.docs_blocks_code_block FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_image_block" ON public.docs_blocks_image_block;
CREATE POLICY "anon_read_image_block"
  ON public.docs_blocks_image_block FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_callout" ON public.docs_blocks_callout;
CREATE POLICY "anon_read_callout"
  ON public.docs_blocks_callout FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_steps" ON public.docs_blocks_steps;
CREATE POLICY "anon_read_steps"
  ON public.docs_blocks_steps FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_card_grid" ON public.docs_blocks_card_grid;
CREATE POLICY "anon_read_card_grid"
  ON public.docs_blocks_card_grid FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_table" ON public.docs_blocks_table;
CREATE POLICY "anon_read_table"
  ON public.docs_blocks_table FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_divider" ON public.docs_blocks_divider;
CREATE POLICY "anon_read_divider"
  ON public.docs_blocks_divider FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_color_swatch" ON public.docs_blocks_color_swatch;
CREATE POLICY "anon_read_color_swatch"
  ON public.docs_blocks_color_swatch FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_dos_donts" ON public.docs_blocks_dos_donts;
CREATE POLICY "anon_read_dos_donts"
  ON public.docs_blocks_dos_donts FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_download_button" ON public.docs_blocks_download_button;
CREATE POLICY "anon_read_download_button"
  ON public.docs_blocks_download_button FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_contact_card" ON public.docs_blocks_contact_card;
CREATE POLICY "anon_read_contact_card"
  ON public.docs_blocks_contact_card FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

DROP POLICY IF EXISTS "anon_read_nav_link" ON public.docs_blocks_nav_link;
CREATE POLICY "anon_read_nav_link"
  ON public.docs_blocks_nav_link FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published' AND d.restricted IS NOT TRUE));

-- Anidadas: _parent_id apunta al bloque padre, no al doc. La
-- condición llega hasta el doc a través del bloque padre, igual
-- que hoy, pero ahora también exige `published` y `restricted IS NOT TRUE`
-- (hoy ninguna de las anidadas comprobaba el doc en absoluto).
DROP POLICY IF EXISTS "anon_read_steps_steps" ON public.docs_blocks_steps_steps;
CREATE POLICY "anon_read_steps_steps"
  ON public.docs_blocks_steps_steps FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_steps p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_steps_steps._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

DROP POLICY IF EXISTS "anon_read_card_grid_cards" ON public.docs_blocks_card_grid_cards;
CREATE POLICY "anon_read_card_grid_cards"
  ON public.docs_blocks_card_grid_cards FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_card_grid p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_card_grid_cards._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

DROP POLICY IF EXISTS "anon_read_table_headers" ON public.docs_blocks_table_headers;
CREATE POLICY "anon_read_table_headers"
  ON public.docs_blocks_table_headers FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_table p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_table_headers._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

DROP POLICY IF EXISTS "anon_read_table_rows" ON public.docs_blocks_table_rows;
CREATE POLICY "anon_read_table_rows"
  ON public.docs_blocks_table_rows FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_table p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_table_rows._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

-- table_rows_cells cuelga de table_rows, que a su vez cuelga de
-- table: tres saltos para llegar al doc.
DROP POLICY IF EXISTS "anon_read_table_rows_cells" ON public.docs_blocks_table_rows_cells;
CREATE POLICY "anon_read_table_rows_cells"
  ON public.docs_blocks_table_rows_cells FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_table_rows r
    JOIN public.docs_blocks_table t ON t.id = r._parent_id
    JOIN public.docs d ON d.id = t._parent_id
    WHERE r.id = docs_blocks_table_rows_cells._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

DROP POLICY IF EXISTS "anon_read_dos_donts_dos" ON public.docs_blocks_dos_donts_dos;
CREATE POLICY "anon_read_dos_donts_dos"
  ON public.docs_blocks_dos_donts_dos FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_dos_donts p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_dos_donts_dos._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

DROP POLICY IF EXISTS "anon_read_dos_donts_donts" ON public.docs_blocks_dos_donts_donts;
CREATE POLICY "anon_read_dos_donts_donts"
  ON public.docs_blocks_dos_donts_donts FOR SELECT TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.docs_blocks_dos_donts p
    JOIN public.docs d ON d.id = p._parent_id
    WHERE p.id = docs_blocks_dos_donts_donts._parent_id
      AND d._status = 'published' AND d.restricted IS NOT TRUE
  ));

-- `docs` y `categories` no cambian: get-navigation necesita sus
-- metadatos (título, slug, orden) y ninguna de las dos lleva cuerpo.

-- ============================================================
-- H8 — marketing*: RLS desde que nacen. Todo el bloque se salta
-- sin fallar si K2-s1 (colecciones en Payload) aún no corrió el
-- push contra producción.
-- ============================================================
DO $$
DECLARE
  -- Sufijos de docs_blocks_* que también existen en marketing_blocks_*
  -- (misma colección de 13 bloques, copiada de Docs.ts).
  first_level text[] := ARRAY[
    'rich_text', 'code_block', 'image_block', 'callout', 'steps',
    'card_grid', 'table', 'divider', 'color_swatch', 'dos_donts',
    'download_button', 'contact_card', 'nav_link'
  ];
  -- Anidadas simples: un salto al bloque padre listado aquí.
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
BEGIN
  IF to_regclass('public.marketing') IS NULL THEN
    RETURN;
  END IF;

  -- marketing: metadatos, mismo criterio que docs (published, sin cuerpo).
  EXECUTE 'ALTER TABLE public.marketing ENABLE ROW LEVEL SECURITY';
  EXECUTE 'DROP POLICY IF EXISTS "anon_read_published_marketing" ON public.marketing';
  EXECUTE $p$CREATE POLICY "anon_read_published_marketing"
    ON public.marketing FOR SELECT TO anon, authenticated
    USING (_status = 'published')$p$;

  -- marketing_categories: pública, igual que categories.
  EXECUTE 'ALTER TABLE public.marketing_categories ENABLE ROW LEVEL SECURITY';
  EXECUTE 'DROP POLICY IF EXISTS "anon_read_marketing_categories" ON public.marketing_categories';
  EXECUTE $p$CREATE POLICY "anon_read_marketing_categories"
    ON public.marketing_categories FOR SELECT TO anon, authenticated
    USING (true)$p$;

  -- marketing_blocks_* de primer nivel: mismo patrón que (a),
  -- published AND restricted IS NOT TRUE.
  FOREACH suf IN ARRAY first_level LOOP
    EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', 'marketing_blocks_' || suf);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_marketing_' || suf, 'marketing_blocks_' || suf);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (EXISTS (SELECT 1 FROM public.marketing d WHERE d.id = _parent_id AND d._status = %L AND d.restricted IS NOT TRUE))',
      'anon_read_marketing_' || suf, 'marketing_blocks_' || suf, 'published'
    );
  END LOOP;

  -- marketing_blocks_* anidadas simples (un salto al padre).
  FOR i IN 1 .. array_length(nested_child, 1) LOOP
    EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', 'marketing_blocks_' || nested_child[i]);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_marketing_' || nested_child[i], 'marketing_blocks_' || nested_child[i]);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (EXISTS (SELECT 1 FROM public.%I p JOIN public.marketing d ON d.id = p._parent_id WHERE p.id = %I._parent_id AND d._status = %L AND d.restricted IS NOT TRUE))',
      'anon_read_marketing_' || nested_child[i],
      'marketing_blocks_' || nested_child[i],
      'marketing_blocks_' || nested_parent[i],
      'marketing_blocks_' || nested_child[i],
      'published'
    );
  END LOOP;

  -- marketing_blocks_table_rows_cells: tres saltos, igual que en docs.
  EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', 'marketing_blocks_table_rows_cells');
  EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', 'anon_read_marketing_table_rows_cells', 'marketing_blocks_table_rows_cells');
  EXECUTE $p$CREATE POLICY "anon_read_marketing_table_rows_cells"
    ON public.marketing_blocks_table_rows_cells FOR SELECT TO anon, authenticated
    USING (EXISTS (
      SELECT 1 FROM public.marketing_blocks_table_rows r
      JOIN public.marketing_blocks_table t ON t.id = r._parent_id
      JOIN public.marketing d ON d.id = t._parent_id
      WHERE r.id = marketing_blocks_table_rows_cells._parent_id
        AND d._status = 'published' AND d.restricted IS NOT TRUE
    ))$p$;

  -- Tablas de versiones (_marketing_v, _marketing_v_blocks_*): RLS
  -- activado, SIN policy — nadie las necesita, ni siquiera anon.
  EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', '_marketing_v');
  FOREACH suf IN ARRAY (first_level || nested_child || ARRAY['table_rows_cells']) LOOP
    EXECUTE format('ALTER TABLE IF EXISTS public.%I ENABLE ROW LEVEL SECURITY', '_marketing_v_blocks_' || suf);
  END LOOP;
END $$;
