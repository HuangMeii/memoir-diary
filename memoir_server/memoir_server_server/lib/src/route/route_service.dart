/// Routing, sampling and route weather.
///
/// Everything here is a plain Dart function or a small client: no endpoint
/// state, so the geometry maths, the sample selection, the ETA calculation and
/// the rule evaluation can all be unit tested without a network or a database.
/// See docs/12-route-weather.md.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../generated/protocol.dart';
import 'route_rules.dart';

/// A failure the endpoint turns into a stable [ApiException] code.
class RouteFailure implements Exception {
  RouteFailure(this.code, this.message);

  /// noRoute | rateLimited | unavailable
  final String code;
  final String message;

  @override
  String toString() => 'RouteFailure($code): $message';
}

/// Routing backends, mirroring docs/12-route-weather.md §12. Public OSRM
/// instances need no API key; swapping in a self-hosted one is a one-line change
/// here and nothing else in the app has to move.
const Map<String, String> routeBackends = {
  'car': 'https://routing.openstreetmap.de/routed-car/route/v1/driving',
  'bike': 'https://routing.openstreetmap.de/routed-bike/route/v1/driving',
  'foot': 'https://routing.openstreetmap.de/routed-foot/route/v1/driving',
};

const String routeGeocodingUrl =
    'https://geocoding-api.open-meteo.com/v1/search';
const String routeForecastUrl = 'https://api.open-meteo.com/v1/forecast';

/// Only the routing backends are OSRM; the weather still comes from Open-Meteo.
const String routePlanSource = 'osrm';

const Duration routeTimeout = Duration(seconds: 5);
const Duration routeCacheTtl = Duration(minutes: 30);

/// Sampling rules of docs/12-route-weather.md §5.1.
const double routeSampleStepKm = 25;
const int routeMaxSamples = 25;

/// The provider forecasts up to 16 days ahead.
const int routeForecastMaxDays = 16;

/// GMT keeps the hourly timestamps comparable with a UTC [DateTime] without a
/// timezone database on the server. Display always uses the real `arrivalAt`,
/// so nothing user-visible depends on this choice.
const String routeForecastTimezone = 'GMT';

const String _hourlyVariables = 'temperature_2m,precipitation,'
    'precipitation_probability,weather_code,wind_speed_10m,'
    'wind_gusts_10m,visibility';

/// A latitude/longitude pair.
class RouteCoord {
  const RouteCoord(this.lat, this.lon);

  final double lat;
  final double lon;
}

const double _earthRadiusMeters = 6371008.8;

double _radians(double degrees) => degrees * math.pi / 180;

/// Great-circle distance in meters.
double haversineMeters(RouteCoord a, RouteCoord b) {
  final dLat = _radians(b.lat - a.lat);
  final dLon = _radians(b.lon - a.lon);
  final lat1 = _radians(a.lat);
  final lat2 = _radians(b.lat);
  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  return 2 * _earthRadiusMeters * math.asin(math.min(1, math.sqrt(h)));
}

/// Reads the `coordinates` of a GeoJSON LineString.
List<RouteCoord> decodeLineString(String geoJson) {
  final dynamic decoded = jsonDecode(geoJson);
  if (decoded is! Map) return const [];
  final coordinates = decoded['coordinates'];
  if (coordinates is! List) return const [];
  final line = <RouteCoord>[];
  for (final point in coordinates) {
    if (point is! List || point.length < 2) continue;
    final lon = (point[0] as num).toDouble();
    final lat = (point[1] as num).toDouble();
    line.add(RouteCoord(lat, lon));
  }
  return line;
}

/// Distance from the start of [line] to each vertex, in meters.
List<double> cumulativeMeters(List<RouteCoord> line) {
  final result = List<double>.filled(line.length, 0);
  for (var i = 1; i < line.length; i++) {
    result[i] = result[i - 1] + haversineMeters(line[i - 1], line[i]);
  }
  return result;
}

/// The point [targetMeters] along [line], interpolated between the two nearest
/// vertices so a marker sits on the drawn road instead of on a corner.
RouteCoord pointAtDistance(
  List<RouteCoord> line,
  List<double> cumulative,
  double targetMeters,
) {
  if (line.length < 2) {
    throw RouteFailure('noRoute', 'Tuyến đường không có đủ điểm để lấy mẫu');
  }
  if (targetMeters <= 0) return line.first;
  if (targetMeters >= cumulative.last) return line.last;

  var low = 0;
  var high = cumulative.length - 1;
  while (low + 1 < high) {
    final mid = (low + high) ~/ 2;
    if (cumulative[mid] <= targetMeters) {
      low = mid;
    } else {
      high = mid;
    }
  }
  final span = cumulative[high] - cumulative[low];
  if (span <= 0) return line[low];
  final t = (targetMeters - cumulative[low]) / span;
  final a = line[low];
  final b = line[high];
  return RouteCoord(a.lat + (b.lat - a.lat) * t, a.lon + (b.lon - a.lon) * t);
}

