import 'dart:math' as math;

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'student_tokens.dart';

/// The student app's type scale: the handoff's families (Geist for UI text,
/// Fraunces for English screen titles) on core_ui's text-theme roles.
///
/// Hindi needs more room than English: Devanagari vowel signs rise above
/// the letters and below the line. A Hindi theme therefore uses taller
/// lines, no tight letter spacing (it would crowd joined letters), and Geist
/// instead of Fraunces for titles, since titles are Devanagari there anyway.
abstract final class StudentType {
  static TextTheme textTheme({required bool devanagari}) {
    final titleFamily = devanagari ? StudentFonts.sans : StudentFonts.serif;
    final titleWeight = devanagari ? FontWeight.w600 : FontWeight.w400;

    TextStyle style(
      String family,
      double size,
      FontWeight weight,
      double height, {
      double spacing = 0,
      Color color = StudentColors.fg1,
    }) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: StudentFonts.fallback,
      fontSize: size,
      fontWeight: weight,
      height: devanagari ? math.max(height + 0.1, 1.4) : height,
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: devanagari ? 0 : spacing,
      color: color,
    );

    return TextTheme(
      displaySmall: style(titleFamily, 30, titleWeight, 1.15, spacing: -0.6),
      headlineMedium: style(titleFamily, 26, titleWeight, 1.15, spacing: -0.5),
      headlineSmall: style(titleFamily, 22, titleWeight, 1.2, spacing: -0.3),
      titleLarge: style(
        StudentFonts.sans,
        18,
        FontWeight.w600,
        1.3,
        spacing: -0.2,
      ),
      titleMedium: style(StudentFonts.sans, 15, FontWeight.w600, 1.35),
      titleSmall: style(StudentFonts.sans, 14, FontWeight.w600, 1.35),
      bodyLarge: style(StudentFonts.sans, 15, FontWeight.w400, 1.55),
      bodyMedium: style(StudentFonts.sans, 14, FontWeight.w400, 1.55),
      bodySmall: style(
        StudentFonts.sans,
        12.5,
        FontWeight.w400,
        1.5,
        color: StudentColors.fg2,
      ),
      labelLarge: style(StudentFonts.sans, 15, FontWeight.w600, 1.3),
      labelMedium: style(
        StudentFonts.sans,
        12.5,
        FontWeight.w500,
        1.35,
        color: StudentColors.fg2,
      ),
      labelSmall: style(
        StudentFonts.mono,
        11,
        FontWeight.w500,
        1.4,
        spacing: 0.3,
        color: StudentColors.fg2,
      ),
    );
  }

  /// Technical values (request ids, versions, addresses) in Geist Mono.
  static TextStyle data({double size = 13, Color color = StudentColors.fg1}) =>
      TextStyle(
        fontFamily: StudentFonts.mono,
        fontFamilyFallback: StudentFonts.fallback,
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );
}

/// The student app's theme (student_app #1): the handoff's navy and orange
/// tokens laid on core_ui's `RvmTheme` structure (the same component themes,
/// core_ui's `RvmSpacing` and `RvmRadii`). Light only for now.
abstract final class StudentTheme {
  /// The theme for a language: Hindi gets the Devanagari type scale.
  static ThemeData forLanguageCode(String languageCode) =>
      light(devanagari: languageCode == 'hi');

  static ThemeData light({bool devanagari = false}) {
    const ink = StudentColors.fg1;
    const muted = StudentColors.fg2;
    const canvas = StudentColors.bg;
    const card = StudentColors.surface;
    const line = StudentColors.border;
    const primary = StudentColors.accent;
    const onPrimary = StudentColors.white;

    final base = ColorScheme.fromSeed(seedColor: primary);
    final scheme = base.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: const Color(0xFFFFEDD5),
      onPrimaryContainer: const Color(0xFF9A3412),
      secondary: StudentColors.navy,
      onSecondary: StudentColors.white,
      secondaryContainer: const Color(0xFFE0E7FF),
      onSecondaryContainer: StudentColors.navy,
      tertiary: StudentColors.info,
      surface: canvas,
      onSurface: ink,
      onSurfaceVariant: muted,
      surfaceContainerLowest: card,
      surfaceContainerLow: card,
      surfaceContainer: card,
      surfaceContainerHigh: StudentColors.surface2,
      surfaceContainerHighest: StudentColors.surface2,
      outline: const Color(0xFFCBD5E1),
      outlineVariant: line,
      error: StudentColors.danger,
      onError: StudentColors.white,
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: const Color(0xFF991B1B),
    );

    final text = StudentType.textTheme(devanagari: devanagari);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: StudentFonts.sans,
      fontFamilyFallback: StudentFonts.fallback,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: canvas,
      canvasColor: canvas,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
        iconTheme: const IconThemeData(color: ink, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: card,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RvmRadii.md),
          side: const BorderSide(color: line),
        ),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: StudentColors.surface2,
          disabledForegroundColor: StudentColors.fg3,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: RvmSpacing.lg,
            vertical: 14,
          ),
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          backgroundColor: card,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: RvmSpacing.md + 2,
            vertical: 12,
          ),
          textStyle: text.labelLarge,
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: StudentColors.accentDark,
          textStyle: text.labelLarge,
          minimumSize: const Size(48, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RvmRadii.sm),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: ink),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: muted,
        textColor: ink,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RvmSpacing.md,
          vertical: 2,
        ),
        minLeadingWidth: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: StudentColors.navy,
        contentTextStyle: text.bodyMedium?.copyWith(color: StudentColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
        ),
        elevation: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: StudentColors.surface2,
        circularTrackColor: StudentColors.surface2,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: StudentColors.navy,
          borderRadius: BorderRadius.circular(RvmRadii.xs),
        ),
        textStyle: text.bodySmall?.copyWith(color: StudentColors.white),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withValues(alpha: 0.22),
        selectionHandleColor: primary,
      ),
    );
  }
}
