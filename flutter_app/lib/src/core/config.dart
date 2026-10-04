/// Build-time configuration, overridable with `--dart-define`.
class AppConfig {
  const AppConfig._();

  // Android emulator reaches the host machine via 10.0.2.2
  // iOS simulator / Flutter web on the same PC can use localhost.
  // Pass at build time:
  //   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );
}