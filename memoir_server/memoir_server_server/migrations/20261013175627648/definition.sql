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
-- Class AuthToken as table auth_tokens
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
-- Class DailyQuote as table daily_quotes
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
-- Class DiaryEntry as table diary_entries
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
-- Class EntryImage as table entry_images
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
-- Class Event as table events
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
    "reminderMinutes" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Class HealthLog as table health_logs
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
-- Class JourneyStop as table journey_stops
--
CREATE TABLE "journey_stops" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "journeyId" uuid NOT NULL,
    "seq" bigint NOT NULL,
    "kind" text NOT NULL,
    "name" text NOT NULL,
    "lat" double precision NOT NULL,
    "lon" double precision NOT NULL,
    "dwellMinutes" bigint NOT NULL DEFAULT 0,
    "arrivalAt" timestamp without time zone,
    "distanceFromStartMeters" bigint
);

-- Indexes
CREATE UNIQUE INDEX "journey_stops__journeyId__seq__unique_idx" ON "journey_stops" USING btree ("journeyId", "seq");

--
-- Class JourneyWeatherPoint as table journey_weather_points
--
CREATE TABLE "journey_weather_points" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "journeyId" uuid NOT NULL,
    "seq" bigint NOT NULL,
    "sampleAt" timestamp without time zone NOT NULL,
    "lat" double precision NOT NULL,
    "lon" double precision NOT NULL,
    "label" text,
    "weatherCode" bigint,
    "weatherGroup" text,
    "weatherId" bigint,
    "tempC" double precision,
    "precipitationMm" double precision,
    "precipitationProbability" bigint,
    "windSpeedKmh" double precision,
    "severity" text,
    "fetchedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "journey_weather_points__journeyId__seq__unique_idx" ON "journey_weather_points" USING btree ("journeyId", "seq");

--
-- Class Journey as table journeys
--
CREATE TABLE "journeys" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "vehicle" text NOT NULL,
    "departureAt" timestamp without time zone NOT NULL,
    "originName" text NOT NULL,
    "originLat" double precision NOT NULL,
    "originLon" double precision NOT NULL,
    "destinationName" text NOT NULL,
    "destinationLat" double precision NOT NULL,
    "destinationLon" double precision NOT NULL,
    "distanceMeters" bigint NOT NULL,
    "durationSeconds" bigint NOT NULL,
    "geometry" text NOT NULL,
    "notes" text,
    "entryId" uuid,
    "weatherSavedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Class Mood as table moods
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
-- Class Note as table notes
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
-- Class Quote as table quotes
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
-- Class Reflection as table reflections
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
-- Class ScheduleItem as table schedule_items
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
-- Class SelfMessage as table self_messages
--
CREATE TABLE "self_messages" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "entryId" uuid,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Class Todo as table todos
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
-- Class User as table users
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
-- Class WeatherSnapshot as table weather_snapshots
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
-- Class Weather as table weathers
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
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectDownloadEntry as table serverpod_cloud_storage_direct_download
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class FutureCallClaimEntry as table serverpod_future_call_claim
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Foreign relations for "daily_quotes" table
--
ALTER TABLE ONLY "daily_quotes"
    ADD CONSTRAINT "daily_quotes_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "diary_entries" table
--
ALTER TABLE ONLY "diary_entries"
    ADD CONSTRAINT "diary_entries_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "entry_images" table
--
ALTER TABLE ONLY "entry_images"
    ADD CONSTRAINT "entry_images_fk_0"
    FOREIGN KEY("entryId")
    REFERENCES "diary_entries"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "events" table
--
ALTER TABLE ONLY "events"
    ADD CONSTRAINT "events_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "health_logs" table
--
ALTER TABLE ONLY "health_logs"
    ADD CONSTRAINT "health_logs_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "journey_stops" table
--
ALTER TABLE ONLY "journey_stops"
    ADD CONSTRAINT "journey_stops_fk_0"
    FOREIGN KEY("journeyId")
    REFERENCES "journeys"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "journey_weather_points" table
--
ALTER TABLE ONLY "journey_weather_points"
    ADD CONSTRAINT "journey_weather_points_fk_0"
    FOREIGN KEY("journeyId")
    REFERENCES "journeys"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "journeys" table
--
ALTER TABLE ONLY "journeys"
    ADD CONSTRAINT "journeys_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "notes" table
--
ALTER TABLE ONLY "notes"
    ADD CONSTRAINT "notes_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "reflections" table
--
ALTER TABLE ONLY "reflections"
    ADD CONSTRAINT "reflections_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "schedule_items" table
--
ALTER TABLE ONLY "schedule_items"
    ADD CONSTRAINT "schedule_items_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "self_messages" table
--
ALTER TABLE ONLY "self_messages"
    ADD CONSTRAINT "self_messages_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "todos" table
--
ALTER TABLE ONLY "todos"
    ADD CONSTRAINT "todos_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "weather_snapshots" table
--
ALTER TABLE ONLY "weather_snapshots"
    ADD CONSTRAINT "weather_snapshots_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_future_call_claim" table
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


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
