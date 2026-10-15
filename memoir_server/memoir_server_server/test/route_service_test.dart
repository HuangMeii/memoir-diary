import 'package:memoir_server_server/src/generated/protocol.dart';
import 'package:memoir_server_server/src/route/route_rules.dart';
import 'package:memoir_server_server/src/route/route_service.dart';
import 'package:test/test.dart';

/// A straight line between two points, [segments] apart.
List<RouteCoord> straightLine(RouteCoord from, RouteCoord to, int segments) => [
      for (var i = 0; i <= segments; i++)
        RouteCoord(
          from.lat + (to.lat - from.lat) * i / segments,
          from.lon + (to.lon - from.lon) * i / segments,
        ),
    ];

RouteStop stop(
  String name,
  double lat,
  double lon, {
  String kind = 'waypoint',
  int dwell = 0,
}) =>
    RouteStop(name: name, lat: lat, lon: lon, kind: kind, dwellMinutes: dwell);

RouteWeatherSample sample(
  int seq,
  String severity, {
  String kind = 'sample',
  int km = 0,
  List<String> reasons = const [],
}) =>
    RouteWeatherSample(
      seq: seq,
      label: kind == 'sample' ? 'Km $km' : 'Điểm $seq',
      kind: kind,
      lat: 10,
      lon: 106,
      distanceFromStartMeters: km * 1000,
      arrivalAt: DateTime.utc(2026, 10, 11, 6).add(Duration(minutes: seq * 10)),
      severity: severity,
      reasons: reasons,
      status: 'forecast',
    );

HourlySeries series({
  required double lat,
  required double lon,
  required List<DateTime> times,
  double temp = 25,
  double precip = 0,
  int probability = 0,
  double wind = 5,
  double gust = 10,
  double visibility = 10000,
  int code = 0,
}) =>
    HourlySeries(
      lat: lat,
      lon: lon,
      times: times,
      temperature: List<double?>.filled(times.length, temp),
      precipitation: List<double?>.filled(times.length, precip),
      probability: List<int?>.filled(times.length, probability),
      windSpeed: List<double?>.filled(times.length, wind),
      windGust: List<double?>.filled(times.length, gust),
      visibility: List<double?>.filled(times.length, visibility),
      weatherCode: List<int?>.filled(times.length, code),
    );

