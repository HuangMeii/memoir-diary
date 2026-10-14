BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "idx_note_checklist_note" ON "note_checklist_items" USING btree ("noteId", "sortOrder");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX "note_entry_unique_idx" ON "note_entry_links" USING btree ("noteId", "entryId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "idx_notes_user_updated" ON "notes" USING btree ("userId", "updatedAt");
CREATE INDEX "idx_notes_user_flags" ON "notes" USING btree ("userId", "isTrashed", "isArchived");

--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261014051115498', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014051115498', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
