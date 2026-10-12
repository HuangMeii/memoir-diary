// Copies journal data from the Neon (staging) database into the local embedded
// PostgreSQL that development mode uses.
//
// Only READS from Neon and only WRITES into the local dev database, so the
// remote database is never modified. Run from the server package:
//
//   cd memoir_server/memoir_server_server
//   dart run tool/sync_from_neon.dart --replace
//
// Options:
//   --replace        truncate the local tables before copying (idempotent runs)
//   --with-tokens    also copy auth_tokens (otherwise just log in again)
//   --tables=a,b,c   copy only the listed tables
//   --dry-run        print source/target row counts without writing

import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:yaml/yaml.dart';

/// Tables copied, in FK-safe order. Serverpod bookkeeping tables are excluded:
/// copying `serverpod_migrations` would desync the local migration state, and
/// logs/health rows are noise. `auth_tokens` is skipped by default so the next
/// login simply issues a fresh token.
const List<String> _defaultTables = [
  'users',
  'moods',
  'weathers',
  'quotes',
  'self_messages',
  'daily_quotes',
  'diary_entries',
  'reflections',
  'entry_images',
  'notes',
  'todos',
  'events',
  'schedule_items',
  'health_logs',
  'weather_snapshots',
];

const int _batchSize = 500;

Future<void> main(List<String> args) async {
  final options = _Options.parse(args);
  final serverDir = _resolveServerDir();
  final dev = _devTarget(serverDir);
  final neon = _neonSource(serverDir);
  final tables = options.tables;

  stdout.writeln(
    'source (Neon): ${neon.endpoint.host}:${neon.endpoint.port}'
    '/${neon.endpoint.database}',
  );
  stdout.writeln(
    'target (dev) : ${dev.endpoint.host} '
    '(unix socket, db ${dev.endpoint.database})',
  );

  final source = await pg.Connection.open(
    neon.endpoint,
    settings: pg.ConnectionSettings(
      sslMode: neon.sslMode,
      connectTimeout: const Duration(seconds: 30),
    ),
  );
  final target = await pg.Connection.open(
    dev.endpoint,
    settings: const pg.ConnectionSettings(
      // The embedded cluster speaks plaintext over its Unix socket; the driver
      // defaults to requiring SSL otherwise.
      sslMode: pg.SslMode.disable,
      connectTimeout: Duration(seconds: 30),
    ),
  );

  try {
    if (!options.dryRun) {
      // Bypass foreign keys and triggers while loading so the copy does not
      // depend on insertion order. Requires a superuser (the embedded cluster's
      // `postgres` role is one).
      await target.execute('SET session_replication_role = replica');
      if (options.replace) {
        await target.execute(
          'TRUNCATE ${tables.map((t) => '"public"."$t"').join(', ')} CASCADE',
        );
      }
    }

    var copied = 0;
    for (final table in tables) {
      final result = await source.execute(
        'SELECT row_to_json(t)::text FROM "public"."$table" t',
      );
      final rows = [for (final row in result) row[0] as String];
      final existing = await _count(target, table);

      if (options.dryRun) {
        stdout.writeln(
          '  ${table.padRight(20)} source=${rows.length} target=$existing',
        );
        continue;
      }

      for (var i = 0; i < rows.length; i += _batchSize) {
        final batch = rows.sublist(i, math.min(i + _batchSize, rows.length));
        await target.runTx((tx) async {
          for (final json in batch) {
            await tx.execute(
              'INSERT INTO "public"."$table" SELECT * FROM '
              'json_populate_record(NULL::"public"."$table", \$1::text::json)',
              parameters: [json],
            );
          }
        });
      }
      copied += rows.length;
      stdout.writeln(
        '  ${table.padRight(20)} copied ${rows.length} (was $existing)',
      );
    }

    if (!options.dryRun) {
      await _resetSequences(target, tables);
      await target.execute('SET session_replication_role = origin');
      stdout.writeln('Done. $copied rows copied.');
    } else {
      stdout.writeln('Dry run: nothing written.');
    }
  } finally {
    await source.close();
    await target.close();
  }
}

Future<int> _count(pg.Session session, String table) async {
  final result = await session.execute(
    'SELECT count(*) FROM "public"."$table"',
  );
  return result.first[0] as int;
}

/// Serial int columns need their sequence advanced past the copied ids, or the
/// next insert collides with an existing primary key.
Future<void> _resetSequences(pg.Session session, List<String> tables) async {
  final result = await session.execute(
    "SELECT table_name, column_name FROM information_schema.columns "
    "WHERE table_schema = 'public' AND column_default LIKE 'nextval(%'",
  );
  for (final row in result) {
    final table = row[0] as String;
    final column = row[1] as String;
    if (!tables.contains(table)) continue;
    await session.execute(
      'SELECT setval('
      'pg_get_serial_sequence(\'"public"."$table"\', \'$column\'), '
      'COALESCE((SELECT max("$column") FROM "public"."$table"), 0) + 1, false)',
    );
  }
}

