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
///
/// The windows are wide enough that a day's total draws a shape rather than a
/// few tall spikes: a storm keeps its rain in the afternoon and evening, a
/// heavy day starts in the morning, and drizzle can run all day.
List<int> _rainyHours(String condition) {
  final c = condition.toLowerCase();
  if (_has(c, const ['giông', 'bão', 'storm', 'thunder'])) {
    return const [13, 14, 15, 16, 17, 18, 19];
  }
  if (_has(c, const ['nhiều', 'heavy', 'to'])) {
    return const [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
  }
  if (_has(c, const ['nhẹ', 'drizzle', 'light'])) {
    return const [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
  }
  return const [11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
}

/// Rain weights across [hours]: a hump centred on the middle of the window, so
/// the bars rise and fall instead of forming a flat row.
List<double> _rainShape(List<int> hours) {
  final middle = (hours.first + hours.last) / 2;
  return [
    for (final hour in hours)
      math.exp(-0.5 * math.pow((hour - middle) / 1.8, 2)),
  ];
}

/// Rounds to one decimal, the resolution the rain charts show.
double _round1(double value) => (value * 10).round() / 10;

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
/// high — the low around 02:00, the high around 14:00 — and the rain follows
/// the hump [_rainShape] draws over the hours the condition calls for.
List<WeatherHour> hourlySeries(WeatherDay day) {
  final low = day.tempMin ?? 24;
  final high = day.tempMax ?? math.max(low, 32);
  final rainyHours = isRainyCondition(day.condition) ||
          isStormyCondition(day.condition)
      ? _rainyHours(day.condition)
      : const <int>[];
  final shape = rainyHours.isEmpty
      ? const <double>[]
      : _rainShape(rainyHours);
  final weightTotal = shape.fold<double>(0, (sum, weight) => sum + weight);
  final total = rainyHours.isEmpty ? 0.0 : rainTotalMm(day);
  final weightByHour = <int, double>{
    for (var i = 0; i < rainyHours.length; i++) rainyHours[i]: shape[i],
  };

  return List<WeatherHour>.generate(24, (hour) {
    final phase = (hour - 14) / 24 * 2 * math.pi;
    final factor = (math.cos(phase) + 1) / 2;
    final weight = weightByHour[hour];
    final rain = weight == null || weightTotal <= 0
        ? 0.0
        : _round1(total * weight / weightTotal);
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

/// The "nice" steps a rain axis may use, in millimetres.
const List<double> _rainSteps = [1, 2, 5, 10, 20, 25, 50, 100, 200];

/// Evenly spaced axis values from 0 to [top], inclusive.
List<double> axisTicks(double top, {int segments = 5}) =>
    List<double>.generate(segments + 1, (i) => top / segments * i);

/// A rain axis: its top value plus the gridlines from 0 up to it.
///
/// The step is the smallest one in [_rainSteps] that keeps the grid down to
/// [maxSegments] lines. Without that a 10 mm hour draws a comb of twelve 1 mm
/// rules, while the weekly plot still wants its 10 mm steps.
({double top, List<double> ticks}) rainAxis(
  Iterable<double> values, {
  int maxSegments = 5,
}) {
  var max = 0.0;
  for (final value in values) {
    if (value > max) max = value;
  }
  final needed = max / maxSegments;
  final step = _rainSteps.firstWhere(
    (candidate) => candidate >= needed,
    orElse: () => _rainSteps.last,
  );
  // At least two segments, so an all-dry week still has a readable scale.
  final top = math.max(step * 2, (max / step).ceil() * step);
  return (top: top, ticks: axisTicks(top, segments: (top / step).round()));
}

/// The hours the `Nhịp trời trong ngày` strip previews, in order.
const List<int> previewHours = [6, 9, 12, 15, 18, 21];
