# memoir_server_server

Serverpod/Dart backend for Memoir — the target backend that replaces the FastAPI
implementation (`backend/`) domain by domain. See
`../docs/convert/07-serverpod-migration-roadmap.md`.

## Requirements

- Dart SDK (pinned by the workspace) and Serverpod CLI 4.0.4:
  `dart pub global activate serverpod_cli 4.0.4`.
- No Docker: the database is the embedded PostgreSQL Serverpod manages
  (`config/development.yaml` -> `database.dataPath`).

## Run

    cd memoir_server
    serverpod start           # generate + run + hot reload

## Endpoints

| Endpoint | Mirrors FastAPI | Notes |
|---|---|---|
| `auth` | `/auth` | register/login/me/logout; opaque tokens in `auth_tokens` |
| `lookups` | `/moods`, `/weathers` | public |
| `entries` | `/entries` | |
| `images` | `/entries/{id}/images` | upload description -> confirm -> gallery |
| `quotes` | `/quotes` | |
| `selfMessages` | `/self-messages` | |
| `dailyQuotes` | `/daily-quotes` | today/history/reshuffle |
| `reflections` | `/reflections` | |
| `notes` | `/notes` | |
| `todos` | `/todos` | |
| `events` | `/events` | |
| `schedules` | `/schedule-items` | |
| `health` | `/health-logs` | |
| `stats` | `/stats` | mood/weather grid + summary |
| `admin` | `/admin` | requires the `admin` scope |
| `weather` | `/weather` | Open-Meteo forecast with snapshot fallback |
| `seed` | `python -m app.seed.seed` | idempotent; seeds lookups + 100 quotes |

## Auth

Tokens are opaque rows in `auth_tokens` (so logout can revoke them) and are
validated by the custom `authenticationHandler` in `lib/src/auth/auth_utils.dart`.
Passwords use bcrypt, matching the existing FastAPI hashes.

## Tests

    cd memoir_server
    dart test                 # embedded PostgreSQL, no Docker

## Checklist after changes

`dart analyze` -> `dart format` -> `serverpod create-migration` (only when a
`table` model changed) -> `dart test`.
