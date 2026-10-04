import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import 'models.dart';

/// Moods and weathers are public reference data -> fetched once and cached.
final moodsProvider = FutureProvider<List<LookupItem>>(
  (ref) async {
    final data = await ref.read(apiClientProvider).get('/moods');
    return (data as List)
        .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
        .toList();
  },
);

final weathersProvider = FutureProvider<List<LookupItem>>(
  (ref) async {
    final data = await ref.read(apiClientProvider).get('/weathers');
    return (data as List)
        .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
        .toList();
  },
);

/// The month currently being browsed, as the first day of that month.
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

String monthKey(DateTime month) =>
    '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

final moodGridProvider =
    FutureProvider.family<List<GridCell>, String>((ref, month) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/stats/mood-grid', query: {'month': month});
  return (data['cells'] as List? ?? [])
      .map((e) => GridCell.fromJson(e as Map<String, dynamic>))
      .toList();
});

final weatherGridProvider =
    FutureProvider.family<List<GridCell>, String>((ref, month) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/stats/weather-grid', query: {'month': month});
  return (data['cells'] as List? ?? [])
      .map((e) => GridCell.fromJson(e as Map<String, dynamic>))
      .toList();
});

final monthSummaryProvider =
    FutureProvider.family<MonthSummary, String>((ref, month) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/stats/summary', query: {'month': month});
  return MonthSummary.fromJson(data as Map<String, dynamic>);
});

final entryByDateProvider =
    FutureProvider.family<DiaryEntry?, DateTime>((ref, date) async {
  final iso = date.toIso8601String().substring(0, 10);
  try {
    final data = await ref.read(apiClientProvider).get('/entries/by-date/$iso');
    return DiaryEntry.fromJson(data as Map<String, dynamic>);
  } on ApiException catch (e) {
    // No entry for that day yet -> the editor starts blank.
    if (e.statusCode == 404) return null;
    rethrow;
  }
});

/// A random quote pair: one library quote + one of the user's own messages.
final randomPairProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    return await ref.read(apiClientProvider).get('/random-pair')
        as Map<String, dynamic>;
  } on ApiException {
    return null;
  }
});

/// Invalidates everything that depends on entries so screens refresh.
void refreshEntryData(WidgetRef ref) {
  ref.invalidate(moodGridProvider);
  ref.invalidate(weatherGridProvider);
  ref.invalidate(monthSummaryProvider);
  ref.invalidate(entryByDateProvider);
  ref.invalidate(randomPairProvider);
}