create type "public"."enum__docs_v_blocks_callout_type" as enum ('info', 'warning', 'tip', 'caution');

create type "public"."enum__docs_v_blocks_card_grid_columns" as enum ('2', '3', '4');

create type "public"."enum__docs_v_blocks_code_block_language" as enum ('typescript', 'javascript', 'html', 'css', 'json', 'bash', 'python', 'markdown');

create type "public"."enum__docs_v_blocks_divider_style" as enum ('line', 'space', 'dots');

create type "public"."enum__docs_v_blocks_image_block_size" as enum ('full', 'medium', 'small');

create type "public"."enum__docs_v_version_status" as enum ('draft', 'published');

create type "public"."enum_docs_blocks_callout_type" as enum ('info', 'warning', 'tip', 'caution');

create type "public"."enum_docs_blocks_card_grid_columns" as enum ('2', '3', '4');

create type "public"."enum_docs_blocks_code_block_language" as enum ('typescript', 'javascript', 'html', 'css', 'json', 'bash', 'python', 'markdown');

create type "public"."enum_docs_blocks_divider_style" as enum ('line', 'space', 'dots');

create type "public"."enum_docs_blocks_image_block_size" as enum ('full', 'medium', 'small');

create type "public"."enum_docs_status" as enum ('draft', 'published');

create type "public"."enum_users_role" as enum ('admin', 'editor');

create sequence "public"."_docs_v_blocks_callout_id_seq";

create sequence "public"."_docs_v_blocks_card_grid_cards_id_seq";

create sequence "public"."_docs_v_blocks_card_grid_id_seq";

create sequence "public"."_docs_v_blocks_code_block_id_seq";

create sequence "public"."_docs_v_blocks_divider_id_seq";

create sequence "public"."_docs_v_blocks_image_block_id_seq";

create sequence "public"."_docs_v_blocks_rich_text_id_seq";

create sequence "public"."_docs_v_blocks_steps_id_seq";

create sequence "public"."_docs_v_blocks_steps_steps_id_seq";

create sequence "public"."_docs_v_blocks_table_headers_id_seq";

create sequence "public"."_docs_v_blocks_table_id_seq";

create sequence "public"."_docs_v_blocks_table_rows_cells_id_seq";

create sequence "public"."_docs_v_blocks_table_rows_id_seq";

create sequence "public"."_docs_v_id_seq";

create sequence "public"."categories_id_seq";

create sequence "public"."docs_id_seq";

create sequence "public"."media_id_seq";

create sequence "public"."payload_kv_id_seq";

create sequence "public"."payload_locked_documents_id_seq";

create sequence "public"."payload_locked_documents_rels_id_seq";

create sequence "public"."payload_migrations_id_seq";

create sequence "public"."payload_preferences_id_seq";

create sequence "public"."payload_preferences_rels_id_seq";

create sequence "public"."site_config_id_seq";

create sequence "public"."users_id_seq";


  create table "public"."_docs_v" (
    "id" integer not null default nextval('public._docs_v_id_seq'::regclass),
    "parent_id" integer,
    "version_title" character varying,
    "version_slug" character varying,
    "version_description" character varying,
    "version_category_id" integer,
    "version_parent_id" integer,
    "version_order" numeric default 0,
    "version_sidebar_label" character varying,
    "version_show_in_sidebar" boolean default true,
    "version_updated_at" timestamp(3) with time zone,
    "version_created_at" timestamp(3) with time zone,
    "version__status" public.enum__docs_v_version_status default 'draft'::public.enum__docs_v_version_status,
    "created_at" timestamp(3) with time zone not null default now(),
    "updated_at" timestamp(3) with time zone not null default now(),
    "latest" boolean,
    "autosave" boolean
      );



  create table "public"."_docs_v_blocks_callout" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_callout_id_seq'::regclass),
    "type" public.enum__docs_v_blocks_callout_type default 'info'::public.enum__docs_v_blocks_callout_type,
    "content" jsonb,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_card_grid" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_card_grid_id_seq'::regclass),
    "columns" public.enum__docs_v_blocks_card_grid_columns default '3'::public.enum__docs_v_blocks_card_grid_columns,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_card_grid_cards" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_card_grid_cards_id_seq'::regclass),
    "title" character varying,
    "description" character varying,
    "image_id" integer,
    "link" character varying,
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_code_block" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_code_block_id_seq'::regclass),
    "code" character varying,
    "language" public.enum__docs_v_blocks_code_block_language default 'typescript'::public.enum__docs_v_blocks_code_block_language,
    "title" character varying,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_divider" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_divider_id_seq'::regclass),
    "style" public.enum__docs_v_blocks_divider_style default 'line'::public.enum__docs_v_blocks_divider_style,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_image_block" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_image_block_id_seq'::regclass),
    "image_id" integer,
    "caption" character varying,
    "size" public.enum__docs_v_blocks_image_block_size default 'full'::public.enum__docs_v_blocks_image_block_size,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_rich_text" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_rich_text_id_seq'::regclass),
    "content" jsonb,
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_steps" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_steps_id_seq'::regclass),
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_steps_steps" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_steps_steps_id_seq'::regclass),
    "title" character varying,
    "content" jsonb,
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_table" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" integer not null default nextval('public._docs_v_blocks_table_id_seq'::regclass),
    "_uuid" character varying,
    "block_name" character varying
      );



  create table "public"."_docs_v_blocks_table_headers" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_table_headers_id_seq'::regclass),
    "label" character varying,
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_table_rows" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_table_rows_id_seq'::regclass),
    "_uuid" character varying
      );



  create table "public"."_docs_v_blocks_table_rows_cells" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" integer not null default nextval('public._docs_v_blocks_table_rows_cells_id_seq'::regclass),
    "value" character varying,
    "_uuid" character varying
      );



  create table "public"."categories" (
    "id" integer not null default nextval('public.categories_id_seq'::regclass),
    "title" character varying not null,
    "slug" character varying not null,
    "description" character varying,
    "parent_category_id" integer,
    "icon" character varying,
    "order" numeric not null default 0,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now()
      );



  create table "public"."docs" (
    "id" integer not null default nextval('public.docs_id_seq'::regclass),
    "title" character varying,
    "slug" character varying,
    "description" character varying,
    "category_id" integer,
    "parent_id" integer,
    "order" numeric default 0,
    "sidebar_label" character varying,
    "show_in_sidebar" boolean default true,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now(),
    "_status" public.enum_docs_status default 'draft'::public.enum_docs_status
      );



  create table "public"."docs_blocks_callout" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "type" public.enum_docs_blocks_callout_type default 'info'::public.enum_docs_blocks_callout_type,
    "content" jsonb,
    "block_name" character varying
      );



  create table "public"."docs_blocks_card_grid" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "columns" public.enum_docs_blocks_card_grid_columns default '3'::public.enum_docs_blocks_card_grid_columns,
    "block_name" character varying
      );



  create table "public"."docs_blocks_card_grid_cards" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "title" character varying,
    "description" character varying,
    "image_id" integer,
    "link" character varying
      );



  create table "public"."docs_blocks_code_block" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "code" character varying,
    "language" public.enum_docs_blocks_code_block_language default 'typescript'::public.enum_docs_blocks_code_block_language,
    "title" character varying,
    "block_name" character varying
      );



  create table "public"."docs_blocks_divider" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "style" public.enum_docs_blocks_divider_style default 'line'::public.enum_docs_blocks_divider_style,
    "block_name" character varying
      );



  create table "public"."docs_blocks_image_block" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "image_id" integer,
    "caption" character varying,
    "size" public.enum_docs_blocks_image_block_size default 'full'::public.enum_docs_blocks_image_block_size,
    "block_name" character varying
      );



  create table "public"."docs_blocks_rich_text" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "content" jsonb,
    "block_name" character varying
      );



  create table "public"."docs_blocks_steps" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "block_name" character varying
      );



  create table "public"."docs_blocks_steps_steps" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "title" character varying,
    "content" jsonb
      );



  create table "public"."docs_blocks_table" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "_path" text not null,
    "id" character varying not null,
    "block_name" character varying
      );



  create table "public"."docs_blocks_table_headers" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "label" character varying
      );



  create table "public"."docs_blocks_table_rows" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null
      );



  create table "public"."docs_blocks_table_rows_cells" (
    "_order" integer not null,
    "_parent_id" character varying not null,
    "id" character varying not null,
    "value" character varying
      );



  create table "public"."media" (
    "id" integer not null default nextval('public.media_id_seq'::regclass),
    "alt" character varying not null,
    "caption" character varying,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now(),
    "url" character varying,
    "thumbnail_u_r_l" character varying,
    "filename" character varying,
    "mime_type" character varying,
    "filesize" numeric,
    "width" numeric,
    "height" numeric,
    "focal_x" numeric,
    "focal_y" numeric,
    "sizes_thumbnail_url" character varying,
    "sizes_thumbnail_width" numeric,
    "sizes_thumbnail_height" numeric,
    "sizes_thumbnail_mime_type" character varying,
    "sizes_thumbnail_filesize" numeric,
    "sizes_thumbnail_filename" character varying,
    "sizes_card_url" character varying,
    "sizes_card_width" numeric,
    "sizes_card_height" numeric,
    "sizes_card_mime_type" character varying,
    "sizes_card_filesize" numeric,
    "sizes_card_filename" character varying
      );



  create table "public"."payload_kv" (
    "id" integer not null default nextval('public.payload_kv_id_seq'::regclass),
    "key" character varying not null,
    "data" jsonb not null
      );



  create table "public"."payload_locked_documents" (
    "id" integer not null default nextval('public.payload_locked_documents_id_seq'::regclass),
    "global_slug" character varying,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now()
      );



  create table "public"."payload_locked_documents_rels" (
    "id" integer not null default nextval('public.payload_locked_documents_rels_id_seq'::regclass),
    "order" integer,
    "parent_id" integer not null,
    "path" character varying not null,
    "users_id" integer,
    "media_id" integer,
    "categories_id" integer,
    "docs_id" integer
      );



  create table "public"."payload_migrations" (
    "id" integer not null default nextval('public.payload_migrations_id_seq'::regclass),
    "name" character varying,
    "batch" numeric,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now()
      );



  create table "public"."payload_preferences" (
    "id" integer not null default nextval('public.payload_preferences_id_seq'::regclass),
    "key" character varying,
    "value" jsonb,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now()
      );



  create table "public"."payload_preferences_rels" (
    "id" integer not null default nextval('public.payload_preferences_rels_id_seq'::regclass),
    "order" integer,
    "parent_id" integer not null,
    "path" character varying not null,
    "users_id" integer
      );



  create table "public"."site_config" (
    "id" integer not null default nextval('public.site_config_id_seq'::regclass),
    "site_name" character varying not null default 'ATOM Design Language'::character varying,
    "site_description" character varying,
    "logo_light_id" integer,
    "logo_dark_id" integer,
    "github_url" character varying,
    "updated_at" timestamp(3) with time zone,
    "created_at" timestamp(3) with time zone
      );



  create table "public"."users" (
    "id" integer not null default nextval('public.users_id_seq'::regclass),
    "name" character varying not null,
    "role" public.enum_users_role not null default 'editor'::public.enum_users_role,
    "updated_at" timestamp(3) with time zone not null default now(),
    "created_at" timestamp(3) with time zone not null default now(),
    "email" character varying not null,
    "reset_password_token" character varying,
    "reset_password_expiration" timestamp(3) with time zone,
    "salt" character varying,
    "hash" character varying,
    "login_attempts" numeric default 0,
    "lock_until" timestamp(3) with time zone
      );



  create table "public"."users_sessions" (
    "_order" integer not null,
    "_parent_id" integer not null,
    "id" character varying not null,
    "created_at" timestamp(3) with time zone,
    "expires_at" timestamp(3) with time zone not null
      );