/// Cumulative distance of the vertex closest to [target], scanning from [from]
/// so consecutive stops are never matched out of order.
(int, double) nearestVertexDistance(
  List<RouteCoord> line,
  List<double> cumulative,
  RouteCoord target,
  int from,
) {
  var bestIndex = from < 0 ? 0 : from;
  var best = double.infinity;
  for (var i = bestIndex; i < line.length; i++) {
    final distance = haversineMeters(line[i], target);
    if (distance < best) {
      best = distance;
      bestIndex = i;
    }
  }
  return (bestIndex, cumulative[bestIndex]);
}

/// One point the forecast is asked about: a stop, or a point in between.
class RouteSamplePoint {
  const RouteSamplePoint({
    required this.distanceMeters,
    required this.coord,
    required this.kind,
    required this.label,
    this.stopIndex,
  });

  final double distanceMeters;
  final RouteCoord coord;

  /// origin | waypoint | destination | sample
  final String kind;
  final String label;

  /// Index into the stop list when this point *is* a stop.
  final int? stopIndex;
}

/// The geometry, the stop anchors and the sample points of one route.
class RouteSamplePlan {
  const RouteSamplePlan({
    required this.line,
    required this.cumulative,
    required this.stopDistances,
    required this.points,
  });

  final List<RouteCoord> line;
  final List<double> cumulative;

  /// Distance from the start to each stop, in travel order.
  final List<double> stopDistances;

  /// Ascending by distance.
  final List<RouteSamplePoint> points;
}

int _interiorCount(double span, double stepMeters) =>
    span <= 1 ? 0 : ((span - 1) / stepMeters).floor();

int _sampleCount(List<double> stopDistances, double stepMeters) {
  var count = 0;
  for (var i = 0; i < stopDistances.length; i++) {
    count++;
    if (i == stopDistances.length - 1) break;
    count += _interiorCount(stopDistances[i + 1] - stopDistances[i], stepMeters);
  }
  return count;
}

/// Grows the step until the sample count fits [maxSamples]. Stops are never
/// dropped: only the points between them get sparser.
double _resolveStep(List<double> stopDistances, double stepMeters, int maxSamples) {
  var step = stepMeters <= 0 ? 1000.0 : stepMeters;
  for (var guard = 0; guard < 24; guard++) {
    if (_sampleCount(stopDistances, step) <= maxSamples) return step;
    step *= 1.5;
  }
  return step;
}

/// The points to forecast at: every stop, plus a point every `stepKm` between
/// two stops (docs/12-route-weather.md §5.1).
RouteSamplePlan planRouteSamples({
  required List<RouteCoord> line,
  required List<RouteStop> stops,
  double stepKm = routeSampleStepKm,
  int maxSamples = routeMaxSamples,
}) {
  if (line.length < 2 || stops.length < 2) {
    throw RouteFailure('noRoute', 'Không đủ dữ liệu để lấy mẫu dọc tuyến');
  }
  final cumulative = cumulativeMeters(line);

  final stopDistances = <double>[];
  var previousIndex = 0;
  for (var i = 0; i < stops.length; i++) {
    if (i == 0) {
      // The route starts where the traveller leaves.
      stopDistances.add(0);
      continue;
    }
    if (i == stops.length - 1) {
      stopDistances.add(cumulative.last);
      continue;
    }
    final (index, distance) = nearestVertexDistance(
      line,
      cumulative,
      RouteCoord(stops[i].lat, stops[i].lon),
      previousIndex,
    );
    previousIndex = index;
    stopDistances.add(distance);
  }
  // Keep the anchors monotonic so no leg can end up with a negative length.
  for (var i = 1; i < stopDistances.length; i++) {
    if (stopDistances[i] < stopDistances[i - 1]) {
      stopDistances[i] = stopDistances[i - 1];
    }
  }

  final stepMeters = _resolveStep(stopDistances, stepKm * 1000, maxSamples);
  final points = <RouteSamplePoint>[];
  for (var i = 0; i < stops.length; i++) {
    points.add(RouteSamplePoint(
      distanceMeters: stopDistances[i],
      coord: RouteCoord(stops[i].lat, stops[i].lon),
      kind: stops[i].kind,
      label: stops[i].name,
      stopIndex: i,
    ));
    if (i == stops.length - 1) continue;
    final from = stopDistances[i];
    final to = stopDistances[i + 1];
    final interior = _interiorCount(to - from, stepMeters);
    for (var k = 1; k <= interior; k++) {
      final distance = from + k * stepMeters;
      points.add(RouteSamplePoint(
        distanceMeters: distance,
        coord: pointAtDistance(line, cumulative, distance),
        kind: 'sample',
        label: 'Km ${(distance / 1000).round()}',
      ));
    }
  }

  points.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

  // A sample must never sit on top of a stop; a stop always wins.
  final kept = <RouteSamplePoint>[];
  for (final point in points) {
    if (kept.isNotEmpty &&
        (point.distanceMeters - kept.last.distanceMeters).abs() < 100 &&
        (point.stopIndex == null || kept.last.stopIndex == null)) {
      if (point.stopIndex != null) kept[kept.length - 1] = point;
      continue;
    }
    kept.add(point);
  }

  return RouteSamplePlan(
    line: line,
    cumulative: cumulative,
    stopDistances: stopDistances,
    points: kept,
  );
}

