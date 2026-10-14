import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/route/route_segments.dart';

/// One degree of latitude on the sphere the route maths uses: the same
/// `6371008.8` the server's haversine is written against.
const double degreeMeters = 6371008.8 * math.pi / 180;

/// How far a cut may sit from an exact vertex, in degrees.
///
/// The server reports sample distances as whole metres, so a cut can land up to
/// half a metre - about `5e-6` degrees - short of a vertex. That is still a
/// thousand times closer than snapping to the nearest vertex would be, which is
/// what these tests are about.
const double cutTolerance = 1e-5;

/// A straight north-bound line of four vertices, ~333,6 km long: the detailed
/// geometry OSRM returns, shortened to something a test can reason about. The
/// vertices sit one degree apart, which is one [degreeMeters] of road.
const List<LatLng> line = [
  LatLng(10, 106),
  LatLng(11, 106),
  LatLng(12, 106),
  LatLng(13, 106),
];

RouteWeatherSample sample(
  int seq, {
  required int meters,
  String severity = RouteSeverity.info,
  bool reading = true,
  String? status,
}) =>
    RouteWeatherSample(
      seq: seq,
      label: 'Km ${(meters / 1000).round()}',
      kind: 'sample',
      lat: 10 + meters / degreeMeters,
      lon: 106,
      distanceFromStartMeters: meters,
      arrivalAt: DateTime.utc(2026, 10, 11, 6).add(Duration(minutes: seq * 30)),
      weatherCode: reading ? 0 : null,
      weatherGroup: reading ? 'sunny' : null,
      severity: severity,
      reasons: const [],
      status: status ?? (reading ? 'forecast' : 'unavailable'),
    );

/// The severity of each stretch, in the order they run along the route.
List<String> severities(List<RouteSegment> segments) =>
    segments.map((segment) => segment.severity).toList();

/// Four samples: a good half, then a bad half, 25 km apart as the server
/// reports them.
List<RouteWeatherSample> halfBad() => [
      sample(0, meters: 0),
      sample(1, meters: degreeMeters.round()),
      sample(2, meters: (2 * degreeMeters).round(), severity: RouteSeverity.warning),
      sample(3, meters: (3 * degreeMeters).round(), severity: RouteSeverity.warning),
    ];

