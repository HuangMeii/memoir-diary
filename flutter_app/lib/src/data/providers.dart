import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth_provider.dart';
import '../core/serverpod_backend.dart';
import 'datasources/backend_data_source.dart';
import 'datasources/serverpod_data_source.dart';
import 'models.dart';
import 'repositories/entry_repository.dart';
import 'repositories/health_repository.dart';
import 'repositories/image_repository.dart';
import 'repositories/lookup_repository.dart';
import 'repositories/notes_repository.dart';
import 'repositories/planner_repository.dart';
import 'repositories/quote_repository.dart';
import 'repositories/route_repository.dart';
import 'repositories/weather_repository.dart';

/// The backend the whole app talks to: the Dart Serverpod server.
///
/// Screens and repositories only know [BackendDataSource], so the transport can
/// change without touching the UI.
final backendDataSourceProvider = Provider<BackendDataSource>(
  (ref) => ServerpodDataSource(ref.watch(serverpodClientProvider)),
);

final lookupRepositoryProvider = Provider<LookupRepository>(
  (ref) => LookupRepository(ref.watch(backendDataSourceProvider)),
);

final entryRepositoryProvider = Provider<EntryRepository>(
  (ref) => EntryRepository(ref.watch(backendDataSourceProvider)),
);

final quoteRepositoryProvider = Provider<QuoteRepository>(
  (ref) => QuoteRepository(ref.watch(backendDataSourceProvider)),
);

final imageRepositoryProvider = Provider<ImageRepository>(
  (ref) => ImageRepository(ref.watch(backendDataSourceProvider)),
);

final healthRepositoryProvider = Provider<HealthRepository>(
  (ref) => HealthRepository(ref.watch(backendDataSourceProvider)),
);

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.watch(backendDataSourceProvider)),
);

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepository(ref.watch(backendDataSourceProvider)),
);

/// Resolves once the stored token has been read (and validated, when present).
///
/// Every authenticated provider awaits this before issuing its first request.
/// Without it they race `_restore()`: the request goes out with no
/// `Authorization` header, the server answers 401, and Riverpod caches that
/// error for the rest of the session because nothing invalidates the provider.
final authReadyProvider = FutureProvider<void>((ref) async {
  // Watching keeps this provider alive alongside the auth state, so the
  // `isLoading` flip below re-runs it after a login or logout.
  final auth = ref.watch(authProvider);
  if (auth.isLoading) return;
  return;
});

/// Moods and weathers are public reference data -> fetched once and cached.
final moodsProvider = FutureProvider<List<LookupItem>>(
  (ref) => ref.read(lookupRepositoryProvider).moods(),
);

final weathersProvider = FutureProvider<List<LookupItem>>(
  (ref) => ref.read(lookupRepositoryProvider).weathers(),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(ref.watch(backendDataSourceProvider)),
);

/// Live forecast plus the multi-day outlook. The server falls back to stored
/// snapshots when Open-Meteo is unreachable, so this rarely errors.
final weatherProvider = FutureProvider<WeatherForecast>((ref) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(weatherRepositoryProvider).current();
});

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
  return ref.read(entryRepositoryProvider).moodGrid(month);
});

final weatherGridProvider =
    FutureProvider.family<List<GridCell>, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(entryRepositoryProvider).weatherGrid(month);
});

final monthSummaryProvider =
    FutureProvider.family<MonthSummary, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(entryRepositoryProvider).summary(month);
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
  return ref.read(entryRepositoryProvider).byDate(isoDate);
});

/// Every entry of one month (`YYYY-MM`), keyed by day.
///
/// The home heatmap ("Nhịp viết của bạn") needs the whole month to score each
/// day by how much of it was filled in, so it reads this instead of asking the
/// server for a separate aggregate.
final monthEntriesProvider =
    FutureProvider.family<Map<String, DiaryEntry>, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  final entries = await ref.read(entryRepositoryProvider).list(month);
  return {
    for (final entry in entries) dayKey(entry.entryDate): entry,
  };
});

/// The pair shown today, stored server-side so it stays the same for the day.
///
/// `/daily-quotes/today` draws a pair only when the day has no row yet; every
/// later call reads it back. That is what makes the history screen meaningful:
/// the card shown on the 3rd is the row stored on the 3rd.
final todayQuoteProvider = FutureProvider<DailyQuotePair>((ref) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(quoteRepositoryProvider).today();
});

/// Stored pairs for one month (`YYYY-MM`), newest first.
final quoteHistoryProvider =
    FutureProvider.family<List<DailyQuotePair>, String>((ref, month) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(quoteRepositoryProvider).history(month);
});

/// Draws a fresh pair for today by dropping today's row.
///
/// The server stores exactly one pair per day, so changing the quote means
/// deleting the row and letting the next read draw again.
Future<void> reshuffleTodayQuote(WidgetRef ref) async {
  final current = ref.read(todayQuoteProvider).valueOrNull;
  if (current != null) {
    await ref.read(quoteRepositoryProvider).reshuffle(current.id);
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
  return ref.read(quoteRepositoryProvider).selfMessages();
});

