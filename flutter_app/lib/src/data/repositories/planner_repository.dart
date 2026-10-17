import '../datasources/backend_data_source.dart';

class PlannerRepository {
  const PlannerRepository(this._source);
  final BackendDataSource _source;

  Future<List<Map<String, dynamic>>> todos() => _list('/todos');
  Future<List<Map<String, dynamic>>> events() => _list('/events');
  Future<List<Map<String, dynamic>>> schedules() => _list('/schedule-items');

  /// Events starting within [from]..[to] (inclusive), for the calendar's month
  /// grid and its upcoming list.
  Future<List<Map<String, dynamic>>> eventsBetween(
    DateTime from,
    DateTime to,
  ) =>
      _list('/events', query: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      });

  /// Schedule items starting within [from]..[to] (inclusive).
  ///
  /// The calendar paints one window at a time, so it asks the server for that
  /// window instead of pulling every timetable row the user ever created.
  Future<List<Map<String, dynamic>>> schedulesBetween(
    DateTime from,
    DateTime to,
  ) =>
      _list('/schedule-items', query: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      });

  Future<void> create(String path, Map<String, dynamic> body) =>
      _source.post(path, data: body);
  Future<void> update(String path, Map<String, dynamic> body) =>
      _source.put(path, data: body);
  Future<void> delete(String path) => _source.delete(path);

  Future<List<Map<String, dynamic>>> _list(
    String path, {
    Map<String, dynamic>? query,
  }) async =>
      ((await _source.get(path, query: query)) as List)
          .cast<Map<String, dynamic>>();
}
