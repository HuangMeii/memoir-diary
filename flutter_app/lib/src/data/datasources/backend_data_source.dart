/// The transport surface the repositories depend on.
///
/// [ServerpodDataSource] implements it. Repositories and screens never depend
/// on a concrete backend, so the transport can change without touching the UI.
abstract class BackendDataSource {
  Future<dynamic> get(String path, {Map<String, dynamic>? query});

  Future<dynamic> post(String path, {Object? data});

  Future<dynamic> put(String path, {Object? data});

  Future<dynamic> delete(String path);

  Future<dynamic> uploadImage(String path, String filePath);
}