alter sequence "public"."_docs_v_blocks_callout_id_seq" owned by "public"."_docs_v_blocks_callout"."id";

alter sequence "public"."_docs_v_blocks_card_grid_cards_id_seq" owned by "public"."_docs_v_blocks_card_grid_cards"."id";

alter sequence "public"."_docs_v_blocks_card_grid_id_seq" owned by "public"."_docs_v_blocks_card_grid"."id";

alter sequence "public"."_docs_v_blocks_code_block_id_seq" owned by "public"."_docs_v_blocks_code_block"."id";

alter sequence "public"."_docs_v_blocks_divider_id_seq" owned by "public"."_docs_v_blocks_divider"."id";

alter sequence "public"."_docs_v_blocks_image_block_id_seq" owned by "public"."_docs_v_blocks_image_block"."id";

alter sequence "public"."_docs_v_blocks_rich_text_id_seq" owned by "public"."_docs_v_blocks_rich_text"."id";

alter sequence "public"."_docs_v_blocks_steps_id_seq" owned by "public"."_docs_v_blocks_steps"."id";

alter sequence "public"."_docs_v_blocks_steps_steps_id_seq" owned by "public"."_docs_v_blocks_steps_steps"."id";

alter sequence "public"."_docs_v_blocks_table_headers_id_seq" owned by "public"."_docs_v_blocks_table_headers"."id";

alter sequence "public"."_docs_v_blocks_table_id_seq" owned by "public"."_docs_v_blocks_table"."id";

alter sequence "public"."_docs_v_blocks_table_rows_cells_id_seq" owned by "public"."_docs_v_blocks_table_rows_cells"."id";

alter sequence "public"."_docs_v_blocks_table_rows_id_seq" owned by "public"."_docs_v_blocks_table_rows"."id";

alter sequence "public"."_docs_v_id_seq" owned by "public"."_docs_v"."id";

alter sequence "public"."categories_id_seq" owned by "public"."categories"."id";

alter sequence "public"."docs_id_seq" owned by "public"."docs"."id";

alter sequence "public"."media_id_seq" owned by "public"."media"."id";

alter sequence "public"."payload_kv_id_seq" owned by "public"."payload_kv"."id";

alter sequence "public"."payload_locked_documents_id_seq" owned by "public"."payload_locked_documents"."id";

alter sequence "public"."payload_locked_documents_rels_id_seq" owned by "public"."payload_locked_documents_rels"."id";

alter sequence "public"."payload_migrations_id_seq" owned by "public"."payload_migrations"."id";

alter sequence "public"."payload_preferences_id_seq" owned by "public"."payload_preferences"."id";

alter sequence "public"."payload_preferences_rels_id_seq" owned by "public"."payload_preferences_rels"."id";

alter sequence "public"."site_config_id_seq" owned by "public"."site_config"."id";

alter sequence "public"."users_id_seq" owned by "public"."users"."id";

CREATE INDEX _docs_v_autosave_idx ON public._docs_v USING btree (autosave);

CREATE INDEX _docs_v_blocks_callout_order_idx ON public._docs_v_blocks_callout USING btree (_order);

CREATE INDEX _docs_v_blocks_callout_parent_id_idx ON public._docs_v_blocks_callout USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_callout_path_idx ON public._docs_v_blocks_callout USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_callout_pkey ON public._docs_v_blocks_callout USING btree (id);

CREATE INDEX _docs_v_blocks_card_grid_cards_image_idx ON public._docs_v_blocks_card_grid_cards USING btree (image_id);

CREATE INDEX _docs_v_blocks_card_grid_cards_order_idx ON public._docs_v_blocks_card_grid_cards USING btree (_order);

CREATE INDEX _docs_v_blocks_card_grid_cards_parent_id_idx ON public._docs_v_blocks_card_grid_cards USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_card_grid_cards_pkey ON public._docs_v_blocks_card_grid_cards USING btree (id);

CREATE INDEX _docs_v_blocks_card_grid_order_idx ON public._docs_v_blocks_card_grid USING btree (_order);

CREATE INDEX _docs_v_blocks_card_grid_parent_id_idx ON public._docs_v_blocks_card_grid USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_card_grid_path_idx ON public._docs_v_blocks_card_grid USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_card_grid_pkey ON public._docs_v_blocks_card_grid USING btree (id);

CREATE INDEX _docs_v_blocks_code_block_order_idx ON public._docs_v_blocks_code_block USING btree (_order);

CREATE INDEX _docs_v_blocks_code_block_parent_id_idx ON public._docs_v_blocks_code_block USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_code_block_path_idx ON public._docs_v_blocks_code_block USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_code_block_pkey ON public._docs_v_blocks_code_block USING btree (id);

CREATE INDEX _docs_v_blocks_divider_order_idx ON public._docs_v_blocks_divider USING btree (_order);

CREATE INDEX _docs_v_blocks_divider_parent_id_idx ON public._docs_v_blocks_divider USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_divider_path_idx ON public._docs_v_blocks_divider USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_divider_pkey ON public._docs_v_blocks_divider USING btree (id);

CREATE INDEX _docs_v_blocks_image_block_image_idx ON public._docs_v_blocks_image_block USING btree (image_id);

CREATE INDEX _docs_v_blocks_image_block_order_idx ON public._docs_v_blocks_image_block USING btree (_order);

CREATE INDEX _docs_v_blocks_image_block_parent_id_idx ON public._docs_v_blocks_image_block USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_image_block_path_idx ON public._docs_v_blocks_image_block USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_image_block_pkey ON public._docs_v_blocks_image_block USING btree (id);

CREATE INDEX _docs_v_blocks_rich_text_order_idx ON public._docs_v_blocks_rich_text USING btree (_order);

CREATE INDEX _docs_v_blocks_rich_text_parent_id_idx ON public._docs_v_blocks_rich_text USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_rich_text_path_idx ON public._docs_v_blocks_rich_text USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_rich_text_pkey ON public._docs_v_blocks_rich_text USING btree (id);

CREATE INDEX _docs_v_blocks_steps_order_idx ON public._docs_v_blocks_steps USING btree (_order);

CREATE INDEX _docs_v_blocks_steps_parent_id_idx ON public._docs_v_blocks_steps USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_steps_path_idx ON public._docs_v_blocks_steps USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_steps_pkey ON public._docs_v_blocks_steps USING btree (id);

CREATE INDEX _docs_v_blocks_steps_steps_order_idx ON public._docs_v_blocks_steps_steps USING btree (_order);

CREATE INDEX _docs_v_blocks_steps_steps_parent_id_idx ON public._docs_v_blocks_steps_steps USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_steps_steps_pkey ON public._docs_v_blocks_steps_steps USING btree (id);

CREATE INDEX _docs_v_blocks_table_headers_order_idx ON public._docs_v_blocks_table_headers USING btree (_order);

CREATE INDEX _docs_v_blocks_table_headers_parent_id_idx ON public._docs_v_blocks_table_headers USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_table_headers_pkey ON public._docs_v_blocks_table_headers USING btree (id);

CREATE INDEX _docs_v_blocks_table_order_idx ON public._docs_v_blocks_table USING btree (_order);

CREATE INDEX _docs_v_blocks_table_parent_id_idx ON public._docs_v_blocks_table USING btree (_parent_id);

CREATE INDEX _docs_v_blocks_table_path_idx ON public._docs_v_blocks_table USING btree (_path);

CREATE UNIQUE INDEX _docs_v_blocks_table_pkey ON public._docs_v_blocks_table USING btree (id);

CREATE INDEX _docs_v_blocks_table_rows_cells_order_idx ON public._docs_v_blocks_table_rows_cells USING btree (_order);

CREATE INDEX _docs_v_blocks_table_rows_cells_parent_id_idx ON public._docs_v_blocks_table_rows_cells USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_table_rows_cells_pkey ON public._docs_v_blocks_table_rows_cells USING btree (id);

CREATE INDEX _docs_v_blocks_table_rows_order_idx ON public._docs_v_blocks_table_rows USING btree (_order);

CREATE INDEX _docs_v_blocks_table_rows_parent_id_idx ON public._docs_v_blocks_table_rows USING btree (_parent_id);

CREATE UNIQUE INDEX _docs_v_blocks_table_rows_pkey ON public._docs_v_blocks_table_rows USING btree (id);

CREATE INDEX _docs_v_created_at_idx ON public._docs_v USING btree (created_at);

CREATE INDEX _docs_v_latest_idx ON public._docs_v USING btree (latest);

CREATE INDEX _docs_v_parent_idx ON public._docs_v USING btree (parent_id);

CREATE UNIQUE INDEX _docs_v_pkey ON public._docs_v USING btree (id);

CREATE INDEX _docs_v_updated_at_idx ON public._docs_v USING btree (updated_at);

CREATE INDEX _docs_v_version_version__status_idx ON public._docs_v USING btree (version__status);

CREATE INDEX _docs_v_version_version_category_idx ON public._docs_v USING btree (version_category_id);

CREATE INDEX _docs_v_version_version_created_at_idx ON public._docs_v USING btree (version_created_at);

CREATE INDEX _docs_v_version_version_parent_idx ON public._docs_v USING btree (version_parent_id);

CREATE INDEX _docs_v_version_version_slug_idx ON public._docs_v USING btree (version_slug);

CREATE INDEX _docs_v_version_version_updated_at_idx ON public._docs_v USING btree (version_updated_at);

CREATE INDEX categories_created_at_idx ON public.categories USING btree (created_at);

CREATE INDEX categories_parent_category_idx ON public.categories USING btree (parent_category_id);

CREATE UNIQUE INDEX categories_pkey ON public.categories USING btree (id);

CREATE UNIQUE INDEX categories_slug_idx ON public.categories USING btree (slug);

CREATE INDEX categories_updated_at_idx ON public.categories USING btree (updated_at);

CREATE INDEX docs__status_idx ON public.docs USING btree (_status);

CREATE INDEX docs_blocks_callout_order_idx ON public.docs_blocks_callout USING btree (_order);

CREATE INDEX docs_blocks_callout_parent_id_idx ON public.docs_blocks_callout USING btree (_parent_id);

CREATE INDEX docs_blocks_callout_path_idx ON public.docs_blocks_callout USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_callout_pkey ON public.docs_blocks_callout USING btree (id);

CREATE INDEX docs_blocks_card_grid_cards_image_idx ON public.docs_blocks_card_grid_cards USING btree (image_id);

CREATE INDEX docs_blocks_card_grid_cards_order_idx ON public.docs_blocks_card_grid_cards USING btree (_order);

CREATE INDEX docs_blocks_card_grid_cards_parent_id_idx ON public.docs_blocks_card_grid_cards USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_card_grid_cards_pkey ON public.docs_blocks_card_grid_cards USING btree (id);

CREATE INDEX docs_blocks_card_grid_order_idx ON public.docs_blocks_card_grid USING btree (_order);

CREATE INDEX docs_blocks_card_grid_parent_id_idx ON public.docs_blocks_card_grid USING btree (_parent_id);

CREATE INDEX docs_blocks_card_grid_path_idx ON public.docs_blocks_card_grid USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_card_grid_pkey ON public.docs_blocks_card_grid USING btree (id);

