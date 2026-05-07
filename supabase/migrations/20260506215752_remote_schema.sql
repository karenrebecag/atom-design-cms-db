create type "public"."enum__docs_v_blocks_download_button_file_type" as enum ('figma', 'svg', 'png', 'pdf', 'zip');

create type "public"."enum_docs_blocks_download_button_file_type" as enum ('figma', 'svg', 'png', 'pdf', 'zip');

create sequence "public"."_docs_v_blocks_color_swatch_id_seq";

create sequence "public"."_docs_v_blocks_contact_card_id_seq";

create sequence "public"."_docs_v_blocks_dos_donts_donts_id_seq";

create sequence "public"."_docs_v_blocks_dos_donts_dos_id_seq";

create sequence "public"."_docs_v_blocks_dos_donts_id_seq";

create sequence "public"."_docs_v_blocks_download_button_id_seq";

drop policy "anon_read_categories" on "public"."categories";

drop policy "anon_read_published_docs" on "public"."docs";

drop policy "anon_read_callout" on "public"."docs_blocks_callout";

drop policy "anon_read_card_grid" on "public"."docs_blocks_card_grid";

drop policy "anon_read_card_grid_cards" on "public"."docs_blocks_card_grid_cards";

drop policy "anon_read_code_block" on "public"."docs_blocks_code_block";

drop policy "anon_read_divider" on "public"."docs_blocks_divider";

drop policy "anon_read_image_block" on "public"."docs_blocks_image_block";

drop policy "anon_read_rich_text" on "public"."docs_blocks_rich_text";

drop policy "anon_read_steps" on "public"."docs_blocks_steps";

drop policy "anon_read_steps_steps" on "public"."docs_blocks_steps_steps";

drop policy "anon_read_table" on "public"."docs_blocks_table";

drop policy "anon_read_table_headers" on "public"."docs_blocks_table_headers";

drop policy "anon_read_table_rows" on "public"."docs_blocks_table_rows";

drop policy "anon_read_table_rows_cells" on "public"."docs_blocks_table_rows_cells";

drop policy "anon_read_media" on "public"."media";

drop policy "anon_read_site_config" on "public"."site_config";


  create table "public"."_docs_v_blocks_color_swatch" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_color_swatch_id_seq'::regclass),
    "label" character varying,
    "hex" character varying,
    "rgb" character varying,
    "cmyk" character varying,
    "pantone" character varying,
    "usage" character varying,
    "gradient" character varying,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_contact_card" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_contact_card_id_seq'::regclass),
    "name" character varying,
    "role" character varying,
    "email" character varying,
    "initials" character varying,
    "note" character varying,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_dos_donts" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_dos_donts_id_seq'::regclass),
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_dos_donts_donts" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_dos_donts_donts_id_seq'::regclass),
    "text" character varying,
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_dos_donts_dos" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_dos_donts_dos_id_seq'::regclass),
    "text" character varying,
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_download_button" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_download_button_id_seq'::regclass),
    "label" character varying,
    "url" character varying,
    "description" character varying,
    "file_type" public.enum__docs_v_blocks_download_button_file_type default 'zip'::public.enum__docs_v_blocks_download_button_file_type,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."docs_blocks_color_swatch" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "label" character varying,
    "hex" character varying,
    "rgb" character varying,
    "cmyk" character varying,
    "pantone" character varying,
    "usage" character varying,
    "gradient" character varying,
    "block_name" character varying
      );



  create table "public"."docs_blocks_contact_card" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "name" character varying,
    "role" character varying,
    "email" character varying,
    "initials" character varying,
    "note" character varying,
    "block_name" character varying
      );



  create table "public"."docs_blocks_dos_donts" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "block_name" character varying
      );



  create table "public"."docs_blocks_dos_donts_donts" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "text" character varying
      );



  create table "public"."docs_blocks_dos_donts_dos" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "text" character varying
      );



  create table "public"."docs_blocks_download_button" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "label" character varying,
    "url" character varying,
    "description" character varying,
    "file_type" public.enum_docs_blocks_download_button_file_type default 'zip'::public.enum_docs_blocks_download_button_file_type,
    "block_name" character varying
      );


alter table "public"."_docs_v" disable row level security;

alter table "public"."_docs_v_blocks_callout" disable row level security;

alter table "public"."_docs_v_blocks_card_grid" disable row level security;

