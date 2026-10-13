/// Weather groups and the rules that flag an unfavourable stretch of a route.
///
/// The WMO -> `weathers.code` table is the same one documented in
/// [docs/11-weather-forecast.md §3](../../../../../docs/11-weather-forecast.md)
/// and implemented privately in `weather/weather_endpoint.dart`. It is repeated
/// here rather than extracted so the working forecast screen keeps its own copy
/// untouched; see docs/12-route-weather.md §7.
library;

/// WMO code -> `weathers.code`. Anything unlisted falls back to "other".
const Map<int, String> _wmoGroups = {
  0: 'sunny',
  1: 'sunny',
  2: 'cloudy',
  3: 'cloudy',
  45: 'cloudy',
  48: 'cloudy',
  51: 'rainy',
  53: 'rainy',
  55: 'rainy',
  56: 'rainy',
  57: 'rainy',
  61: 'rainy',
  63: 'rainy',
  65: 'rainy',
  66: 'rainy',
  67: 'rainy',
  80: 'rainy',
  81: 'rainy',
  82: 'rainy',
  95: 'storm',
  96: 'storm',
  99: 'storm',
};

/// Vietnamese wording matching the seeded lookup labels.
const Map<String, (String, String)> _labels = {
  'sunny': ('Trời quang', '☀️'),
  'cloudy': ('Có mây', '☁️'),
  'rainy': ('Mưa', '🌧️'),
  'storm': ('Bão', '⛈️'),
  'other': ('Khác', '❔'),
};

String wmoGroupForCode(int code) => _wmoGroups[code] ?? 'other';

(String, String) wmoLabelForGroup(String group) =>
    _labels[group] ?? _labels['other']!;

/// How notable the weather at one point is. Ordered from calm to worst.
abstract final class RouteSeverity {
  static const String info = 'info';
  static const String caution = 'caution';
  static const String warning = 'warning';

  static const List<String> ordered = [info, caution, warning];

  /// Index in [ordered]; unknown values rank as [info].
  static int rank(String severity) {
    final index = ordered.indexOf(severity);
    return index < 0 ? 0 : index;
  }

  /// The worst of [values], or [info] when empty.
  static String highest(Iterable<String> values) {
    var worst = info;
    for (final value in values) {
      if (rank(value) > rank(worst)) worst = value;
    }
    return worst;
  }
}

/// Thresholds of docs/12-route-weather.md §6. They are display rules for
/// Memoir, not official road-safety advice.
abstract final class RouteRuleThresholds {
  static const double rainCautionMm = 2.5;
  static const double rainWarningMm = 7.6;
  static const int rainCautionProbability = 60;
  static const double rainCautionProbabilityMm = 1.0;
  static const double stormGustKmh = 60;
  static const double windCautionKmh = 40;
  static const double fogVisibilityMeters = 1000;
  static const double hotC = 35;
  static const double coldC = 10;
  static const Set<int> stormCodes = {95, 96, 97, 99};
  static const Set<int> fogCodes = {45, 48};
}

/// What a rule can look at. Every value is optional: the provider may not
/// return all of them, and a missing value must never raise a false alarm.
class RouteConditions {
  const RouteConditions({
    this.weatherCode,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
    this.windGustKmh,
    this.visibilityMeters,
  });

  final int? weatherCode;
  final double? tempC;
  final double? precipitationMm;
  final int? precipitationProbability;
  final double? windSpeedKmh;
  final double? windGustKmh;
  final double? visibilityMeters;
}

/// The verdict for one point of the route.
class RouteVerdict {
  const RouteVerdict(this.severity, this.reasons);

  final String severity;

  /// Human readable reasons, in the order the rules are listed in the docs.
  final List<String> reasons;

  bool get isCaution => severity != RouteSeverity.info;
}

/// Applies docs/12-route-weather.md §6 to [conditions].
///
/// A point can trip several rules; every reason is reported and the severity is
/// the worst of them.
RouteVerdict evaluateRouteConditions(RouteConditions conditions) {
  final reasons = <String>[];
  final severities = <String>[];

  void flag(String severity, String reason) {
    severities.add(severity);
    reasons.add(reason);
  }

  final precip = conditions.precipitationMm;
  final probability = conditions.precipitationProbability;
  final code = conditions.weatherCode;
  final gust = conditions.windGustKmh;
  final wind = conditions.windSpeedKmh;
  final visibility = conditions.visibilityMeters;
  final temp = conditions.tempC;

  if (precip != null && precip >= RouteRuleThresholds.rainWarningMm) {
    flag(RouteSeverity.warning, 'Mưa lớn, hạn chế tầm nhìn');
  } else if (precip != null && precip >= RouteRuleThresholds.rainCautionMm) {
    flag(RouteSeverity.caution, 'Mưa vừa, đường có thể trơn');
  } else if (precip != null &&
      probability != null &&
      probability >= RouteRuleThresholds.rainCautionProbability &&
      precip >= RouteRuleThresholds.rainCautionProbabilityMm) {
    flag(RouteSeverity.caution, 'Khả năng mưa cao, đường có thể trơn');
  }

  final stormy = (code != null && RouteRuleThresholds.stormCodes.contains(code));
  final gusty = gust != null && gust >= RouteRuleThresholds.stormGustKmh;
  if (stormy || gusty) {
    flag(RouteSeverity.warning, 'Dông, gió giật mạnh');
  } else if (wind != null && wind >= RouteRuleThresholds.windCautionKmh) {
    flag(RouteSeverity.caution, 'Gió mạnh');
  }

  final foggy = (code != null && RouteRuleThresholds.fogCodes.contains(code));
  final hazy = visibility != null &&
      visibility < RouteRuleThresholds.fogVisibilityMeters;
  if (foggy || hazy) {
    flag(RouteSeverity.caution, 'Sương mù, tầm nhìn hạn chế');
  }

  if (temp != null && temp >= RouteRuleThresholds.hotC) {
    flag(RouteSeverity.caution, 'Nắng nóng');
  } else if (temp != null && temp <= RouteRuleThresholds.coldC) {
    flag(RouteSeverity.caution, 'Trời lạnh');
  }

  if (reasons.isEmpty) {
    return const RouteVerdict(RouteSeverity.info, []);
  }
  return RouteVerdict(RouteSeverity.highest(severities), reasons);
}