CREATE INDEX docs_blocks_code_block_order_idx ON public.docs_blocks_code_block USING btree (_order);

CREATE INDEX docs_blocks_code_block_parent_id_idx ON public.docs_blocks_code_block USING btree (_parent_id);

CREATE INDEX docs_blocks_code_block_path_idx ON public.docs_blocks_code_block USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_code_block_pkey ON public.docs_blocks_code_block USING btree (id);

CREATE INDEX docs_blocks_divider_order_idx ON public.docs_blocks_divider USING btree (_order);

CREATE INDEX docs_blocks_divider_parent_id_idx ON public.docs_blocks_divider USING btree (_parent_id);

CREATE INDEX docs_blocks_divider_path_idx ON public.docs_blocks_divider USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_divider_pkey ON public.docs_blocks_divider USING btree (id);

CREATE INDEX docs_blocks_image_block_image_idx ON public.docs_blocks_image_block USING btree (image_id);

CREATE INDEX docs_blocks_image_block_order_idx ON public.docs_blocks_image_block USING btree (_order);

CREATE INDEX docs_blocks_image_block_parent_id_idx ON public.docs_blocks_image_block USING btree (_parent_id);

CREATE INDEX docs_blocks_image_block_path_idx ON public.docs_blocks_image_block USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_image_block_pkey ON public.docs_blocks_image_block USING btree (id);

CREATE INDEX docs_blocks_rich_text_order_idx ON public.docs_blocks_rich_text USING btree (_order);

CREATE INDEX docs_blocks_rich_text_parent_id_idx ON public.docs_blocks_rich_text USING btree (_parent_id);

CREATE INDEX docs_blocks_rich_text_path_idx ON public.docs_blocks_rich_text USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_rich_text_pkey ON public.docs_blocks_rich_text USING btree (id);

CREATE INDEX docs_blocks_steps_order_idx ON public.docs_blocks_steps USING btree (_order);

CREATE INDEX docs_blocks_steps_parent_id_idx ON public.docs_blocks_steps USING btree (_parent_id);

CREATE INDEX docs_blocks_steps_path_idx ON public.docs_blocks_steps USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_steps_pkey ON public.docs_blocks_steps USING btree (id);

CREATE INDEX docs_blocks_steps_steps_order_idx ON public.docs_blocks_steps_steps USING btree (_order);

CREATE INDEX docs_blocks_steps_steps_parent_id_idx ON public.docs_blocks_steps_steps USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_steps_steps_pkey ON public.docs_blocks_steps_steps USING btree (id);

CREATE INDEX docs_blocks_table_headers_order_idx ON public.docs_blocks_table_headers USING btree (_order);

CREATE INDEX docs_blocks_table_headers_parent_id_idx ON public.docs_blocks_table_headers USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_table_headers_pkey ON public.docs_blocks_table_headers USING btree (id);

CREATE INDEX docs_blocks_table_order_idx ON public.docs_blocks_table USING btree (_order);

CREATE INDEX docs_blocks_table_parent_id_idx ON public.docs_blocks_table USING btree (_parent_id);

CREATE INDEX docs_blocks_table_path_idx ON public.docs_blocks_table USING btree (_path);

CREATE UNIQUE INDEX docs_blocks_table_pkey ON public.docs_blocks_table USING btree (id);

CREATE INDEX docs_blocks_table_rows_cells_order_idx ON public.docs_blocks_table_rows_cells USING btree (_order);

CREATE INDEX docs_blocks_table_rows_cells_parent_id_idx ON public.docs_blocks_table_rows_cells USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_table_rows_cells_pkey ON public.docs_blocks_table_rows_cells USING btree (id);

CREATE INDEX docs_blocks_table_rows_order_idx ON public.docs_blocks_table_rows USING btree (_order);

CREATE INDEX docs_blocks_table_rows_parent_id_idx ON public.docs_blocks_table_rows USING btree (_parent_id);

CREATE UNIQUE INDEX docs_blocks_table_rows_pkey ON public.docs_blocks_table_rows USING btree (id);

CREATE INDEX docs_category_idx ON public.docs USING btree (category_id);

CREATE INDEX docs_created_at_idx ON public.docs USING btree (created_at);

CREATE INDEX docs_parent_idx ON public.docs USING btree (parent_id);

CREATE UNIQUE INDEX docs_pkey ON public.docs USING btree (id);

CREATE INDEX docs_slug_idx ON public.docs USING btree (slug);

CREATE INDEX docs_updated_at_idx ON public.docs USING btree (updated_at);

CREATE INDEX media_created_at_idx ON public.media USING btree (created_at);

CREATE UNIQUE INDEX media_filename_idx ON public.media USING btree (filename);

CREATE UNIQUE INDEX media_pkey ON public.media USING btree (id);

CREATE INDEX media_sizes_card_sizes_card_filename_idx ON public.media USING btree (sizes_card_filename);

CREATE INDEX media_sizes_thumbnail_sizes_thumbnail_filename_idx ON public.media USING btree (sizes_thumbnail_filename);

CREATE INDEX media_updated_at_idx ON public.media USING btree (updated_at);

CREATE UNIQUE INDEX payload_kv_key_idx ON public.payload_kv USING btree (key);

CREATE UNIQUE INDEX payload_kv_pkey ON public.payload_kv USING btree (id);

CREATE INDEX payload_locked_documents_created_at_idx ON public.payload_locked_documents USING btree (created_at);

CREATE INDEX payload_locked_documents_global_slug_idx ON public.payload_locked_documents USING btree (global_slug);

CREATE UNIQUE INDEX payload_locked_documents_pkey ON public.payload_locked_documents USING btree (id);

CREATE INDEX payload_locked_documents_rels_categories_id_idx ON public.payload_locked_documents_rels USING btree (categories_id);

CREATE INDEX payload_locked_documents_rels_docs_id_idx ON public.payload_locked_documents_rels USING btree (docs_id);

CREATE INDEX payload_locked_documents_rels_media_id_idx ON public.payload_locked_documents_rels USING btree (media_id);

CREATE INDEX payload_locked_documents_rels_order_idx ON public.payload_locked_documents_rels USING btree ("order");

CREATE INDEX payload_locked_documents_rels_parent_idx ON public.payload_locked_documents_rels USING btree (parent_id);

CREATE INDEX payload_locked_documents_rels_path_idx ON public.payload_locked_documents_rels USING btree (path);

CREATE UNIQUE INDEX payload_locked_documents_rels_pkey ON public.payload_locked_documents_rels USING btree (id);

CREATE INDEX payload_locked_documents_rels_users_id_idx ON public.payload_locked_documents_rels USING btree (users_id);

CREATE INDEX payload_locked_documents_updated_at_idx ON public.payload_locked_documents USING btree (updated_at);

CREATE INDEX payload_migrations_created_at_idx ON public.payload_migrations USING btree (created_at);

CREATE UNIQUE INDEX payload_migrations_pkey ON public.payload_migrations USING btree (id);

CREATE INDEX payload_migrations_updated_at_idx ON public.payload_migrations USING btree (updated_at);

CREATE INDEX payload_preferences_created_at_idx ON public.payload_preferences USING btree (created_at);

CREATE INDEX payload_preferences_key_idx ON public.payload_preferences USING btree (key);

CREATE UNIQUE INDEX payload_preferences_pkey ON public.payload_preferences USING btree (id);

CREATE INDEX payload_preferences_rels_order_idx ON public.payload_preferences_rels USING btree ("order");

CREATE INDEX payload_preferences_rels_parent_idx ON public.payload_preferences_rels USING btree (parent_id);

CREATE INDEX payload_preferences_rels_path_idx ON public.payload_preferences_rels USING btree (path);

CREATE UNIQUE INDEX payload_preferences_rels_pkey ON public.payload_preferences_rels USING btree (id);

CREATE INDEX payload_preferences_rels_users_id_idx ON public.payload_preferences_rels USING btree (users_id);

CREATE INDEX payload_preferences_updated_at_idx ON public.payload_preferences USING btree (updated_at);

CREATE INDEX site_config_logo_dark_idx ON public.site_config USING btree (logo_dark_id);

CREATE INDEX site_config_logo_light_idx ON public.site_config USING btree (logo_light_id);

CREATE UNIQUE INDEX site_config_pkey ON public.site_config USING btree (id);

CREATE INDEX users_created_at_idx ON public.users USING btree (created_at);

CREATE UNIQUE INDEX users_email_idx ON public.users USING btree (email);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

CREATE INDEX users_sessions_order_idx ON public.users_sessions USING btree (_order);

CREATE INDEX users_sessions_parent_id_idx ON public.users_sessions USING btree (_parent_id);

CREATE UNIQUE INDEX users_sessions_pkey ON public.users_sessions USING btree (id);

CREATE INDEX users_updated_at_idx ON public.users USING btree (updated_at);

alter table "public"."_docs_v" add constraint "_docs_v_pkey" PRIMARY KEY using index "_docs_v_pkey";

alter table "public"."_docs_v_blocks_callout" add constraint "_docs_v_blocks_callout_pkey" PRIMARY KEY using index "_docs_v_blocks_callout_pkey";

alter table "public"."_docs_v_blocks_card_grid" add constraint "_docs_v_blocks_card_grid_pkey" PRIMARY KEY using index "_docs_v_blocks_card_grid_pkey";

alter table "public"."_docs_v_blocks_card_grid_cards" add constraint "_docs_v_blocks_card_grid_cards_pkey" PRIMARY KEY using index "_docs_v_blocks_card_grid_cards_pkey";

alter table "public"."_docs_v_blocks_code_block" add constraint "_docs_v_blocks_code_block_pkey" PRIMARY KEY using index "_docs_v_blocks_code_block_pkey";

alter table "public"."_docs_v_blocks_divider" add constraint "_docs_v_blocks_divider_pkey" PRIMARY KEY using index "_docs_v_blocks_divider_pkey";

alter table "public"."_docs_v_blocks_image_block" add constraint "_docs_v_blocks_image_block_pkey" PRIMARY KEY using index "_docs_v_blocks_image_block_pkey";

alter table "public"."_docs_v_blocks_rich_text" add constraint "_docs_v_blocks_rich_text_pkey" PRIMARY KEY using index "_docs_v_blocks_rich_text_pkey";

alter table "public"."_docs_v_blocks_steps" add constraint "_docs_v_blocks_steps_pkey" PRIMARY KEY using index "_docs_v_blocks_steps_pkey";

alter table "public"."_docs_v_blocks_steps_steps" add constraint "_docs_v_blocks_steps_steps_pkey" PRIMARY KEY using index "_docs_v_blocks_steps_steps_pkey";

alter table "public"."_docs_v_blocks_table" add constraint "_docs_v_blocks_table_pkey" PRIMARY KEY using index "_docs_v_blocks_table_pkey";

alter table "public"."_docs_v_blocks_table_headers" add constraint "_docs_v_blocks_table_headers_pkey" PRIMARY KEY using index "_docs_v_blocks_table_headers_pkey";

alter table "public"."_docs_v_blocks_table_rows" add constraint "_docs_v_blocks_table_rows_pkey" PRIMARY KEY using index "_docs_v_blocks_table_rows_pkey";

alter table "public"."_docs_v_blocks_table_rows_cells" add constraint "_docs_v_blocks_table_rows_cells_pkey" PRIMARY KEY using index "_docs_v_blocks_table_rows_cells_pkey";

alter table "public"."categories" add constraint "categories_pkey" PRIMARY KEY using index "categories_pkey";

alter table "public"."docs" add constraint "docs_pkey" PRIMARY KEY using index "docs_pkey";

