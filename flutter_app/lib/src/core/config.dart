// Build-time configuration, overridable with `--dart-define`.
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  const AppConfig._();

  // Web runs on the same machine as the server -> localhost.
  // Android emulator reaches the host machine via 10.0.2.2.
  // Android/iOS physical devices -> override with --dart-define.
  //
  //   flutter run -d chrome
  //   flutter run --dart-define=SERVERPOD_URL=http://10.0.2.2:8080
  static const String serverpodUrl = String.fromEnvironment(
    'SERVERPOD_URL',
    defaultValue: kIsWeb ? 'http://127.0.0.1:8080' : 'http://10.0.2.2:8080',
  );
}
