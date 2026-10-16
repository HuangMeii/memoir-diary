/// Routing, sampling and route weather.
///
/// Everything here is a plain Dart function or a small client: no endpoint
/// state, so the geometry maths, the sample selection, the ETA calculation and
/// the rule evaluation can all be unit tested without a network or a database.
/// See docs/12-route-weather.md.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
/// instances need no API key.
///
/// The URLs resolve from `ROUTE_API_URL_CAR|BIKE|FOOT` (docs/12 §19):
/// a self-hosted instance on `vietnam-latest.osm.pbf` keeps every route
/// inside Vietnam, because OSRM has no "avoid country" parameter. The public
/// FOSSGIS instances stay as the fallback so a dev machine without a local
/// OSRM still works.
///
/// Pass an explicit [environment] in tests to avoid touching
/// [Platform.environment]; production callers omit it.
Map<String, String> resolveRouteBackends([Map<String, String>? environment]) {
  final env = environment ?? Platform.environment;
  String pick(String key, String fallback) {
    final value = env[key]?.trim();
    return (value == null || value.isEmpty) ? fallback : value;
  }

  return {
    'car': pick(
      'ROUTE_API_URL_CAR',
      'https://routing.openstreetmap.de/routed-car/route/v1/driving',
    ),
    'bike': pick(
      'ROUTE_API_URL_BIKE',
      'https://routing.openstreetmap.de/routed-bike/route/v1/driving',
    ),
    'foot': pick(
      'ROUTE_API_URL_FOOT',
      'https://routing.openstreetmap.de/routed-foot/route/v1/driving',
    ),
  };
}

/// The default backends: environment overrides, else the public instances.
///
/// Kept as a getter (not a const) so setting `ROUTE_API_URL_*` before boot
/// takes effect without a restart of the analysis server. Pure helpers keep
/// using this; tests inject their own map via [resolveRouteBackends].
Map<String, String> get routeBackends => resolveRouteBackends();

/// True when [backends] still point at the global public graph, whose
/// long north-south routes cut through Laos and Cambodia (docs/12 §19).
bool usesPublicRouteBackends([Map<String, String>? backends]) {
  final resolved = backends ?? routeBackends;
  return resolved.values.any(
    (url) => url.contains('routing.openstreetmap.de'),
  );
}

/// One-line warning for the server log when the public graph is in use.
String get publicRouteBackendWarning =>
    'Routing dùng OSRM công khai (đồ thị toàn cầu) — '
    'tuyến dài có thể đi qua Lào/Campuchia; '
    'đặt ROUTE_API_URL_CAR|BIKE|FOOT trỏ instance extract Việt Nam (§19).';

/// Nominatim geocodes OpenStreetMap data, which keeps addresses down to
/// the street / ward level - the reason it replaced Open-Meteo Geocoding
/// (see docs/12-route-weather.md §2 and §18.3).
const String routeGeocodingUrl =
    'https://nominatim.openstreetmap.org/search';

/// The other direction of the same geocoder: coordinates in, the address
/// there out. The planner asks this after a tap on the map so the stop field
/// shows an address instead of raw numbers (docs/12-route-weather.md §11).
const String routeReverseGeocodingUrl =
    'https://nominatim.openstreetmap.org/reverse';

/// Nominatim ranks globally, so without this "Tây Thạnh" resolves to
/// Tây Thạnh in Đà Nẵng (~600 km away) and "Le T" to places in France.
const String routeGeocodingCountry = 'vn';

const String routeForecastUrl = 'https://api.open-meteo.com/v1/forecast';

/// Only the routing backends are OSRM; the weather still comes from Open-Meteo.
const String routePlanSource = 'osrm';

