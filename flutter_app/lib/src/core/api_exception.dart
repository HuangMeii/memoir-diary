/// Thrown for any backend error, carrying a message fit for the UI.
///
/// It used to live in `api_client.dart`. It survived the removal of the REST
/// client because the Serverpod data source and the repositories throw and
/// catch it too.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;
  bool get isConflict => statusCode == 409;

  @override
  String toString() => message;
}