alter table "public"."docs_blocks_callout" add constraint "docs_blocks_callout_pkey" PRIMARY KEY using index "docs_blocks_callout_pkey";

alter table "public"."docs_blocks_card_grid" add constraint "docs_blocks_card_grid_pkey" PRIMARY KEY using index "docs_blocks_card_grid_pkey";

alter table "public"."docs_blocks_card_grid_cards" add constraint "docs_blocks_card_grid_cards_pkey" PRIMARY KEY using index "docs_blocks_card_grid_cards_pkey";

alter table "public"."docs_blocks_code_block" add constraint "docs_blocks_code_block_pkey" PRIMARY KEY using index "docs_blocks_code_block_pkey";

alter table "public"."docs_blocks_divider" add constraint "docs_blocks_divider_pkey" PRIMARY KEY using index "docs_blocks_divider_pkey";

alter table "public"."docs_blocks_image_block" add constraint "docs_blocks_image_block_pkey" PRIMARY KEY using index "docs_blocks_image_block_pkey";

alter table "public"."docs_blocks_rich_text" add constraint "docs_blocks_rich_text_pkey" PRIMARY KEY using index "docs_blocks_rich_text_pkey";

alter table "public"."docs_blocks_steps" add constraint "docs_blocks_steps_pkey" PRIMARY KEY using index "docs_blocks_steps_pkey";

alter table "public"."docs_blocks_steps_steps" add constraint "docs_blocks_steps_steps_pkey" PRIMARY KEY using index "docs_blocks_steps_steps_pkey";

alter table "public"."docs_blocks_table" add constraint "docs_blocks_table_pkey" PRIMARY KEY using index "docs_blocks_table_pkey";

alter table "public"."docs_blocks_table_headers" add constraint "docs_blocks_table_headers_pkey" PRIMARY KEY using index "docs_blocks_table_headers_pkey";

alter table "public"."docs_blocks_table_rows" add constraint "docs_blocks_table_rows_pkey" PRIMARY KEY using index "docs_blocks_table_rows_pkey";

alter table "public"."docs_blocks_table_rows_cells" add constraint "docs_blocks_table_rows_cells_pkey" PRIMARY KEY using index "docs_blocks_table_rows_cells_pkey";

alter table "public"."media" add constraint "media_pkey" PRIMARY KEY using index "media_pkey";

alter table "public"."payload_kv" add constraint "payload_kv_pkey" PRIMARY KEY using index "payload_kv_pkey";

alter table "public"."payload_locked_documents" add constraint "payload_locked_documents_pkey" PRIMARY KEY using index "payload_locked_documents_pkey";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_pkey" PRIMARY KEY using index "payload_locked_documents_rels_pkey";

alter table "public"."payload_migrations" add constraint "payload_migrations_pkey" PRIMARY KEY using index "payload_migrations_pkey";

alter table "public"."payload_preferences" add constraint "payload_preferences_pkey" PRIMARY KEY using index "payload_preferences_pkey";

alter table "public"."payload_preferences_rels" add constraint "payload_preferences_rels_pkey" PRIMARY KEY using index "payload_preferences_rels_pkey";

alter table "public"."site_config" add constraint "site_config_pkey" PRIMARY KEY using index "site_config_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."users_sessions" add constraint "users_sessions_pkey" PRIMARY KEY using index "users_sessions_pkey";