alter table "public"."_docs_v_blocks_card_grid_cards" disable row level security;

alter table "public"."_docs_v_blocks_code_block" disable row level security;

alter table "public"."_docs_v_blocks_divider" disable row level security;

alter table "public"."_docs_v_blocks_image_block" disable row level security;

alter table "public"."_docs_v_blocks_rich_text" disable row level security;

alter table "public"."_docs_v_blocks_steps" disable row level security;

alter table "public"."_docs_v_blocks_steps_steps" disable row level security;

alter table "public"."_docs_v_blocks_table" disable row level security;

alter table "public"."_docs_v_blocks_table_headers" disable row level security;

alter table "public"."_docs_v_blocks_table_rows" disable row level security;

alter table "public"."_docs_v_blocks_table_rows_cells" disable row level security;

alter table "public"."categories" disable row level security;

alter table "public"."docs" disable row level security;

alter table "public"."docs_blocks_callout" disable row level security;

alter table "public"."docs_blocks_card_grid" disable row level security;

alter table "public"."docs_blocks_card_grid_cards" disable row level security;

alter table "public"."docs_blocks_code_block" disable row level security;

alter table "public"."docs_blocks_divider" disable row level security;

alter table "public"."docs_blocks_image_block" disable row level security;

alter table "public"."docs_blocks_rich_text" disable row level security;

alter table "public"."docs_blocks_steps" disable row level security;

alter table "public"."docs_blocks_steps_steps" disable row level security;

alter table "public"."docs_blocks_table" disable row level security;

alter table "public"."docs_blocks_table_headers" disable row level security;

alter table "public"."docs_blocks_table_rows" disable row level security;

alter table "public"."docs_blocks_table_rows_cells" disable row level security;

alter table "public"."media" disable row level security;

alter table "public"."payload_kv" disable row level security;

alter table "public"."payload_locked_documents" disable row level security;

alter table "public"."payload_locked_documents_rels" disable row level security;

alter table "public"."payload_migrations" disable row level security;

alter table "public"."payload_preferences" disable row level security;

alter table "public"."payload_preferences_rels" disable row level security;

alter table "public"."site_config" disable row level security;

alter table "public"."users" disable row level security;

alter table "public"."users_sessions" disable row level security;

alter sequence "public"."_docs_v_blocks_color_swatch_id_seq" owned by "public"."_docs_v_blocks_color_swatch"."id";

alter sequence "public"."_docs_v_blocks_contact_card_id_seq" owned by "public"."_docs_v_blocks_contact_card"."id";

alter sequence "public"."_docs_v_blocks_dos_donts_donts_id_seq" owned by "public"."_docs_v_blocks_dos_donts_donts"."id";

alter sequence "public"."_docs_v_blocks_dos_donts_dos_id_seq" owned by "public"."_docs_v_blocks_dos_donts_dos"."id";

alter sequence "public"."_docs_v_blocks_dos_donts_id_seq" owned by "public"."_docs_v_blocks_dos_donts"."id";

alter sequence "public"."_docs_v_blocks_download_button_id_seq" owned by "public"."_docs_v_blocks_download_button"."id";

CREATE INDEX _docs_v_blocks_color_swatch_order_idx ON public._docs_v_blocks_color_swatch USING btree (_order);

CREATE INDEX _docs_v_blocks_color_swatch_parent_id_idx ON public._docs_v_blocks_color_swatch USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_color_swatch_path_idx ON public._docs_v_blocks_color_swatch USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_color_swatch_pkey ON public._docs_v_blocks_color_swatch USING btree (id);

CREATE INDEX _docs_v_blocks_contact_card_order_idx ON public._docs_v_blocks_contact_card USING btree (_order);

CREATE INDEX _docs_v_blocks_contact_card_parent_id_idx ON public._docs_v_blocks_contact_card USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_contact_card_path_idx ON public._docs_v_blocks_contact_card USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_contact_card_pkey ON public._docs_v_blocks_contact_card USING btree (id);

CREATE INDEX _docs_v_blocks_dos_donts_donts_order_idx ON public._docs_v_blocks_dos_donts_donts USING btree (_order);

CREATE INDEX _docs_v_blocks_dos_donts_donts_parent_id_idx ON public._docs_v_blocks_dos_donts_donts USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_dos_donts_donts_pkey ON public._docs_v_blocks_dos_donts_donts USING btree (id);

