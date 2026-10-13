BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "events" ADD COLUMN "reminderMinutes" bigint;

--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261013033425716', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013033425716', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
