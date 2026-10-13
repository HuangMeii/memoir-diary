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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "journey_stops"
    ADD CONSTRAINT "journey_stops_fk_0"
    FOREIGN KEY("journeyId")
    REFERENCES "journeys"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "journey_weather_points"
    ADD CONSTRAINT "journey_weather_points_fk_0"
    FOREIGN KEY("journeyId")
    REFERENCES "journeys"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "journeys"
    ADD CONSTRAINT "journeys_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR memoir_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('memoir_server', '20261013174623807', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013174623807', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