CREATE INDEX _docs_v_blocks_dos_donts_dos_order_idx ON public._docs_v_blocks_dos_donts_dos USING btree (_order);

CREATE INDEX _docs_v_blocks_dos_donts_dos_parent_id_idx ON public._docs_v_blocks_dos_donts_dos USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_dos_donts_dos_pkey ON public._docs_v_blocks_dos_donts_dos USING btree (id);

CREATE INDEX _docs_v_blocks_dos_donts_order_idx ON public._docs_v_blocks_dos_donts USING btree (_order);

CREATE INDEX _docs_v_blocks_dos_donts_parent_id_idx ON public._docs_v_blocks_dos_donts USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_dos_donts_path_idx ON public._docs_v_blocks_dos_donts USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_dos_donts_pkey ON public._docs_v_blocks_dos_donts USING btree (id);

CREATE INDEX _docs_v_blocks_download_button_order_idx ON public._docs_v_blocks_download_button USING btree (_order);

CREATE INDEX _docs_v_blocks_download_button_parent_id_idx ON public._docs_v_blocks_download_button USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_download_button_path_idx ON public._docs_v_blocks_download_button USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_download_button_pkey ON public._docs_v_blocks_download_button USING btree (id);

CREATE INDEX docs_blocks_color_swatch_order_idx ON public.docs_blocks_color_swatch USING btree (_order);

CREATE INDEX docs_blocks_color_swatch_parent_id_idx ON public.docs_blocks_color_swatch USING btree (_parent_id);

CREATE INDEX docs_blocks_color_swatch_path_idx ON public.docs_blocks_color_swatch USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_color_swatch_pkey ON public.docs_blocks_color_swatch USING btree (id);

CREATE INDEX docs_blocks_contact_card_order_idx ON public.docs_blocks_contact_card USING btree (_order);

CREATE INDEX docs_blocks_contact_card_parent_id_idx ON public.docs_blocks_contact_card USING btree (_parent_id);

CREATE INDEX docs_blocks_contact_card_path_idx ON public.docs_blocks_contact_card USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_contact_card_pkey ON public.docs_blocks_contact_card USING btree (id);

CREATE INDEX docs_blocks_dos_donts_donts_order_idx ON public.docs_blocks_dos_donts_donts USING btree (_order);

CREATE INDEX docs_blocks_dos_donts_donts_parent_id_idx ON public.docs_blocks_dos_donts_donts USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_dos_donts_donts_pkey ON public.docs_blocks_dos_donts_donts USING btree (id);

CREATE INDEX docs_blocks_dos_donts_dos_order_idx ON public.docs_blocks_dos_donts_dos USING btree (_order);

CREATE INDEX docs_blocks_dos_donts_dos_parent_id_idx ON public.docs_blocks_dos_donts_dos USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_dos_donts_dos_pkey ON public.docs_blocks_dos_donts_dos USING btree (id);

CREATE INDEX docs_blocks_dos_donts_order_idx ON public.docs_blocks_dos_donts USING btree (_order);

CREATE INDEX docs_blocks_dos_donts_parent_id_idx ON public.docs_blocks_dos_donts USING btree (_parent_id);

CREATE INDEX docs_blocks_dos_donts_path_idx ON public.docs_blocks_dos_donts USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_dos_donts_pkey ON public.docs_blocks_dos_donts USING btree (id);

CREATE INDEX docs_blocks_download_button_order_idx ON public.docs_blocks_download_button USING btree (_order);

CREATE INDEX docs_blocks_download_button_parent_id_idx ON public.docs_blocks_download_button USING btree (_parent_id);

CREATE INDEX docs_blocks_download_button_path_idx ON public.docs_blocks_download_button USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_download_button_pkey ON public.docs_blocks_download_button USING btree (id);

alter table "public"."_docs_v_blocks_color_swatch" add constraint "_docs_v_blocks_color_swatch_pkey" PRIMARY KEY using index "_docs_v_blocks_color_swatch_pkey";

alter table "public"."_docs_v_blocks_contact_card" add constraint "_docs_v_blocks_contact_card_pkey" PRIMARY KEY using index "_docs_v_blocks_contact_card_pkey";

alter table "public"."_docs_v_blocks_dos_donts" add constraint "_docs_v_blocks_dos_donts_pkey" PRIMARY KEY using index "_docs_v_blocks_dos_donts_pkey";

