import '../datasources/fastapi_data_source.dart';

class NotesRepository {
  const NotesRepository(this._source);
  final FastApiDataSource _source;

  Future<List<Map<String, dynamic>>> list() async =>
      ((await _source.get('/notes')) as List).cast<Map<String, dynamic>>();

  Future<void> add(String content) async {
    await _source.post('/notes', data: {
      'title': content.length > 60 ? content.substring(0, 60) : content,
      'content': content,
    });
  }

  Future<void> delete(String id) => _source.delete('/notes/$id');
}
