import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';
import 'route_rules.dart';
import 'route_service.dart' as routing;

/// Saved trips and their weather snapshot (docs/12-route-weather.md §8, §9).
///
/// A journey is written only when the user asks for it, and it keeps the
/// forecast it was planned with: reopening a trip shows that snapshot next to a
/// separately fetched, fresher forecast instead of mixing the two.
class JourneysEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The user's trips, newest departure first.
  Future<List<Journey>> list(Session session) => Journey.db.find(
        session,
        where: (t) => t.userId.equals(currentUserId(session)),
        orderBy: (t) => t.departureAt.desc(),
      );

  /// One trip with its stops and its saved weather snapshot.
  Future<JourneyDetail> detail(Session session, UuidValue id) async {
    final journey = await _owned(session, id);
    return JourneyDetail(
      journey: journey,
      stops: await JourneyStop.db.find(
        session,
        where: (t) => t.journeyId.equals(id),
        orderBy: (t) => t.seq,
      ),
      weatherPoints: await JourneyWeatherPoint.db.find(
        session,
        where: (t) => t.journeyId.equals(id),
        orderBy: (t) => t.seq,
      ),
    );
  }

  /// Stores a trip, its stops and its weather snapshot.
  ///
  /// [entryId] links an existing diary entry. [createEntry] instead writes the
  /// departure day's entry — or updates it, since there is one row per day —
  /// with [entryText], and links that. Passing neither saves the trip alone.
  Future<JourneyDetail> save(
    Session session, {
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required List<RouteStop> stops,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    UuidValue? entryId,
    List<RouteWeatherSample>? weatherSamples,
    bool? createEntry,
    String? entryText,
    int? weatherId,
  }) async {
    final userId = currentUserId(session);
    final ordered = routing.normalizeStops(stops);
    if (ordered.length < 2) {
      throw ApiException(
        message: 'Hành trình cần ít nhất điểm đi và điểm đến',
        code: 'validation',
      );
    }

    var linkedEntryId = entryId;
    if (createEntry ?? false) {
      linkedEntryId = await _upsertEntry(
        session,
        userId: userId,
        departureAt: departureAt,
        text: entryText,
        weatherId: weatherId,
      );
    }

    final samples = weatherSamples ?? const <RouteWeatherSample>[];
    final journey = await Journey.db.insertRow(
      session,
      Journey(
        userId: userId,
        title: title.trim().isEmpty ? 'Hành trình' : title.trim(),
        vehicle: vehicle,
        departureAt: departureAt.toUtc(),
        originName: ordered.first.name,
        originLat: ordered.first.lat,
        originLon: ordered.first.lon,
        destinationName: ordered.last.name,
        destinationLat: ordered.last.lat,
        destinationLon: ordered.last.lon,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
        geometry: geometry,
        notes: notes,
        entryId: linkedEntryId,
        weatherSavedAt: samples.isEmpty ? null : DateTime.now().toUtc(),
      ),
    );

    final journeyId = journey.id!;
    // The stops appear in the sample list in the same order, so they line up.
    final stopSamples = samples.where((s) => s.kind != 'sample').toList();
    final stopRows = <JourneyStop>[];
    for (var i = 0; i < ordered.length; i++) {
      final sample = i < stopSamples.length ? stopSamples[i] : null;
      stopRows.add(await JourneyStop.db.insertRow(
        session,
        JourneyStop(
          journeyId: journeyId,
          seq: i,
          kind: ordered[i].kind,
          name: ordered[i].name,
          lat: ordered[i].lat,
          lon: ordered[i].lon,
          dwellMinutes: ordered[i].dwellMinutes,
          arrivalAt: sample?.arrivalAt,
          distanceFromStartMeters: sample?.distanceFromStartMeters,
        ),
      ));
    }

    final weatherRows = <JourneyWeatherPoint>[];
    if (samples.isNotEmpty) {
      // Same WMO -> `weathers` mapping the forecast grid uses, so a saved trip
      // can still be coloured by the month grids later on.
      final weatherIds = {
        for (final weather in await Weather.db.find(session))
          weather.code: weather.id!,
      };
      for (final sample in samples) {
        final code = sample.weatherCode;
        weatherRows.add(await JourneyWeatherPoint.db.insertRow(
          session,
          JourneyWeatherPoint(
            journeyId: journeyId,
            seq: sample.seq,
            sampleAt: sample.arrivalAt.toUtc(),
            lat: sample.lat,
            lon: sample.lon,
            label: sample.label,
            weatherCode: code,
            weatherGroup: code == null ? null : wmoGroupForCode(code),
            weatherId: code == null ? null : weatherIds[wmoGroupForCode(code)],
            tempC: sample.tempC,
            precipitationMm: sample.precipitationMm,
            precipitationProbability: sample.precipitationProbability,
            windSpeedKmh: sample.windSpeedKmh,
            severity: sample.severity,
          ),
        ));
      }
    }

    return JourneyDetail(
      journey: journey,
      stops: stopRows,
      weatherPoints: weatherRows,
    );
  }

  Future<void> delete(Session session, UuidValue id) async {
    final journey = await _owned(session, id);
    // Stops and weather points are removed by the foreign key cascade.
    await Journey.db.deleteRow(session, journey);
  }

  /// Writes the departure day's diary entry, or updates the one already there.
  Future<UuidValue?> _upsertEntry(
    Session session, {
    required UuidValue userId,
    required DateTime departureAt,
    String? text,
    int? weatherId,
  }) async {
    final day = dateOnly(departureAt);
    final existing = await DiaryEntry.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.entryDate.equals(day),
    );
    if (existing != null) {
      if (text != null && text.trim().isNotEmpty) existing.diaryText = text;
      if (weatherId != null) existing.weatherId = weatherId;
      existing.updatedAt = DateTime.now().toUtc();
      return (await DiaryEntry.db.updateRow(session, existing)).id;
    }
    final created = await DiaryEntry.db.insertRow(
      session,
      DiaryEntry(
        userId: userId,
        entryDate: day,
        weatherId: weatherId,
        diaryText: text,
      ),
    );
    return created.id;
  }

  Future<Journey> _owned(Session session, UuidValue id) async {
    final journey = await Journey.db.findById(session, id);
    ensureOwned(journey != null && journey.userId == currentUserId(session));
    return journey!;
  }
}