const Duration routeTimeout = Duration(seconds: 5);
const Duration routeForecastTimeout = Duration(seconds: 30);
const int routeForecastChunkSize = 8;
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
///
/// A 404 is normally a failure, but with [notFoundIsNull] it becomes `null`
/// instead: Nominatim's `/reverse` answers 404 for a point that has no
/// address at all (open water, an unlabelled field), and "nothing here" is
/// an answer the caller can show, not an outage.
Future<dynamic> _getJson(
  Uri uri, {
  bool notFoundIsNull = false,
  Duration timeout = routeTimeout,
}) async {
  final http.Response response;
  try {
    response = await http.get(
      uri,
      headers: const {'User-Agent': 'Memoir-RoutePlanner/1.0'},
    ).timeout(timeout);
  } on TimeoutException {
    throw RouteFailure('unavailable', 'Máy chủ dữ liệu không phản hồi kịp');
  } catch (_) {
    throw RouteFailure('unavailable', 'Không kết nối được tới máy chủ dữ liệu');
  }

  if (response.statusCode == 429) {
    throw RouteFailure('rateLimited', 'Đã vượt giới hạn truy vấn');
  }
  if (response.statusCode == 404 && notFoundIsNull) {
    return null;
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

/// Nominatim's `/search` answers with a bare JSON array, unlike the other
/// providers here, which all answer with an object.
Future<List<dynamic>> _getJsonList(Uri uri) async {
  final decoded = await _getJson(uri);
  if (decoded is! List) {
    throw RouteFailure('unavailable', 'Dữ liệu trả về không hợp lệ');
  }
  return decoded;
}

/// The query Nominatim is called with.
///
/// Sent as the user typed it, diacritics included: the live API matches those
/// correctly. Nothing is appended to it either — a comma makes Nominatim switch
/// to its structured form, where the text after it must name a real admin area
/// exactly, so appending ", vn" turned "140 Lê Trọng Tấn, Phường Tây Thạnh"
/// into a search restricted to an area that does not exist. The country filter
/// is the `countrycodes` parameter below, which is a filter and not query
/// syntax.
String geocodingQuery(String query) => query.trim();

/// The parameters of one geocoding request, in the order they matter.
Map<String, String> geocodingParams(String query, int limit) => {
      'q': geocodingQuery(query),
      'format': 'jsonv2',
      'limit': '${limit.clamp(1, 20)}',
      // Vietnamese names, so results read "Đà Lạt, Tỉnh Lâm Đồng".
      'accept-language': 'vi',
      // Fills the `address` breakdown (ward, street, house number).
      'addressdetails': '1',
      // Keeps the ranking inside Vietnam; see [routeGeocodingCountry].
      'countrycodes': routeGeocodingCountry,
    };

/// One Nominatim result as a [PlaceCandidate].
///
/// Nominatim is the odd provider out in this file: `lat` / `lon` come back as
/// **strings**, not numbers, and the hierarchy lives in a nested `address`
/// object rather than flat `admin1` / `admin2` fields.
PlaceCandidate fromNominatim(Map row) {
  final address = (row['address'] as Map?) ?? const {};
  final admin = address['city'] ??
      address['town'] ??
      address['suburb'] ??
      address['county'] ??
      address['state'];
  return PlaceCandidate(
    // `name` is absent for a bare street; the address itself is then the name.
    name: ((row['name'] as String?) ?? (row['display_name'] as String?))?.trim() ??
        '',
    admin: admin is String ? admin : null,
    country: address['country'] is String ? address['country'] as String : null,
    lat: double.tryParse('${row['lat']}') ?? 0,
    lon: double.tryParse('${row['lon']}') ?? 0,
  );
}

/// Geocoding answers, keyed by lower-cased query and limit, for
/// [routeGeocodeTtl].
///
/// The form asks once per typing pause, so the same text comes round again as
/// soon as the user backspaces or refocuses; answering those here is what
/// keeps repeat lookups off Nominatim. Errors are deliberately never stored —
/// the next attempt must reach the provider again rather than be answered
/// with a failure the user has already seen.
final Map<String, (DateTime, List<PlaceCandidate>)> routeGeocodeCache = {};

/// How long one answer stays worth reusing: long enough that retyping the
/// same address never costs a request, short enough that a corrected OSM
/// entry still shows up within a session.
const Duration routeGeocodeTtl = Duration(minutes: 30);

/// Entries kept in [routeGeocodeCache]; the map is emptied once it is full.
const int routeGeocodeCacheMax = 256;

/// The geocoding budget this server keeps to: two requests per second to
/// Nominatim, shared by `searchPlaces` and `reversePlace` (docs/12 §11).
/// Its public instance asks for one per second per client; two leaves head
/// room for several users while a burst of map taps stays under the line.
const Duration geocodeSlotInterval = Duration(milliseconds: 500);

/// When [claimGeocodeSlot] may let the next request through.
///
/// Public so tests can reset it; production code only moves it through
/// [claimGeocodeSlot].
DateTime geocodeNextSlot = DateTime.fromMillisecondsSinceEpoch(0);

/// Waits until the geocoding budget has room, then spends it.
///
/// The wait re-checks after waking, so callers stack onto distinct slots
/// instead of stepping on each other: the provider never sees two requests
/// closer together than [geocodeSlotInterval].
Future<void> claimGeocodeSlot() async {
  while (true) {
    final now = DateTime.now();
    final next = geocodeNextSlot;
    if (!now.isBefore(next)) break;
    await Future<void>.delayed(next.difference(now));
  }
  geocodeNextSlot = DateTime.now().add(geocodeSlotInterval);
}

/// The cached answer for [key], or null when there is none or it is older
/// than [routeGeocodeTtl].
List<PlaceCandidate>? cachedGeocode(String key) {
  final cached = routeGeocodeCache[key];
  if (cached == null) return null;
  if (DateTime.now().toUtc().difference(cached.$1) >= routeGeocodeTtl) {
    return null;
  }
  return cached.$2;
}

/// Places matching [query], for the search box of the planner.
///
/// Asked once per typing pause rather than once per key — the form waits out
/// its one-second debounce — and answered from [routeGeocodeCache] whenever
/// the same text comes round again. The public Nominatim instance caps at one
/// request per second and its usage policy frowns on auto-complete, so
/// repeat lookups must never leave this server (docs/12-route-weather.md §11).
Future<List<PlaceCandidate>> searchPlaces(String query, {int limit = 8}) async {
  final trimmed = query.trim();
  // One character matches half the country; not worth a round trip.
  if (trimmed.length < 2) return const [];

  final key = '${trimmed.toLowerCase()}|$limit';
  final hit = cachedGeocode(key);
  if (hit != null) return hit;

  await claimGeocodeSlot();
  final uri =
      Uri.parse(routeGeocodingUrl).replace(queryParameters: geocodingParams(
    trimmed,
    limit,
  ));
  final results = await _getJsonList(uri);
  final places = results.whereType<Map>().map(fromNominatim).toList();

  // One long typing session can produce a lot of distinct prefixes; once the
  // map is full every entry in it is old enough to drop anyway.
  if (routeGeocodeCache.length >= routeGeocodeCacheMax) {
    routeGeocodeCache.clear();
  }
  routeGeocodeCache[key] = (DateTime.now().toUtc(), places);
  return places;
}

/// The parameters of one reverse lookup.
///
/// `countrycodes` is deliberately absent, unlike [geocodingParams]: there is
/// no ranking to steer — the coordinates already say exactly where the point
/// is — and a pick on a route that runs across the border (docs/12 §19) must
/// still name the place it landed on.
Map<String, String> reverseGeocodingParams(double lat, double lon) => {
      'lat': lat.toStringAsFixed(6),
      'lon': lon.toStringAsFixed(6),
      'format': 'jsonv2',
      // Vietnamese names, so results read "Bến Nghé, Quận 1, TP.HCM".
      'accept-language': 'vi',
      // Fills the `address` breakdown (ward, street, house number).
      'addressdetails': '1',
    };

/// The address at [lat] / [lon], or null when the point has none.
///
/// What a tap on the map puts into the planner's stop field, so the form
/// shows an address instead of raw coordinates (docs/12-route-weather.md
/// §11). The row shape is Nominatim's, so [fromNominatim] reads it the same
/// way it reads a search hit. Answers share [routeGeocodeCache] with the
/// search, keyed by the coordinates rounded to four decimals (~11 m):
/// tapping the same corner twice must not cost two requests. Errors are
/// never stored, exactly as in [searchPlaces].
Future<PlaceCandidate?> reversePlace(double lat, double lon) async {
  final key = reverseGeocodeKey(lat, lon);
  final hit = cachedGeocode(key);
  if (hit != null) return hit.isEmpty ? null : hit.first;

  await claimGeocodeSlot();
  final uri = Uri.parse(routeReverseGeocodingUrl).replace(
    queryParameters: reverseGeocodingParams(lat, lon),
  );
  // A 404 means "nothing is mapped here" — open water, an unnamed field —
  // which the caller answers with the coordinates, not with an error.
  final row = await _getJson(uri, notFoundIsNull: true);
  if (row == null) return null;
  if (row is! Map) {
    throw RouteFailure('unavailable', 'Dữ liệu trả về không hợp lệ');
  }

  final place = fromNominatim(row);
  if (place.name.isEmpty) return null;

  if (routeGeocodeCache.length >= routeGeocodeCacheMax) {
    routeGeocodeCache.clear();
  }
  routeGeocodeCache[key] = (DateTime.now().toUtc(), [place]);
  return place;
}

/// The cache key of a reverse lookup: the coordinates rounded to four
/// decimals (~11 m), which is finer than any address repeats at.
String reverseGeocodeKey(double lat, double lon) =>
    'rev|${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}';

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

/// The failure to report for one routing answer, or null when it is a route.
///
/// OSRM answers `NoRoute` when no road connects the points, but it answers
/// `InvalidOptions` for a request it refuses outright — most often a point left
/// at 0,0, which is a buoy in the Atlantic rather than a place. Those are two
/// different problems: the first means "pick somewhere else", the second means
/// "a stop has no coordinates yet". Collapsing them into one code made an
/// unplaced destination read as "no route exists", which sent people looking
/// for the wrong fault.
RouteFailure? routeFailureFor(dynamic body, List<dynamic> routes) {
  if (routes.isNotEmpty && body is Map && body['code'] == 'Ok') return null;

  final code = body is Map ? body['code'] : null;
  if (code == 'InvalidOptions') {
    return RouteFailure(
      'noPoints',
      'Điểm đi hoặc điểm đến chưa xác định được vị trí',
    );
  }
  return RouteFailure(
    'noRoute',
    'Không tìm thấy tuyến đường giữa các điểm đã chọn',
  );
}

/// Western boundary of Vietnam as (latitude, min-longitude) breakpoints,
/// north to south (docs/12 §19.7). A single min-lon cannot work: Dien Bien
/// is at ~102°E while eastern Laos at the same southern latitudes is at
/// ~104-105°E, so the boundary follows the Annamite range instead.
const List<RouteCoord> routeVietnamWestBoundary = [
  RouteCoord(23.65, 101.85),
  RouteCoord(21.00, 102.50),
  RouteCoord(20.00, 103.50),
  RouteCoord(19.00, 104.00),
  RouteCoord(18.50, 105.15),
  RouteCoord(18.00, 105.00),
  RouteCoord(17.00, 105.40),
  RouteCoord(16.00, 105.90),
  RouteCoord(15.00, 106.20),
  RouteCoord(14.00, 106.40),
  RouteCoord(13.00, 106.50),
  RouteCoord(12.00, 106.40),
  RouteCoord(11.00, 105.80),
  RouteCoord(10.00, 103.20),
  RouteCoord(8.15, 103.20),
];

/// Latitude range of Vietnam, padded slightly.
const double routeVietnamMinLat = 8.15;
const double routeVietnamMaxLat = 23.65;

/// Eastern edge, padded slightly (Hoang Sa waters).
const double routeVietnamMaxLon = 110.10;

/// Western longitude limit at [lat], linearly interpolated between the
/// breakpoints above. Pure, so it is unit tested without a network.
double routeVietnamMinLonAt(double lat) {
  final edge = routeVietnamWestBoundary;
  if (lat >= edge.first.lat) return edge.first.lon;
  if (lat <= edge.last.lat) return edge.last.lon;
  for (var i = 0; i < edge.length - 1; i++) {
    final upper = edge[i];
    final lower = edge[i + 1];
    if (lat <= upper.lat && lat >= lower.lat) {
      final span = upper.lat - lower.lat;
      final mix = span <= 0 ? 0.0 : (upper.lat - lat) / span;
      return upper.lon + (lower.lon - upper.lon) * mix;
    }
  }
  return edge.last.lon;
}

/// How many consecutive vertices outside the box it takes to call a route
/// out of Vietnam. One or two stray points are usually a snap artefact.
const int routeVietnamOutlierRun = 3;

/// Fixed pins along QL1A, north to south (docs/12 §19.7). Inserted between
/// the origin and destination when the engine's first answer leaves Vietnam.
const List<RouteCoord> routeVietnamPins = [
  RouteCoord(18.6833, 105.6833), // Vinh
  RouteCoord(17.4833, 106.6167), // Dong Hoi
  RouteCoord(16.8167, 107.1000), // Dong Ha
  RouteCoord(16.4637, 107.5900), // Hue
  RouteCoord(16.0600, 108.2100), // Da Nang
  RouteCoord(13.7667, 109.2333), // Quy Nhon
  RouteCoord(12.2500, 109.1833), // Nha Trang
];

/// Maximum pins inserted on a retry.
const int routeVietnamMaxPins = 3;

bool _outsideVietnam(RouteCoord point) =>
    point.lat < routeVietnamMinLat ||
    point.lat > routeVietnamMaxLat ||
    point.lon < routeVietnamMinLonAt(point.lat) ||
    point.lon > routeVietnamMaxLon;

/// True when [line] runs outside Vietnam: at least [routeVietnamOutlierRun]
/// consecutive vertices outside the padded box. Pure, so it is unit tested
/// without a network.
bool routeLeavesVietnam(List<RouteCoord> line) {
  var run = 0;
  for (final point in line) {
    if (_outsideVietnam(point)) {
      run++;
      if (run >= routeVietnamOutlierRun) return true;
    } else {
      run = 0;
    }
  }
  return false;
}

/// Pins between [origin] and [destination], spread evenly by latitude so no
/// long segment is left unpinned (docs/12 §19.7). The span is split into
/// [routeVietnamMaxPins] + 1 equal parts; each part contributes its nearest
/// pin. Picking by closeness to the straight connector instead bunched every
/// pin in the north (Hue/Dong Ha/Da Nang for Hanoi–HCMC) and left the
/// ~900 km Da Nang–HCMC leg free to swing through Cambodia.
List<RouteCoord> vietnamPinsBetween(RouteCoord origin, RouteCoord destination) {
  final low = origin.lat < destination.lat ? origin.lat : destination.lat;
  final high = origin.lat < destination.lat ? destination.lat : origin.lat;
  final span = high - low;
  if (span <= 0) return const [];
  final candidates = routeVietnamPins
      .where((pin) => pin.lat > low && pin.lat < high)
      .toList(growable: false);
  if (candidates.isEmpty) return const [];
  final picked = <RouteCoord>[];
  for (var i = 1; i <= routeVietnamMaxPins; i++) {
    final target = low + span * i / (routeVietnamMaxPins + 1);
    RouteCoord? best;
    var bestGap = double.infinity;
    for (final pin in candidates) {
      if (picked.contains(pin)) continue;
      final gap = (pin.lat - target).abs();
      if (gap < bestGap) {
        bestGap = gap;
        best = pin;
      }
    }
    if (best != null) picked.add(best);
  }
  picked.sort((a, b) => origin.lat < destination.lat
      ? a.lat.compareTo(b.lat)
      : b.lat.compareTo(a.lat));
  return picked;
}

/// Merges the legs of a pinned retry back onto the user's stops: distances
/// and durations are summed per user leg, [toIndex] is renumbered. The pins
/// stay invisible to the client.
List<RouteLeg> mergePinnedLegs({
  required List<RouteLeg> rawLegs,
  required int userLegCount,
  required int pinCount,
}) {
  if (rawLegs.length != userLegCount + pinCount || userLegCount < 1) {
    return rawLegs;
  }
  // Pins are always inserted as one block right after the origin here, so the
  // first user leg absorbs pinCount + 1 raw legs and the rest stay 1:1.
  final merged = <RouteLeg>[];
  var rawIndex = 0;
  for (var leg = 0; leg < userLegCount; leg++) {
    var distance = 0;
    var duration = 0;
    final take = leg == 0 ? pinCount + 1 : 1;
    for (var k = 0; k < take && rawIndex < rawLegs.length; k++) {
      distance += rawLegs[rawIndex].distanceMeters;
      duration += rawLegs[rawIndex].durationSeconds;
      rawIndex++;
    }
    merged.add(
      RouteLeg(
          distanceMeters: distance, durationSeconds: duration, toIndex: leg + 1),
    );
  }
  return merged;
}

/// Asks the routing engine for a route through [stops].
///
/// Alternatives are requested only for a plain two-point route: OSRM returns
/// them for two waypoints and silently ignores the flag otherwise, so asking
/// with more stops would only make the UI look broken.
///
/// When the first answer leaves Vietnam ([routeLeavesVietnam]) and the trip
/// spans at least one of [routeVietnamPins], the request is retried once with
/// pins inserted — then the legs are merged back onto the user's stops so the
/// pins stay invisible (docs/12 §19.7). The retry never asks for alternatives.
Future<RoutePlan> fetchRoutePlan({
  required List<RouteStop> stops,
  required String vehicle,
  bool wantAlternatives = true,
  Map<String, String>? backends,
}) async {
  final ordered = normalizeStops(stops);
  if (ordered.length < 2) {
    throw RouteFailure('noRoute', 'Cần ít nhất điểm đi và điểm đến');
  }

  final resolved = backends ?? routeBackends;
  var plan = await _fetchOnce(
    ordered: ordered,
    vehicle: vehicle,
    wantAlternatives: wantAlternatives,
    resolved: resolved,
  );

  final pins = vietnamPinsBetween(
    RouteCoord(ordered.first.lat, ordered.first.lon),
    RouteCoord(ordered.last.lat, ordered.last.lon),
  );
  if (pins.isEmpty) return plan;
  if (!routeLeavesVietnam(decodeLineString(plan.geometry))) return plan;

  final pinned = [
    ordered.first,
    for (final pin in pins)
      RouteStop(
        name: 'Ghim · ${pin.lat.toStringAsFixed(2)},'
            '${pin.lon.toStringAsFixed(2)}',
        lat: pin.lat,
        lon: pin.lon,
        kind: 'waypoint',
      ),
    ordered.last,
  ];
  final retry = await _fetchOnce(
    ordered: pinned,
    vehicle: vehicle,
    wantAlternatives: false,
    resolved: resolved,
  );
  return RoutePlan(
    stops: ordered,
    distanceMeters: retry.distanceMeters,
    durationSeconds: retry.durationSeconds,
    geometry: retry.geometry,
    legs: mergePinnedLegs(
      rawLegs: retry.legs,
      userLegCount: ordered.length - 1,
      pinCount: pins.length,
    ),
    alternatives: const [],
    source: routePlanSource,
    vehicle: resolved.containsKey(vehicle) ? vehicle : 'car',
  );
}

Future<RoutePlan> _fetchOnce({
  required List<RouteStop> ordered,
  required String vehicle,
  required bool wantAlternatives,
  required Map<String, String> resolved,
}) async {
  final base = resolved[vehicle] ?? resolved['car']!;
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

  final failure = routeFailureFor(body, routes);
  if (failure != null) throw failure;

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
    vehicle: resolved.containsKey(vehicle) ? vehicle : 'car',
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

/// One request per [routeForecastChunkSize] coordinates: the provider accepts
/// a comma separated list and answers with an entry per coordinate, but a
/// 25-point route x 16 days x 7 hourly variables is several MB in one URL
/// and always trips the 5 s [routeTimeout] on slow links (HN-HCM showed only
/// "Chua co du lieu du bao" for this reason). Chunks run sequentially with
/// the longer [routeForecastTimeout]; a failed chunk keeps the coordinates
/// of the other chunks instead of failing the whole route.
Future<List<HourlySeries>> fetchHourlySeries(List<RouteCoord> coords) async {
  if (coords.isEmpty) return const [];

  final series = <HourlySeries>[];
  for (var i = 0; i < coords.length; i += routeForecastChunkSize) {
    final chunk = coords.sublist(
      i,
      (i + routeForecastChunkSize).clamp(0, coords.length),
    );

    final uri = Uri.parse(routeForecastUrl).replace(queryParameters: {
      'latitude': chunk.map((c) => c.lat.toStringAsFixed(4)).join(','),
      'longitude': chunk.map((c) => c.lon.toStringAsFixed(4)).join(','),
      'hourly': _hourlyVariables,
      'forecast_days': '$routeForecastMaxDays',
      'timezone': routeForecastTimezone,
    });

    List<dynamic> entries;
    try {
      final decoded = await _getJson(uri, timeout: routeForecastTimeout);
      // A single coordinate comes back as an object, several as an array.
      entries = decoded is List ? decoded : [decoded];
    } on RouteFailure {
      // One slow chunk must not wipe the samples the other chunks fetched:
      // those coordinates simply get no series and fall back to `unavailable`
      // samples downstream instead of failing the whole report.
      continue;
    }

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






