alter table "public"."_docs_v_blocks_contact_card" add column "image_id" integer;

alter table "public"."docs_blocks_contact_card" add column "image_id" integer;

CREATE INDEX _docs_v_blocks_contact_card_image_idx ON public._docs_v_blocks_contact_card USING btree (image_id);

CREATE INDEX docs_blocks_contact_card_image_idx ON public.docs_blocks_contact_card USING btree (image_id);

alter table "public"."_docs_v_blocks_contact_card" add constraint "_docs_v_blocks_contact_card_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."_docs_v_blocks_contact_card" validate constraint "_docs_v_blocks_contact_card_image_id_media_id_fk";

alter table "public"."docs_blocks_contact_card" add constraint "docs_blocks_contact_card_image_id_media_id_fk" FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL not valid;

alter table "public"."docs_blocks_contact_card" validate constraint "docs_blocks_contact_card_image_id_media_id_fk";


