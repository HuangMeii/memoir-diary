BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "journey_weather_points" ADD COLUMN "weatherGroup" text;

--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261013175627648', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013175627648', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
