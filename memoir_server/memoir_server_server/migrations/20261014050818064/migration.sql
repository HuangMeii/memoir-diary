BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "note_checklist_items" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "noteId" uuid NOT NULL,
    "text" text NOT NULL,
    "isDone" boolean NOT NULL DEFAULT false,
    "sortOrder" bigint NOT NULL DEFAULT 0
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "note_entry_links" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "noteId" uuid NOT NULL,
    "entryId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "notes" ADD COLUMN "title" text;
ALTER TABLE "notes" ADD COLUMN "tags" json;
ALTER TABLE "notes" ADD COLUMN "isArchived" boolean NOT NULL DEFAULT false;
ALTER TABLE "notes" ADD COLUMN "isTrashed" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "note_checklist_items"
    ADD CONSTRAINT "note_checklist_items_fk_0"
    FOREIGN KEY("noteId")
    REFERENCES "notes"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "note_entry_links"
    ADD CONSTRAINT "note_entry_links_fk_0"
    FOREIGN KEY("noteId")
    REFERENCES "notes"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "note_entry_links"
    ADD CONSTRAINT "note_entry_links_fk_1"
    FOREIGN KEY("entryId")
    REFERENCES "diary_entries"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261014050818064', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014050818064', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