alter table "public"."_docs_v_blocks_dos_donts_donts" add constraint "_docs_v_blocks_dos_donts_donts_pkey" PRIMARY KEY using index "_docs_v_blocks_dos_donts_donts_pkey";

alter table "public"."_docs_v_blocks_dos_donts_dos" add constraint "_docs_v_blocks_dos_donts_dos_pkey" PRIMARY KEY using index "_docs_v_blocks_dos_donts_dos_pkey";

alter table "public"."_docs_v_blocks_download_button" add constraint "_docs_v_blocks_download_button_pkey" PRIMARY KEY using index "_docs_v_blocks_download_button_pkey";

alter table "public"."docs_blocks_color_swatch" add constraint "docs_blocks_color_swatch_pkey" PRIMARY KEY using index "docs_blocks_color_swatch_pkey";

alter table "public"."docs_blocks_contact_card" add constraint "docs_blocks_contact_card_pkey" PRIMARY KEY using index "docs_blocks_contact_card_pkey";

alter table "public"."docs_blocks_dos_donts" add constraint "docs_blocks_dos_donts_pkey" PRIMARY KEY using index "docs_blocks_dos_donts_pkey";

alter table "public"."docs_blocks_dos_donts_donts" add constraint "docs_blocks_dos_donts_donts_pkey" PRIMARY KEY using index "docs_blocks_dos_donts_donts_pkey";

alter table "public"."docs_blocks_dos_donts_dos" add constraint "docs_blocks_dos_donts_dos_pkey" PRIMARY KEY using index "docs_blocks_dos_donts_dos_pkey";

alter table "public"."docs_blocks_download_button" add constraint "docs_blocks_download_button_pkey" PRIMARY KEY using index "docs_blocks_download_button_pkey";

alter table "public"."_docs_v_blocks_color_swatch" add constraint "_docs_v_blocks_color_swatch_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_color_swatch" validate constraint "_docs_v_blocks_color_swatch_parent_id_fk";

alter table "public"."_docs_v_blocks_contact_card" add constraint "_docs_v_blocks_contact_card_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_contact_card" validate constraint "_docs_v_blocks_contact_card_parent_id_fk";

alter table "public"."_docs_v_blocks_dos_donts" add constraint "_docs_v_blocks_dos_donts_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_dos_donts" validate constraint "_docs_v_blocks_dos_donts_parent_id_fk";

alter table "public"."_docs_v_blocks_dos_donts_donts" add constraint "_docs_v_blocks_dos_donts_donts_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_dos_donts(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_dos_donts_donts" validate constraint "_docs_v_blocks_dos_donts_donts_parent_id_fk";

alter table "public"."_docs_v_blocks_dos_donts_dos" add constraint "_docs_v_blocks_dos_donts_dos_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_dos_donts(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_dos_donts_dos" validate constraint "_docs_v_blocks_dos_donts_dos_parent_id_fk";

alter table "public"."_docs_v_blocks_download_button" add constraint "_docs_v_blocks_download_button_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_download_button" validate constraint "_docs_v_blocks_download_button_parent_id_fk";

alter table "public"."docs_blocks_color_swatch" add constraint "docs_blocks_color_swatch_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_color_swatch" validate constraint "docs_blocks_color_swatch_parent_id_fk";

alter table "public"."docs_blocks_contact_card" add constraint "docs_blocks_contact_card_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_contact_card" validate constraint "docs_blocks_contact_card_parent_id_fk";

alter table "public"."docs_blocks_dos_donts" add constraint "docs_blocks_dos_donts_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_dos_donts" validate constraint "docs_blocks_dos_donts_parent_id_fk";

alter table "public"."docs_blocks_dos_donts_donts" add constraint "docs_blocks_dos_donts_donts_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_dos_donts(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_dos_donts_donts" validate constraint "docs_blocks_dos_donts_donts_parent_id_fk";

alter table "public"."docs_blocks_dos_donts_dos" add constraint "docs_blocks_dos_donts_dos_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_dos_donts(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_dos_donts_dos" validate constraint "docs_blocks_dos_donts_dos_parent_id_fk";

