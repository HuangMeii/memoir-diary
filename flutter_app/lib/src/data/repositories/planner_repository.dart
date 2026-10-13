import '../datasources/backend_data_source.dart';

class PlannerRepository {
  const PlannerRepository(this._source);
  final BackendDataSource _source;

  Future<List<Map<String, dynamic>>> todos() => _list('/todos');
  Future<List<Map<String, dynamic>>> events() => _list('/events');
  Future<List<Map<String, dynamic>>> schedules() => _list('/schedule-items');

  Future<void> create(String path, Map<String, dynamic> body) =>
      _source.post(path, data: body);
  Future<void> update(String path, Map<String, dynamic> body) =>
      _source.put(path, data: body);
  Future<void> delete(String path) => _source.delete(path);

  Future<List<Map<String, dynamic>>> _list(String path) async =>
      ((await _source.get(path)) as List).cast<Map<String, dynamic>>();
}