/// Locates the server package directory: the one holding
/// `config/development.yaml`. Checks the current directory and its parents,
/// then the location of this script.
Directory _resolveServerDir() {
  var dir = Directory.current;
  for (var i = 0; i < 4; i++) {
    if (File(p.join(dir.path, 'config', 'development.yaml')).existsSync()) {
      return dir;
    }
    dir = dir.parent;
  }
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  if (File(p.join(scriptDir.path, 'config', 'development.yaml')).existsSync()) {
    return scriptDir;
  }
  throw StateError(
    'Could not find config/development.yaml. Run this from the server package '
    '(memoir_server/memoir_server_server).',
  );
}

Map<String, dynamic> _readYaml(File file) {
  if (!file.existsSync()) {
    throw StateError('Missing config file: ${file.path}');
  }
  final parsed = loadYaml(file.readAsStringSync());
  if (parsed is! Map) {
    throw StateError('Expected a YAML map in ${file.path}');
  }
  return parsed.cast<String, dynamic>();
}

/// Builds the connection to the local embedded PostgreSQL. The cluster only
/// listens on a Unix domain socket, so [pg.Endpoint.host] must be the socket
/// *file* (`.../run/.s.PGSQL.<port>`), not the directory.
_DevTarget _devTarget(Directory serverDir) {
  final config = _readYaml(
    File(p.join(serverDir.path, 'config', 'development.yaml')),
  );
  final database = (config['database'] as Map).cast<String, dynamic>();
  final passwords = _readYaml(
    File(p.join(serverDir.path, 'config', 'passwords.yaml')),
  );
  final devPasswords = (passwords['development'] as Map)
      .cast<String, dynamic>();

  final pgDataDir = p.normalize(
    p.join(serverDir.path, database['dataPath'] as String),
  );
  final runDir = p.join(Directory(pgDataDir).parent.path, 'run');
  final port = _readPgPort(File(p.join(pgDataDir, 'postmaster.pid'))) ?? 5432;
  final socketFile = p.join(runDir, '.s.PGSQL.$port');

  if (!File(socketFile).existsSync()) {
    throw StateError(
      'Embedded PostgreSQL socket not found at $socketFile. Start the server '
      'once (dart bin/main.dart) so the cluster is running.',
    );
  }

  return _DevTarget(
    pg.Endpoint(
      host: socketFile,
      port: port,
      database: database['name'] as String,
      username: database['user'] as String,
      password: devPasswords['database'] as String?,
      isUnixSocket: true,
    ),
  );
}

/// Builds the connection to the Neon staging branch from staging.yaml plus the
/// matching password in passwords.yaml.
_NeonSource _neonSource(Directory serverDir) {
  final config = _readYaml(
    File(p.join(serverDir.path, 'config', 'staging.yaml')),
  );
  final database = (config['database'] as Map).cast<String, dynamic>();
  final passwords = _readYaml(
    File(p.join(serverDir.path, 'config', 'passwords.yaml')),
  );
  final stagingPasswords = (passwords['staging'] as Map)
      .cast<String, dynamic>();

  final requireSsl = database['requireSsl'] == true;
  return _NeonSource(
    pg.Endpoint(
      host: database['host'] as String,
      port: (database['port'] as num?)?.toInt() ?? 5432,
      database: database['name'] as String,
      username: database['user'] as String,
      password: stagingPasswords['database'] as String?,
    ),
    requireSsl ? pg.SslMode.require : pg.SslMode.disable,
  );
}

/// PostgreSQL writes its port on the fourth line of `postmaster.pid`.
int? _readPgPort(File pidFile) {
  if (!pidFile.existsSync()) return null;
  final lines = pidFile.readAsLinesSync();
  if (lines.length < 4) return null;
  return int.tryParse(lines[3].trim());
}

class _NeonSource {
  _NeonSource(this.endpoint, this.sslMode);

  final pg.Endpoint endpoint;
  final pg.SslMode sslMode;
}

class _DevTarget {
  _DevTarget(this.endpoint);

  final pg.Endpoint endpoint;
}

class _Options {
  _Options({
    required this.replace,
    required this.withTokens,
    required this.dryRun,
    required this.tables,
  });

  final bool replace;
  final bool withTokens;
  final bool dryRun;
  final List<String> tables;

  static _Options parse(List<String> args) {
    var replace = false;
    var withTokens = false;
    var dryRun = false;
    List<String>? tables;

    for (final arg in args) {
      if (arg == '--replace') {
        replace = true;
      } else if (arg == '--with-tokens') {
        withTokens = true;
      } else if (arg == '--dry-run') {
        dryRun = true;
      } else if (arg.startsWith('--tables=')) {
        tables = arg
            .substring('--tables='.length)
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();
      } else {
        throw ArgumentError('Unknown argument: $arg');
      }
    }

    var resolved = tables ?? _defaultTables;
    if (withTokens && !resolved.contains('auth_tokens')) {
      resolved = [...resolved, 'auth_tokens'];
    }
    return _Options(
      replace: replace,
      withTokens: withTokens,
      dryRun: dryRun,
      tables: resolved,
    );
  }
}