alter table "public"."_docs_v" add constraint "_docs_v_parent_id_docs_id_fk" FOREIGN KEY (parent_id) REFERENCES public.docs(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v" validate constraint "_docs_v_parent_id_docs_id_fk";

alter table "public"."_docs_v" add constraint "_docs_v_version_category_id_categories_id_fk" FOREIGN KEY (version_category_id) REFERENCES public.categories(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v" validate constraint "_docs_v_version_category_id_categories_id_fk";

alter table "public"."_docs_v" add constraint "_docs_v_version_parent_id_docs_id_fk" FOREIGN KEY (version_parent_id) REFERENCES public.docs(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v" validate constraint "_docs_v_version_parent_id_docs_id_fk";

alter table "public"."_docs_v_blocks_callout" add constraint "_docs_v_blocks_callout_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_callout" validate constraint "_docs_v_blocks_callout_parent_id_fk";

alter table "public"."_docs_v_blocks_card_grid" add constraint "_docs_v_blocks_card_grid_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_card_grid" validate constraint "_docs_v_blocks_card_grid_parent_id_fk";

alter table "public"."_docs_v_blocks_card_grid_cards" add constraint "_docs_v_blocks_card_grid_cards_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v_blocks_card_grid_cards" validate constraint "_docs_v_blocks_card_grid_cards_image_id_media_id_fk";

alter table "public"."_docs_v_blocks_card_grid_cards" add constraint "_docs_v_blocks_card_grid_cards_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_card_grid(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_card_grid_cards" validate constraint "_docs_v_blocks_card_grid_cards_parent_id_fk";

alter table "public"."_docs_v_blocks_code_block" add constraint "_docs_v_blocks_code_block_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_code_block" validate constraint "_docs_v_blocks_code_block_parent_id_fk";

alter table "public"."_docs_v_blocks_divider" add constraint "_docs_v_blocks_divider_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_divider" validate constraint "_docs_v_blocks_divider_parent_id_fk";

alter table "public"."_docs_v_blocks_image_block" add constraint "_docs_v_blocks_image_block_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v_blocks_image_block" validate constraint "_docs_v_blocks_image_block_image_id_media_id_fk";

alter table "public"."_docs_v_blocks_image_block" add constraint "_docs_v_blocks_image_block_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_image_block" validate constraint "_docs_v_blocks_image_block_parent_id_fk";

alter table "public"."_docs_v_blocks_rich_text" add constraint "_docs_v_blocks_rich_text_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_rich_text" validate constraint "_docs_v_blocks_rich_text_parent_id_fk";

alter table "public"."_docs_v_blocks_steps" add constraint "_docs_v_blocks_steps_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_steps" validate constraint "_docs_v_blocks_steps_parent_id_fk";

alter table "public"."_docs_v_blocks_steps_steps" add constraint "_docs_v_blocks_steps_steps_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_steps(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_steps_steps" validate constraint "_docs_v_blocks_steps_steps_parent_id_fk";

alter table "public"."_docs_v_blocks_table" add constraint "_docs_v_blocks_table_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_table" validate constraint "_docs_v_blocks_table_parent_id_fk";

alter table "public"."_docs_v_blocks_table_headers" add constraint "_docs_v_blocks_table_headers_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_table(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_table_headers" validate constraint "_docs_v_blocks_table_headers_parent_id_fk";

alter table "public"."_docs_v_blocks_table_rows" add constraint "_docs_v_blocks_table_rows_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_table(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_table_rows" validate constraint "_docs_v_blocks_table_rows_parent_id_fk";

alter table "public"."_docs_v_blocks_table_rows_cells" add constraint "_docs_v_blocks_table_rows_cells_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public._docs_v_blocks_table_rows(id) ON DELETE CASCADE not valid;

alter table "public"."_docs_v_blocks_table_rows_cells" validate constraint "_docs_v_blocks_table_rows_cells_parent_id_fk";

alter table "public"."categories" add constraint "categories_parent_category_id_categories_id_fk" FOREIGN KEY (parent_category_id) REFERENCES public.categories(id) ON DELETE SET NULL not valid;

alter table "public"."categories" validate constraint "categories_parent_category_id_categories_id_fk";

alter table "public"."docs" add constraint "docs_category_id_categories_id_fk" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL not valid;

alter table "public"."docs" validate constraint "docs_category_id_categories_id_fk";

alter table "public"."docs" add constraint "docs_parent_id_docs_id_fk" FOREIGN KEY (parent_id) REFERENCES public.docs(id) ON DELETE SET NULL not valid;

alter table "public"."docs" validate constraint "docs_parent_id_docs_id_fk";

alter table "public"."docs_blocks_callout" add constraint "docs_blocks_callout_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_callout" validate constraint "docs_blocks_callout_parent_id_fk";

alter table "public"."docs_blocks_card_grid" add constraint "docs_blocks_card_grid_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_card_grid" validate constraint "docs_blocks_card_grid_parent_id_fk";

alter table "public"."docs_blocks_card_grid_cards" add constraint "docs_blocks_card_grid_cards_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."docs_blocks_card_grid_cards" validate constraint "docs_blocks_card_grid_cards_image_id_media_id_fk";

alter table "public"."docs_blocks_card_grid_cards" add constraint "docs_blocks_card_grid_cards_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_card_grid(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_card_grid_cards" validate constraint "docs_blocks_card_grid_cards_parent_id_fk";

alter table "public"."docs_blocks_code_block" add constraint "docs_blocks_code_block_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_code_block" validate constraint "docs_blocks_code_block_parent_id_fk";

alter table "public"."docs_blocks_divider" add constraint "docs_blocks_divider_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_divider" validate constraint "docs_blocks_divider_parent_id_fk";

alter table "public"."docs_blocks_image_block" add constraint "docs_blocks_image_block_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."docs_blocks_image_block" validate constraint "docs_blocks_image_block_image_id_media_id_fk";

alter table "public"."docs_blocks_image_block" add constraint "docs_blocks_image_block_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_image_block" validate constraint "docs_blocks_image_block_parent_id_fk";

alter table "public"."docs_blocks_rich_text" add constraint "docs_blocks_rich_text_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_rich_text" validate constraint "docs_blocks_rich_text_parent_id_fk";

alter table "public"."docs_blocks_steps" add constraint "docs_blocks_steps_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_steps" validate constraint "docs_blocks_steps_parent_id_fk";

alter table "public"."docs_blocks_steps_steps" add constraint "docs_blocks_steps_steps_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_steps(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_steps_steps" validate constraint "docs_blocks_steps_steps_parent_id_fk";

alter table "public"."docs_blocks_table" add constraint "docs_blocks_table_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_table" validate constraint "docs_blocks_table_parent_id_fk";

alter table "public"."docs_blocks_table_headers" add constraint "docs_blocks_table_headers_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_table(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_table_headers" validate constraint "docs_blocks_table_headers_parent_id_fk";

alter table "public"."docs_blocks_table_rows" add constraint "docs_blocks_table_rows_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_table(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_table_rows" validate constraint "docs_blocks_table_rows_parent_id_fk";

alter table "public"."docs_blocks_table_rows_cells" add constraint "docs_blocks_table_rows_cells_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.docs_blocks_table_rows(id) ON DELETE CASCADE not valid;

alter table "public"."docs_blocks_table_rows_cells" validate constraint "docs_blocks_table_rows_cells_parent_id_fk";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_categories_fk" FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE not valid;

alter table "public"."payload_locked_documents_rels" validate constraint "payload_locked_documents_rels_categories_fk";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_docs_fk" FOREIGN KEY (docs_id) REFERENCES public.docs(id) ON DELETE CASCADE not valid;

alter table "public"."payload_locked_documents_rels" validate constraint "payload_locked_documents_rels_docs_fk";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_media_fk" FOREIGN KEY (media_id) REFERENCES public.media(id) ON DELETE CASCADE not valid;

alter table "public"."payload_locked_documents_rels" validate constraint "payload_locked_documents_rels_media_fk";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_parent_fk" FOREIGN KEY (parent_id) REFERENCES public.payload_locked_documents(id) ON DELETE CASCADE not valid;

alter table "public"."payload_locked_documents_rels" validate constraint "payload_locked_documents_rels_parent_fk";

alter table "public"."payload_locked_documents_rels" add constraint "payload_locked_documents_rels_users_fk" FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."payload_locked_documents_rels" validate constraint "payload_locked_documents_rels_users_fk";

alter table "public"."payload_preferences_rels" add constraint "payload_preferences_rels_parent_fk" FOREIGN KEY (parent_id) REFERENCES public.payload_preferences(id) ON DELETE CASCADE not valid;

alter table "public"."payload_preferences_rels" validate constraint "payload_preferences_rels_parent_fk";

alter table "public"."payload_preferences_rels" add constraint "payload_preferences_rels_users_fk" FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."payload_preferences_rels" validate constraint "payload_preferences_rels_users_fk";

alter table "public"."site_config" add constraint "site_config_logo_dark_id_media_id_fk" FOREIGN KEY (logo_dark_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."site_config" validate constraint "site_config_logo_dark_id_media_id_fk";

alter table "public"."site_config" add constraint "site_config_logo_light_id_media_id_fk" FOREIGN KEY (logo_light_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."site_config" validate constraint "site_config_logo_light_id_media_id_fk";

alter table "public"."users_sessions" add constraint "users_sessions_parent_id_fk" FOREIGN KEY (_parent_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."users_sessions" validate constraint "users_sessions_parent_id_fk";

grant delete on table "public"."_docs_v" to "anon";

grant insert on table "public"."_docs_v" to "anon";

grant references on table "public"."_docs_v" to "anon";

grant select on table "public"."_docs_v" to "anon";

grant trigger on table "public"."_docs_v" to "anon";

grant truncate on table "public"."_docs_v" to "anon";

grant update on table "public"."_docs_v" to "anon";

grant delete on table "public"."_docs_v" to "authenticated";

grant insert on table "public"."_docs_v" to "authenticated";

grant references on table "public"."_docs_v" to "authenticated";

grant select on table "public"."_docs_v" to "authenticated";

grant trigger on table "public"."_docs_v" to "authenticated";

grant truncate on table "public"."_docs_v" to "authenticated";

grant update on table "public"."_docs_v" to "authenticated";

grant delete on table "public"."_docs_v" to "service_role";

grant insert on table "public"."_docs_v" to "service_role";

grant references on table "public"."_docs_v" to "service_role";

grant select on table "public"."_docs_v" to "service_role";

grant trigger on table "public"."_docs_v" to "service_role";

grant truncate on table "public"."_docs_v" to "service_role";

grant update on table "public"."_docs_v" to "service_role";

grant delete on table "public"."_docs_v_blocks_callout" to "anon";

grant insert on table "public"."_docs_v_blocks_callout" to "anon";

grant references on table "public"."_docs_v_blocks_callout" to "anon";

grant select on table "public"."_docs_v_blocks_callout" to "anon";

grant trigger on table "public"."_docs_v_blocks_callout" to "anon";

grant truncate on table "public"."_docs_v_blocks_callout" to "anon";

grant update on table "public"."_docs_v_blocks_callout" to "anon";

grant delete on table "public"."_docs_v_blocks_callout" to "authenticated";

grant insert on table "public"."_docs_v_blocks_callout" to "authenticated";

grant references on table "public"."_docs_v_blocks_callout" to "authenticated";

grant select on table "public"."_docs_v_blocks_callout" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_callout" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_callout" to "authenticated";

grant update on table "public"."_docs_v_blocks_callout" to "authenticated";

grant delete on table "public"."_docs_v_blocks_callout" to "service_role";

grant insert on table "public"."_docs_v_blocks_callout" to "service_role";

grant references on table "public"."_docs_v_blocks_callout" to "service_role";

grant select on table "public"."_docs_v_blocks_callout" to "service_role";

grant trigger on table "public"."_docs_v_blocks_callout" to "service_role";

grant truncate on table "public"."_docs_v_blocks_callout" to "service_role";

grant update on table "public"."_docs_v_blocks_callout" to "service_role";

grant delete on table "public"."_docs_v_blocks_card_grid" to "anon";

grant insert on table "public"."_docs_v_blocks_card_grid" to "anon";

grant references on table "public"."_docs_v_blocks_card_grid" to "anon";

grant select on table "public"."_docs_v_blocks_card_grid" to "anon";

grant trigger on table "public"."_docs_v_blocks_card_grid" to "anon";

grant truncate on table "public"."_docs_v_blocks_card_grid" to "anon";

grant update on table "public"."_docs_v_blocks_card_grid" to "anon";

grant delete on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant insert on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant references on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant select on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant update on table "public"."_docs_v_blocks_card_grid" to "authenticated";

grant delete on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant insert on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant references on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant select on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant trigger on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant truncate on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant update on table "public"."_docs_v_blocks_card_grid" to "service_role";

grant delete on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant insert on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant references on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant select on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant trigger on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant truncate on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant update on table "public"."_docs_v_blocks_card_grid_cards" to "anon";

grant delete on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant insert on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant references on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant select on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant update on table "public"."_docs_v_blocks_card_grid_cards" to "authenticated";

grant delete on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant insert on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant references on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant select on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant trigger on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant truncate on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant update on table "public"."_docs_v_blocks_card_grid_cards" to "service_role";

grant delete on table "public"."_docs_v_blocks_code_block" to "anon";

grant insert on table "public"."_docs_v_blocks_code_block" to "anon";

grant references on table "public"."_docs_v_blocks_code_block" to "anon";

grant select on table "public"."_docs_v_blocks_code_block" to "anon";

grant trigger on table "public"."_docs_v_blocks_code_block" to "anon";

grant truncate on table "public"."_docs_v_blocks_code_block" to "anon";

grant update on table "public"."_docs_v_blocks_code_block" to "anon";

grant delete on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant insert on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant references on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant select on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant update on table "public"."_docs_v_blocks_code_block" to "authenticated";

grant delete on table "public"."_docs_v_blocks_code_block" to "service_role";

grant insert on table "public"."_docs_v_blocks_code_block" to "service_role";

grant references on table "public"."_docs_v_blocks_code_block" to "service_role";

grant select on table "public"."_docs_v_blocks_code_block" to "service_role";

grant trigger on table "public"."_docs_v_blocks_code_block" to "service_role";

grant truncate on table "public"."_docs_v_blocks_code_block" to "service_role";

grant update on table "public"."_docs_v_blocks_code_block" to "service_role";

grant delete on table "public"."_docs_v_blocks_divider" to "anon";

grant insert on table "public"."_docs_v_blocks_divider" to "anon";

grant references on table "public"."_docs_v_blocks_divider" to "anon";

grant select on table "public"."_docs_v_blocks_divider" to "anon";

grant trigger on table "public"."_docs_v_blocks_divider" to "anon";

grant truncate on table "public"."_docs_v_blocks_divider" to "anon";

grant update on table "public"."_docs_v_blocks_divider" to "anon";

grant delete on table "public"."_docs_v_blocks_divider" to "authenticated";

grant insert on table "public"."_docs_v_blocks_divider" to "authenticated";

grant references on table "public"."_docs_v_blocks_divider" to "authenticated";

grant select on table "public"."_docs_v_blocks_divider" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_divider" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_divider" to "authenticated";

grant update on table "public"."_docs_v_blocks_divider" to "authenticated";

grant delete on table "public"."_docs_v_blocks_divider" to "service_role";

grant insert on table "public"."_docs_v_blocks_divider" to "service_role";

grant references on table "public"."_docs_v_blocks_divider" to "service_role";

grant select on table "public"."_docs_v_blocks_divider" to "service_role";

grant trigger on table "public"."_docs_v_blocks_divider" to "service_role";

grant truncate on table "public"."_docs_v_blocks_divider" to "service_role";

grant update on table "public"."_docs_v_blocks_divider" to "service_role";

grant delete on table "public"."_docs_v_blocks_image_block" to "anon";

grant insert on table "public"."_docs_v_blocks_image_block" to "anon";

grant references on table "public"."_docs_v_blocks_image_block" to "anon";

grant select on table "public"."_docs_v_blocks_image_block" to "anon";

grant trigger on table "public"."_docs_v_blocks_image_block" to "anon";

grant truncate on table "public"."_docs_v_blocks_image_block" to "anon";

grant update on table "public"."_docs_v_blocks_image_block" to "anon";

grant delete on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant insert on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant references on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant select on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant update on table "public"."_docs_v_blocks_image_block" to "authenticated";

grant delete on table "public"."_docs_v_blocks_image_block" to "service_role";

grant insert on table "public"."_docs_v_blocks_image_block" to "service_role";

grant references on table "public"."_docs_v_blocks_image_block" to "service_role";

grant select on table "public"."_docs_v_blocks_image_block" to "service_role";

grant trigger on table "public"."_docs_v_blocks_image_block" to "service_role";

grant truncate on table "public"."_docs_v_blocks_image_block" to "service_role";

grant update on table "public"."_docs_v_blocks_image_block" to "service_role";

grant delete on table "public"."_docs_v_blocks_rich_text" to "anon";

grant insert on table "public"."_docs_v_blocks_rich_text" to "anon";

grant references on table "public"."_docs_v_blocks_rich_text" to "anon";

grant select on table "public"."_docs_v_blocks_rich_text" to "anon";

grant trigger on table "public"."_docs_v_blocks_rich_text" to "anon";

grant truncate on table "public"."_docs_v_blocks_rich_text" to "anon";

grant update on table "public"."_docs_v_blocks_rich_text" to "anon";

grant delete on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant insert on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant references on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant select on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant update on table "public"."_docs_v_blocks_rich_text" to "authenticated";

grant delete on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant insert on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant references on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant select on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant trigger on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant truncate on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant update on table "public"."_docs_v_blocks_rich_text" to "service_role";

grant delete on table "public"."_docs_v_blocks_steps" to "anon";

grant insert on table "public"."_docs_v_blocks_steps" to "anon";

grant references on table "public"."_docs_v_blocks_steps" to "anon";

grant select on table "public"."_docs_v_blocks_steps" to "anon";

grant trigger on table "public"."_docs_v_blocks_steps" to "anon";

grant truncate on table "public"."_docs_v_blocks_steps" to "anon";

grant update on table "public"."_docs_v_blocks_steps" to "anon";

grant delete on table "public"."_docs_v_blocks_steps" to "authenticated";

grant insert on table "public"."_docs_v_blocks_steps" to "authenticated";

grant references on table "public"."_docs_v_blocks_steps" to "authenticated";

grant select on table "public"."_docs_v_blocks_steps" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_steps" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_steps" to "authenticated";

grant update on table "public"."_docs_v_blocks_steps" to "authenticated";

grant delete on table "public"."_docs_v_blocks_steps" to "service_role";

grant insert on table "public"."_docs_v_blocks_steps" to "service_role";

grant references on table "public"."_docs_v_blocks_steps" to "service_role";

grant select on table "public"."_docs_v_blocks_steps" to "service_role";

grant trigger on table "public"."_docs_v_blocks_steps" to "service_role";

grant truncate on table "public"."_docs_v_blocks_steps" to "service_role";

grant update on table "public"."_docs_v_blocks_steps" to "service_role";

grant delete on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant insert on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant references on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant select on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant trigger on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant truncate on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant update on table "public"."_docs_v_blocks_steps_steps" to "anon";

grant delete on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant insert on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant references on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant select on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant update on table "public"."_docs_v_blocks_steps_steps" to "authenticated";

grant delete on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant insert on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant references on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant select on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant trigger on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant truncate on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant update on table "public"."_docs_v_blocks_steps_steps" to "service_role";

grant delete on table "public"."_docs_v_blocks_table" to "anon";

grant insert on table "public"."_docs_v_blocks_table" to "anon";

grant references on table "public"."_docs_v_blocks_table" to "anon";

grant select on table "public"."_docs_v_blocks_table" to "anon";

grant trigger on table "public"."_docs_v_blocks_table" to "anon";

grant truncate on table "public"."_docs_v_blocks_table" to "anon";

grant update on table "public"."_docs_v_blocks_table" to "anon";

grant delete on table "public"."_docs_v_blocks_table" to "authenticated";

grant insert on table "public"."_docs_v_blocks_table" to "authenticated";

grant references on table "public"."_docs_v_blocks_table" to "authenticated";

grant select on table "public"."_docs_v_blocks_table" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_table" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_table" to "authenticated";

grant update on table "public"."_docs_v_blocks_table" to "authenticated";

grant delete on table "public"."_docs_v_blocks_table" to "service_role";

grant insert on table "public"."_docs_v_blocks_table" to "service_role";

grant references on table "public"."_docs_v_blocks_table" to "service_role";

grant select on table "public"."_docs_v_blocks_table" to "service_role";

grant trigger on table "public"."_docs_v_blocks_table" to "service_role";

grant truncate on table "public"."_docs_v_blocks_table" to "service_role";

grant update on table "public"."_docs_v_blocks_table" to "service_role";

grant delete on table "public"."_docs_v_blocks_table_headers" to "anon";

grant insert on table "public"."_docs_v_blocks_table_headers" to "anon";

grant references on table "public"."_docs_v_blocks_table_headers" to "anon";

grant select on table "public"."_docs_v_blocks_table_headers" to "anon";

grant trigger on table "public"."_docs_v_blocks_table_headers" to "anon";

grant truncate on table "public"."_docs_v_blocks_table_headers" to "anon";

grant update on table "public"."_docs_v_blocks_table_headers" to "anon";

grant delete on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant insert on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant references on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant select on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant update on table "public"."_docs_v_blocks_table_headers" to "authenticated";

grant delete on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant insert on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant references on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant select on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant trigger on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant truncate on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant update on table "public"."_docs_v_blocks_table_headers" to "service_role";

grant delete on table "public"."_docs_v_blocks_table_rows" to "anon";

grant insert on table "public"."_docs_v_blocks_table_rows" to "anon";

grant references on table "public"."_docs_v_blocks_table_rows" to "anon";

grant select on table "public"."_docs_v_blocks_table_rows" to "anon";

grant trigger on table "public"."_docs_v_blocks_table_rows" to "anon";

grant truncate on table "public"."_docs_v_blocks_table_rows" to "anon";

grant update on table "public"."_docs_v_blocks_table_rows" to "anon";

grant delete on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant insert on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant references on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant select on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant update on table "public"."_docs_v_blocks_table_rows" to "authenticated";

grant delete on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant insert on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant references on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant select on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant trigger on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant truncate on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant update on table "public"."_docs_v_blocks_table_rows" to "service_role";

grant delete on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant insert on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant references on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant select on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant trigger on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant truncate on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant update on table "public"."_docs_v_blocks_table_rows_cells" to "anon";

grant delete on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant insert on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant references on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant select on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant trigger on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant truncate on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant update on table "public"."_docs_v_blocks_table_rows_cells" to "authenticated";

grant delete on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant insert on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant references on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant select on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant trigger on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant truncate on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant update on table "public"."_docs_v_blocks_table_rows_cells" to "service_role";

grant delete on table "public"."categories" to "anon";

grant insert on table "public"."categories" to "anon";

grant references on table "public"."categories" to "anon";

grant select on table "public"."categories" to "anon";

grant trigger on table "public"."categories" to "anon";

grant truncate on table "public"."categories" to "anon";

grant update on table "public"."categories" to "anon";

grant delete on table "public"."categories" to "authenticated";

grant insert on table "public"."categories" to "authenticated";

grant references on table "public"."categories" to "authenticated";

grant select on table "public"."categories" to "authenticated";

grant trigger on table "public"."categories" to "authenticated";

grant truncate on table "public"."categories" to "authenticated";

grant update on table "public"."categories" to "authenticated";

grant delete on table "public"."categories" to "service_role";

grant insert on table "public"."categories" to "service_role";

grant references on table "public"."categories" to "service_role";

grant select on table "public"."categories" to "service_role";

grant trigger on table "public"."categories" to "service_role";

grant truncate on table "public"."categories" to "service_role";

grant update on table "public"."categories" to "service_role";

grant delete on table "public"."docs" to "anon";

grant insert on table "public"."docs" to "anon";

grant references on table "public"."docs" to "anon";

grant select on table "public"."docs" to "anon";

grant trigger on table "public"."docs" to "anon";

grant truncate on table "public"."docs" to "anon";

grant update on table "public"."docs" to "anon";

grant delete on table "public"."docs" to "authenticated";

grant insert on table "public"."docs" to "authenticated";

grant references on table "public"."docs" to "authenticated";

grant select on table "public"."docs" to "authenticated";

grant trigger on table "public"."docs" to "authenticated";

grant truncate on table "public"."docs" to "authenticated";

grant update on table "public"."docs" to "authenticated";

grant delete on table "public"."docs" to "service_role";

grant insert on table "public"."docs" to "service_role";

grant references on table "public"."docs" to "service_role";

grant select on table "public"."docs" to "service_role";

grant trigger on table "public"."docs" to "service_role";

grant truncate on table "public"."docs" to "service_role";

grant update on table "public"."docs" to "service_role";

grant delete on table "public"."docs_blocks_callout" to "anon";

grant insert on table "public"."docs_blocks_callout" to "anon";

grant references on table "public"."docs_blocks_callout" to "anon";

grant select on table "public"."docs_blocks_callout" to "anon";

grant trigger on table "public"."docs_blocks_callout" to "anon";

grant truncate on table "public"."docs_blocks_callout" to "anon";

grant update on table "public"."docs_blocks_callout" to "anon";

grant delete on table "public"."docs_blocks_callout" to "authenticated";

grant insert on table "public"."docs_blocks_callout" to "authenticated";

grant references on table "public"."docs_blocks_callout" to "authenticated";

grant select on table "public"."docs_blocks_callout" to "authenticated";

grant trigger on table "public"."docs_blocks_callout" to "authenticated";

grant truncate on table "public"."docs_blocks_callout" to "authenticated";

grant update on table "public"."docs_blocks_callout" to "authenticated";

grant delete on table "public"."docs_blocks_callout" to "service_role";

grant insert on table "public"."docs_blocks_callout" to "service_role";

grant references on table "public"."docs_blocks_callout" to "service_role";

grant select on table "public"."docs_blocks_callout" to "service_role";

grant trigger on table "public"."docs_blocks_callout" to "service_role";

grant truncate on table "public"."docs_blocks_callout" to "service_role";

grant update on table "public"."docs_blocks_callout" to "service_role";

grant delete on table "public"."docs_blocks_card_grid" to "anon";

grant insert on table "public"."docs_blocks_card_grid" to "anon";

grant references on table "public"."docs_blocks_card_grid" to "anon";

grant select on table "public"."docs_blocks_card_grid" to "anon";

grant trigger on table "public"."docs_blocks_card_grid" to "anon";

grant truncate on table "public"."docs_blocks_card_grid" to "anon";

grant update on table "public"."docs_blocks_card_grid" to "anon";

grant delete on table "public"."docs_blocks_card_grid" to "authenticated";

grant insert on table "public"."docs_blocks_card_grid" to "authenticated";

grant references on table "public"."docs_blocks_card_grid" to "authenticated";

grant select on table "public"."docs_blocks_card_grid" to "authenticated";

grant trigger on table "public"."docs_blocks_card_grid" to "authenticated";

grant truncate on table "public"."docs_blocks_card_grid" to "authenticated";

grant update on table "public"."docs_blocks_card_grid" to "authenticated";

grant delete on table "public"."docs_blocks_card_grid" to "service_role";

grant insert on table "public"."docs_blocks_card_grid" to "service_role";

grant references on table "public"."docs_blocks_card_grid" to "service_role";

grant select on table "public"."docs_blocks_card_grid" to "service_role";

grant trigger on table "public"."docs_blocks_card_grid" to "service_role";

grant truncate on table "public"."docs_blocks_card_grid" to "service_role";

grant update on table "public"."docs_blocks_card_grid" to "service_role";

grant delete on table "public"."docs_blocks_card_grid_cards" to "anon";

grant insert on table "public"."docs_blocks_card_grid_cards" to "anon";

grant references on table "public"."docs_blocks_card_grid_cards" to "anon";

grant select on table "public"."docs_blocks_card_grid_cards" to "anon";

grant trigger on table "public"."docs_blocks_card_grid_cards" to "anon";

grant truncate on table "public"."docs_blocks_card_grid_cards" to "anon";

grant update on table "public"."docs_blocks_card_grid_cards" to "anon";

grant delete on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant insert on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant references on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant select on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant trigger on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant truncate on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant update on table "public"."docs_blocks_card_grid_cards" to "authenticated";

grant delete on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant insert on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant references on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant select on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant trigger on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant truncate on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant update on table "public"."docs_blocks_card_grid_cards" to "service_role";

grant delete on table "public"."docs_blocks_code_block" to "anon";

grant insert on table "public"."docs_blocks_code_block" to "anon";

grant references on table "public"."docs_blocks_code_block" to "anon";

grant select on table "public"."docs_blocks_code_block" to "anon";

grant trigger on table "public"."docs_blocks_code_block" to "anon";

grant truncate on table "public"."docs_blocks_code_block" to "anon";

grant update on table "public"."docs_blocks_code_block" to "anon";

grant delete on table "public"."docs_blocks_code_block" to "authenticated";

grant insert on table "public"."docs_blocks_code_block" to "authenticated";

grant references on table "public"."docs_blocks_code_block" to "authenticated";

grant select on table "public"."docs_blocks_code_block" to "authenticated";

grant trigger on table "public"."docs_blocks_code_block" to "authenticated";

grant truncate on table "public"."docs_blocks_code_block" to "authenticated";

grant update on table "public"."docs_blocks_code_block" to "authenticated";

grant delete on table "public"."docs_blocks_code_block" to "service_role";

grant insert on table "public"."docs_blocks_code_block" to "service_role";

grant references on table "public"."docs_blocks_code_block" to "service_role";

grant select on table "public"."docs_blocks_code_block" to "service_role";

grant trigger on table "public"."docs_blocks_code_block" to "service_role";

grant truncate on table "public"."docs_blocks_code_block" to "service_role";

grant update on table "public"."docs_blocks_code_block" to "service_role";

grant delete on table "public"."docs_blocks_divider" to "anon";

grant insert on table "public"."docs_blocks_divider" to "anon";

grant references on table "public"."docs_blocks_divider" to "anon";

grant select on table "public"."docs_blocks_divider" to "anon";

grant trigger on table "public"."docs_blocks_divider" to "anon";

grant truncate on table "public"."docs_blocks_divider" to "anon";

grant update on table "public"."docs_blocks_divider" to "anon";

grant delete on table "public"."docs_blocks_divider" to "authenticated";

grant insert on table "public"."docs_blocks_divider" to "authenticated";

grant references on table "public"."docs_blocks_divider" to "authenticated";

grant select on table "public"."docs_blocks_divider" to "authenticated";

grant trigger on table "public"."docs_blocks_divider" to "authenticated";

grant truncate on table "public"."docs_blocks_divider" to "authenticated";

grant update on table "public"."docs_blocks_divider" to "authenticated";

grant delete on table "public"."docs_blocks_divider" to "service_role";

grant insert on table "public"."docs_blocks_divider" to "service_role";

grant references on table "public"."docs_blocks_divider" to "service_role";

grant select on table "public"."docs_blocks_divider" to "service_role";

grant trigger on table "public"."docs_blocks_divider" to "service_role";

grant truncate on table "public"."docs_blocks_divider" to "service_role";

grant update on table "public"."docs_blocks_divider" to "service_role";

grant delete on table "public"."docs_blocks_image_block" to "anon";

grant insert on table "public"."docs_blocks_image_block" to "anon";

grant references on table "public"."docs_blocks_image_block" to "anon";

grant select on table "public"."docs_blocks_image_block" to "anon";

grant trigger on table "public"."docs_blocks_image_block" to "anon";

grant truncate on table "public"."docs_blocks_image_block" to "anon";

grant update on table "public"."docs_blocks_image_block" to "anon";

grant delete on table "public"."docs_blocks_image_block" to "authenticated";

grant insert on table "public"."docs_blocks_image_block" to "authenticated";

grant references on table "public"."docs_blocks_image_block" to "authenticated";

grant select on table "public"."docs_blocks_image_block" to "authenticated";

grant trigger on table "public"."docs_blocks_image_block" to "authenticated";

grant truncate on table "public"."docs_blocks_image_block" to "authenticated";

grant update on table "public"."docs_blocks_image_block" to "authenticated";

grant delete on table "public"."docs_blocks_image_block" to "service_role";

grant insert on table "public"."docs_blocks_image_block" to "service_role";

grant references on table "public"."docs_blocks_image_block" to "service_role";

grant select on table "public"."docs_blocks_image_block" to "service_role";

grant trigger on table "public"."docs_blocks_image_block" to "service_role";

grant truncate on table "public"."docs_blocks_image_block" to "service_role";

grant update on table "public"."docs_blocks_image_block" to "service_role";

grant delete on table "public"."docs_blocks_rich_text" to "anon";

grant insert on table "public"."docs_blocks_rich_text" to "anon";

grant references on table "public"."docs_blocks_rich_text" to "anon";

grant select on table "public"."docs_blocks_rich_text" to "anon";

grant trigger on table "public"."docs_blocks_rich_text" to "anon";

grant truncate on table "public"."docs_blocks_rich_text" to "anon";

grant update on table "public"."docs_blocks_rich_text" to "anon";

grant delete on table "public"."docs_blocks_rich_text" to "authenticated";

grant insert on table "public"."docs_blocks_rich_text" to "authenticated";

grant references on table "public"."docs_blocks_rich_text" to "authenticated";

grant select on table "public"."docs_blocks_rich_text" to "authenticated";

grant trigger on table "public"."docs_blocks_rich_text" to "authenticated";

grant truncate on table "public"."docs_blocks_rich_text" to "authenticated";

grant update on table "public"."docs_blocks_rich_text" to "authenticated";

grant delete on table "public"."docs_blocks_rich_text" to "service_role";

grant insert on table "public"."docs_blocks_rich_text" to "service_role";

grant references on table "public"."docs_blocks_rich_text" to "service_role";

grant select on table "public"."docs_blocks_rich_text" to "service_role";

grant trigger on table "public"."docs_blocks_rich_text" to "service_role";

grant truncate on table "public"."docs_blocks_rich_text" to "service_role";

grant update on table "public"."docs_blocks_rich_text" to "service_role";

grant delete on table "public"."docs_blocks_steps" to "anon";

grant insert on table "public"."docs_blocks_steps" to "anon";

grant references on table "public"."docs_blocks_steps" to "anon";

grant select on table "public"."docs_blocks_steps" to "anon";

grant trigger on table "public"."docs_blocks_steps" to "anon";

grant truncate on table "public"."docs_blocks_steps" to "anon";

grant update on table "public"."docs_blocks_steps" to "anon";

grant delete on table "public"."docs_blocks_steps" to "authenticated";

grant insert on table "public"."docs_blocks_steps" to "authenticated";

grant references on table "public"."docs_blocks_steps" to "authenticated";

grant select on table "public"."docs_blocks_steps" to "authenticated";

grant trigger on table "public"."docs_blocks_steps" to "authenticated";

grant truncate on table "public"."docs_blocks_steps" to "authenticated";

grant update on table "public"."docs_blocks_steps" to "authenticated";

grant delete on table "public"."docs_blocks_steps" to "service_role";

grant insert on table "public"."docs_blocks_steps" to "service_role";

grant references on table "public"."docs_blocks_steps" to "service_role";

grant select on table "public"."docs_blocks_steps" to "service_role";

grant trigger on table "public"."docs_blocks_steps" to "service_role";

grant truncate on table "public"."docs_blocks_steps" to "service_role";

grant update on table "public"."docs_blocks_steps" to "service_role";

grant delete on table "public"."docs_blocks_steps_steps" to "anon";

grant insert on table "public"."docs_blocks_steps_steps" to "anon";

grant references on table "public"."docs_blocks_steps_steps" to "anon";

grant select on table "public"."docs_blocks_steps_steps" to "anon";

grant trigger on table "public"."docs_blocks_steps_steps" to "anon";

grant truncate on table "public"."docs_blocks_steps_steps" to "anon";

grant update on table "public"."docs_blocks_steps_steps" to "anon";

grant delete on table "public"."docs_blocks_steps_steps" to "authenticated";

grant insert on table "public"."docs_blocks_steps_steps" to "authenticated";

grant references on table "public"."docs_blocks_steps_steps" to "authenticated";

grant select on table "public"."docs_blocks_steps_steps" to "authenticated";

grant trigger on table "public"."docs_blocks_steps_steps" to "authenticated";

grant truncate on table "public"."docs_blocks_steps_steps" to "authenticated";

grant update on table "public"."docs_blocks_steps_steps" to "authenticated";

grant delete on table "public"."docs_blocks_steps_steps" to "service_role";

grant insert on table "public"."docs_blocks_steps_steps" to "service_role";

grant references on table "public"."docs_blocks_steps_steps" to "service_role";

grant select on table "public"."docs_blocks_steps_steps" to "service_role";

grant trigger on table "public"."docs_blocks_steps_steps" to "service_role";

grant truncate on table "public"."docs_blocks_steps_steps" to "service_role";

grant update on table "public"."docs_blocks_steps_steps" to "service_role";

grant delete on table "public"."docs_blocks_table" to "anon";

grant insert on table "public"."docs_blocks_table" to "anon";

grant references on table "public"."docs_blocks_table" to "anon";

grant select on table "public"."docs_blocks_table" to "anon";

grant trigger on table "public"."docs_blocks_table" to "anon";

grant truncate on table "public"."docs_blocks_table" to "anon";

grant update on table "public"."docs_blocks_table" to "anon";

grant delete on table "public"."docs_blocks_table" to "authenticated";

grant insert on table "public"."docs_blocks_table" to "authenticated";

grant references on table "public"."docs_blocks_table" to "authenticated";

grant select on table "public"."docs_blocks_table" to "authenticated";

grant trigger on table "public"."docs_blocks_table" to "authenticated";

grant truncate on table "public"."docs_blocks_table" to "authenticated";

grant update on table "public"."docs_blocks_table" to "authenticated";

grant delete on table "public"."docs_blocks_table" to "service_role";

grant insert on table "public"."docs_blocks_table" to "service_role";

grant references on table "public"."docs_blocks_table" to "service_role";

grant select on table "public"."docs_blocks_table" to "service_role";

grant trigger on table "public"."docs_blocks_table" to "service_role";

grant truncate on table "public"."docs_blocks_table" to "service_role";

grant update on table "public"."docs_blocks_table" to "service_role";

grant delete on table "public"."docs_blocks_table_headers" to "anon";

grant insert on table "public"."docs_blocks_table_headers" to "anon";

grant references on table "public"."docs_blocks_table_headers" to "anon";

grant select on table "public"."docs_blocks_table_headers" to "anon";

grant trigger on table "public"."docs_blocks_table_headers" to "anon";

grant truncate on table "public"."docs_blocks_table_headers" to "anon";

grant update on table "public"."docs_blocks_table_headers" to "anon";

grant delete on table "public"."docs_blocks_table_headers" to "authenticated";

grant insert on table "public"."docs_blocks_table_headers" to "authenticated";

grant references on table "public"."docs_blocks_table_headers" to "authenticated";

grant select on table "public"."docs_blocks_table_headers" to "authenticated";

grant trigger on table "public"."docs_blocks_table_headers" to "authenticated";

grant truncate on table "public"."docs_blocks_table_headers" to "authenticated";

grant update on table "public"."docs_blocks_table_headers" to "authenticated";

grant delete on table "public"."docs_blocks_table_headers" to "service_role";

grant insert on table "public"."docs_blocks_table_headers" to "service_role";

grant references on table "public"."docs_blocks_table_headers" to "service_role";

grant select on table "public"."docs_blocks_table_headers" to "service_role";

grant trigger on table "public"."docs_blocks_table_headers" to "service_role";

grant truncate on table "public"."docs_blocks_table_headers" to "service_role";

grant update on table "public"."docs_blocks_table_headers" to "service_role";

grant delete on table "public"."docs_blocks_table_rows" to "anon";

grant insert on table "public"."docs_blocks_table_rows" to "anon";

grant references on table "public"."docs_blocks_table_rows" to "anon";

grant select on table "public"."docs_blocks_table_rows" to "anon";

grant trigger on table "public"."docs_blocks_table_rows" to "anon";

grant truncate on table "public"."docs_blocks_table_rows" to "anon";

grant update on table "public"."docs_blocks_table_rows" to "anon";

grant delete on table "public"."docs_blocks_table_rows" to "authenticated";

grant insert on table "public"."docs_blocks_table_rows" to "authenticated";

grant references on table "public"."docs_blocks_table_rows" to "authenticated";

grant select on table "public"."docs_blocks_table_rows" to "authenticated";

grant trigger on table "public"."docs_blocks_table_rows" to "authenticated";

grant truncate on table "public"."docs_blocks_table_rows" to "authenticated";

grant update on table "public"."docs_blocks_table_rows" to "authenticated";

grant delete on table "public"."docs_blocks_table_rows" to "service_role";

grant insert on table "public"."docs_blocks_table_rows" to "service_role";

grant references on table "public"."docs_blocks_table_rows" to "service_role";

grant select on table "public"."docs_blocks_table_rows" to "service_role";

grant trigger on table "public"."docs_blocks_table_rows" to "service_role";

grant truncate on table "public"."docs_blocks_table_rows" to "service_role";

grant update on table "public"."docs_blocks_table_rows" to "service_role";

grant delete on table "public"."docs_blocks_table_rows_cells" to "anon";

grant insert on table "public"."docs_blocks_table_rows_cells" to "anon";

grant references on table "public"."docs_blocks_table_rows_cells" to "anon";

grant select on table "public"."docs_blocks_table_rows_cells" to "anon";

grant trigger on table "public"."docs_blocks_table_rows_cells" to "anon";

grant truncate on table "public"."docs_blocks_table_rows_cells" to "anon";

grant update on table "public"."docs_blocks_table_rows_cells" to "anon";

grant delete on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant insert on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant references on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant select on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant trigger on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant truncate on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant update on table "public"."docs_blocks_table_rows_cells" to "authenticated";

grant delete on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant insert on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant references on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant select on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant trigger on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant truncate on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant update on table "public"."docs_blocks_table_rows_cells" to "service_role";

grant delete on table "public"."media" to "anon";

grant insert on table "public"."media" to "anon";

grant references on table "public"."media" to "anon";

grant select on table "public"."media" to "anon";

grant trigger on table "public"."media" to "anon";

grant truncate on table "public"."media" to "anon";

grant update on table "public"."media" to "anon";

grant delete on table "public"."media" to "authenticated";

grant insert on table "public"."media" to "authenticated";

grant references on table "public"."media" to "authenticated";

grant select on table "public"."media" to "authenticated";

grant trigger on table "public"."media" to "authenticated";

grant truncate on table "public"."media" to "authenticated";

grant update on table "public"."media" to "authenticated";

grant delete on table "public"."media" to "service_role";

grant insert on table "public"."media" to "service_role";

grant references on table "public"."media" to "service_role";

grant select on table "public"."media" to "service_role";

grant trigger on table "public"."media" to "service_role";

grant truncate on table "public"."media" to "service_role";

grant update on table "public"."media" to "service_role";

grant delete on table "public"."payload_kv" to "anon";

grant insert on table "public"."payload_kv" to "anon";

grant references on table "public"."payload_kv" to "anon";

grant select on table "public"."payload_kv" to "anon";

grant trigger on table "public"."payload_kv" to "anon";

grant truncate on table "public"."payload_kv" to "anon";

grant update on table "public"."payload_kv" to "anon";

grant delete on table "public"."payload_kv" to "authenticated";

grant insert on table "public"."payload_kv" to "authenticated";

grant references on table "public"."payload_kv" to "authenticated";

grant select on table "public"."payload_kv" to "authenticated";

grant trigger on table "public"."payload_kv" to "authenticated";

grant truncate on table "public"."payload_kv" to "authenticated";

grant update on table "public"."payload_kv" to "authenticated";

grant delete on table "public"."payload_kv" to "service_role";

grant insert on table "public"."payload_kv" to "service_role";

grant references on table "public"."payload_kv" to "service_role";

grant select on table "public"."payload_kv" to "service_role";

grant trigger on table "public"."payload_kv" to "service_role";

grant truncate on table "public"."payload_kv" to "service_role";

grant update on table "public"."payload_kv" to "service_role";

grant delete on table "public"."payload_locked_documents" to "anon";

grant insert on table "public"."payload_locked_documents" to "anon";

grant references on table "public"."payload_locked_documents" to "anon";

grant select on table "public"."payload_locked_documents" to "anon";

grant trigger on table "public"."payload_locked_documents" to "anon";

grant truncate on table "public"."payload_locked_documents" to "anon";

grant update on table "public"."payload_locked_documents" to "anon";

grant delete on table "public"."payload_locked_documents" to "authenticated";

grant insert on table "public"."payload_locked_documents" to "authenticated";

grant references on table "public"."payload_locked_documents" to "authenticated";

grant select on table "public"."payload_locked_documents" to "authenticated";

grant trigger on table "public"."payload_locked_documents" to "authenticated";

grant truncate on table "public"."payload_locked_documents" to "authenticated";

grant update on table "public"."payload_locked_documents" to "authenticated";

grant delete on table "public"."payload_locked_documents" to "service_role";

grant insert on table "public"."payload_locked_documents" to "service_role";

grant references on table "public"."payload_locked_documents" to "service_role";

grant select on table "public"."payload_locked_documents" to "service_role";

grant trigger on table "public"."payload_locked_documents" to "service_role";

grant truncate on table "public"."payload_locked_documents" to "service_role";

grant update on table "public"."payload_locked_documents" to "service_role";

grant delete on table "public"."payload_locked_documents_rels" to "anon";

grant insert on table "public"."payload_locked_documents_rels" to "anon";

grant references on table "public"."payload_locked_documents_rels" to "anon";

grant select on table "public"."payload_locked_documents_rels" to "anon";

grant trigger on table "public"."payload_locked_documents_rels" to "anon";

grant truncate on table "public"."payload_locked_documents_rels" to "anon";

grant update on table "public"."payload_locked_documents_rels" to "anon";

grant delete on table "public"."payload_locked_documents_rels" to "authenticated";

grant insert on table "public"."payload_locked_documents_rels" to "authenticated";

grant references on table "public"."payload_locked_documents_rels" to "authenticated";

grant select on table "public"."payload_locked_documents_rels" to "authenticated";

grant trigger on table "public"."payload_locked_documents_rels" to "authenticated";

grant truncate on table "public"."payload_locked_documents_rels" to "authenticated";

grant update on table "public"."payload_locked_documents_rels" to "authenticated";

grant delete on table "public"."payload_locked_documents_rels" to "service_role";

grant insert on table "public"."payload_locked_documents_rels" to "service_role";

grant references on table "public"."payload_locked_documents_rels" to "service_role";

grant select on table "public"."payload_locked_documents_rels" to "service_role";

grant trigger on table "public"."payload_locked_documents_rels" to "service_role";

grant truncate on table "public"."payload_locked_documents_rels" to "service_role";

grant update on table "public"."payload_locked_documents_rels" to "service_role";

grant delete on table "public"."payload_migrations" to "anon";

grant insert on table "public"."payload_migrations" to "anon";

grant references on table "public"."payload_migrations" to "anon";

grant select on table "public"."payload_migrations" to "anon";

grant trigger on table "public"."payload_migrations" to "anon";

grant truncate on table "public"."payload_migrations" to "anon";

grant update on table "public"."payload_migrations" to "anon";

grant delete on table "public"."payload_migrations" to "authenticated";

grant insert on table "public"."payload_migrations" to "authenticated";

grant references on table "public"."payload_migrations" to "authenticated";

grant select on table "public"."payload_migrations" to "authenticated";

grant trigger on table "public"."payload_migrations" to "authenticated";

grant truncate on table "public"."payload_migrations" to "authenticated";

grant update on table "public"."payload_migrations" to "authenticated";

grant delete on table "public"."payload_migrations" to "service_role";

grant insert on table "public"."payload_migrations" to "service_role";

grant references on table "public"."payload_migrations" to "service_role";

grant select on table "public"."payload_migrations" to "service_role";

grant trigger on table "public"."payload_migrations" to "service_role";

grant truncate on table "public"."payload_migrations" to "service_role";

grant update on table "public"."payload_migrations" to "service_role";

grant delete on table "public"."payload_preferences" to "anon";

grant insert on table "public"."payload_preferences" to "anon";

grant references on table "public"."payload_preferences" to "anon";

grant select on table "public"."payload_preferences" to "anon";

grant trigger on table "public"."payload_preferences" to "anon";

grant truncate on table "public"."payload_preferences" to "anon";

grant update on table "public"."payload_preferences" to "anon";

grant delete on table "public"."payload_preferences" to "authenticated";

grant insert on table "public"."payload_preferences" to "authenticated";

grant references on table "public"."payload_preferences" to "authenticated";

grant select on table "public"."payload_preferences" to "authenticated";

grant trigger on table "public"."payload_preferences" to "authenticated";

grant truncate on table "public"."payload_preferences" to "authenticated";

grant update on table "public"."payload_preferences" to "authenticated";

grant delete on table "public"."payload_preferences" to "service_role";

grant insert on table "public"."payload_preferences" to "service_role";

grant references on table "public"."payload_preferences" to "service_role";

grant select on table "public"."payload_preferences" to "service_role";

grant trigger on table "public"."payload_preferences" to "service_role";

grant truncate on table "public"."payload_preferences" to "service_role";

grant update on table "public"."payload_preferences" to "service_role";

grant delete on table "public"."payload_preferences_rels" to "anon";

grant insert on table "public"."payload_preferences_rels" to "anon";

grant references on table "public"."payload_preferences_rels" to "anon";

grant select on table "public"."payload_preferences_rels" to "anon";

grant trigger on table "public"."payload_preferences_rels" to "anon";

grant truncate on table "public"."payload_preferences_rels" to "anon";

grant update on table "public"."payload_preferences_rels" to "anon";

grant delete on table "public"."payload_preferences_rels" to "authenticated";

grant insert on table "public"."payload_preferences_rels" to "authenticated";

grant references on table "public"."payload_preferences_rels" to "authenticated";

grant select on table "public"."payload_preferences_rels" to "authenticated";

grant trigger on table "public"."payload_preferences_rels" to "authenticated";

grant truncate on table "public"."payload_preferences_rels" to "authenticated";

grant update on table "public"."payload_preferences_rels" to "authenticated";

grant delete on table "public"."payload_preferences_rels" to "service_role";

grant insert on table "public"."payload_preferences_rels" to "service_role";

grant references on table "public"."payload_preferences_rels" to "service_role";

grant select on table "public"."payload_preferences_rels" to "service_role";

grant trigger on table "public"."payload_preferences_rels" to "service_role";

grant truncate on table "public"."payload_preferences_rels" to "service_role";

grant update on table "public"."payload_preferences_rels" to "service_role";

grant delete on table "public"."site_config" to "anon";

grant insert on table "public"."site_config" to "anon";

grant references on table "public"."site_config" to "anon";

grant select on table "public"."site_config" to "anon";

grant trigger on table "public"."site_config" to "anon";

grant truncate on table "public"."site_config" to "anon";

grant update on table "public"."site_config" to "anon";

grant delete on table "public"."site_config" to "authenticated";

grant insert on table "public"."site_config" to "authenticated";

grant references on table "public"."site_config" to "authenticated";

grant select on table "public"."site_config" to "authenticated";

grant trigger on table "public"."site_config" to "authenticated";

grant truncate on table "public"."site_config" to "authenticated";

grant update on table "public"."site_config" to "authenticated";

grant delete on table "public"."site_config" to "service_role";

grant insert on table "public"."site_config" to "service_role";

grant references on table "public"."site_config" to "service_role";

grant select on table "public"."site_config" to "service_role";

grant trigger on table "public"."site_config" to "service_role";

grant truncate on table "public"."site_config" to "service_role";

grant update on table "public"."site_config" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

grant delete on table "public"."users_sessions" to "anon";

grant insert on table "public"."users_sessions" to "anon";

grant references on table "public"."users_sessions" to "anon";

grant select on table "public"."users_sessions" to "anon";

grant trigger on table "public"."users_sessions" to "anon";

grant truncate on table "public"."users_sessions" to "anon";

grant update on table "public"."users_sessions" to "anon";

grant delete on table "public"."users_sessions" to "authenticated";

grant insert on table "public"."users_sessions" to "authenticated";

grant references on table "public"."users_sessions" to "authenticated";

grant select on table "public"."users_sessions" to "authenticated";

grant trigger on table "public"."users_sessions" to "authenticated";

grant truncate on table "public"."users_sessions" to "authenticated";

grant update on table "public"."users_sessions" to "authenticated";

grant delete on table "public"."users_sessions" to "service_role";

grant insert on table "public"."users_sessions" to "service_role";

grant references on table "public"."users_sessions" to "service_role";

grant select on table "public"."users_sessions" to "service_role";

grant trigger on table "public"."users_sessions" to "service_role";

grant truncate on table "public"."users_sessions" to "service_role";

grant update on table "public"."users_sessions" to "service_role";


