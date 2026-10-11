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
        height: MemoirType.headingPage2LineHeight / MemoirType.headingPage,
        color: on,
      ),
      headlineMedium: TextStyle(
        fontFamily: serifFamily,
        fontSize: MemoirType.heading1,
        height: MemoirType.heading12LineHeight / MemoirType.heading1,
        color: on,
      ),
      headlineSmall: TextStyle(
        fontFamily: serifFamily,
        fontSize: MemoirType.headingEditorial,
        height: MemoirType.headingEditorial2LineHeight / MemoirType.headingEditorial,
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
      labelSmall: TextStyle(fontSize: MemoirType.overline2Editorial, color: muted),
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