alter table "public"."docs_blocks_download_button" add constraint "docs_blocks_download_button_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_download_button" validate constraint "docs_blocks_download_button_parent_id_fk";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fix_lexical_node(node jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
  fixed jsonb;
  fixed_children jsonb[];
  child jsonb;
BEGIN
  fixed := node;

  IF (fixed->>'version') IS NULL THEN
    fixed := fixed || '{"version": 1}';
  END IF;

  IF (fixed->>'type') IN ('listitem', 'paragraph', 'heading', 'list', 'quote', 'root') AND (fixed->>'indent') IS NULL THEN
    fixed := fixed || '{"indent": 0}';
  END IF;

  IF (fixed->>'type') = 'listitem' AND (fixed->>'value') IS NULL THEN
    fixed := fixed || '{"value": 1}';
  END IF;

  IF (fixed->>'type') NOT IN ('text', 'linebreak', 'tab') AND (fixed->>'direction') IS NULL THEN
    fixed := fixed || '{"direction": "ltr"}';
  END IF;

  IF (fixed->>'type') = 'text' THEN
    IF (fixed->>'format') IS NULL THEN fixed := fixed || '{"format": 0}'; END IF;
    IF (fixed->>'mode')   IS NULL THEN fixed := fixed || '{"mode": "normal"}'; END IF;
    IF (fixed->>'style')  IS NULL THEN fixed := fixed || '{"style": ""}'; END IF;
    IF (fixed->>'detail') IS NULL THEN fixed := fixed || '{"detail": 0}'; END IF;
  END IF;

  IF (fixed->'children') IS NOT NULL AND jsonb_typeof(fixed->'children') = 'array' THEN
    fixed_children := ARRAY[]::jsonb[];
    FOR child IN SELECT * FROM jsonb_array_elements(fixed->'children') LOOP
      fixed_children := fixed_children || fix_lexical_node(child);
    END LOOP;
    fixed := fixed || jsonb_build_object('children', to_jsonb(fixed_children));
  END IF;

  RETURN fixed;
END;
$function$
;

grant delete on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant insert on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant references on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant select on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant trigger on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant truncate on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant update on table "public"."_docs_v_blocks_color_swatch" to "anon";

grant delete on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant insert on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant references on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant select on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant update on table "public"."_docs_v_blocks_color_swatch" to "authenticated";

grant delete on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant insert on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant references on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant select on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant trigger on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant truncate on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant update on table "public"."_docs_v_blocks_color_swatch" to "service_role";

grant delete on table "public"."_docs_v_blocks_contact_card" to "anon";

grant insert on table "public"."_docs_v_blocks_contact_card" to "anon";

grant references on table "public"."_docs_v_blocks_contact_card" to "anon";

grant select on table "public"."_docs_v_blocks_contact_card" to "anon";

grant trigger on table "public"."_docs_v_blocks_contact_card" to "anon";

grant truncate on table "public"."_docs_v_blocks_contact_card" to "anon";

grant update on table "public"."_docs_v_blocks_contact_card" to "anon";

grant delete on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant insert on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant references on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant select on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant update on table "public"."_docs_v_blocks_contact_card" to "authenticated";

grant delete on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant insert on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant references on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant select on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant trigger on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant truncate on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant update on table "public"."_docs_v_blocks_contact_card" to "service_role";

grant delete on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant insert on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant references on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant select on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant trigger on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant truncate on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant update on table "public"."_docs_v_blocks_dos_donts" to "anon";

grant delete on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant insert on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant references on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant select on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant update on table "public"."_docs_v_blocks_dos_donts" to "authenticated";

grant delete on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant insert on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant references on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant select on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant trigger on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant truncate on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant update on table "public"."_docs_v_blocks_dos_donts" to "service_role";

grant delete on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant insert on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant references on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant select on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant trigger on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant truncate on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant update on table "public"."_docs_v_blocks_dos_donts_donts" to "anon";

grant delete on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant insert on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant references on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant select on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant update on table "public"."_docs_v_blocks_dos_donts_donts" to "authenticated";

grant delete on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant insert on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant references on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant select on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant trigger on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant truncate on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant update on table "public"."_docs_v_blocks_dos_donts_donts" to "service_role";

grant delete on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant insert on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant references on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant select on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant trigger on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant truncate on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant update on table "public"."_docs_v_blocks_dos_donts_dos" to "anon";

grant delete on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant insert on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant references on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant select on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant update on table "public"."_docs_v_blocks_dos_donts_dos" to "authenticated";

grant delete on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant insert on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant references on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant select on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant trigger on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant truncate on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant update on table "public"."_docs_v_blocks_dos_donts_dos" to "service_role";

grant delete on table "public"."_docs_v_blocks_download_button" to "anon";

grant insert on table "public"."_docs_v_blocks_download_button" to "anon";

grant references on table "public"."_docs_v_blocks_download_button" to "anon";

grant select on table "public"."_docs_v_blocks_download_button" to "anon";

grant trigger on table "public"."_docs_v_blocks_download_button" to "anon";

grant truncate on table "public"."_docs_v_blocks_download_button" to "anon";

grant update on table "public"."_docs_v_blocks_download_button" to "anon";

grant delete on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant insert on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant references on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant select on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant update on table "public"."_docs_v_blocks_download_button" to "authenticated";

grant delete on table "public"."_docs_v_blocks_download_button" to "service_role";

grant insert on table "public"."_docs_v_blocks_download_button" to "service_role";

grant references on table "public"."_docs_v_blocks_download_button" to "service_role";

grant select on table "public"."_docs_v_blocks_download_button" to "service_role";

grant trigger on table "public"."_docs_v_blocks_download_button" to "service_role";

grant truncate on table "public"."_docs_v_blocks_download_button" to "service_role";

grant update on table "public"."_docs_v_blocks_download_button" to "service_role";

grant delete on table "public"."docs_blocks_color_swatch" to "anon";

grant insert on table "public"."docs_blocks_color_swatch" to "anon";

grant references on table "public"."docs_blocks_color_swatch" to "anon";

grant select on table "public"."docs_blocks_color_swatch" to "anon";

grant trigger on table "public"."docs_blocks_color_swatch" to "anon";

grant truncate on table "public"."docs_blocks_color_swatch" to "anon";

grant update on table "public"."docs_blocks_color_swatch" to "anon";

grant delete on table "public"."docs_blocks_color_swatch" to "authenticated";

grant insert on table "public"."docs_blocks_color_swatch" to "authenticated";

grant references on table "public"."docs_blocks_color_swatch" to "authenticated";

grant select on table "public"."docs_blocks_color_swatch" to "authenticated";

grant trigger on table "public"."docs_blocks_color_swatch" to "authenticated";

grant truncate on table "public"."docs_blocks_color_swatch" to "authenticated";

grant update on table "public"."docs_blocks_color_swatch" to "authenticated";

grant delete on table "public"."docs_blocks_color_swatch" to "service_role";

grant insert on table "public"."docs_blocks_color_swatch" to "service_role";

grant references on table "public"."docs_blocks_color_swatch" to "service_role";

grant select on table "public"."docs_blocks_color_swatch" to "service_role";

grant trigger on table "public"."docs_blocks_color_swatch" to "service_role";

grant truncate on table "public"."docs_blocks_color_swatch" to "service_role";

grant update on table "public"."docs_blocks_color_swatch" to "service_role";

grant delete on table "public"."docs_blocks_contact_card" to "anon";

grant insert on table "public"."docs_blocks_contact_card" to "anon";

grant references on table "public"."docs_blocks_contact_card" to "anon";

grant select on table "public"."docs_blocks_contact_card" to "anon";

grant trigger on table "public"."docs_blocks_contact_card" to "anon";

grant truncate on table "public"."docs_blocks_contact_card" to "anon";

grant update on table "public"."docs_blocks_contact_card" to "anon";

grant delete on table "public"."docs_blocks_contact_card" to "authenticated";

grant insert on table "public"."docs_blocks_contact_card" to "authenticated";

grant references on table "public"."docs_blocks_contact_card" to "authenticated";

grant select on table "public"."docs_blocks_contact_card" to "authenticated";

grant trigger on table "public"."docs_blocks_contact_card" to "authenticated";

grant truncate on table "public"."docs_blocks_contact_card" to "authenticated";

grant update on table "public"."docs_blocks_contact_card" to "authenticated";

grant delete on table "public"."docs_blocks_contact_card" to "service_role";

grant insert on table "public"."docs_blocks_contact_card" to "service_role";

grant references on table "public"."docs_blocks_contact_card" to "service_role";

grant select on table "public"."docs_blocks_contact_card" to "service_role";

grant trigger on table "public"."docs_blocks_contact_card" to "service_role";

grant truncate on table "public"."docs_blocks_contact_card" to "service_role";

grant update on table "public"."docs_blocks_contact_card" to "service_role";

grant delete on table "public"."docs_blocks_dos_donts" to "anon";

grant insert on table "public"."docs_blocks_dos_donts" to "anon";

grant references on table "public"."docs_blocks_dos_donts" to "anon";

grant select on table "public"."docs_blocks_dos_donts" to "anon";

grant trigger on table "public"."docs_blocks_dos_donts" to "anon";

grant truncate on table "public"."docs_blocks_dos_donts" to "anon";

grant update on table "public"."docs_blocks_dos_donts" to "anon";

grant delete on table "public"."docs_blocks_dos_donts" to "authenticated";

grant insert on table "public"."docs_blocks_dos_donts" to "authenticated";

grant references on table "public"."docs_blocks_dos_donts" to "authenticated";

grant select on table "public"."docs_blocks_dos_donts" to "authenticated";

grant trigger on table "public"."docs_blocks_dos_donts" to "authenticated";

grant truncate on table "public"."docs_blocks_dos_donts" to "authenticated";

grant update on table "public"."docs_blocks_dos_donts" to "authenticated";

grant delete on table "public"."docs_blocks_dos_donts" to "service_role";

grant insert on table "public"."docs_blocks_dos_donts" to "service_role";

grant references on table "public"."docs_blocks_dos_donts" to "service_role";

grant select on table "public"."docs_blocks_dos_donts" to "service_role";

grant trigger on table "public"."docs_blocks_dos_donts" to "service_role";

grant truncate on table "public"."docs_blocks_dos_donts" to "service_role";

grant update on table "public"."docs_blocks_dos_donts" to "service_role";

grant delete on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant insert on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant references on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant select on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant trigger on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant truncate on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant update on table "public"."docs_blocks_dos_donts_donts" to "anon";

grant delete on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant insert on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant references on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant select on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant trigger on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant truncate on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant update on table "public"."docs_blocks_dos_donts_donts" to "authenticated";

grant delete on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant insert on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant references on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant select on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant trigger on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant truncate on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant update on table "public"."docs_blocks_dos_donts_donts" to "service_role";

grant delete on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant insert on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant references on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant select on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant trigger on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant truncate on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant update on table "public"."docs_blocks_dos_donts_dos" to "anon";

grant delete on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant insert on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant references on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant select on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant trigger on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant truncate on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant update on table "public"."docs_blocks_dos_donts_dos" to "authenticated";

grant delete on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant insert on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant references on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant select on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant trigger on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant truncate on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant update on table "public"."docs_blocks_dos_donts_dos" to "service_role";

grant delete on table "public"."docs_blocks_download_button" to "anon";

grant insert on table "public"."docs_blocks_download_button" to "anon";

grant references on table "public"."docs_blocks_download_button" to "anon";

grant select on table "public"."docs_blocks_download_button" to "anon";

grant trigger on table "public"."docs_blocks_download_button" to "anon";

grant truncate on table "public"."docs_blocks_download_button" to "anon";

grant update on table "public"."docs_blocks_download_button" to "anon";

grant delete on table "public"."docs_blocks_download_button" to "authenticated";

grant insert on table "public"."docs_blocks_download_button" to "authenticated";

grant references on table "public"."docs_blocks_download_button" to "authenticated";

grant select on table "public"."docs_blocks_download_button" to "authenticated";

grant trigger on table "public"."docs_blocks_download_button" to "authenticated";

grant truncate on table "public"."docs_blocks_download_button" to "authenticated";

grant update on table "public"."docs_blocks_download_button" to "authenticated";

grant delete on table "public"."docs_blocks_download_button" to "service_role";

grant insert on table "public"."docs_blocks_download_button" to "service_role";

grant references on table "public"."docs_blocks_download_button" to "service_role";

grant select on table "public"."docs_blocks_download_button" to "service_role";

grant trigger on table "public"."docs_blocks_download_button" to "service_role";

grant truncate on table "public"."docs_blocks_download_button" to "service_role";

grant update on table "public"."docs_blocks_download_button" to "service_role";