void main() {
  group('route backends', () {
    test('empty environment falls back to the public instances', () {
      final backends = resolveRouteBackends(const {});

      expect(
        backends['car'],
        'https://routing.openstreetmap.de/routed-car/route/v1/driving',
      );
      expect(
        backends['bike'],
        'https://routing.openstreetmap.de/routed-bike/route/v1/driving',
      );
      expect(
        backends['foot'],
        'https://routing.openstreetmap.de/routed-foot/route/v1/driving',
      );
      expect(usesPublicRouteBackends(backends), isTrue);
    });

    test('environment overrides win over the defaults', () {
      final backends = resolveRouteBackends(const {
        'ROUTE_API_URL_CAR': 'http://localhost:5000/route/v1/driving',
        'ROUTE_API_URL_BIKE': 'http://localhost:5001/route/v1/driving',
        'ROUTE_API_URL_FOOT': 'http://localhost:5002/route/v1/driving',
      });

      expect(backends['car'], 'http://localhost:5000/route/v1/driving');
      expect(backends['bike'], 'http://localhost:5001/route/v1/driving');
      expect(backends['foot'], 'http://localhost:5002/route/v1/driving');
      expect(usesPublicRouteBackends(backends), isFalse);
    });

    test('blank values and stray spaces fall back or get trimmed', () {
      final backends = resolveRouteBackends(const {
        'ROUTE_API_URL_CAR': '   ',
        'ROUTE_API_URL_BIKE': '  http://localhost:5001/route/v1/driving  ',
      });

      expect(
        backends['car'],
        'https://routing.openstreetmap.de/routed-car/route/v1/driving',
      );
      expect(backends['bike'], 'http://localhost:5001/route/v1/driving');
      expect(usesPublicRouteBackends(backends), isTrue);
    });
  });

  group('vietnam pins', () {
    test('a Hanoi–HCMC crossing line leaves, real border towns do not', () {
      // Simplified shape of the real OSRM answer: exits around 18.2°N,
      // runs through Laos (~104.8-105.1E) before re-entering at Dong Nai.
      final crossing = [
        const RouteCoord(21.03, 105.85),
        const RouteCoord(18.45, 105.23),
        const RouteCoord(18.20, 104.98),
        const RouteCoord(17.41, 104.83),
        const RouteCoord(16.28, 105.13),
        const RouteCoord(10.78, 106.70),
      ];
      expect(routeLeavesVietnam(crossing), isTrue);

      // Real border towns keep their roads: Dien Bien Phu (far west),
      // Ha Giang (far north), Ha Tien and Phu Quoc (far south-west).
      final borderTowns = [
        const RouteCoord(21.39, 103.02),
        const RouteCoord(22.83, 104.99),
        const RouteCoord(10.38, 104.48),
        const RouteCoord(10.23, 103.96),
      ];
      expect(routeLeavesVietnam(borderTowns), isFalse);
    });

    test('one or two stray vertices do not count as leaving', () {
      final stray = [
        const RouteCoord(21.03, 105.85),
        const RouteCoord(18.20, 104.90),
        const RouteCoord(18.45, 105.23),
        const RouteCoord(16.06, 108.21),
      ];
      expect(routeLeavesVietnam(stray), isFalse);
    });

    test('pins spread evenly instead of bunching in the north', () {
      final pins = vietnamPinsBetween(
        const RouteCoord(21.0283, 105.8540),
        const RouteCoord(10.7769, 106.7009),
      );
      expect(pins.length, routeVietnamMaxPins);
      // Travel order: descending latitude for a north-to-south trip.
      for (var i = 1; i < pins.length; i++) {
        expect(pins[i].lat, lessThan(pins[i - 1].lat));
      }
      // Even spread: one pin per third of the span — north, middle, south.
      // The old closest-to-connector pick bunched Hue/Dong Ha/Da Nang and
      // left the ~900 km Da Nang–HCMC leg free to swing through Cambodia.
      expect(pins[0].lat, greaterThan(16.0));
      expect(pins[1].lat, greaterThan(13.0));
      expect(pins[1].lat, lessThan(17.0));
      expect(pins[2].lat, lessThan(14.0));
    });

    test('a short hop spans no pins', () {
      expect(
        vietnamPinsBetween(
          const RouteCoord(21.0283, 105.8540),
          const RouteCoord(20.0000, 105.9000),
        ),
        isEmpty,
      );
    });

    test('merging folds pinned legs back onto one user leg', () {
      RouteLeg leg(int meters, int seconds) => RouteLeg(
            distanceMeters: meters,
            durationSeconds: seconds,
            toIndex: 0,
          );
      final merged = mergePinnedLegs(
        rawLegs: [leg(100, 10), leg(200, 20), leg(300, 30), leg(400, 40)],
        userLegCount: 1,
        pinCount: 3,
      );
      expect(merged, hasLength(1));
      expect(merged.first.distanceMeters, 1000);
      expect(merged.first.durationSeconds, 100);
      expect(merged.first.toIndex, 1);
    });

    test('merging keeps later user legs one-to-one', () {
      RouteLeg leg(int meters, int seconds) => RouteLeg(
            distanceMeters: meters,
            durationSeconds: seconds,
            toIndex: 0,
          );
      final merged = mergePinnedLegs(
        rawLegs: [leg(100, 1), leg(200, 2), leg(300, 3)],
        userLegCount: 2,
        pinCount: 1,
      );
      expect(merged, hasLength(2));
      expect(merged[0].distanceMeters, 300);
      expect(merged[1].distanceMeters, 300);
      expect(merged[1].toIndex, 2);
    });

    test('merging passes through mismatched raw legs untouched', () {
      RouteLeg leg(int meters) => RouteLeg(
            distanceMeters: meters,
            durationSeconds: 0,
            toIndex: 0,
          );
      final raw = [leg(100), leg(200)];
      expect(
        mergePinnedLegs(rawLegs: raw, userLegCount: 1, pinCount: 3),
        same(raw),
      );
    });
  });

  group('geometry', () {
    test('haversine matches a degree of latitude', () {
      final meters = haversineMeters(
        const RouteCoord(10, 106),
        const RouteCoord(11, 106),
      );
      expect(meters, closeTo(111195, 300));
    });

    test('cumulative distances start at zero and grow', () {
      final line =
          straightLine(const RouteCoord(10, 106), const RouteCoord(11, 106), 4);
      final cumulative = cumulativeMeters(line);

      expect(cumulative.first, 0);
      expect(cumulative.last, closeTo(111195, 300));
      for (var i = 1; i < cumulative.length; i++) {
        expect(cumulative[i], greaterThan(cumulative[i - 1]));
      }
    });

    test('pointAtDistance clamps and interpolates', () {
      final line = [
        const RouteCoord(0, 0),
        const RouteCoord(0, 1),
        const RouteCoord(0, 2),
      ];
      final cumulative = cumulativeMeters(line);
      final total = cumulative.last;

      expect(pointAtDistance(line, cumulative, -5).lon, 0);
      expect(pointAtDistance(line, cumulative, total * 2).lon, 2);

      final middle = pointAtDistance(line, cumulative, total / 4);
      expect(middle.lat, closeTo(0, 0.0001));
      expect(middle.lon, closeTo(0.5, 0.01));
    });

    test('decodeLineString reads GeoJSON lon/lat pairs', () {
      final line = decodeLineString(
        '{"type":"LineString","coordinates":[[106.0,10.0],[107.5,11.25]]}',
      );
      expect(line, hasLength(2));
      expect(line.first.lat, 10.0);
      expect(line.first.lon, 106.0);
      expect(line.last.lat, 11.25);
    });

    test('decodeLineString survives junk', () {
      expect(decodeLineString('{}'), isEmpty);
      expect(decodeLineString('{"coordinates":"nope"}'), isEmpty);
    });

    test('normalizeStops forces the kinds by position', () {
      final stops = normalizeStops([
        stop('A', 10, 106, kind: 'waypoint'),
        stop('  ', 10.5, 106),
        stop('B', 11, 106, kind: 'origin'),
        stop('C', 11.5, 106, kind: 'origin'),
      ]);

      expect(stops.map((s) => s.name).toList(), ['A', 'B', 'C']);
      expect(stops.map((s) => s.kind).toList(), [
        'origin',
        'waypoint',
        'destination',
      ]);
    });

    test('sends the query untouched and filters by country parameter', () {
      final params = geocodingParams('Đà Lạt', 8);
      // Nothing is appended: a comma would switch Nominatim to its structured
      // form and demand an exact admin-area name.
      expect(params['q'], 'Đà Lạt');
      expect(params['countrycodes'], 'vn');
      expect(params['accept-language'], 'vi');
    });

    test('keeps a comma in the query as the user typed it', () {
      expect(
        geocodingParams('140 Lê Trọng Tấn, Phường Tây Thạnh', 8)['q'],
        '140 Lê Trọng Tấn, Phường Tây Thạnh',
      );
    });

    test('clamps the geocoding limit', () {
      expect(geocodingParams('a', 0)['limit'], '1');
      expect(geocodingParams('a', 8)['limit'], '8');
      expect(geocodingParams('a', 500)['limit'], '20');
    });

    test('reads a Nominatim street address, strings and all', () {
      final place = fromNominatim({
        'name': 'Trường Đại học Công Thương Thành phố Hồ Chí Minh',
        'display_name': 'Trường Đại học Công Thương Thành phố Hồ Chí Minh, '
            '140, Lê Trọng Tấn, Khu phố 21, Phường Tây Thạnh, '
            'Thành phố Hồ Chí Minh, 72009, Việt Nam',
        'lat': '10.8070354',
        'lon': '106.6287031',
        'address': {
          'house_number': '140',
          'road': 'Lê Trọng Tấn',
          'suburb': 'Phường Tây Thạnh',
          'city': 'Thành phố Hồ Chí Minh',
          'postcode': '72009',
          'country': 'Việt Nam',
        },
      });

      expect(place.name, startsWith('Trường Đại học'));
      expect(place.admin, 'Thành phố Hồ Chí Minh');
      expect(place.country, 'Việt Nam');
      // lat/lon arrive as strings, not numbers.
      expect(place.lat, closeTo(10.8070354, 0.0001));
      expect(place.lon, closeTo(106.6287031, 0.0001));
    });

    test('falls back to display_name for a bare street', () {
      final place = fromNominatim({
        'display_name': 'Lê Trọng Tấn, Phường Tây Thạnh, '
            'Thành phố Hồ Chí Minh, 72009, Việt Nam',
        'lat': '10.8070',
        'lon': '106.6287',
        'address': {
          'road': 'Lê Trọng Tấn',
          'suburb': 'Phường Tây Thạnh',
          'country': 'Việt Nam',
        },
      });

      expect(place.name, startsWith('Lê Trọng Tấn'));
      // No `city`, so the ward is the nearest thing to an area.
      expect(place.admin, 'Phường Tây Thạnh');
    });

    test('survives a Nominatim row with nothing in it', () {
      final place = fromNominatim({});
      expect(place.name, '');
      expect(place.admin, isNull);
      expect(place.country, isNull);
      expect(place.lat, 0);
      expect(place.lon, 0);
    });
  });

  group('routing failures', () {
    test('a normal answer is not a failure', () {
      expect(
        routeFailureFor({'code': 'Ok', 'routes': [{'distance': 1}]}, [
          {'distance': 1},
        ]),
        isNull,
      );
    });

    test('an empty route list is noRoute', () {
      expect(
        routeFailureFor({'code': 'Ok', 'routes': const []}, const [])?.code,
        'noRoute',
      );
    });

    test('NoRoute is noRoute', () {
      expect(
        routeFailureFor({'code': 'NoRoute'}, const [])?.code,
        'noRoute',
      );
    });

    // OSRM refuses a point at 0,0 outright, which is what an unplaced stop
    // looks like: a different problem from two places with no road between.
    test('InvalidOptions says the points are missing, not that no road exists', () {
      final failure = routeFailureFor({
        'code': 'InvalidOptions',
        'message': 'Welcome to Null Island...',
      }, const []);

      expect(failure?.code, 'noPoints');
      expect(failure?.message, contains('chưa xác định được vị trí'));
    });

    test('a body that is not even JSON is noRoute, not a crash', () {
      expect(routeFailureFor('nope', const [])?.code, 'noRoute');
    });
  });

  group('sampling', () {
    test('keeps every stop and adds points every 25 km', () {
      // 300 km straight north, waypoint in the middle.
      final line = straightLine(
        const RouteCoord(10, 106),
        const RouteCoord(12.7, 106),
        300,
      );
      final plan = planRouteSamples(
        line: line,
        stops: [
          stop('A', 10, 106, kind: 'origin'),
          stop('B', 11.35, 106, kind: 'waypoint'),
          stop('C', 12.7, 106, kind: 'destination'),
        ],
      );

      expect(plan.points.first.kind, 'origin');
      expect(plan.points.last.kind, 'destination');
      expect(plan.points.where((point) => point.kind == 'waypoint'), hasLength(1));

      // One point per 25 km step along both legs, and every stop kept.
      final interior =
          plan.points.where((point) => point.kind == 'sample').toList();
      expect(interior, isNotEmpty);
      for (var i = 1; i < interior.length; i++) {
        final gap = interior[i].distanceMeters - interior[i - 1].distanceMeters;
        expect(gap, greaterThan(24000));
        expect(gap, lessThan(26000));
      }
      expect(
        plan.points.where((point) => point.stopIndex != null),
        hasLength(3),
      );
    });

    test('thins the samples instead of dropping stops on a long route', () {
      final line = straightLine(
        const RouteCoord(10, 106),
        const RouteCoord(28, 106),
        400,
      );
      final plan = planRouteSamples(
        line: line,
        stops: [
          stop('A', 10, 106, kind: 'origin'),
          stop('B', 16, 106),
          stop('C', 22, 106),
          stop('D', 28, 106, kind: 'destination'),
        ],
      );

      expect(plan.points.length, lessThanOrEqualTo(routeMaxSamples));
      expect(plan.points.where((point) => point.stopIndex != null), hasLength(4));

      final distances =
          plan.points.map((point) => point.distanceMeters).toList();
      for (var i = 1; i < distances.length; i++) {
        expect(distances[i], greaterThanOrEqualTo(distances[i - 1]));
      }
    });

    test('a stop never sits on top of a plain sample', () {
      final line = straightLine(
        const RouteCoord(10, 106),
        const RouteCoord(12.7, 106),
        300,
      );
      final plan = planRouteSamples(
        line: line,
        stops: [
          stop('A', 10, 106, kind: 'origin'),
          // Exactly one 25 km step in, where a plain sample would land.
          stop('B', 10 + 25 / 111.195, 106),
          stop('C', 12.7, 106, kind: 'destination'),
        ],
      );

      final atStop = plan.points
          .where((point) => (point.distanceMeters - plan.stopDistances[1]).abs() < 100)
          .toList();
      expect(atStop, hasLength(1));
      expect(atStop.single.kind, 'waypoint');
    });

    test('needs a line and two stops', () {
      expect(
        () => planRouteSamples(
          line: const [RouteCoord(10, 106)],
          stops: [stop('A', 10, 106), stop('B', 11, 106)],
        ),
        throwsA(isA<RouteFailure>()),
      );
    });
  });

  group('arrival times', () {
    test('adds the dwell at waypoints between the legs', () {
      final line = straightLine(
        const RouteCoord(10, 106),
        const RouteCoord(12.7, 106),
        300,
      );
      final stops = [
        stop('A', 10, 106, kind: 'origin'),
        stop('B', 11.35, 106, dwell: 30),
        stop('C', 12.7, 106, kind: 'destination'),
      ];
      final plan = planRouteSamples(line: line, stops: stops);
      final arrivals = arrivalTimes(
        points: plan.points,
        stopDistances: plan.stopDistances,
        stops: stops,
        legs: [
          RouteLeg(distanceMeters: 150000, durationSeconds: 3600, toIndex: 1),
          RouteLeg(distanceMeters: 150000, durationSeconds: 7200, toIndex: 2),
        ],
        totalDurationSeconds: 10800,
        departureAt: DateTime.utc(2026, 10, 11, 6),
      );

      final origin = plan.points.indexWhere((point) => point.kind == 'origin');
      final waypoint = plan.points.indexWhere((point) => point.kind == 'waypoint');
      final destination =
          plan.points.indexWhere((point) => point.kind == 'destination');

      expect(arrivals[origin], DateTime.utc(2026, 10, 11, 6));
      expect(arrivals[waypoint], DateTime.utc(2026, 10, 11, 7));
      // The 2 h leg plus the half hour spent at the waypoint.
      expect(arrivals[destination], DateTime.utc(2026, 10, 11, 9, 30));
    });

    test('places a sample partway along its leg', () {
      final points = [
        const RouteSamplePoint(
          distanceMeters: 0,
          coord: RouteCoord(10, 106),
          kind: 'origin',
          label: 'A',
          stopIndex: 0,
        ),
        const RouteSamplePoint(
          distanceMeters: 55597.5,
          coord: RouteCoord(10.5, 106),
          kind: 'sample',
          label: 'Km 56',
        ),
        const RouteSamplePoint(
          distanceMeters: 111195,
          coord: RouteCoord(11, 106),
          kind: 'destination',
          label: 'B',
          stopIndex: 1,
        ),
      ];
      final arrivals = arrivalTimes(
        points: points,
        stopDistances: const [0, 111195],
        stops: [
          stop('A', 10, 106, kind: 'origin'),
          stop('B', 11, 106, kind: 'destination'),
        ],
        legs: [
          RouteLeg(distanceMeters: 111195, durationSeconds: 3600, toIndex: 1),
        ],
        totalDurationSeconds: 3600,
        departureAt: DateTime.utc(2026, 10, 11, 6),
      );

      expect(arrivals[1], DateTime.utc(2026, 10, 11, 6, 30));
    });

    test('spreads the total duration when the engine sent no legs', () {
      final durations = legDurations(
        stopDistances: const [0, 100000, 300000],
        legs: const [],
        totalDurationSeconds: 7200,
      );

      expect(durations, hasLength(2));
      // Spans are 100 km and 200 km of a 300 km route, so a quarter and three
      // quarters of the total duration.
      expect(durations.first, 2400);
      expect(durations.last, 4800);
      expect(durations.reduce((a, b) => a + b), 7200);
    });

    test('keeps the engine durations when the legs line up', () {
      final durations = legDurations(
        stopDistances: const [0, 100000, 300000],
        legs: [
          RouteLeg(distanceMeters: 100000, durationSeconds: 111, toIndex: 1),
          RouteLeg(distanceMeters: 200000, durationSeconds: 222, toIndex: 2),
        ],
        totalDurationSeconds: 999,
      );

      expect(durations, [111, 222]);
    });
  });

  group('hour lookup', () {
    final times = [
      DateTime.utc(2026, 10, 11, 0),
      DateTime.utc(2026, 10, 11, 1),
      DateTime.utc(2026, 10, 11, 2),
      DateTime.utc(2026, 10, 11, 3),
    ];

    test('picks the hour that has already started', () {
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 0)), 0);
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 0, 59)), 0);
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 1)), 1);
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 2, 30)), 2);
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 3)), 3);
    });

    test('clamps before the window and reports the horizon', () {
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 10, 20)), 0);
      expect(hourIndexFor(times, DateTime.utc(2026, 10, 11, 3, 1)), isNull);
      expect(hourIndexFor(const [], DateTime.utc(2026)), isNull);
    });
  });

  group('adverse weather rules', () {
    test('a calm reading stays info', () {
      final verdict = evaluateRouteConditions(
        const RouteConditions(
          weatherCode: 0,
          tempC: 24,
          precipitationMm: 0,
          precipitationProbability: 5,
          windSpeedKmh: 6,
          windGustKmh: 12,
          visibilityMeters: 20000,
        ),
      );

      expect(verdict.severity, RouteSeverity.info);
      expect(verdict.reasons, isEmpty);
      expect(verdict.isCaution, isFalse);
    });

    test('flags moderate and heavy rain at their thresholds', () {
      expect(
        evaluateRouteConditions(const RouteConditions(precipitationMm: 2.5))
            .severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(
          const RouteConditions(
            precipitationMm: 1,
            precipitationProbability: 60,
          ),
        ).severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(
          const RouteConditions(
            precipitationMm: 0.4,
            precipitationProbability: 90,
          ),
        ).severity,
        RouteSeverity.info,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(precipitationMm: 7.6))
            .severity,
        RouteSeverity.warning,
      );
    });

    test('flags a thunderstorm code and strong gusts', () {
      expect(
        evaluateRouteConditions(const RouteConditions(weatherCode: 95)).severity,
        RouteSeverity.warning,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(windGustKmh: 60)).severity,
        RouteSeverity.warning,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(windSpeedKmh: 40)).severity,
        RouteSeverity.caution,
      );
      // A storm outranks the plain wind rule.
      expect(
        evaluateRouteConditions(
          const RouteConditions(weatherCode: 99, windSpeedKmh: 45),
        ).severity,
        RouteSeverity.warning,
      );
    });

    test('flags fog, heat and cold', () {
      expect(
        evaluateRouteConditions(const RouteConditions(weatherCode: 45)).severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(visibilityMeters: 900))
            .severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(tempC: 35)).severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(tempC: 10)).severity,
        RouteSeverity.caution,
      );
      expect(
        evaluateRouteConditions(const RouteConditions(tempC: 11)).severity,
        RouteSeverity.info,
      );
    });

    test('reports every reason and keeps the worst severity', () {
      final verdict = evaluateRouteConditions(
        const RouteConditions(
          weatherCode: 80,
          tempC: 36,
          precipitationMm: 9,
          windSpeedKmh: 45,
        ),
      );

      expect(verdict.severity, RouteSeverity.warning);
      expect(verdict.reasons, hasLength(3));
    });

    test('missing values never raise an alarm', () {
      expect(
        evaluateRouteConditions(const RouteConditions()).severity,
        RouteSeverity.info,
      );
    });
  });

  group('alerts and conditions', () {
    test('merges neighbouring notable samples into one stretch', () {
      final alerts = mergeAlerts([
        sample(0, RouteSeverity.info, km: 0, kind: 'origin'),
        sample(1, RouteSeverity.caution, km: 25, reasons: const ['Mưa vừa']),
        sample(2, RouteSeverity.warning, km: 50, reasons: const ['Gió mạnh']),
        sample(3, RouteSeverity.info, km: 75),
      ]);

      expect(alerts, hasLength(1));
      expect(alerts.single.severity, RouteSeverity.warning);
      expect(alerts.single.fromSeq, 1);
      expect(alerts.single.toSeq, 2);
      expect(alerts.single.summary, contains('Mưa vừa'));
      expect(alerts.single.summary, contains('Gió mạnh'));
      expect(alerts.single.title, 'Đoạn Km 25 – Km 50');
    });

    test('names the stretch after a stop when one is inside it', () {
      final alerts = mergeAlerts([
        sample(0, RouteSeverity.info, km: 0),
        sample(1, RouteSeverity.caution, km: 25),
        sample(2, RouteSeverity.caution, km: 50, kind: 'waypoint'),
        sample(3, RouteSeverity.info, km: 75),
      ]);

      expect(alerts, hasLength(1));
      expect(alerts.single.title, contains('Điểm 2'));
    });

    test('a one-sample stretch is a point, not a range', () {
      final alerts = mergeAlerts([
        sample(0, RouteSeverity.info, km: 0),
        sample(1, RouteSeverity.caution, km: 206),
        sample(2, RouteSeverity.info, km: 231),
      ]);

      expect(alerts, hasLength(1));
      expect(alerts.single.title, 'Đoạn Km 206');
    });

    test('a calm route has no alerts', () {
      expect(
        mergeAlerts([
          sample(0, RouteSeverity.info, km: 0),
          sample(1, RouteSeverity.info, km: 25),
        ]),
        isEmpty,
      );
    });

    test('matches the response entry nearest to the sample', () {
      final times = [
        DateTime.utc(2026, 10, 11, 6),
        DateTime.utc(2026, 10, 11, 7),
      ];
      final hourly = [
        series(lat: 10, lon: 106, times: times, temp: 30, code: 0),
        series(lat: 11.5, lon: 107.5, times: times, temp: 18, code: 63),
      ];

      final near = conditionsAt(
        hourly,
        const RouteCoord(11.52, 107.49),
        DateTime.utc(2026, 10, 11, 6, 30),
      );
      expect(near?.tempC, 18);
      expect(near?.weatherCode, 63);

      final far = conditionsAt(
        hourly,
        const RouteCoord(10.01, 106.01),
        DateTime.utc(2026, 10, 11, 6, 30),
      );
      expect(far?.tempC, 30);
    });

    test('past the horizon there is no reading', () {
      final hourly = [
        series(lat: 10, lon: 106, times: [DateTime.utc(2026, 10, 11, 6)]),
      ];

      expect(
        conditionsAt(
          hourly,
          const RouteCoord(10, 106),
          DateTime.utc(2026, 10, 20),
        ),
        isNull,
      );
      expect(
        conditionsAt(const [], const RouteCoord(10, 106), DateTime.utc(2026)),
        isNull,
      );
    });
  });

  group('departure comparison', () {
    RouteWeatherReport report({
      required String source,
      List<RouteWeatherSample> samples = const [],
    }) =>
        RouteWeatherReport(
          generatedAt: DateTime.utc(2026, 10, 11),
          coverage: samples.isEmpty ? 'none' : 'full',
          source: source,
          beyondRange: false,
          samples: samples,
          alerts: const [],
          notes: const [],
        );

    test('summarises an unavailable forecast instead of pretending', () {
      expect(
        headlineFor(RouteSeverity.info, report(source: 'unavailable')),
        'Chưa có dữ liệu dự báo',
      );
    });

    test('reads the worst sample severity', () {
      final full = report(
        source: 'api',
        samples: [sample(0, RouteSeverity.info, km: 0)],
      );

      expect(headlineFor(RouteSeverity.warning, full), 'Có đoạn thời tiết xấu');
      expect(headlineFor(RouteSeverity.caution, full), 'Có đoạn cần chú ý');
      expect(headlineFor(RouteSeverity.info, full), 'Điều kiện thuận lợi');
    });
  });
}