/// Leg durations in seconds, one per consecutive stop pair.
///
/// Uses the values the routing engine returned. If the engine sent a different
/// number of legs (or none at all), the plan's total duration is split across
/// the legs in proportion to their length so the timeline still adds up.
List<int> legDurations({
  required List<double> stopDistances,
  required List<RouteLeg> legs,
  required int totalDurationSeconds,
}) {
  final legCount = stopDistances.length - 1;
  if (legCount <= 0) return const [];
  if (legs.length == legCount) {
    return legs.map((leg) => leg.durationSeconds).toList();
  }

  final spans = <double>[];
  var total = 0.0;
  for (var i = 0; i < legCount; i++) {
    final span = math.max(0.0, stopDistances[i + 1] - stopDistances[i]);
    spans.add(span);
    total += span;
  }
  if (total <= 0) {
    final even = legCount == 0 ? 0 : totalDurationSeconds ~/ legCount;
    return List<int>.filled(legCount, even);
  }
  return spans
      .map((span) => (totalDurationSeconds * span / total).round())
      .toList();
}

/// Arrival time at each sample point, from the leg durations and the time spent
/// at each stop (docs/12-route-weather.md §5.3).
///
/// `dwellMinutes` counts at the waypoints only: the departure time already
/// describes leaving the origin, and nothing happens after the destination.
List<DateTime> arrivalTimes({
  required List<RouteSamplePoint> points,
  required List<double> stopDistances,
  required List<RouteStop> stops,
  required List<RouteLeg> legs,
  required int totalDurationSeconds,
  required DateTime departureAt,
}) {
  final durations = legDurations(
    stopDistances: stopDistances,
    legs: legs,
    totalDurationSeconds: totalDurationSeconds,
  );

  // Time the traveller is at stop j, before moving on.
  final stopTimes = <DateTime>[];
  var elapsed = Duration.zero;
  for (var j = 0; j < stops.length; j++) {
    stopTimes.add(departureAt.add(elapsed));
    if (j == stops.length - 1) break;
    elapsed += Duration(seconds: durations[j]);
    if (stops[j].kind == 'waypoint') {
      elapsed += Duration(minutes: stops[j].dwellMinutes);
    }
  }

  final result = <DateTime>[];
  for (final point in points) {
    final stopIndex = point.stopIndex;
    if (stopIndex != null) {
      result.add(stopTimes[stopIndex]);
      continue;
    }
    // Between two stops: a fraction of that leg's duration.
    var leg = 0;
    while (leg < stopDistances.length - 2 &&
        point.distanceMeters > stopDistances[leg + 1]) {
      leg++;
    }
    final span = stopDistances[leg + 1] - stopDistances[leg];
    final fraction = span <= 0
        ? 0.0
        : ((point.distanceMeters - stopDistances[leg]) / span).clamp(0.0, 1.0);
    final seconds = (durations[leg] * fraction).round();
    result.add(stopTimes[leg].add(Duration(seconds: seconds)));
  }
  return result;
}

