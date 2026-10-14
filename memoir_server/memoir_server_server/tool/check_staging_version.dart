// Prints the migration state of the Neon (staging) database. Run this before
// any migration surgery on the local/dev side so the branch that staging is on
// is known first.
//
// Read-only: only SELECTs against staging.
//
//   cd memoir_server/memoir_server_server
//   dart run tool/check_staging_version.dart

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final serverDir = _resolveServerDir();
  final config = _readYaml(
    File(p.join(serverDir.path, 'config', 'staging.yaml')),
  );
  final passwords = _readYaml(
    File(p.join(serverDir.path, 'config', 'passwords.yaml')),
  );
  final database = config['database'] as Map;
  final stagingPasswords = passwords['staging'] as Map;
  final requireSsl = database['requireSsl'] as bool? ?? true;

  final endpoint = pg.Endpoint(
    host: database['host'] as String,
    port: (database['port'] as num?)?.toInt() ?? 5432,
    database: database['name'] as String,
    username: database['user'] as String,
    password: stagingPasswords['database'] as String?,
  );

  stdout.writeln(
    'staging: ${endpoint.host}:${endpoint.port}/${endpoint.database}',
  );

  final connection = await pg.Connection.open(
    endpoint,
    settings: pg.ConnectionSettings(
      sslMode: requireSsl ? pg.SslMode.require : pg.SslMode.disable,
      connectTimeout: const Duration(seconds: 20),
    ),
  );

  try {
    final versions = await connection.execute(
      'SELECT module, version FROM serverpod_migrations ORDER BY module',
    );
    if (versions.isEmpty) {
      stdout.writeln(
        'serverpod_migrations: (empty - database has not been migrated)',
      );
    } else {
      stdout.writeln('serverpod_migrations:');
      for (final row in versions) {
        stdout.writeln('  ${row[0]} = ${row[1]}');
      }
    }

    final tables = await connection.execute(
      "SELECT table_name FROM information_schema.tables "
      "WHERE table_schema = 'public' "
      "AND (table_name LIKE 'note%' OR table_name LIKE 'journey%') "
      'ORDER BY table_name',
    );
    stdout.writeln('branch-specific tables (notes vs journey):');
    for (final row in tables) {
      stdout.writeln('  ${row[0]}');
    }
    if (tables.isEmpty) stdout.writeln('  (none)');
  } finally {
    await connection.close();
  }
}

Directory _resolveServerDir() {
  var dir = Directory.current;
  while (true) {
    if (File(p.join(dir.path, 'config', 'staging.yaml')).existsSync() &&
        File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      stderr.writeln('Run this from the server package (memoir_server_server).');
      exit(1);
    }
    dir = parent;
  }
}

Map _readYaml(File file) {
  if (!file.existsSync()) {
    stderr.writeln('Missing config file: ${file.path}');
    exit(1);
  }
  return loadYaml(file.readAsStringSync()) as Map;
}
