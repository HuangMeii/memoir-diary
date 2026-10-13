import '../datasources/backend_data_source.dart';
import '../models.dart';

class LookupRepository {
  const LookupRepository(this._source);

  final BackendDataSource _source;

  Future<List<LookupItem>> moods() => _list('/moods');

  Future<List<LookupItem>> weathers() => _list('/weathers');

  Future<List<LookupItem>> _list(String path) async {
    final data = await _source.get(path);
    return (data as List)
        .map((item) => LookupItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
