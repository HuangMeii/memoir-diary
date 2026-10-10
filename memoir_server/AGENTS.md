# Serverpod project

This project is a Serverpod server (backend).

The user starts the server with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload the running server.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `hot_reload` / `hot_restart` to reload or restart the server. Use `hot_restart` for changes that hot reload cannot apply, such as changes to `main()`.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `memoir_server_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically)
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` for any issues.

## What we're building

`memoir_server` is the Dart/Serverpod backend for **Memoir**, a multi-user
digital diary. It is the target implementation that replaces the Python FastAPI
backend in `../backend/` domain by domain (see
`../docs/convert/07-serverpod-migration-roadmap.md`). FastAPI stays as the parity
reference until every domain has passed cutover.

- Domain code lives in `memoir_server_server/lib/src/<domain>/` with one
  `.spy.yaml` per model and `<domain>_endpoint.dart` per endpoint.
- Auth is a custom `authenticationHandler` (`lib/src/auth/auth_utils.dart`) over
  opaque tokens in `auth_tokens`; passwords are bcrypt for parity with the old
  hashes. Endpoints opt in with `requireLogin` / `requiredScopes`.
- Reference data is seeded through the idempotent `seed` endpoint; its quote
  data is `memoir_server_server/assets/quotes_100.json`.
- Errors the client is expected to handle are thrown as the serializable
  `ApiException` with a stable `code`.
