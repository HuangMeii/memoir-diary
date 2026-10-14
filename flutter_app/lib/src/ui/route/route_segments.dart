import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import '../../data/models.dart';

/// The severity of a stretch the forecast does not cover.
///
/// It is the app's own value, never sent by the server: `route_rules.dart` only
/// knows `info` / `caution` / `warning`. The map paints such a stretch grey and
/// dashed, so a gap in the data never reads as good news.
const String routeSeverityUnknown = 'unknown';

/// One stretch of the drawn route, carrying the severity of the weather along
/// it so the map can colour the line the way Google Maps colours traffic.
class RouteSegment {
  const RouteSegment({
    required this.points,
    required this.severity,
    required this.startMeters,
    required this.endMeters,
  });

  /// The geometry of the stretch, already cut at the two samples bounding it.
  /// Neighbouring stretches share their boundary point, so the line stays whole.
  final List<LatLng> points;

  /// info | caution | warning | unknown
  final String severity;

  /// Distance from the start of the route, kept so the sample the timeline
  /// selected can be matched back to the stretch it sits on.
  final double startMeters;
  final double endMeters;

  /// Whether [meters] along the route falls inside this stretch.
  bool covers(double meters) => meters >= startMeters && meters <= endMeters;
}

/// Mean Earth radius, the same constant the server's haversine uses
/// (`route_service.dart`), so cutting at a sample's `distanceFromStartMeters`
/// lands on the point the server measured instead of a few hundred metres off.
const double _earthRadiusMeters = 6371008.8;

double _radians(double degrees) => degrees * math.pi / 180;

/// Great-circle distance in meters: the client-side twin of the server's
/// `haversineMeters`.
double routeMetersBetween(LatLng a, LatLng b) {
  final sinLat = math.sin(_radians(b.latitude - a.latitude) / 2);
  final sinLon = math.sin(_radians(b.longitude - a.longitude) / 2);
  final h = sinLat * sinLat +
      sinLon *
          sinLon *
          math.cos(_radians(a.latitude)) *
          math.cos(_radians(b.latitude));
  return 2 * _earthRadiusMeters * math.asin(math.min(1, math.sqrt(h)));
}

/// Distance from the start of [line] to each of its vertices, in meters.
List<double> routeCumulativeMeters(List<LatLng> line) {
  final result = List<double>.filled(line.length, 0);
  for (var i = 1; i < line.length; i++) {
    result[i] = result[i - 1] + routeMetersBetween(line[i - 1], line[i]);
  }
  return result;
}

/// The point [targetMeters] along [line], interpolated between the two vertices
/// that straddle it so a cut lands on the road rather than on a corner, and
/// clamped to the ends of the line.
LatLng routePointAt(
  List<LatLng> line,
  List<double> cumulative,
  double targetMeters,
) {
  final target = targetMeters.clamp(0.0, cumulative.last).toDouble();

  var index = 0;
  while (index < line.length - 2 && cumulative[index + 1] < target) {
    index++;
  }

  final span = cumulative[index + 1] - cumulative[index];
  // Vertices can repeat in a detailed geometry; there is no stretch to walk.
  if (span <= 0) return line[index];

  final t = (target - cumulative[index]) / span;
  final from = line[index];
  final to = line[index + 1];
  return LatLng(
    from.latitude + (to.latitude - from.latitude) * t,
    from.longitude + (to.longitude - from.longitude) * t,
  );
}

