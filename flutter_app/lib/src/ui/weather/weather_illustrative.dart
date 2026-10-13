/// The illustrative forecast behind the weather screen's hourly tables and
/// rain charts.
///
/// The `Thời tiết · Tuần/Ngày/Theo giờ · Web` frames are mockups — they carry a
/// `Dữ liệu minh họa · Chưa kết nối API` notice — and the backend only serves
/// the current reading plus seven daily rows. These helpers turn one
/// [WeatherDay] into stable, plausible numbers instead of random ones, so the
/// page keeps the same shape across rebuilds.
///
/// Everything here is a pure function of the day, which is what the unit tests
/// pin down.
library;

import 'dart:math' as math;

import '../../data/models.dart';

/// One hour of the illustrative forecast.
class WeatherHour {
  const WeatherHour({
    required this.hour,
    required this.temperature,
    required this.rainMm,
    required this.condition,
  });

  /// Local hour, 0–23.
  final int hour;

  /// Degrees Celsius.
  final double temperature;

  /// Rain accumulated during this hour, in millimetres.
  final double rainMm;

  /// The condition driving this hour's icon.
  final String condition;

  /// `15:00`.
  String get label => '${hour.toString().padLeft(2, '0')}:00';

  /// `15:00–16:00`.
  String get rangeLabel =>
      '$label–${((hour + 1) % 24).toString().padLeft(2, '0')}:00';
}

bool _has(String condition, List<String> needles) {
  final c = condition.toLowerCase();
  return needles.any(c.contains);
}

/// Whether the condition reads as rain.
bool isRainyCondition(String condition) =>
    _has(condition, const ['mưa', 'rain', 'drizzle']);

/// Whether the condition reads as a storm.
bool isStormyCondition(String condition) =>
    _has(condition, const ['giông', 'bão', 'storm', 'thunder']);

/// Whether the condition reads as sunshine.
bool isSunnyCondition(String condition) =>
    _has(condition, const ['nắng', 'clear', 'sun']);

/// Stable seed for [day]: the same date always draws the same mock forecast.
int _seed(WeatherDay day) =>
    day.date.year * 10000 + day.date.month * 100 + day.date.day;

/// The hours a rainy day concentrates its rain in, by condition wording.
List<int> _rainyHours(String condition) {
  final c = condition.toLowerCase();
  if (_has(c, const ['giông', 'bão', 'storm', 'thunder'])) {
    return const [15, 16, 17, 18];
  }
  if (_has(c, const ['nhiều', 'heavy', 'to'])) {
    return const [12, 13, 14, 15, 16, 17, 18, 19, 20];
  }
  if (_has(c, const ['nhẹ', 'drizzle', 'light'])) {
    return const [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
  }
  return const [14, 15, 16, 17];
}

/// Rain chance for [day], as a whole percentage (0–100).
int rainChance(WeatherDay day) {
  if (isStormyCondition(day.condition)) return 85 + _seed(day) % 11;
  if (isRainyCondition(day.condition)) return 55 + _seed(day) % 36;
  if (isSunnyCondition(day.condition)) return 5 + _seed(day) % 20;
  return 25 + _seed(day) % 30;
}

/// Rain accumulated over [day], in millimetres.
double rainTotalMm(WeatherDay day) {
  if (isStormyCondition(day.condition)) return 24 + (_seed(day) % 28).toDouble();
  if (isRainyCondition(day.condition)) return 6 + (_seed(day) % 22).toDouble();
  return (rainChance(day) ~/ 25).toDouble();
}

/// Relative humidity over [day], as a whole percentage.
int humidityPercent(WeatherDay day) {
  final base =
      isStormyCondition(day.condition) || isRainyCondition(day.condition)
          ? 78
          : 58;
  return (base + _seed(day) % 15).clamp(40, 96);
}

/// Wind speed over [day], in km/h.
int windKmh(WeatherDay day) {
  final base = isStormyCondition(day.condition)
      ? 18
      : isRainyCondition(day.condition)
          ? 12
          : 8;
  return base + _seed(day) % 6;
}

const List<String> _windDirections = [
  'Bắc',
  'Đông Bắc',
  'Đông',
  'Đông Nam',
  'Nam',
  'Tây Nam',
  'Tây',
  'Tây Bắc',
];

/// Compass name of the wind over [day], e.g. `Tây Nam`.
String windDirection(WeatherDay day) => _windDirections[_seed(day) % 8];

/// The 24 illustrative hours of [day], oldest first.
///
/// The temperature follows a smooth daily curve between the day's low and
/// high — the low around 02:00, the high around 14:00 — and the rain is spread
/// evenly over the hours the condition calls for.
List<WeatherHour> hourlySeries(WeatherDay day) {
  final low = day.tempMin ?? 24;
  final high = day.tempMax ?? math.max(low, 32);
  final rainyHours = isRainyCondition(day.condition) ||
          isStormyCondition(day.condition)
      ? _rainyHours(day.condition)
      : const <int>[];
  final total = rainTotalMm(day);
  final perHour = rainyHours.isEmpty
      ? 0.0
      : ((total / rainyHours.length) * 10).round() / 10;

  return List<WeatherHour>.generate(24, (hour) {
    final phase = (hour - 14) / 24 * 2 * math.pi;
    final factor = (math.cos(phase) + 1) / 2;
    final rain = rainyHours.contains(hour) ? perHour : 0.0;
    final wet = rain > 0;
    return WeatherHour(
      hour: hour,
      temperature: low + (high - low) * factor,
      rainMm: rain,
      condition: wet || (!isRainyCondition(day.condition) &&
              !isStormyCondition(day.condition))
          ? day.condition
          : 'Mây',
    );
  });
}

/// Total rain over [days], in millimetres.
double rainTotalWeekMm(List<WeatherDay> days) =>
    days.fold(0, (sum, day) => sum + rainTotalMm(day));

/// A round top for a rain axis: the next multiple of [step] above [values].
double axisTop(Iterable<double> values, {double step = 10, double minimum = 20}) {
  var top = minimum;
  for (final value in values) {
    if (value > top) top = value;
  }
  return (top / step).ceil() * step;
}

/// Evenly spaced axis values from 0 to [top], inclusive.
List<double> axisTicks(double top, {int segments = 5}) =>
    List<double>.generate(segments + 1, (i) => top / segments * i);

/// The hours the `Nhịp trời trong ngày` strip previews, in order.
const List<int> previewHours = [6, 9, 12, 15, 18, 21];
