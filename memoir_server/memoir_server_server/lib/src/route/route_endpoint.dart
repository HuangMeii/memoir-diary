import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
// Prefixed so the endpoint methods can keep the same names as the helpers they
// call (`plan`, `searchPlaces`, `compareDepartures`) without shadowing them.
import 'route_service.dart' as routing;

/// Route planning and the weather along a route
/// (docs/12-route-weather.md §9).
///
/// The client never talks to OSRM or Open-Meteo directly: this endpoint owns the
/// provider choice, the sampling rules, the adverse-weather rules and the
/// 30-minute cache, so all of that can change without touching the app.
class RouteEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Logged once per server run when the public OSRM graph is in use, so a
  /// forgotten `ROUTE_API_URL_*` shows up in the logs instead of silently
  /// drawing cross-border routes (docs/12 §19).
  static bool _publicBackendWarned = false;

  void _warnOnPublicBackends(Session session) {
    if (_publicBackendWarned || !routing.usesPublicRouteBackends()) return;
    _publicBackendWarned = true;
    session.log(routing.publicRouteBackendWarning);
  }

  /// Places matching [query], for the planner's search box.
  Future<List<PlaceCandidate>> searchPlaces(
    Session session,
    String query, {
    int? limit,
  }) async {
    try {
      return await routing.searchPlaces(query, limit: limit ?? 8);
    } on routing.RouteFailure catch (failure) {
      throw _api(failure);
    }
  }

  /// The route through [origin], the optional [waypoints] and [destination].
  Future<RoutePlan> plan(
    Session session, {
    required RouteStop origin,
    required RouteStop destination,
    List<RouteStop>? waypoints,
    String? vehicle,
    bool? alternatives,
  }) async {
    try {
      _warnOnPublicBackends(session);
      return await routing.fetchRoutePlan(
        stops: [origin, ...?waypoints, destination],
        vehicle: vehicle ?? 'car',
        wantAlternatives: alternatives ?? true,
      );
    } on routing.RouteFailure catch (failure) {
      throw _api(failure);
    }
  }

  /// The weather along [plan], sampled at the stops and every 25 km in between,
  /// each read at the time the traveller is expected to be there.
  Future<RouteWeatherReport> forecast(
    Session session, {
    required RoutePlan plan,
    required DateTime departureAt,
  }) =>
      routing.weatherAlongRoute(plan: plan, departureAt: departureAt);

  /// [plan] and [forecast] in one call, so the screen needs a single round trip.
  Future<RoutePlanWithWeather> planWithWeather(
    Session session, {
    required RouteStop origin,
    required RouteStop destination,
    List<RouteStop>? waypoints,
    String? vehicle,
    DateTime? departureAt,
    bool? alternatives,
  }) async {
    final route = await plan(
      session,
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      vehicle: vehicle,
      alternatives: alternatives,
    );
    final weather = await routing.weatherAlongRoute(
      plan: route,
      departureAt: departureAt?.toUtc() ?? DateTime.now().toUtc(),
    );
    return RoutePlanWithWeather(plan: route, weather: weather);
  }

  /// Departure times around the picked one, each with its own forecast, for the
  /// "compare departure times" panel.
  Future<List<RouteDepartureOption>> compareDepartures(
    Session session, {
    required RoutePlan plan,
    required DateTime departureAt,
    List<int>? offsetsHours,
  }) =>
      routing.compareDepartures(
        plan: plan,
        departureAt: departureAt,
        offsetsHours: offsetsHours,
      );

  ApiException _api(routing.RouteFailure failure) =>
      ApiException(message: failure.message, code: failure.code);
}
