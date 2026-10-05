import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../core/auth_provider.dart';
import 'models.dart';

/// Resolves once the stored token has been read (and validated, when present).
///
/// Every authenticated provider awaits this before issuing its first request.
/// Without it they race `_restore()`: the request goes out with no
/// `Authorization` header, FastAPI answers 401, and Riverpod caches that error
/// for the rest of the session because nothing ever invalidates the provider.
final authReadyProvider = FutureProvider<void>((ref) async {
  // Watching keeps this provider alive alongside the auth state, so the
  // `isLoading` flip below re-runs it after a login or logout.
  final auth = ref.watch(authProvider);
  if (auth.isLoading) return;
  return;
});

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
  await ref.watch(authReadyProvider.future);
  final data = await ref
      .read(apiClientProvider)
      .get('/stats/mood-grid', query: {'month': month});
  return (data['cells'] as List? ?? [])
      .map((e) => GridCell.fromJson(e as Map<String, dynamic>))
      .toList();
});

final weatherGridProvider =
    FutureProvider.family<List<GridCell>, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  final data = await ref
      .read(apiClientProvider)
      .get('/stats/weather-grid', query: {'month': month});
  return (data['cells'] as List? ?? [])
      .map((e) => GridCell.fromJson(e as Map<String, dynamic>))
      .toList();
});

final monthSummaryProvider =
    FutureProvider.family<MonthSummary, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
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
  await ref.watch(authReadyProvider.future);
  try {
    final data = await ref.read(apiClientProvider).get('/entries/by-date/$isoDate');
    return DiaryEntry.fromJson(data as Map<String, dynamic>);
  } on ApiException catch (e) {
    // No entry for that day yet -> the editor starts blank.
    if (e.statusCode == 404) return null;
    rethrow;
  }
});

/// The pair shown today, stored server-side so it stays the same for the day.
///
/// `/daily-quotes/today` draws a pair only when the day has no row yet; every
/// later call reads it back. That is what makes the history screen meaningful:
/// the card shown on the 3rd is the row stored on the 3rd.
final todayQuoteProvider = FutureProvider<DailyQuotePair>((ref) async {
  await ref.watch(authReadyProvider.future);
  final data = await ref
      .read(apiClientProvider)
      .get('/daily-quotes/today') as Map<String, dynamic>;
  return DailyQuotePair.fromJson(data);
});

/// Stored pairs for one month (`YYYY-MM`), newest first.
final quoteHistoryProvider =
    FutureProvider.family<List<DailyQuotePair>, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  final data = await ref
      .read(apiClientProvider)
      .get('/daily-quotes', query: {'month': month});
  return (data as List)
      .map((e) => DailyQuotePair.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Draws a fresh pair for today by dropping today's row.
///
/// The server stores exactly one pair per day, so changing the quote means
/// deleting the row and letting the next read draw again.
Future<void> reshuffleTodayQuote(WidgetRef ref) async {
  final current = ref.read(todayQuoteProvider).valueOrNull;
  if (current != null) {
    await ref.read(apiClientProvider).delete('/daily-quotes/${current.id}');
  }
  ref.invalidate(todayQuoteProvider);
  ref.invalidate(quoteHistoryProvider);
}

/// The user's own messages, newest first.
///
/// Only the count matters on the quote card (it decides whether the day pairs
/// a quote with one of these), but the id/content come along for the list view.
final selfMessagesProvider = FutureProvider<List<SelfMessage>>((ref) async {
  await ref.watch(authReadyProvider.future);
  final data = await ref.read(apiClientProvider).get('/self-messages');
  return (data as List)
      .map((e) => SelfMessage.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// The user's reflections, newest first.
final reflectionsProvider = FutureProvider<List<Reflection>>((ref) async {
  await ref.watch(authReadyProvider.future);
  final data = await ref.read(apiClientProvider).get('/reflections');
  return (data as List)
      .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// The reflection written today, or null when none is stored yet.
///
/// The list is newest first and the endpoint has no per-day filter, so the
/// first row that is not older than today is treated as "today's".
Reflection? todayReflection(List<Reflection> items) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  for (final item in items) {
    final at = item.createdAt?.toLocal();
    if (at == null) continue;
    if (!at.isBefore(today)) return item;
  }
  return null;
}

/// Saves a message to self from the quote card.
///
/// The message joins the user's library, which is what the daily pairing draws
/// from once there are enough of them. It is not attached to today's pair: that
/// pair was already stored when the card loaded, and rewriting it would change
/// the history for that day.
Future<void> saveSelfMessage(WidgetRef ref, String text) async {
  final content = text.trim();
  if (content.isEmpty) return;
  await ref
      .read(apiClientProvider)
      .post('/self-messages', data: {'content': content});
  ref.invalidate(selfMessagesProvider);
}

/// Saves a thought about the pair shown today.
///
/// `entry_id` is left out on purpose: the server fills in the pair stored for
/// today, so the reflection points at the quotes the user actually saw even
/// when they have no diary entry for that day.
Future<void> saveReflection(WidgetRef ref, String thought) async {
  final body = thought.trim();
  if (body.isEmpty) return;
  await ref
      .read(apiClientProvider)
      .post('/reflections', data: {'thought': body});
  ref.invalidate(reflectionsProvider);
}

/// Images of one entry, each paired with a short-lived presigned read URL.
///
/// The list endpoint never returns a URL, so each image needs a second call.
/// An image whose URL cannot be signed is skipped rather than failing the
/// whole grid: a 503 (storage not configured) must not blank the section.
final entryImagesProvider =
    FutureProvider.family<List<EntryImageView>, String>((ref, entryId) async {
  await ref.watch(authReadyProvider.future);
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
  await ref.watch(authReadyProvider.future);
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
  ref.invalidate(todayQuoteProvider);
  ref.invalidate(entryImagesProvider);
}