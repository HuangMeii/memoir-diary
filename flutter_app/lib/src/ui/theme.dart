import 'package:flutter/material.dart';

import 'tokens.dart';

/// Typeface families from the Figma design.
const serifFamily = 'Lora';
const sansFamily = 'Inter';

/// Material 3 theme built from the design tokens in `tokens/`.
///
/// Colours come from the Figma palette (light + dark), typography from the
/// Foundation type scale: Lora for brand and headings, Inter for UI text.
/// Regenerate `tokens.dart` with `dart run tool/gen_tokens.dart`.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  Color pick(Color light, Color darkValue) => dark ? darkValue : light;

  final scheme = ColorScheme.fromSeed(
    seedColor: MemoirColorsLight.actionPrimary,
    brightness: brightness,
  ).copyWith(
    primary: pick(MemoirColorsLight.actionPrimary, MemoirColorsDark.actionPrimary),
    onPrimary: pick(MemoirColorsLight.textOnPrimary, MemoirColorsDark.textOnPrimary),
    surface: pick(MemoirColorsLight.backgroundPage, MemoirColorsDark.backgroundPage),
    onSurface: pick(MemoirColorsLight.textPrimary, MemoirColorsDark.textPrimary),
    onSurfaceVariant:
        pick(MemoirColorsLight.textSecondary, MemoirColorsDark.textSecondary),
    outlineVariant: pick(MemoirColorsLight.borderDefault, MemoirColorsDark.borderDefault),
    error: pick(MemoirColorsLight.feedbackError, MemoirColorsDark.feedbackError),
    surfaceContainerHighest:
        pick(MemoirColorsLight.surfaceInput, MemoirColorsDark.surfaceInput),
  );

  final on = scheme.onSurface;
  final muted = scheme.onSurfaceVariant;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: sansFamily,
    textTheme: TextTheme(
      // Lora — brand and headings.
      displaySmall: TextStyle(
        fontFamily: serifFamily,
        fontSize: MemoirType.headingPage,
        height: MemoirType.headingPageLineHeight / MemoirType.headingPage,
        color: on,
      ),
      headlineMedium: TextStyle(
        fontFamily: serifFamily,
        fontSize: MemoirType.heading1,
        height: MemoirType.heading1LineHeight / MemoirType.heading1,
        color: on,
      ),
      headlineSmall: TextStyle(
        fontFamily: serifFamily,
        fontSize: MemoirType.headingEditorial,
        height: MemoirType.headingEditorialLineHeight / MemoirType.headingEditorial,
        color: on,
      ),
      titleLarge: TextStyle(fontFamily: serifFamily, fontSize: MemoirType.heading1, color: on),
      // Inter — UI text.
      bodyMedium: TextStyle(fontSize: MemoirType.bodyMeta, color: muted),
      bodySmall: TextStyle(fontSize: MemoirType.caption, color: muted),
      labelLarge: TextStyle(
        fontSize: MemoirType.label,
        fontWeight: FontWeight.w500,
        color: on,
      ),
      labelSmall: TextStyle(fontSize: MemoirType.overlineEditorial, color: muted),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: pick(MemoirColorsLight.surfaceCard, MemoirColorsDark.surfaceCard),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: pick(MemoirColorsLight.surfaceInput, MemoirColorsDark.surfaceInput),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MemoirRadius.input),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MemoirRadius.input),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MemoirSpace.s4,
        vertical: MemoirSpace.s3,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        textStyle: const TextStyle(
          fontFamily: sansFamily,
          fontSize: MemoirType.button,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MemoirRadius.button),
        ),
      ),
    ),
  );
}

/// Parses "#RRGGBB" from the backend, falling back to the given colour.
Color colorFromHex(String? hex, {Color fallback = const Color(0xFFEEEEEE)}) {
  if (hex == null) return fallback;
  final cleaned = hex.replaceFirst('#', '');
  if (cleaned.length != 6) return fallback;
  final value = int.tryParse(cleaned, radix: 16);
  return value == null ? fallback : Color(0xFF000000 | value);
}

/// Raw Figma palette values that the Material [ColorScheme] does not carry.
///
/// Most widgets should read colours off `Theme.of(context).colorScheme`; this
/// helper is only for the tokens that have no Material equivalent (the
/// brand-tinted surfaces and the heatmap ramp).
class MemoirPalette {
  const MemoirPalette._(this._dark);

  factory MemoirPalette.of(BuildContext context) =>
      MemoirPalette._(Theme.of(context).brightness == Brightness.dark);

  final bool _dark;

  /// Card background tinted with the brand colour (`surface.brand-subtle`).
  Color get surfaceBrandSubtle => _dark
      ? MemoirColorsDark.surfaceBrandSubtle
      : MemoirColorsLight.surfaceBrandSubtle;

  /// Colour of the botanical sprig in the quote card.
  Color get botanical => _dark
      ? MemoirColorsDark.illustrationBotanical
      : MemoirColorsLight.illustrationBotanical;

  /// Panel background (`surface.card`).
  Color get surfaceCard =>
      _dark ? MemoirColorsDark.surfaceCard : MemoirColorsLight.surfaceCard;

  /// Page background behind the panels (`background.page`).
  Color get pageBackground => _dark
      ? MemoirColorsDark.backgroundPage
      : MemoirColorsLight.backgroundPage;

  /// Hairline between the top bars and the page (`border.default`).
  Color get borderDefault => _dark
      ? MemoirColorsDark.borderDefault
      : MemoirColorsLight.borderDefault;

  /// Watermark colour for numbers outside the current period.
  Color get textDisabled =>
      _dark ? MemoirColorsDark.textDisabled : MemoirColorsLight.textDisabled;

  /// Soft brand-tinted panel used by the "Câu nói hôm nay" card
  /// (`surface.illustration`).
  Color get surfaceIllustration => _dark
      ? MemoirColorsDark.surfaceInput
      : MemoirColorsLight.surfaceIllustration;
}

/// Five-step green ramp for the journal heatmap ("Nhịp viết của bạn").
///
/// Light mode reuses the mood heatmap tokens from Figma, which are already a
/// light-to-dark green scale. There are no dark-mode heatmap tokens yet, so
/// dark mode ramps the brand colour by opacity instead.
List<Color> journalHeatmapScale(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  if (dark) {
    final base = Theme.of(context).colorScheme.primary;
    return [0.12, 0.28, 0.46, 0.66, 0.92]
        .map((o) => base.withValues(alpha: o))
        .toList(growable: false);
  }
  return const [
    MemoirColorsLight.heatmapMoodVerySad,
    MemoirColorsLight.heatmapMoodSad,
    MemoirColorsLight.heatmapMoodNeutral,
    MemoirColorsLight.heatmapMoodHappy,
    MemoirColorsLight.heatmapMoodVeryHappy,
  ];
}