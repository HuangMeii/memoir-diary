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
        // `Size.fromHeight(48)` reads like "48 tall" but is
        // `Size(double.infinity, 48)` — an infinite *minimum width*. Buttons
        // that a parent does not stretch (a direct child of a `Row`, which
        // lays its non-flex children out with unbounded width) then get an
        // impossible constraint, `performLayout` throws "BoxConstraints
        // forces an infinite width", and on web that blanks the whole page.
        // State the height only; a button that must span its column is made
        // to by that column.
        minimumSize: const Size(0, 48),
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

  /// Bar colour of the weather rain charts
  /// (`chart.weather.rain-accumulation`).
  Color get rainChart => _dark
      ? MemoirColorsDark.statusDefault
      : MemoirColorsLight.chartWeatherRainAccumulation;

  /// Panel behind a cautious callout (`feedback.warning-background`).
  Color get warningSurface => _dark
      ? MemoirColorsDark.feedbackWarningBackground
      : MemoirColorsLight.feedbackWarningBackground;

  /// Text and icon colour inside a cautious callout (`feedback.warning`).
  Color get warningText => _dark
      ? MemoirColorsDark.feedbackWarning
      : MemoirColorsLight.feedbackWarning;

  /// Botanical sprig colour of the forecast context note
  /// (`illustration.botanical`).
  Color get botanicalNote => _dark
      ? MemoirColorsDark.illustrationBotanical
      : MemoirColorsLight.illustrationBotanical;
}

/// Five-step ramp for the journal heatmap ("Nhịp viết của bạn").
///
/// Reads as a page warming up: the lightest step is a pale yellow (a quiet day)
/// and the darkest is the sage green of a full one. Both ends are colours the
/// design already has — `heatmap.weather.sunny` and `heatmap.mood.very-happy` —
/// and the three steps between them are interpolated, so the ramp stays inside
/// the palette instead of inventing a second set of greens.
///
/// Dark mode has no heatmap tokens yet, so it ramps the brand colour by opacity
/// instead.
List<Color> journalHeatmapScale(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  if (dark) {
    final base = Theme.of(context).colorScheme.primary;
    return [0.12, 0.28, 0.46, 0.66, 0.92]
        .map((o) => base.withValues(alpha: o))
        .toList(growable: false);
  }

  // The yellow is taken part of the way to the paper at the light end, so the
  // first step reads as "barely started" beside an empty cell rather than as a
  // painted tile.
  final quiet = Color.lerp(
    MemoirColorsLight.heatmapWeatherSunny,
    MemoirColorsLight.surfaceCard,
    0.45,
  )!;
  const busy = MemoirColorsLight.heatmapMoodVeryHappy;

  return [
    for (var step = 0; step < 5; step++)
      Color.lerp(quiet, busy, step / 4)!,
  ];
}
