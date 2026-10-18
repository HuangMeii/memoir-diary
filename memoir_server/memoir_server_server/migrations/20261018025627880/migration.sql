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
CREATE TABLE "health_activities" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "logDate" timestamp without time zone NOT NULL,
    "atTime" text NOT NULL,
    "title" text NOT NULL,
    "detail" text,
    "kind" text NOT NULL DEFAULT 'note'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "health_logs" ADD COLUMN "workoutType" text;
ALTER TABLE "health_logs" ADD COLUMN "workoutIntensity" text;
ALTER TABLE "health_logs" ADD COLUMN "sleepBedtime" text;
ALTER TABLE "health_logs" ADD COLUMN "sleepWake" text;
ALTER TABLE "health_logs" ADD COLUMN "sleepDeepMinutes" bigint;
ALTER TABLE "health_logs" ADD COLUMN "sleepQuality" text;
ALTER TABLE "health_logs" ADD COLUMN "sleepNote" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "health_profiles" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "heightCm" bigint,
    "weightGoalKg" double precision,
    "weightStartKg" double precision,
    "stepsGoal" bigint NOT NULL DEFAULT 8000,
    "workoutGoalMinutes" bigint NOT NULL DEFAULT 60,
    "waterGoalMl" bigint NOT NULL DEFAULT 2000,
    "sleepGoalHours" double precision NOT NULL DEFAULT 8,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "health_profiles__userId__unique_idx" ON "health_profiles" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "health_water_entries" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "logDate" timestamp without time zone NOT NULL,
    "amountMl" bigint NOT NULL,
    "recordedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "health_activities"
    ADD CONSTRAINT "health_activities_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "health_profiles"
    ADD CONSTRAINT "health_profiles_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "health_water_entries"
    ADD CONSTRAINT "health_water_entries_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

-- Indexes (health)
CREATE INDEX IF NOT EXISTS "idx_health_water_user_date"
  ON "health_water_entries" ("userId", "logDate", "recordedAt");

CREATE INDEX IF NOT EXISTS "idx_health_activity_user_date"
  ON "health_activities" ("userId", "logDate", "atTime");

CREATE INDEX IF NOT EXISTS "idx_health_logs_user_date"
  ON "health_logs" ("userId", "logDate");


--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261018025627880', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261018025627880', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