/// Cuts [line] at every sample and paints each stretch with the worst severity
/// of the two samples bounding it.
///
/// The server reports the weather at up to 25 points along the route
/// (docs/12-route-weather.md §5.1), so one stretch is as long as the gap
/// between two samples: a stretch is never more certain than the readings that
/// bound it. Neighbouring stretches of the same severity are joined back
/// together, which keeps the layer down to a handful of polylines.
///
/// Without a forecast the whole line comes back as one stretch in the brand
/// colour - exactly how the map drew it before any weather arrived.
List<RouteSegment> buildRouteSegments(
  List<LatLng> line,
  List<RouteWeatherSample> samples,
) {
  if (line.length < 2) return const [];

  final cumulative = routeCumulativeMeters(line);
  final total = cumulative.last;

  final ordered = [...samples]..sort(
      (a, b) => a.distanceFromStartMeters.compareTo(b.distanceFromStartMeters),
    );

  if (ordered.length < 2) {
    return [
      RouteSegment(
        points: line,
        severity: RouteSeverity.info,
        startMeters: 0,
        endMeters: total,
      ),
    ];
  }

  // Where a sample sits along the route, never past either end.
  double at(RouteWeatherSample sample) =>
      sample.distanceFromStartMeters.toDouble().clamp(0.0, total).toDouble();

  final stretches = <RouteSegment>[];
  for (var i = 0; i < ordered.length - 1; i++) {
    final start = at(ordered[i]);
    final end = at(ordered[i + 1]);
    if (end <= start) continue;
    stretches.add(
      RouteSegment(
        points: _slice(line, cumulative, start, end),
        severity: _stretchSeverity(ordered[i], ordered[i + 1]),
        startMeters: start,
        endMeters: end,
      ),
    );
  }

  // A plan whose first sample does not sit at the origin, or whose last sample
  // does not sit at the destination, still needs those ends drawn: each takes
  // the severity of the reading nearest it.
  if (stretches.isEmpty) {
    return [
      RouteSegment(
        points: line,
        severity: _onlySeverity(ordered.first),
        startMeters: 0,
        endMeters: total,
      ),
    ];
  }
  if (stretches.first.startMeters > 0) {
    stretches.insert(
      0,
      RouteSegment(
        points: _slice(line, cumulative, 0, stretches.first.startMeters),
        severity: _onlySeverity(ordered.first),
        startMeters: 0,
        endMeters: stretches.first.startMeters,
      ),
    );
  }
  if (stretches.last.endMeters < total) {
    final last = stretches.last;
    stretches.add(
      RouteSegment(
        points: _slice(line, cumulative, last.endMeters, total),
        severity: last.severity,
        startMeters: last.endMeters,
        endMeters: total,
      ),
    );
  }

  return _merge(stretches);
}

/// The vertices of [line] between [startMeters] and [endMeters], with an
/// interpolated vertex at each end so neighbouring stretches meet without a gap.
List<LatLng> _slice(
  List<LatLng> line,
  List<double> cumulative,
  double startMeters,
  double endMeters,
) {
  final points = <LatLng>[routePointAt(line, cumulative, startMeters)];
  for (var i = 0; i < line.length; i++) {
    if (cumulative[i] > startMeters && cumulative[i] < endMeters) {
      points.add(line[i]);
    }
  }
  points.add(routePointAt(line, cumulative, endMeters));
  return points;
}

/// Joins neighbouring stretches that share a severity, so a route with twenty
/// samples does not need twenty polylines.
List<RouteSegment> _merge(List<RouteSegment> stretches) {
  final merged = <RouteSegment>[];
  for (final stretch in stretches) {
    if (stretch.points.length < 2) continue;
    final last = merged.isEmpty ? null : merged.last;
    if (last != null && last.severity == stretch.severity) {
      merged[merged.length - 1] = RouteSegment(
        points: [...last.points, ...stretch.points.sublist(1)],
        severity: last.severity,
        startMeters: last.startMeters,
        endMeters: stretch.endMeters,
      );
    } else {
      merged.add(stretch);
    }
  }
  return merged;
}

/// The severity of the stretch between two samples: the worst of what either
/// end reports, or [routeSeverityUnknown] when neither end has a reading.
///
/// This is the rule the timeline flags a leg with (`route_timeline.dart`), so
/// the map and the cards can never disagree about the same stretch.
String _stretchSeverity(RouteWeatherSample a, RouteWeatherSample b) {
  final known = <String>[
    if (_hasReading(a)) a.severity,
    if (_hasReading(b)) b.severity,
  ];
  return known.isEmpty ? routeSeverityUnknown : RouteSeverity.highest(known);
}

/// The severity of one sample on its own, for the stretches past the first and
/// last readings.
String _onlySeverity(RouteWeatherSample sample) =>
    _hasReading(sample) ? sample.severity : routeSeverityUnknown;

/// Whether the forecast actually says something about the weather at [sample].
///
/// A stale reading is still a reading - it is the best the app knows - so only
/// a sample that never arrived counts as missing.
bool _hasReading(RouteWeatherSample sample) =>
    sample.hasWeather && sample.status != 'unavailable';