/// The user's reflections, newest first.
final reflectionsProvider = FutureProvider<List<Reflection>>((ref) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(quoteRepositoryProvider).reflections();
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

/// Saves a message to self from the quote card and returns its id.
///
/// Passing [id] edits that message instead of creating a second one, which is
/// what lets the card keep the text in the box after saving: a second save
/// tweaks the same row rather than piling up near-duplicates.
Future<String> saveSelfMessage(WidgetRef ref, String text, {String? id}) async {
  final content = text.trim();
  if (content.isEmpty) return id ?? '';
  id = await ref.read(quoteRepositoryProvider).saveSelfMessage(
        content,
        id: id,
      );
  ref.invalidate(selfMessagesProvider);
  return id;
}

/// Saves a thought about the pair shown today and returns the reflection id.
///
/// `entry_id` is left out on purpose: the server fills in the pair stored for
/// today, so the reflection points at the quotes the user actually saw even
/// when they have no diary entry for that day. Passing [id] edits the existing
/// reflection instead of adding another.
Future<String> saveReflection(WidgetRef ref, String thought,
    {String? id}) async {
  final body = thought.trim();
  if (body.isEmpty) return id ?? '';
  id = await ref.read(quoteRepositoryProvider).saveReflection(
        body,
        id: id,
      );
  ref.invalidate(reflectionsProvider);
  return id;
}

/// Images of one entry, each paired with a short-lived presigned read URL.
///
/// The list endpoint never returns a URL, so each image needs a second call.
/// An image whose URL cannot be signed is skipped rather than failing the
/// whole grid: a 503 (storage not configured) must not blank the section.
final entryImagesProvider =
    FutureProvider.family<List<EntryImageView>, String>((ref, entryId) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(imageRepositoryProvider).forEntry(entryId);
});

/// Health logs within a date range, newest first.
///
/// [dateFrom] and [dateTo] are inclusive `YYYY-MM-DD` strings.
final healthLogsProvider =
    FutureProvider.family<List<HealthLog>, ({String from, String to})>(
          (ref, range) async {
    await ref.watch(authReadyProvider.future);
    return ref.read(healthRepositoryProvider).logs(
          from: range.from,
          to: range.to,
        );
});

/// Invalidates everything that depends on entries so screens refresh.
void refreshEntryData(WidgetRef ref) {
  ref.invalidate(moodGridProvider);
  ref.invalidate(weatherGridProvider);
  ref.invalidate(monthSummaryProvider);
  ref.invalidate(entryByDateProvider);
  ref.invalidate(monthEntriesProvider);
  ref.invalidate(todayQuoteProvider);
  ref.invalidate(entryImagesProvider);
}

/// Everything the route weather depends on, as one value, so Riverpod can cache
/// by value: change one field and the route is planned again.
class RouteQuery {
  const RouteQuery({
    required this.stops,
    required this.vehicle,
    required this.departureAt,
    this.alternatives = true,
  });

  final List<RouteStop> stops;
  final String vehicle;
  final DateTime departureAt;
  final bool alternatives;

  bool get isValid => stops.length >= 2;

  @override
  bool operator ==(Object other) =>
      other is RouteQuery &&
      other.vehicle == vehicle &&
      other.departureAt == departureAt &&
      other.alternatives == alternatives &&
      _sameStops(other.stops, stops);

  @override
  int get hashCode =>
      Object.hash(vehicle, departureAt, alternatives, Object.hashAll(stops));
}

bool _sameStops(List<RouteStop> a, List<RouteStop> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

final routeRepositoryProvider = Provider<RouteRepository>(
  (ref) => RouteRepository(ref.watch(backendDataSourceProvider)),
);

/// The route and the weather along it, cached per [RouteQuery].
///
/// One call, because the screen always wants both and a second round trip would
/// only make the loading state longer.
final routePlanProvider =
    FutureProvider.family<RoutePlanWithWeather, RouteQuery>((ref, query) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(routeRepositoryProvider).planWithWeather(
        stops: query.stops,
        vehicle: query.vehicle,
        departureAt: query.departureAt,
        alternatives: query.alternatives,
      );
});

/// Departure times around the picked one, each with its own forecast. Reuses the
/// cached plan instead of asking for it again.
final routeDeparturesProvider =
    FutureProvider.family<List<RouteDepartureOption>, RouteQuery>(
        (ref, query) async {
  final planned = await ref.watch(routePlanProvider(query).future);
  return ref.read(routeRepositoryProvider).compareDepartures(
        plan: planned.plan,
        departureAt: query.departureAt,
      );
});

/// Places matching a search term, for the planner's suggestion list.
final placeSearchProvider =
    FutureProvider.family<List<PlaceCandidate>, String>((ref, query) async {
  if (query.trim().length < 2) return const [];
  return ref.read(routeRepositoryProvider).searchPlaces(query);
});

/// The user's saved trips, newest departure first.
final journeysProvider = FutureProvider<List<Journey>>((ref) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(routeRepositoryProvider).journeys();
});

/// One saved trip with its stops and its saved weather snapshot.
final journeyDetailProvider =
    FutureProvider.family<JourneyDetail, String>((ref, id) async {
  await ref.watch(authReadyProvider.future);
  return ref.read(routeRepositoryProvider).journey(id);
});

