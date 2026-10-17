import 'package:flutter/material.dart';

import 'screens/route_weather_screen.dart';
import 'screens/weather_screen.dart';

/// One entry in the "Tiện ích" bar.
///
/// Adding a new utility is a single line in [utilityItems]; the header is the
/// only place that reads the list.
class UtilityItem {
  const UtilityItem({
    required this.icon,
    required this.label,
    required this.builder,
    this.iconAsset,
    this.shortLabel,
  });

  /// Material fallback icon, used when [iconAsset] is null.
  final IconData icon;

  /// Figma icon name without extension, e.g. `weather`. Preferred over [icon]
  /// so the bar matches the design.
  final String? iconAsset;

  final String label;

  /// Shorter wording for the header pill.
  ///
  /// The header has a fixed budget: the wordmark, the navigation, the pills and
  /// the account actions share one row, and the navigation starts scrolling (and
  /// stops being tappable) as soon as the pills grow past it. The pills scroll
  /// inside their own share, so a long label is survivable but cramped — hence
  /// the shorter wording.
  final String? shortLabel;

  final Widget Function() builder;
}

/// The utilities shown in the header.
const List<UtilityItem> utilityItems = [
  UtilityItem(
    icon: Icons.wb_sunny_outlined,
    iconAsset: 'weather',
    label: 'Xem thời tiết',
    builder: WeatherScreen.new,
  ),
  UtilityItem(
    icon: Icons.route_outlined,
    label: 'Thời tiết hành trình',
    shortLabel: 'Hành trình',
    builder: RouteWeatherScreen.new,
  ),
];

/// Opens a utility screen. Kept next to [utilityItems] so every entry point
/// (the header pills) navigates identically.
void openUtility(BuildContext context, UtilityItem item) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => item.builder()),
  );
}
