import '../datasources/backend_data_source.dart';
import '../models.dart';

/// Route planning, the weather along a route, and saved trips.
///
/// The backend owns OSRM, the geocoder and Open-Meteo, plus the sampling and
/// adverse-weather rules, so this only shapes the requests and reads the
/// answers back into models. See docs/12-route-weather.md.
class RouteRepository {
  const RouteRepository(this._source);

  final BackendDataSource _source;

  /// Places matching [query], for the search box.
  Future<List<PlaceCandidate>> searchPlaces(
    String query, {
    int limit = 8,
  }) async {
    final data = await _source.post(
      '/route/search-places',
      data: {'query': query, 'limit': limit},
    );
    return ((data as List?) ?? const [])
        .map((e) => PlaceCandidate.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// The route through [stops], in order, for [vehicle].
  Future<RoutePlan> plan({
    required List<RouteStop> stops,
    required String vehicle,
    bool alternatives = true,
  }) async {
    final data = await _source.post(
      '/route/plan',
      data: _planRequest(stops, vehicle, alternatives),
    );
    return RoutePlan.fromJson((data as Map).cast<String, dynamic>());
  }

  /// The route and the weather along it in one round trip.
  Future<RoutePlanWithWeather> planWithWeather({
    required List<RouteStop> stops,
    required String vehicle,
    required DateTime departureAt,
    bool alternatives = true,
  }) async {
    final data = await _source.post(
      '/route/plan-with-weather',
      data: {
        ..._planRequest(stops, vehicle, alternatives),
        'departure_at': departureAt.toUtc().toIso8601String(),
      },
    );
    return RoutePlanWithWeather.fromJson((data as Map).cast<String, dynamic>());
  }

  /// Re-reads the weather for a route already planned, e.g. when the user comes
  /// back to a saved trip and asks for the latest forecast.
  Future<RouteWeatherReport> forecast({
    required RoutePlan plan,
    required DateTime departureAt,
  }) async {
    final data = await _source.post('/route/forecast', data: {
      'plan': _planBody(plan),
      'departure_at': departureAt.toUtc().toIso8601String(),
    });
    return RouteWeatherReport.fromJson((data as Map).cast<String, dynamic>());
  }

  /// Departure times around [departureAt], each with its own forecast.
  Future<List<RouteDepartureOption>> compareDepartures({
    required RoutePlan plan,
    required DateTime departureAt,
    List<int>? offsetsHours,
  }) async {
    final data = await _source.post('/route/departures', data: {
      'plan': _planBody(plan),
      'departure_at': departureAt.toUtc().toIso8601String(),
      if (offsetsHours != null) 'offsets_hours': offsetsHours,
    });
    return ((data as List?) ?? const [])
        .map((e) =>
            RouteDepartureOption.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// The user's saved trips, newest departure first.
  Future<List<Journey>> journeys() async {
    final data = await _source.get('/journeys');
    return ((data as List?) ?? const [])
        .map((e) => Journey.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// One saved trip with its stops and its weather snapshot.
  Future<JourneyDetail> journey(String id) async {
    final data = await _source.get('/journeys/$id');
    return JourneyDetail.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<void> deleteJourney(String id) => _source.delete('/journeys/$id');

  /// Stores a trip, its stops and its weather snapshot.
  ///
  /// [entryId] links an existing diary entry; [createEntry] instead writes the
  /// departure day's entry with [entryText] and links that. Photos are uploaded
  /// against the linked entry through the existing image endpoints.
  Future<JourneyDetail> saveJourney({
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required List<RouteStop> stops,
    required RoutePlan plan,
    required List<RouteWeatherSample> weatherSamples,
    String? notes,
    String? entryId,
    bool createEntry = false,
    String? entryText,
    int? weatherId,
  }) async {
    final data = await _source.post('/journeys', data: {
      'title': title,
      'vehicle': vehicle,
      'departure_at': departureAt.toUtc().toIso8601String(),
      'stops': _ordered(stops).map((stop) => stop.toJson()).toList(),
      'distance_meters': plan.distanceMeters,
      'duration_seconds': plan.durationSeconds,
      'geometry': plan.geometry,
      'notes': notes,
      'entry_id': entryId,
      'weather_samples': [
        for (final sample in weatherSamples) _sampleBody(sample),
      ],
      'create_entry': createEntry,
      'entry_text': entryText,
      'weather_id': weatherId,
    });
    return JourneyDetail.fromJson((data as Map).cast<String, dynamic>());
  }

  Map<String, dynamic> _planRequest(
    List<RouteStop> stops,
    String vehicle,
    bool alternatives,
  ) {
    final ordered = _ordered(stops);
    return {
      'origin': ordered.first.toJson(),
      'destination': ordered.last.toJson(),
      'waypoints': [
        for (final stop in ordered.sublist(1, ordered.length - 1))
          stop.toJson(),
      ],
      'vehicle': vehicle,
      'alternatives': alternatives,
    };
  }

  /// The plan shape the server accepts back.
  Map<String, dynamic> _planBody(RoutePlan plan) => {
        'stops': [for (final stop in plan.stops) stop.toJson()],
        'distance_meters': plan.distanceMeters,
        'duration_seconds': plan.durationSeconds,
        'geometry': plan.geometry,
        'legs': [
          for (final leg in plan.legs)
            {
              'distance_meters': leg.distanceMeters,
              'duration_seconds': leg.durationSeconds,
              'to_index': leg.toIndex,
            },
        ],
        'alternatives': [
          for (final alternative in plan.alternatives)
            {
              'distance_meters': alternative.distanceMeters,
              'duration_seconds': alternative.durationSeconds,
              'geometry': alternative.geometry,
            },
        ],
        'source': plan.source,
        'vehicle': plan.vehicle,
      };

  Map<String, dynamic> _sampleBody(RouteWeatherSample sample) => {
        'seq': sample.seq,
        'label': sample.label,
        'kind': sample.kind,
        'lat': sample.lat,
        'lon': sample.lon,
        'distance_from_start_meters': sample.distanceFromStartMeters,
        'arrival_at': sample.arrivalAt.toUtc().toIso8601String(),
        'weather_code': sample.weatherCode,
        'weather_group': sample.weatherGroup,
        'condition': sample.condition,
        'icon': sample.icon,
        'temp_c': sample.tempC,
        'precipitation_mm': sample.precipitationMm,
        'precipitation_probability': sample.precipitationProbability,
        'wind_speed_kmh': sample.windSpeedKmh,
        'severity': sample.severity,
        'reasons': sample.reasons,
        'status': sample.status,
      };
}

/// The stops in travel order, with `kind` matching each position.
///
/// The server normalizes this too, but doing it here keeps the request honest
/// and the alternatives list consistent.
List<RouteStop> _ordered(List<RouteStop> stops) => [
      for (var i = 0; i < stops.length; i++)
        stops[i].copyWith(
          kind: i == 0
              ? 'origin'
              : i == stops.length - 1
                  ? 'destination'
                  : 'waypoint',
        ),
    ];

