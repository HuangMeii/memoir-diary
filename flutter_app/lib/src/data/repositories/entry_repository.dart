import '../../core/api_exception.dart';
import '../datasources/backend_data_source.dart';
import '../models.dart';

class EntryRepository {
  const EntryRepository(this._source);

  final BackendDataSource _source;

  Future<DiaryEntry?> byDate(String isoDate) async {
    try {
      final data = await _source.get('/entries/by-date/$isoDate');
      return DiaryEntry.fromJson(data as Map<String, dynamic>);
    } on ApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }

  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      (await _source.post('/entries', data: body) as Map).cast<String, dynamic>();

  Future<void> update(String id, Map<String, dynamic> body) =>
      _source.put('/entries/$id', data: body);

  /// Saves the entry for [isoDate], recovering when another request creates
  /// the same day between the lookup and the create.
  Future<DiaryEntry> saveForDate(
    String isoDate,
    Map<String, dynamic> body,
  ) async {
    var existing = await byDate(isoDate);
    if (existing != null) {
      final data = await _source.put('/entries/${existing.id}', data: body);
      return DiaryEntry.fromJson((data as Map).cast<String, dynamic>());
    }

    try {
      final data = await create({'entry_date': isoDate, ...body});
      return DiaryEntry.fromJson(data);
    } on ApiException catch (error) {
      if (!error.isConflict) rethrow;
      existing = await byDate(isoDate);
      if (existing == null) rethrow;
      final data = await _source.put('/entries/${existing.id}', data: body);
      return DiaryEntry.fromJson((data as Map).cast<String, dynamic>());
    }
  }

  /// Every entry of one month (`YYYY-MM`), newest first.
  ///
  /// The server already exposes `entries.list(month:)`, so this needs no
  /// backend change; the home heatmap uses it to score each day.
  Future<List<DiaryEntry>> list(String month) async {
    final data = await _source.get('/entries', query: {'month': month});
    return (data as List)
        .map((item) => DiaryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Entries whose day falls inside `[from]..[to]`, newest first.
  ///
  /// The calendar paints a window that can straddle two months, so it asks for
  /// a date range instead of one `YYYY-MM` bucket per month.
  Future<List<DiaryEntry>> listBetween(DateTime from, DateTime to) async {
    final data = await _source.get('/entries', query: {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    });
    return (data as List)
        .map((item) => DiaryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<GridCell>> moodGrid(String month) =>
      _grid('/stats/mood-grid', month);

  Future<List<GridCell>> weatherGrid(String month) =>
      _grid('/stats/weather-grid', month);

  Future<MonthSummary> summary(String month) async {
    final data = await _source.get('/stats/summary', query: {'month': month});
    return MonthSummary.fromJson(data as Map<String, dynamic>);
  }

  Future<List<GridCell>> _grid(String path, String month) async {
    final data = await _source.get(path, query: {'month': month});
    return (data['cells'] as List? ?? [])
        .map((item) => GridCell.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
