/// Thrown for any backend error, carrying a message fit for the UI.
///
/// It used to live in `api_client.dart`. It survived the removal of the REST
/// client because the Serverpod data source and the repositories throw and
/// catch it too.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;

  /// The backend's stable error code, when it sent one: `notFound`,
  /// `conflict`, `unauthorized`, `forbidden`, or one of the route codes
  /// `noRoute`, `rateLimited`, `unavailable`.
  final String? code;

  bool get isUnauthorized => statusCode == 401;
  bool get isConflict => statusCode == 409;

  /// The routing engine found no way through the chosen points.
  bool get isNoRoute => code == 'noRoute';

  /// The provider refused because we asked too often.
  bool get isRateLimited => code == 'rateLimited';

  /// The provider timed out or failed.
  bool get isUnavailable => code == 'unavailable';

  @override
  String toString() => message;
}
