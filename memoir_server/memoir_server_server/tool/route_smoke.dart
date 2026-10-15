// Smoke test against the real routing and weather providers. It is not part of
// the test suite: it talks to the network and only prints a summary, so it can
// be run by hand when a provider changes.
//
//   cd memoir_server/memoir_server_server
//   dart run tool/route_smoke.dart
//
// ignore_for_file: avoid_print
import 'package:memoir_server_server/src/generated/protocol.dart';
import 'package:memoir_server_server/src/route/route_service.dart';

Future<void> main() async {
  final stops = [
    RouteStop(
      name: 'TP. Hồ Chí Minh',
      lat: 10.7769,
      lon: 106.7009,
      dwellMinutes: 0,
      kind: 'origin',
    ),
    RouteStop(
      name: 'Đèo Bảo Lộc',
      lat: 11.5397,
      lon: 107.8020,
      dwellMinutes: 30,
      kind: 'waypoint',
    ),
    RouteStop(
      name: 'Đà Lạt',
      lat: 11.9404,
      lon: 108.4583,
      dwellMinutes: 0,
      kind: 'destination',
    ),
  ];

  print('--- geocoding ---');
  final places = await searchPlaces('Đà Lạt');
  print('${places.length} results: '
      '${places.take(3).map((p) => '${p.name} / ${p.admin}').join(' · ')}');

  print('--- routing ---');
  final plan = await fetchRoutePlan(stops: stops, vehicle: 'car');
  print('${(plan.distanceMeters / 1000).round()} km, '
      '${(plan.durationSeconds / 60).round()} min, '
      'legs=${plan.legs.length}, alternatives=${plan.alternatives.length}, '
      'geometry points=${decodeLineString(plan.geometry).length}');

  final twoPoint = await fetchRoutePlan(stops: [stops.first, stops.last], vehicle: 'car');
  print('two-point route alternatives=${twoPoint.alternatives.length}');

  print('--- Hanoi to HCMC (pinned-waypoint check) ---');
  final longHaul = await fetchRoutePlan(
    stops: [
      RouteStop(
        name: 'Ha Noi',
        lat: 21.0283334,
        lon: 105.8540410,
        dwellMinutes: 0,
        kind: 'origin',
      ),
      RouteStop(
        name: 'TP. Ho Chi Minh',
        lat: 10.7768899,
        lon: 106.7009019,
        dwellMinutes: 0,
        kind: 'destination',
      ),
    ],
    vehicle: 'car',
  );
  final longLine = decodeLineString(longHaul.geometry);
  print('${(longHaul.distanceMeters / 1000).round()} km, '
      '${(longHaul.durationSeconds / 3600).toStringAsFixed(1)} h, '
      'legs=${longHaul.legs.length}, stops=${longHaul.stops.length}, '
      'leavesVietnam=${routeLeavesVietnam(longLine)}');

  print('--- weather along the route ---');
  final departure = DateTime.now().toUtc().add(const Duration(hours: 12));
  final report = await weatherAlongRoute(plan: plan, departureAt: departure);
  print('coverage=${report.coverage} source=${report.source} '
      'beyond=${report.beyondRange} samples=${report.samples.length} '
      'alerts=${report.alerts.length}');
  if (report.notes.isNotEmpty) print('notes: ${report.notes.join(' | ')}');
  for (final sample in report.samples) {
    print('  #${sample.seq} ${sample.label} (${sample.kind}) '
        'km=${(sample.distanceFromStartMeters / 1000).round()} '
        'eta=${sample.arrivalAt.toIso8601String()} '
        '${sample.condition ?? '-'} ${sample.tempC ?? '-'}°C '
        'rain=${sample.precipitationMm ?? '-'}mm '
        '${sample.severity} ${sample.reasons} [${sample.status}]');
  }
  for (final alert in report.alerts) {
    print('  ! ${alert.severity} ${alert.title}: ${alert.summary} '
        '(${alert.startAt.toIso8601String()} → ${alert.endAt.toIso8601String()})');
  }

  print('--- departures ---');
  for (final option in await compareDepartures(
    plan: plan,
    departureAt: departure,
  )) {
    print('  ${option.offsetHours >= 0 ? '+' : ''}${option.offsetHours}h '
        '${option.headline} (${option.severity})');
  }
}
