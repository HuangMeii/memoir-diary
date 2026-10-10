import '../datasources/fastapi_data_source.dart';
import '../models.dart';

class HealthRepository {
  const HealthRepository(this._source);

  final FastApiDataSource _source;

  Future<List<HealthLog>> logs({
    required String from,
    required String to,
  }) async {
    final data = await _source.get(
      '/health-logs',
      query: {'from': from, 'to': to},
    );
    return (data as List)
        .map((item) => HealthLog.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(String date, Map<String, dynamic> payload) =>
      _source.post('/health-logs', data: {'log_date': date, ...payload});
}