void main() {
  group('route distances', () {
    test('measures a degree of latitude like the server does', () {
      expect(
        routeMetersBetween(const LatLng(10, 106), const LatLng(11, 106)),
        closeTo(degreeMeters, 0.1),
      );
    });

    test('adds the vertices up from the start of the line', () {
      final cumulative = routeCumulativeMeters(line);

      expect(cumulative.first, 0);
      expect(cumulative.last, closeTo(3 * degreeMeters, 5));
      for (var i = 1; i < cumulative.length; i++) {
        expect(cumulative[i], greaterThan(cumulative[i - 1]));
      }
    });

    test('interpolates a point between two vertices', () {
      final cumulative = routeCumulativeMeters(line);
      final middle = routePointAt(line, cumulative, degreeMeters / 2);

      expect(middle.latitude, closeTo(10.5, cutTolerance));
      expect(middle.longitude, 106);
    });

    test('clamps a point past the end of the line to the last vertex', () {
      final cumulative = routeCumulativeMeters(line);
      final past = routePointAt(line, cumulative, 10 * degreeMeters);

      expect(past.latitude, closeTo(13, cutTolerance));
      expect(past.longitude, 106);
    });
  });

  group('route stretches', () {
    test('paints each stretch with the worst severity bounding it', () {
      final segments = buildRouteSegments(line, halfBad());

      expect(severities(segments), [RouteSeverity.info, RouteSeverity.warning]);
      expect(segments.first.startMeters, 0);
      expect(segments.first.endMeters, closeTo(degreeMeters, 1));
      expect(segments.last.endMeters, closeTo(3 * degreeMeters, 1));
    });

    test('meets the next stretch at the same point, so the line has no gap',
        () {
      final segments = buildRouteSegments(line, halfBad());

      expect(
        segments.first.points.last.latitude,
        closeTo(segments.last.points.first.latitude, 1e-9),
      );
      expect(
        segments.first.points.last.longitude,
        closeTo(segments.last.points.first.longitude, 1e-9),
      );
      // The cut sits on the sample, not on the nearest vertex: that is the
      // whole point of measuring along the road.
      expect(segments.first.points.last.latitude, closeTo(11, cutTolerance));
      // The vertex inside the bad half is kept, not smoothed away.
      expect(
        segments.last.points
            .any((point) => (point.latitude - 12).abs() < cutTolerance),
        isTrue,
      );
    });

    test('joins neighbouring stretches that share a severity', () {
      final segments = buildRouteSegments(line, [
        sample(0, meters: 0),
        sample(1, meters: (3 * degreeMeters).round()),
      ]);

      expect(segments, hasLength(1));
      expect(segments.single.startMeters, 0);
      expect(segments.single.endMeters, closeTo(3 * degreeMeters, 1));
      expect(segments.single.points.first.latitude, closeTo(10, cutTolerance));
      // The last sample sits a fraction of a metre short of the end of the
      // geometry, as whole-metre distances do, so the line is filled in all the
      // way to the destination anyway.
      expect(segments.single.points.last.latitude, closeTo(13, cutTolerance));
      expect(segments.single.points.length, greaterThanOrEqualTo(line.length));
    });

    test('hides a stretch with no reading on either end behind grey', () {
      final segments = buildRouteSegments(line, [
        sample(0, meters: 0, reading: false),
        sample(1, meters: degreeMeters.round(), reading: false),
        sample(2, meters: (3 * degreeMeters).round()),
      ]);

      expect(severities(segments), [routeSeverityUnknown, RouteSeverity.info]);
    });

    test('keeps a stale reading, because it is still the best the app knows',
        () {
      final segments = buildRouteSegments(line, [
        sample(
          0,
          meters: 0,
          severity: RouteSeverity.caution,
          status: 'stale',
        ),
        sample(1, meters: (3 * degreeMeters).round()),
      ]);

      expect(severities(segments), [RouteSeverity.caution]);
    });

    test('sorts samples that arrive out of order', () {
      final segments = buildRouteSegments(line, [
        sample(
          3,
          meters: (3 * degreeMeters).round(),
          severity: RouteSeverity.warning,
        ),
        sample(0, meters: 0),
        sample(
          2,
          meters: (2 * degreeMeters).round(),
          severity: RouteSeverity.warning,
        ),
        sample(1, meters: degreeMeters.round()),
      ]);

      expect(severities(segments), [RouteSeverity.info, RouteSeverity.warning]);
    });

    test('draws the whole line in the brand colour when there is no forecast',
        () {
      final withoutWeather = <List<RouteWeatherSample>>[
        <RouteWeatherSample>[],
        [sample(0, meters: 0)],
      ];

      for (final samples in withoutWeather) {
        final segments = buildRouteSegments(line, samples);

        expect(segments, hasLength(1));
        expect(segments.single.severity, RouteSeverity.info);
        expect(segments.single.startMeters, 0);
        expect(segments.single.endMeters, closeTo(3 * degreeMeters, 1));
        expect(segments.single.points, hasLength(line.length));
      }
    });

    test('draws the head of the route when the first sample sits further along',
        () {
      final segments = buildRouteSegments(line, [
        sample(1, meters: degreeMeters.round()),
        sample(
          2,
          meters: (3 * degreeMeters).round(),
          severity: RouteSeverity.warning,
        ),
      ]);

      expect(severities(segments), [RouteSeverity.info, RouteSeverity.warning]);
      expect(segments.first.startMeters, 0);
      expect(segments.first.endMeters, closeTo(degreeMeters, 1));
    });

    test('clamps a sample that sits past the end of the geometry', () {
      final segments = buildRouteSegments(line, [
        sample(0, meters: 0),
        sample(1, meters: (10 * degreeMeters).round()),
      ]);

      expect(segments, hasLength(1));
      expect(segments.single.endMeters, closeTo(3 * degreeMeters, 1));
    });

    test('answers which stretch holds a sample, so the map can thicken it', () {
      final segments = buildRouteSegments(line, halfBad());

      expect(segments.first.covers(0), isTrue);
      expect(segments.first.covers(degreeMeters.roundToDouble()), isTrue);
      expect(segments.first.covers(3 * degreeMeters), isFalse);
      expect(segments.last.covers(2 * degreeMeters), isTrue);
    });

    test('draws nothing when the geometry is too short to be a line', () {
      final samples = [sample(0, meters: 0), sample(1, meters: 1000)];

      expect(buildRouteSegments(const [], samples), isEmpty);
      expect(
        buildRouteSegments(const [LatLng(10, 106)], samples),
        isEmpty,
      );
    });
  });
}