/// The hourly index to read for [at], or null when [at] is past the horizon.
///
/// [times] are the (UTC) hour starts the provider returned; the index is the
/// last hour that has already begun, which is what a forecast "at" that time
/// means (docs/12-route-weather.md §5.4).
int? hourIndexFor(List<DateTime> times, DateTime at) {
  if (times.isEmpty) return null;
  if (at.isBefore(times.first)) return 0;
  if (at.isAfter(times.last)) return null;

  var low = 0;
  var high = times.length - 1;
  while (low < high) {
    final mid = (low + high + 1) ~/ 2;
    if (!times[mid].isAfter(at)) {
      low = mid;
    } else {
      high = mid - 1;
    }
  }
  return low;
}

/// Past this moment the provider has no data at all.
DateTime routeForecastHorizon() =>
    DateTime.now().toUtc().add(const Duration(days: routeForecastMaxDays));

/// JSON body of a GET request, with the failures mapped onto [RouteFailure].
Future<dynamic> _getJson(Uri uri) async {
  final http.Response response;
  try {
    response = await http.get(
      uri,
      headers: const {'User-Agent': 'Memoir-RoutePlanner/1.0'},
    ).timeout(routeTimeout);
  } on TimeoutException {
    throw RouteFailure('unavailable', 'Máy chủ dữ liệu không phản hồi kịp');
  } catch (_) {
    throw RouteFailure('unavailable', 'Không kết nối được tới máy chủ dữ liệu');
  }

  if (response.statusCode == 429) {
    throw RouteFailure('rateLimited', 'Đã vượt giới hạn truy vấn');
  }
  if (response.statusCode != 200) {
    throw RouteFailure(
      'unavailable',
      'Máy chủ dữ liệu trả lỗi ${response.statusCode}',
    );
  }

  try {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } catch (_) {
    throw RouteFailure('unavailable', 'Dữ liệu trả về không hợp lệ');
  }
}

Future<Map<String, dynamic>> _getJsonMap(Uri uri) async {
  final decoded = await _getJson(uri);
  if (decoded is! Map) {
    throw RouteFailure('unavailable', 'Dữ liệu trả về không hợp lệ');
  }
  return decoded.cast<String, dynamic>();
}

/// Vietnamese letters folded to their ASCII base. Built once, at first use.
final Map<String, String> _asciiFold = () {
  const groups = {
    'a': 'áàảãạăắằẳẵặâấầẩẫậ',
    'd': 'đ',
    'e': 'éèẻẽẹêếềểễệ',
    'i': 'íìỉĩị',
    'o': 'óòỏõọôốồổỗộơớờởỡợ',
    'u': 'úùủũụưứừửữự',
    'y': 'ýỳỷỹỵ',
  };
  final map = <String, String>{};
  for (final entry in groups.entries) {
    map[entry.key] = entry.key;
    map[entry.key.toUpperCase()] = entry.key.toUpperCase();
    for (final char in entry.value.split('')) {
      map[char] = entry.key;
      map[char.toUpperCase()] = entry.key.toUpperCase();
    }
  }
  return map;
}();

/// Folds [value] to ASCII.
///
/// The geocoder matches ASCII best — measured against the live API, `Da Lat`
/// finds Đà Lạt while `Đà Lạt` matches something else entirely — so the query is
/// folded before it is sent. Only the query is folded; the names that come back
/// are the provider's own.
String foldForSearch(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_asciiFold[char] ?? char);
  }
  return buffer.toString();
}

/// Places matching [query], for the search box of the planner.
Future<List<PlaceCandidate>> searchPlaces(String query, {int limit = 8}) async {
  final trimmed = query.trim();
  // One character matches half the country; not worth a round trip.
  if (trimmed.length < 2) return const [];

  final uri = Uri.parse(routeGeocodingUrl).replace(queryParameters: {
    'name': foldForSearch(trimmed),
    'count': '${limit.clamp(1, 20)}',
    'language': 'vi',
    'format': 'json',
  });
  final body = await _getJsonMap(uri);
  final results = (body['results'] as List?) ?? const [];

  return results.whereType<Map>().map((row) {
    final admin = row['admin1'] ?? row['admin2'];
    return PlaceCandidate(
      name: (row['name'] as String?)?.trim() ?? trimmed,
      admin: admin is String ? admin : null,
      country: row['country'] is String ? row['country'] as String : null,
      lat: ((row['latitude'] as num?) ?? 0).toDouble(),
      lon: ((row['longitude'] as num?) ?? 0).toDouble(),
    );
  }).toList();
}

