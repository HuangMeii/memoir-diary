import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';

/// One entry in the "Tiện ích" bar.
///
/// Adding a new utility is a single line in [utilityItems]; the top bar and the
/// in-page section both read from the same list.
class UtilityItem {
  const UtilityItem({
    required this.icon,
    required this.label,
    required this.builder,
    this.iconAsset,
  });

  /// Material fallback icon, used when [iconAsset] is null.
  final IconData icon;

  /// Figma icon name without extension, e.g. `weather`. Preferred over [icon]
  /// so the bar matches the design.
  final String? iconAsset;

  final String label;
  final Widget Function() builder;
}

/// The utilities shown in the top bar. Weather is the first; more will follow.
const List<UtilityItem> utilityItems = [
  UtilityItem(
    icon: Icons.wb_sunny_outlined,
    iconAsset: 'weather',
    label: 'Xem thời tiết',
    builder: WeatherScreen.new,
  ),
];
