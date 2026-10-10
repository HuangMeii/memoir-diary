/// The transport surface the repositories depend on.
///
/// Both the FastAPI REST client ([FastApiDataSource]) and the Serverpod SDK
/// ([ServerpodDataSource]) implement it. Repositories and screens never depend
/// on a concrete backend, which is what lets the app switch with a build flag.
abstract class BackendDataSource {
  Future<dynamic> get(String path, {Map<String, dynamic>? query});

  Future<dynamic> post(String path, {Object? data});

  Future<dynamic> put(String path, {Object? data});

  Future<dynamic> delete(String path);

  Future<dynamic> uploadImage(String path, String filePath);
}