/// Forces `kind` to match the position: first stop is the origin, last is the
/// destination, everything in between is a waypoint.
List<RouteStop> normalizeStops(List<RouteStop> stops) {
  final cleaned = stops
      .where((stop) => stop.name.trim().isNotEmpty)
      .toList(growable: false);
  return [
    for (var i = 0; i < cleaned.length; i++)
      RouteStop(
        name: cleaned[i].name,
        lat: cleaned[i].lat,
        lon: cleaned[i].lon,
        dwellMinutes: cleaned[i].dwellMinutes,
        kind: i == 0
            ? 'origin'
            : i == cleaned.length - 1
                ? 'destination'
                : 'waypoint',
      ),
  ];
}

/// Asks the routing engine for a route through [stops].
///
/// Alternatives are requested only for a plain two-point route: OSRM returns
/// them for two waypoints and silently ignores the flag otherwise, so asking
/// with more stops would only make the UI look broken.
Future<RoutePlan> fetchRoutePlan({
  required List<RouteStop> stops,
  required String vehicle,
  bool wantAlternatives = true,
}) async {
  final ordered = normalizeStops(stops);
  if (ordered.length < 2) {
    throw RouteFailure('noRoute', 'Cần ít nhất điểm đi và điểm đến');
  }

  final base = routeBackends[vehicle] ?? routeBackends['car']!;
  final coordinates = ordered
      .map((stop) => '${stop.lon},${stop.lat}')
      .join(';');
  final alternatives = wantAlternatives && ordered.length == 2;

  final uri = Uri.parse('$base/$coordinates').replace(queryParameters: {
    'overview': 'full',
    'geometries': 'geojson',
    'steps': 'false',
    'alternatives': alternatives ? 'true' : 'false',
  });

  final body = await _getJsonMap(uri);
  final routes = (body['routes'] as List?) ?? const [];
  if (body['code'] != 'Ok' || routes.isEmpty) {
    throw RouteFailure(
      'noRoute',
      'Không tìm thấy tuyến đường giữa các điểm đã chọn',
    );
  }

  final primary = routes.first;
  if (primary is! Map) {
    throw RouteFailure('noRoute', 'Không tìm thấy tuyến đường');
  }

  return RoutePlan(
    stops: ordered,
    distanceMeters: ((primary['distance'] as num?) ?? 0).round(),
    durationSeconds: ((primary['duration'] as num?) ?? 0).round(),
    geometry: jsonEncode(primary['geometry'] ?? const {}),
    legs: _legsOf(primary),
    alternatives: _alternativesOf(routes.skip(1), ordered.length),
    source: routePlanSource,
    vehicle: routeBackends.containsKey(vehicle) ? vehicle : 'car',
  );
}

List<RouteLeg> _legsOf(Map route) {
  final legs = (route['legs'] as List?) ?? const [];
  final result = <RouteLeg>[];
  for (var i = 0; i < legs.length; i++) {
    final leg = legs[i];
    if (leg is! Map) continue;
    result.add(RouteLeg(
      distanceMeters: ((leg['distance'] as num?) ?? 0).round(),
      durationSeconds: ((leg['duration'] as num?) ?? 0).round(),
      toIndex: i + 1,
    ));
  }
  return result;
}

List<RouteAlternative> _alternativesOf(Iterable<dynamic> routes, int stopCount) {
  if (stopCount != 2) return const [];
  final result = <RouteAlternative>[];
  for (final route in routes) {
    if (route is! Map) continue;
    final geometry = route['geometry'];
    if (geometry == null) continue;
    result.add(RouteAlternative(
      distanceMeters: ((route['distance'] as num?) ?? 0).round(),
      durationSeconds: ((route['duration'] as num?) ?? 0).round(),
      geometry: jsonEncode(geometry),
    ));
  }
  return result;
}

/// The hourly series the provider returned for one requested coordinate.
class HourlySeries {
  const HourlySeries({
    required this.lat,
    required this.lon,
    required this.times,
    required this.temperature,
    required this.precipitation,
    required this.probability,
    required this.windSpeed,
    required this.windGust,
    required this.visibility,
    required this.weatherCode,
  });

  final double lat;
  final double lon;
  final List<DateTime> times;
  final List<double?> temperature;
  final List<double?> precipitation;
  final List<int?> probability;
  final List<double?> windSpeed;
  final List<double?> windGust;
  final List<double?> visibility;
  final List<int?> weatherCode;
}

List<double?> _doubles(dynamic value) => ((value as List?) ?? const [])
    .map((entry) => (entry as num?)?.toDouble())
    .toList();

List<int?> _ints(dynamic value) => ((value as List?) ?? const [])
    .map((entry) => (entry as num?)?.toInt())
    .toList();

