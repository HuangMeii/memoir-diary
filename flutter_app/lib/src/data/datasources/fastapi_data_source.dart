import '../../core/api_client.dart';
import 'backend_data_source.dart';

/// Transport boundary for the existing FastAPI backend.
///
/// Features should depend on this boundary through repositories instead of
/// calling [ApiClient] directly from widgets or providers.
class FastApiDataSource implements BackendDataSource {
  const FastApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _client.get(path, query: query);

  @override
  Future<dynamic> post(String path, {Object? data}) =>
      _client.post(path, data: data);

  @override
  Future<dynamic> put(String path, {Object? data}) =>
      _client.put(path, data: data);

  @override
  Future<dynamic> delete(String path) => _client.delete(path);

  @override
  Future<dynamic> uploadImage(String path, String filePath) =>
      _client.uploadImage(path, filePath);
}

