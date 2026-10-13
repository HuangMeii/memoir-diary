# Serverpod Backend Migration Roadmap

## Decision

The long-term application stack is:

```text
Flutter/Dart client
        |
        v
Serverpod/Dart application backend
        |
        +--> Neon PostgreSQL
        +--> private object storage
        +--> Python AI services (HTTP or queue)
```

FastAPI remains the reference implementation until every domain has passed
parity checks. It is not removed at the beginning of the migration.

## Non-negotiable boundaries

- Flutter never receives database, JWT-signing, or object-storage secrets.
- The Serverpod backend owns authentication, authorization, ownership checks,
  transactions, file signing, and AI service credentials.
- Python is reserved for AI/data workloads where its ecosystem is a material
  advantage.
- Existing PostgreSQL tables and object keys are preserved unless a reviewed
  migration explicitly changes them.
- The Flutter repository interfaces remain stable while the data source moves
  from FastAPI to Serverpod.

## Delivery phases

### Phase 0 — Toolchain and contract freeze

- Install and pin the Dart SDK and Serverpod CLI in CI and developer setup.
- Create the Serverpod workspace with server, generated client, and shared
  protocol packages.
- Define JSON/protocol contracts for auth, planner, journal, images, quotes,
  health, stats, and admin.
- Add contract fixtures based on the current FastAPI responses.
- Keep FastAPI as the oracle for parity tests.

Exit criteria: a clean Serverpod development build and versioned contract
fixtures exist without changing production traffic.

### Phase 1 — Shared infrastructure

- Configure Neon PostgreSQL and migrations.
- Implement structured errors, request IDs, logging, health checks, and
  environment validation.
- Implement session storage, access/refresh token rotation, and role checks.
- Add a storage gateway for private objects and short-lived signed URLs.

Exit criteria: authenticated requests, ownership checks, and storage operations
are covered by integration tests.

### Phase 2 — Low-risk domains

Migrate lookups, notes, todos, events, schedules, and health logs first.
These domains have isolated CRUD behavior and provide a practical validation of
the database layer and generated client.

Exit criteria: read/write parity against FastAPI for authorized and unauthorized
requests.

### Phase 3 — Journal and media

Migrate entries, entry images, upload, delete, and signed URL generation.
Run a read-only dual-read comparison before changing writes.

Exit criteria: no cross-user reads, no orphaned objects, and identical
create/edit/gallery behavior.

### Phase 4 — Quotes and statistics

Migrate quotes, daily quote generation, self messages, reflections, and stats.
Daily pairing and reshuffle must remain transactional and idempotent.

Exit criteria: historical quote rows and monthly summaries match the reference
implementation.

### Phase 5 — Cutover

- Route one domain at a time to Serverpod.
- Monitor error rate, latency, auth failures, and storage failures.
- Keep FastAPI rollback routes available during the canary period.
- Remove FastAPI only after the final parity report and database backup.

## AI integration

AI is an external capability, not a reason to couple the core backend to Python.
The Serverpod backend calls an `AiGateway` with a narrow, authenticated
contract. The gateway may target a Python service, a hosted model provider, or
another implementation without exposing credentials to Flutter.

```text
Flutter -> Serverpod -> AiGateway -> Python AI service
```

## First implementation slice

The current Flutter repositories already provide the correct seam:

```text
Screen -> Repository -> DataSource
```

The next implementation slice should replace the `FastApiDataSource` inside
repositories one domain at a time. The UI must not be changed merely because
the backend implementation changes.