/// One request for every sample coordinate: the provider accepts a comma
/// separated list and answers with an entry per coordinate.
Future<List<HourlySeries>> fetchHourlySeries(List<RouteCoord> coords) async {
  if (coords.isEmpty) return const [];

  final uri = Uri.parse(routeForecastUrl).replace(queryParameters: {
    'latitude': coords.map((c) => c.lat.toStringAsFixed(4)).join(','),
    'longitude': coords.map((c) => c.lon.toStringAsFixed(4)).join(','),
    'hourly': _hourlyVariables,
    'forecast_days': '$routeForecastMaxDays',
    'timezone': routeForecastTimezone,
  });

  final decoded = await _getJson(uri);
  // A single coordinate comes back as an object, several as an array.
  final entries = decoded is List ? decoded : [decoded];

  final series = <HourlySeries>[];
  for (final entry in entries) {
    if (entry is! Map) continue;
    final hourly = entry['hourly'];
    if (hourly is! Map) continue;
    final rawTimes = (hourly['time'] as List?) ?? const [];
    series.add(HourlySeries(
      lat: ((entry['latitude'] as num?) ?? 0).toDouble(),
      lon: ((entry['longitude'] as num?) ?? 0).toDouble(),
      // The request asks for GMT, so the naive timestamps are UTC.
      times: rawTimes
          .whereType<String>()
          .map((raw) => DateTime.parse('${raw}Z'))
          .toList(),
      temperature: _doubles(hourly['temperature_2m']),
      precipitation: _doubles(hourly['precipitation']),
      probability: _ints(hourly['precipitation_probability']),
      windSpeed: _doubles(hourly['wind_speed_10m']),
      windGust: _doubles(hourly['wind_gusts_10m']),
      visibility: _doubles(hourly['visibility']),
      weatherCode: _ints(hourly['weather_code']),
    ));
  }
  return series;
}

T? _valueAt<T>(List<T?> values, int index) =>
    index >= 0 && index < values.length ? values[index] : null;

/// The conditions at [arrival] for [coord].
///
/// The response entry is matched to the coordinate by proximity instead of by
/// position, so a reordered or partially failed response cannot attribute one
/// place's weather to another.
RouteConditions? conditionsAt(
  List<HourlySeries> series,
  RouteCoord coord,
  DateTime arrival,
) {
  if (series.isEmpty) return null;

  var nearest = series.first;
  var best = double.infinity;
  for (final candidate in series) {
    final distance =
        haversineMeters(RouteCoord(candidate.lat, candidate.lon), coord);
    if (distance < best) {
      best = distance;
      nearest = candidate;
    }
  }

  final index = hourIndexFor(nearest.times, arrival);
  if (index == null) return null;

  return RouteConditions(
    weatherCode: _valueAt(nearest.weatherCode, index),
    tempC: _valueAt(nearest.temperature, index),
    precipitationMm: _valueAt(nearest.precipitation, index),
    precipitationProbability: _valueAt(nearest.probability, index),
    windSpeedKmh: _valueAt(nearest.windSpeed, index),
    windGustKmh: _valueAt(nearest.windGust, index),
    visibilityMeters: _valueAt(nearest.visibility, index),
  );
}

/// "Đoạn Km 206" for a single point, "Đoạn Km 25 – Km 50" for a stretch.
String _stretchLabel(RouteWeatherSample first, RouteWeatherSample last) {
  final from = (first.distanceFromStartMeters / 1000).round();
  final to = (last.distanceFromStartMeters / 1000).round();
  return from == to ? 'Đoạn Km $from' : 'Đoạn Km $from – Km $to';
}

/// Merges neighbouring notable samples into one alert per stretch
/// (docs/12-route-weather.md §6).
List<RouteAlert> mergeAlerts(List<RouteWeatherSample> samples) {
  final alerts = <RouteAlert>[];
  int? start;

  for (var i = 0; i <= samples.length; i++) {
    final notable = i < samples.length &&
        RouteSeverity.rank(samples[i].severity) >=
            RouteSeverity.rank(RouteSeverity.caution);
    if (notable) {
      start ??= i;
      continue;
    }
    if (start == null) continue;

    final run = samples.sublist(start, i);
    final stops = run.where((sample) => sample.kind != 'sample').toList();
    final first = run.first;
    final last = run.last;
    final reasons = <String>{for (final sample in run) ...sample.reasons};

    alerts.add(RouteAlert(
      severity: RouteSeverity.highest(run.map((sample) => sample.severity)),
      title: stops.isNotEmpty
          ? stops.first.label
          : _stretchLabel(first, last),
      summary: reasons.isEmpty
          ? 'Điều kiện thời tiết có thể bất lợi.'
          : '${reasons.join(' · ')}.',
      startAt: first.arrivalAt,
      endAt: last.arrivalAt,
      fromSeq: first.seq,
      toSeq: last.seq,
    ));
    start = null;
  }
  return alerts;
}

