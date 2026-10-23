BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX IF NOT EXISTS "idx_health_activity_user_date" ON "health_activities" USING btree ("userId", "logDate", "atTime");
--
-- ACTION ALTER TABLE
--
CREATE INDEX IF NOT EXISTS "idx_health_logs_user_date" ON "health_logs" USING btree ("userId", "logDate");
--
-- ACTION ALTER TABLE
--
CREATE INDEX IF NOT EXISTS "idx_health_water_user_date" ON "health_water_entries" USING btree ("userId", "logDate", "recordedAt");

--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261020173019487-health-indexes', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261020173019487-health-indexes', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
