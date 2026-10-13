import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An icon exported from the Figma design (`assets/icons/<name>.svg`).
///
/// The SVGs carry the light-mode brand colour, so they are tinted with the
/// active theme colour instead of being drawn as-is; that keeps dark mode
/// correct without shipping a second set of files.
class MemoirIcon extends StatelessWidget {
  const MemoirIcon(
    this.name, {
    super.key,
    required this.size,
    this.color,
  });

  /// File name without the extension, e.g. `sun` for `assets/icons/sun.svg`.
  final String name;

  final double size;

  /// Defaults to the theme's primary colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
    );
  }
}

/// Weather lookup code → Figma icon name.
const Map<String, String> _weatherIcons = {
  'sunny': 'sun',
  'cloudy': 'cloud',
  'rainy': 'cloud-rain',
  'storm': 'storm',
  'other': 'weather',
};

/// Mood lookup code → Figma icon name. `mood-1` is the lowest level, so the
/// codes the database seeds today (happy/sad/bored/neutral/angry) are mapped
/// onto the same five icons.
const Map<String, String> _moodIcons = {
  'very-sad': 'mood-1',
  'sad': 'mood-2',
  'neutral': 'mood-3',
  'happy': 'mood-4',
  'very-happy': 'mood-5',
  'angry': 'mood-1',
  'bored': 'mood-3',
};

/// Figma icon for a weather lookup code, falling back to the generic icon.
String weatherIcon(String? code) => _weatherIcons[code] ?? 'weather';

/// Figma icon for a mood lookup code, falling back to the neutral level.
String moodIcon(String? code) => _moodIcons[code] ?? 'mood-3';