/// Rebuilds a sample with a different status.
///
/// Written out by hand rather than `copyWith` so every nullable weather value
/// keeps exactly the value it had: a missing reading must stay missing.
RouteWeatherSample _withStatus(RouteWeatherSample sample, String status) =>
    RouteWeatherSample(
      seq: sample.seq,
      label: sample.label,
      kind: sample.kind,
      lat: sample.lat,
      lon: sample.lon,
      distanceFromStartMeters: sample.distanceFromStartMeters,
      arrivalAt: sample.arrivalAt,
      weatherCode: sample.weatherCode,
      weatherGroup: sample.weatherGroup,
      condition: sample.condition,
      icon: sample.icon,
      tempC: sample.tempC,
      precipitationMm: sample.precipitationMm,
      precipitationProbability: sample.precipitationProbability,
      windSpeedKmh: sample.windSpeedKmh,
      severity: sample.severity,
      reasons: sample.reasons,
      status: status,
    );

RouteWeatherReport _labeled(RouteWeatherReport report, String source) =>
    RouteWeatherReport(
      generatedAt: report.generatedAt,
      coverage: report.coverage,
      source: source,
      beyondRange: report.beyondRange,
      samples: report.samples
          .map((sample) => _withStatus(
                sample,
                sample.weatherCode == null ? 'unavailable' : 'stale',
              ))
          .toList(),
      alerts: report.alerts,
      notes: report.notes,
    );

/// Forecast per sample coordinate, cached for [routeCacheTtl].
///
/// Never throws for an upstream failure: the route, the distances and the ETAs
/// are all still worth showing, so the report comes back with
/// `source = "unavailable"` and the reason in `notes`. Only the cache is used
/// as a fallback when the provider is unreachable.
final Map<String, (DateTime, RouteWeatherReport)> routeWeatherCache = {};

String _cacheKey(List<RouteSamplePoint> points, List<DateTime> arrivals) {
  final buffer = StringBuffer();
  for (var i = 0; i < points.length; i++) {
    buffer
      ..write(points[i].coord.lat.toStringAsFixed(2))
      ..write(',')
      ..write(points[i].coord.lon.toStringAsFixed(2))
      ..write('@')
      ..write(arrivals[i].millisecondsSinceEpoch ~/ Duration.millisecondsPerHour)
      ..write(';');
  }
  return buffer.toString();
}

Future<RouteWeatherReport> weatherAlongRoute({
  required RoutePlan plan,
  required DateTime departureAt,
  bool useCache = true,
}) async {
  final line = decodeLineString(plan.geometry);
  final samples = planRouteSamples(line: line, stops: plan.stops);
  final arrivals = arrivalTimes(
    points: samples.points,
    stopDistances: samples.stopDistances,
    stops: plan.stops,
    legs: plan.legs,
    totalDurationSeconds: plan.durationSeconds,
    departureAt: departureAt.toUtc(),
  );

  final key = _cacheKey(samples.points, arrivals);
  final cached = useCache ? routeWeatherCache[key] : null;
  if (cached != null &&
      DateTime.now().toUtc().difference(cached.$1) < routeCacheTtl) {
    return _labeled(cached.$2, 'cache');
  }

  List<HourlySeries> series;
  try {
    series = await fetchHourlySeries(
      samples.points.map((point) => point.coord).toList(),
    );
  } catch (failure) {
    if (cached != null) return _labeled(cached.$2, 'cache');
    return RouteWeatherReport(
      generatedAt: DateTime.now().toUtc(),
      coverage: 'none',
      source: 'unavailable',
      beyondRange: false,
      samples: _samplesWithoutData(samples.points, arrivals),
      alerts: const [],
      notes: [
        if (failure is RouteFailure) failure.message else '$failure',
        'Vẫn hiển thị tuyến đường và thời gian dự kiến đi qua.',
      ],
    );
  }

  final report = _buildReport(
    points: samples.points,
    arrivals: arrivals,
    series: series,
  );
  routeWeatherCache[key] = (DateTime.now().toUtc(), report);
  return report;
}

