import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';

/// One entry in the "Tiện ích" footer.
///
/// Adding a new utility is a single line in [utilityItems]; the footer and the
/// in-page section both read from the same list.
class UtilityItem {
  const UtilityItem({
    required this.icon,
    required this.label,
    required this.builder,
  });

  final IconData icon;
  final String label;
  final Widget Function() builder;
}

/// The utilities shown in the footer. Weather is the first; more will follow.
const List<UtilityItem> utilityItems = [
  UtilityItem(
    icon: Icons.wb_sunny_outlined,
    label: 'Thời tiết',
    builder: WeatherScreen.new,
  ),
];
