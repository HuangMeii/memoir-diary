import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/data/providers.dart';
import 'package:memoir_app/src/ui/route/route_format.dart';
import 'package:memoir_app/src/ui/route/route_map_view.dart';

RouteWeatherSample sample(
  int seq, {
  String severity = RouteSeverity.info,
  String kind = 'sample',
  int km = 0,
}) =>
    RouteWeatherSample(
      seq: seq,
      label: kind == 'sample' ? 'Km $km' : 'Điểm $seq',
      kind: kind,
      lat: 10 + seq.toDouble(),
      lon: 106,
      distanceFromStartMeters: km * 1000,
      arrivalAt: DateTime.utc(2026, 10, 11, 6).add(Duration(minutes: seq * 30)),
      weatherCode: 0,
      weatherGroup: 'sunny',
      severity: severity,
      reasons: const [],
      status: 'forecast',
    );

void main() {
  group('route formatting', () {
    test('distances read naturally at every scale', () {
      expect(formatKm(305400), '305 km');
      expect(formatKm(18400), '18,4 km');
      expect(formatKm(9500), '9,5 km');
    });

    test('durations drop the part that is zero', () {
      expect(formatDuration(23400), '6 giờ 30 phút');
      expect(formatDuration(7200), '2 giờ');
      expect(formatDuration(2700), '45 phút');
    });
  });

  group('RouteStop', () {
    test('copies fields without touching the rest', () {
      const stop = RouteStop(
        name: 'Đà Lạt',
        lat: 11.94,
        lon: 108.45,
        dwellMinutes: 30,
        kind: 'waypoint',
      );
      final moved = stop.copyWith(lat: 12, name: 'Bảo Lộc');

      expect(moved.lat, 12);
      expect(moved.name, 'Bảo Lộc');
      expect(moved.lon, 108.45);
      expect(moved.dwellMinutes, 30);
      expect(moved.kind, 'waypoint');
    });

    test('equality follows every field, so queries cache by value', () {
      const a = RouteStop(name: 'A', lat: 1, lon: 2, kind: 'origin');
      const b = RouteStop(name: 'A', lat: 1, lon: 2, kind: 'origin');
      const c = RouteStop(name: 'A', lat: 1, lon: 2, dwellMinutes: 15);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });

  group('RouteQuery', () {
    const stops = [
      RouteStop(name: 'Hà Nội', lat: 21, lon: 105, kind: 'origin'),
      RouteStop(name: 'Đà Lạt', lat: 11, lon: 108, kind: 'destination'),
    ];
    final departure = DateTime.utc(2026, 10, 11, 6);

    test('is the same query for the same inputs', () {
      final a = RouteQuery(stops: stops, vehicle: 'car', departureAt: departure);
      final b =
          RouteQuery(stops: [...stops], vehicle: 'car', departureAt: departure);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('changes when the vehicle changes', () {
      expect(
        RouteQuery(stops: stops, vehicle: 'car', departureAt: departure) ==
            RouteQuery(stops: stops, vehicle: 'bike', departureAt: departure),
        isFalse,
      );
    });

    test('changes when the departure time changes', () {
      expect(
        RouteQuery(stops: stops, vehicle: 'car', departureAt: departure) ==
            RouteQuery(
              stops: stops,
              vehicle: 'car',
              departureAt: departure.add(const Duration(hours: 2)),
            ),
        isFalse,
      );
    });

    test('changes when a stop changes', () {
      expect(
        RouteQuery(stops: stops, vehicle: 'car', departureAt: departure) ==
            RouteQuery(
              stops: [stops.first],
              vehicle: 'car',
              departureAt: departure,
            ),
        isFalse,
      );
    });
  });

  group('report helpers', () {
    RouteWeatherReport report(
      List<RouteWeatherSample> samples, {
      String source = 'api',
      String coverage = 'full',
    }) =>
        RouteWeatherReport(
          generatedAt: DateTime.utc(2026, 10, 11, 6),
          coverage: coverage,
          source: source,
          beyondRange: false,
          samples: samples,
          alerts: const [],
          notes: const [],
        );

    test('keeps only the stops for the timeline', () {
      final built = report([
        sample(0, kind: 'origin'),
        sample(1, km: 25),
        sample(2, km: 50, kind: 'destination'),
      ]);

      expect(built.stopSamples.map((s) => s.seq).toList(), [0, 2]);
    });

    test('reads the worst severity along the route', () {
      final built = report([
        sample(0, kind: 'origin'),
        sample(1, severity: RouteSeverity.caution),
        sample(2, severity: RouteSeverity.warning),
        sample(3, kind: 'destination'),
      ]);

      expect(built.worstSeverity, RouteSeverity.warning);
    });

    test('tells a cached answer from a live one, and from no answer', () {
      expect(report([sample(0)], source: 'cache').isStale, isTrue);
      expect(report([sample(0)], source: 'api').isStale, isFalse);

      final missing = report(const [], source: 'unavailable', coverage: 'none');
      expect(missing.isUnavailable, isTrue);
      expect(missing.isPartial, isFalse);
      expect(report([sample(0)], coverage: 'partial').isPartial, isTrue);
    });

    test('labels a severity for the chips', () {
      expect(RouteSeverity.label(RouteSeverity.info), 'Thuận lợi');
      expect(RouteSeverity.label(RouteSeverity.caution), 'Cần chú ý');
      expect(RouteSeverity.label(RouteSeverity.warning), 'Cảnh báo');
    });
  });

  group('journey plans', () {
    final detail = JourneyDetail(
      journey: Journey(
        id: 'j1',
        title: 'Đà Lạt',
        vehicle: 'car',
        departureAt: DateTime.utc(2026, 10, 11, 6),
        originName: 'TP. Hồ Chí Minh',
        originLat: 10.77,
        originLon: 106.7,
        destinationName: 'Đà Lạt',
        destinationLat: 11.94,
        destinationLon: 108.45,
        distanceMeters: 293000,
        durationSeconds: 228 * 60,
        geometry: '{"type":"LineString","coordinates":'
            '[[106.7,10.77],[108.45,11.94]]}',
      ),
      stops: const [
        JourneyStop(
          seq: 0,
          kind: 'origin',
          name: 'TP. Hồ Chí Minh',
          lat: 10.77,
          lon: 106.7,
          dwellMinutes: 0,
        ),
        JourneyStop(
          seq: 1,
          kind: 'waypoint',
          name: 'Đèo Bảo Lộc',
          lat: 11.54,
          lon: 107.8,
          dwellMinutes: 30,
        ),
        JourneyStop(
          seq: 2,
          kind: 'destination',
          name: 'Đà Lạt',
          lat: 11.94,
          lon: 108.45,
          dwellMinutes: 0,
        ),
      ],
      weatherPoints: const [],
    );

    test('rebuilds a plan from a saved trip, without inventing legs', () {
      final plan = planFromJourney(detail);

      expect(plan.stops, hasLength(3));
      expect(plan.stops[1].dwellMinutes, 30);
      expect(plan.stops[1].kind, 'waypoint');
      expect(plan.distanceMeters, 293000);
      expect(plan.durationSeconds, 228 * 60);
      expect(plan.geometry, detail.journey.geometry);
      // No legs on purpose: the server splits the stored duration instead.
      expect(plan.legs, isEmpty);
    });

    test('marks a trip as linked only when it has an entry', () {
      expect(detail.journey.isLinkedToEntry, isFalse);
      expect(detail.journey.hasSavedWeather, isFalse);
    });
  });

  group('map geometry', () {
    test('decodes GeoJSON lon/lat pairs into map points', () {
      final points = decodeRoutePoints(
        '{"type":"LineString","coordinates":[[106.7,10.77],[107.5,11.2]]}',
      );

      expect(points, hasLength(2));
      expect(points.first.latitude, 10.77);
      expect(points.first.longitude, 106.7);
      expect(points.last.latitude, 11.2);
    });

    test('survives an empty or malformed geometry', () {
      expect(decodeRoutePoints(''), isEmpty);
      expect(decodeRoutePoints('{}'), isEmpty);
      expect(decodeRoutePoints('{"coordinates":"nope"}'), isEmpty);
    });

    test('skips a lone ordinate and keeps any that follow the pair', () {
      final points = decodeRoutePoints(
        '{"coordinates":[[106.7],[106.7,10.77,3]]}',
      );

      expect(points, hasLength(1));
      expect(points.single.latitude, 10.77);
      expect(points.single.longitude, 106.7);
    });
  });
}

