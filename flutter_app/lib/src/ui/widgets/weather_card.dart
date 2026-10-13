import 'package:flutter/material.dart';

import '../icons.dart';

/// Best matching Figma weather icon for the backend's condition text.
///
/// The lookups and the forecast use their own names, so this is matched by
/// keyword and falls back to the generic `cloud`.
String weatherIconFor(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('mưa') || c.contains('rain') || c.contains('drizzle')) {
    return 'cloud-rain';
  }
  if (c.contains('giông') || c.contains('thunder') || c.contains('storm')) {
    return 'storm';
  }
  if (c.contains('gió') || c.contains('wind')) {
    return 'wind';
  }
  if (c.contains('nắng') || c.contains('clear') || c.contains('sun')) {
    return 'sun';
  }
  if (c.contains('sương') || c.contains('fog') || c.contains('snow')) {
    return 'weather';
  }
  return 'cloud';
}

/// The Figma weather icon for a condition, tinted with the theme's brand
/// colour like every other `MemoirIcon`.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.condition, required this.size});

  final String condition;
  final double size;

  @override
  Widget build(BuildContext context) =>
      MemoirIcon(weatherIconFor(condition), size: size);
}

/// Time a cached reading was taken, as `HH:mm`; `không rõ giờ` when the server
/// sent none.
///
/// The weather screen shows it in the `Dữ liệu cũ · cập nhật …` notice, so a
/// reader can tell a live reading from one answered out of the server's
/// snapshots.
String weatherUpdatedLabel(String? updatedAt) {
  final parsed = updatedAt == null ? null : DateTime.tryParse(updatedAt);
  if (parsed == null) return 'không rõ giờ';
  final local = parsed.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}


