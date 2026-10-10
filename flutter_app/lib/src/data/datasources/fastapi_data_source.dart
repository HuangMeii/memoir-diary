import '../../core/api_client.dart';

/// Transport boundary for the existing FastAPI backend.
///
/// Features should depend on this boundary through repositories instead of
/// calling [ApiClient] directly from widgets or providers.
class FastApiDataSource {
  const FastApiDataSource(this._client);

  final ApiClient _client;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _client.get(path, query: query);

  Future<dynamic> post(String path, {Object? data}) =>
      _client.post(path, data: data);

  Future<dynamic> put(String path, {Object? data}) =>
      _client.put(path, data: data);

  Future<dynamic> delete(String path) => _client.delete(path);

  Future<dynamic> uploadImage(String path, String filePath) =>
      _client.uploadImage(path, filePath);
}