List<RouteWeatherSample> _samplesWithoutData(
  List<RouteSamplePoint> points,
  List<DateTime> arrivals,
) =>
    [
      for (var i = 0; i < points.length; i++)
        RouteWeatherSample(
          seq: i,
          label: points[i].label,
          kind: points[i].kind,
          lat: points[i].coord.lat,
          lon: points[i].coord.lon,
          distanceFromStartMeters: points[i].distanceMeters.round(),
          arrivalAt: arrivals[i],
          severity: RouteSeverity.info,
          reasons: const [],
          status: 'unavailable',
        ),
    ];

/// Turns the provider's hourly series into the report the screen renders.
RouteWeatherReport _buildReport({
  required List<RouteSamplePoint> points,
  required List<DateTime> arrivals,
  required List<HourlySeries> series,
}) {
  final horizon = routeForecastHorizon();
  final samples = <RouteWeatherSample>[];
  var withData = 0;
  var beyond = false;

  for (var i = 0; i < points.length; i++) {
    final point = points[i];
    final arrival = arrivals[i];
    final conditions = conditionsAt(series, point.coord, arrival);
    final verdict =
        evaluateRouteConditions(conditions ?? const RouteConditions());
    if (conditions != null) withData++;
    if (arrival.isAfter(horizon)) beyond = true;

    String? condition;
    String? icon;
    String? group;
    final code = conditions?.weatherCode;
    if (code != null) {
      group = wmoGroupForCode(code);
      final (label, glyph) = wmoLabelForGroup(group);
      condition = label;
      icon = glyph;
    }

    samples.add(RouteWeatherSample(
      seq: i,
      label: point.label,
      kind: point.kind,
      lat: point.coord.lat,
      lon: point.coord.lon,
      distanceFromStartMeters: point.distanceMeters.round(),
      arrivalAt: arrival,
      weatherCode: code,
      weatherGroup: group,
      condition: condition,
      icon: icon,
      tempC: conditions?.tempC,
      precipitationMm: conditions?.precipitationMm,
      precipitationProbability: conditions?.precipitationProbability,
      windSpeedKmh: conditions?.windSpeedKmh,
      severity: conditions == null ? RouteSeverity.info : verdict.severity,
      reasons: conditions == null ? const [] : verdict.reasons,
      status: conditions == null ? 'unavailable' : 'forecast',
    ));
  }

  final coverage = withData == 0
      ? 'none'
      : (withData == samples.length ? 'full' : 'partial');

  return RouteWeatherReport(
    generatedAt: DateTime.now().toUtc(),
    coverage: coverage,
    source: 'api',
    beyondRange: beyond,
    samples: samples,
    alerts: mergeAlerts(samples),
    notes: [
      if (beyond)
        'Thời gian yêu cầu vượt quá phạm vi dự báo ($routeForecastMaxDays ngày).',
      if (coverage == 'partial' && !beyond)
        'Chỉ có dữ liệu cho một phần hành trình.',
      if (coverage == 'none') 'Chưa có dữ liệu thời tiết cho hành trình này.',
    ],
  );
}

/// Short verdict shown on a departure-time card.
String headlineFor(String severity, RouteWeatherReport report) {
  if (report.samples.isEmpty || report.source == 'unavailable') {
    return 'Chưa có dữ liệu dự báo';
  }
  switch (severity) {
    case RouteSeverity.warning:
      return 'Có đoạn thời tiết xấu';
    case RouteSeverity.caution:
      return 'Có đoạn cần chú ý';
  }
  return 'Điều kiện thuận lợi';
}

/// Departure times around the one the user picked, each with its own forecast.
///
/// Three options by default (earlier / chosen / later), matching the design.
Future<List<RouteDepartureOption>> compareDepartures({
  required RoutePlan plan,
  required DateTime departureAt,
  List<int>? offsetsHours,
}) async {
  final offsets = (offsetsHours == null || offsetsHours.isEmpty)
      ? const [-2, 0, 2]
      : offsetsHours;

  final options = <RouteDepartureOption>[];
  for (final offset in offsets) {
    final at = departureAt.toUtc().add(Duration(hours: offset));
    final report = await weatherAlongRoute(plan: plan, departureAt: at);
    final severity =
        RouteSeverity.highest(report.samples.map((sample) => sample.severity));
    options.add(RouteDepartureOption(
      offsetHours: offset,
      departureAt: at,
      arrivalAt: report.samples.isEmpty ? at : report.samples.last.arrivalAt,
      severity: severity,
      headline: headlineFor(severity, report),
      weather: report,
    ));
  }
  return options;
}






