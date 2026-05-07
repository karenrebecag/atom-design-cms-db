-- NavLink block tables (live + versions)
CREATE TABLE IF NOT EXISTS docs_blocks_nav_link (
  _order integer NOT NULL,
  _parent_id integer NOT NULL REFERENCES docs(id) ON DELETE CASCADE,
  _path text NOT NULL DEFAULT '',
  id varchar PRIMARY KEY DEFAULT gen_random_uuid(),
  label varchar,
  url varchar,
  context varchar,
  _uuid varchar,
  block_name varchar
);

CREATE TABLE IF NOT EXISTS _docs_v_blocks_nav_link (
  _order integer NOT NULL,
  _parent_id integer NOT NULL REFERENCES _docs_v(id) ON DELETE CASCADE,
  _path text NOT NULL DEFAULT '',
  id serial PRIMARY KEY,
  label varchar,
  url varchar,
  context varchar,
  _uuid varchar,
  block_name varchar
);

CREATE INDEX IF NOT EXISTS docs_blocks_nav_link_order_idx ON docs_blocks_nav_link (_order);
CREATE INDEX IF NOT EXISTS docs_blocks_nav_link_parent_id_idx ON docs_blocks_nav_link (_parent_id);
CREATE INDEX IF NOT EXISTS _docs_v_blocks_nav_link_order_idx ON _docs_v_blocks_nav_link (_order);
CREATE INDEX IF NOT EXISTS _docs_v_blocks_nav_link_parent_id_idx ON _docs_v_blocks_nav_link (_parent_id);

-- RLS
ALTER TABLE docs_blocks_nav_link ENABLE ROW LEVEL SECURITY;
ALTER TABLE _docs_v_blocks_nav_link ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "anon_read_nav_link"
    ON public.docs_blocks_nav_link FOR SELECT TO anon, authenticated
    USING (EXISTS (SELECT 1 FROM public.docs d WHERE d.id = _parent_id AND d._status = 'published'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
