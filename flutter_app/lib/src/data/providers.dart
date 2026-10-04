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

/// Stable `YYYY-MM-DD` key for a day, safe to use as a provider family key.
String dayKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

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

/// The diary entry for a day, or null when nothing is written yet.
///
/// Keyed by the `YYYY-MM-DD` string rather than a `DateTime`: a
/// `DateTime.now()` taken on each build is a different object with a different
/// `==`, so a `.family` keyed by it would spawn a fresh provider (and a fresh
/// request) on every rebuild, looping forever. A normalised string is stable.
final entryByDateProvider =
    FutureProvider.family<DiaryEntry?, String>((ref, isoDate) async {
  try {
    final data = await ref.read(apiClientProvider).get('/entries/by-date/$isoDate');
    return DiaryEntry.fromJson(data as Map<String, dynamic>);
  } on ApiException catch (e) {
    // No entry for that day yet -> the editor starts blank.
    if (e.statusCode == 404) return null;
    rethrow;
  }
});

/// A random quote pair: one library quote + one of the user's own messages.
///
/// Errors propagate instead of being swallowed, so the UI can tell "the request
/// failed" apart from "the user has no self message yet". Returning null on any
/// failure made a network error look like an empty library.
final randomPairProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return await ref
      .read(apiClientProvider)
      .get('/random-pair') as Map<String, dynamic>;
});

/// Images of one entry, each paired with a short-lived presigned read URL.
///
/// The list endpoint never returns a URL, so each image needs a second call.
/// An image whose URL cannot be signed is skipped rather than failing the
/// whole grid: a 503 (storage not configured) must not blank the section.
final entryImagesProvider =
    FutureProvider.family<List<EntryImageView>, String>((ref, entryId) async {
  final client = ref.read(apiClientProvider);
  final data = await client.get('/entries/$entryId/images');
  final images = (data as List)
      .map((e) => EntryImage.fromJson(e as Map<String, dynamic>))
      .toList();

  final views = <EntryImageView>[];
  for (final image in images) {
    try {
      final res =
          await client.get('/images/${image.id}/url') as Map<String, dynamic>;
      final url = res['url'] as String?;
      if (url != null && url.isNotEmpty) {
        views.add(EntryImageView(image: image, url: url));
      }
    } on ApiException {
      // Storage unavailable or the object vanished -> leave it out of the grid.
    }
  }
  return views;
});

/// Health logs within a date range, newest first.
///
/// [dateFrom] and [dateTo] are inclusive `YYYY-MM-DD` strings.
final healthLogsProvider =
    FutureProvider.family<List<HealthLog>, ({String from, String to})>(
        (ref, range) async {
  final data = await ref.read(apiClientProvider).get(
        '/health-logs',
        query: {'from': range.from, 'to': range.to},
      );
  return (data as List)
      .map((e) => HealthLog.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Invalidates everything that depends on entries so screens refresh.
void refreshEntryData(WidgetRef ref) {
  ref.invalidate(moodGridProvider);
  ref.invalidate(weatherGridProvider);
  ref.invalidate(monthSummaryProvider);
  ref.invalidate(entryByDateProvider);
  ref.invalidate(randomPairProvider);
  ref.invalidate(entryImagesProvider);
}