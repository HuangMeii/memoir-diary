import '../datasources/backend_data_source.dart';
import '../models.dart';

class QuoteRepository {
  const QuoteRepository(this._source);

  final BackendDataSource _source;

  Future<DailyQuotePair> today() async {
    final data = await _source.get('/daily-quotes/today');
    return DailyQuotePair.fromJson(data as Map<String, dynamic>);
  }

  Future<List<DailyQuotePair>> history(String month) async {
    final data = await _source.get('/daily-quotes', query: {'month': month});
    return (data as List)
        .map((item) => DailyQuotePair.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<SelfMessage>> selfMessages() async {
    final data = await _source.get('/self-messages');
    return (data as List)
        .map((item) => SelfMessage.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reflection>> reflections() async {
    final data = await _source.get('/reflections');
    return (data as List)
        .map((item) => Reflection.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<String> saveSelfMessage(String content, {String? id}) async {
    final data = id == null
        ? await _source.post('/self-messages', data: {'content': content})
        : await _source.put('/self-messages/$id', data: {'content': content});
    return id ?? (data as Map<String, dynamic>)['id'] as String;
  }

  Future<String> saveReflection(String thought, {String? id}) async {
    final data = id == null
        ? await _source.post('/reflections', data: {'thought': thought})
        : await _source.put('/reflections/$id', data: {'thought': thought});
    return id ?? (data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> reshuffle(String id) =>
      _source.delete('/daily-quotes/$id');
}
