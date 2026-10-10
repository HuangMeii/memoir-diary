// Build-time configuration, overridable with `--dart-define`.
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  const AppConfig._();

  // Web chạy trên cùng máy → localhost.
  // Android emulator reaches the host machine via 10.0.2.2
  // Android/iOS thiết bị thật → bắt buộc override bằng --dart-define.
  // Pass at build time:
  //   flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
  //   flutter run          --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb
        ? 'http://127.0.0.1:8000/api/v1'
        : 'http://10.0.2.2:8000/api/v1',
  );

  // --- Backend selection ---------------------------------------------------
  //
  // The app can talk to either the Python FastAPI reference backend or the
  // Dart Serverpod backend. `fastapi` stays the default while the migration is
  // in progress (see docs/convert/07-serverpod-migration-roadmap.md).
  //
  //   flutter run -d chrome --dart-define=BACKEND=serverpod
  static const String backend = String.fromEnvironment(
    'BACKEND',
    defaultValue: 'fastapi',
  );

  /// Serverpod API server URL; used only when [backend] is `serverpod`.
  static const String serverpodUrl = String.fromEnvironment(
    'SERVERPOD_URL',
    defaultValue: kIsWeb
        ? 'http://127.0.0.1:8080'
        : 'http://10.0.2.2:8080',
  );

  static bool get useServerpod => backend == 'serverpod';
}