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
CREATE TABLE "auth_tokens" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "auth_tokens__token__unique_idx" ON "auth_tokens" USING btree ("token");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "daily_quotes" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "quoteDate" timestamp without time zone NOT NULL,
    "quoteId" uuid,
    "quoteId2" uuid,
    "selfMessageId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "daily_quotes__userId__quoteDate__unique_idx" ON "daily_quotes" USING btree ("userId", "quoteDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "diary_entries" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "entryDate" timestamp without time zone NOT NULL,
    "moodId" bigint,
    "weatherId" bigint,
    "diaryText" text,
    "otherPerspective" text,
    "futureMessage" text,
    "selfCare" text,
    "tomorrowHope" text,
    "gratitude" text,
    "dream" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "diary_entries__userId__entryDate__unique_idx" ON "diary_entries" USING btree ("userId", "entryDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "entry_images" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "entryId" uuid NOT NULL,
    "objectKey" text NOT NULL,
    "url" text,
    "contentType" text NOT NULL DEFAULT 'image/jpeg'::text,
    "sizeBytes" bigint,
    "width" bigint,
    "height" bigint,
    "caption" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "events" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "startAt" timestamp without time zone NOT NULL,
    "endAt" timestamp without time zone,
    "location" text,
    "isAllDay" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "health_logs" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "logDate" timestamp without time zone NOT NULL,
    "steps" bigint,
    "workoutMinutes" bigint,
    "waterMl" bigint,
    "sleepHours" double precision,
    "weightKg" double precision,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "health_logs__userId__logDate__unique_idx" ON "health_logs" USING btree ("userId", "logDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "moods" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "labelVi" text NOT NULL,
    "colorHex" text NOT NULL,
    "icon" text NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "moods__code__unique_idx" ON "moods" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notes" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "content" text NOT NULL,
    "color" text,
    "isPinned" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "quotes" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid,
    "text" text NOT NULL,
    "author" text,
    "source" text,
    "category" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reflections" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "entryId" uuid,
    "quoteId" uuid,
    "selfMessageId" uuid,
    "thought" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "schedule_items" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "startAt" timestamp without time zone NOT NULL,
    "endAt" timestamp without time zone,
    "recurrenceRule" text,
    "reminderMinutes" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "self_messages" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "entryId" uuid,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "todos" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "notes" text,
    "dueDate" timestamp without time zone,
    "weekLabel" text,
    "priority" bigint NOT NULL DEFAULT 2,
    "isDone" boolean NOT NULL DEFAULT false,
    "completedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "users" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "email" text NOT NULL,
    "username" text NOT NULL,
    "passwordHash" text,
    "displayName" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "role" text NOT NULL DEFAULT 'user'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "weatherLat" double precision,
    "weatherLon" double precision,
    "weatherLocationName" text
);

-- Indexes
CREATE UNIQUE INDEX "users__email__unique_idx" ON "users" USING btree ("email");
CREATE UNIQUE INDEX "users__username__unique_idx" ON "users" USING btree ("username");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "weather_snapshots" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "forecastDate" timestamp without time zone NOT NULL,
    "weatherCode" bigint NOT NULL,
    "weatherId" bigint,
    "tempMin" double precision,
    "tempMax" double precision,
    "tempAvg" double precision,
    "precipitationMm" double precision,
    "fetchedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "weather_snapshots__userId__forecastDate__unique_idx" ON "weather_snapshots" USING btree ("userId", "forecastDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "weathers" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "labelVi" text NOT NULL,
    "colorHex" text NOT NULL,
    "icon" text NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "weathers__code__unique_idx" ON "weathers" USING btree ("code");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "daily_quotes"
    ADD CONSTRAINT "daily_quotes_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "diary_entries"
    ADD CONSTRAINT "diary_entries_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "entry_images"
    ADD CONSTRAINT "entry_images_fk_0"
    FOREIGN KEY("entryId")
    REFERENCES "diary_entries"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "events"
    ADD CONSTRAINT "events_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "health_logs"
    ADD CONSTRAINT "health_logs_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notes"
    ADD CONSTRAINT "notes_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reflections"
    ADD CONSTRAINT "reflections_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "schedule_items"
    ADD CONSTRAINT "schedule_items_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "self_messages"
    ADD CONSTRAINT "self_messages_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "todos"
    ADD CONSTRAINT "todos_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "weather_snapshots"
    ADD CONSTRAINT "weather_snapshots_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261010150402579', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261010150402579', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
