import 'package:flutter/material.dart';

import 'student_tokens.g.dart';

/// The bundled font families (pubspec.yaml, assets/fonts/SOURCES.md).
abstract final class StudentFonts {
  /// UI text: every English word and every digit.
  static const sans = 'Geist';

  /// Technical values: request ids, versions, addresses.
  static const mono = 'GeistMono';

  /// Screen titles in English.
  static const serif = 'Fraunces';

  /// Hindi. Geist and Fraunces have no Devanagari, and Noto Sans Devanagari
  /// has no Latin letters, so every style lists this as its fallback: each
  /// character is drawn from the first family that has it.
  static const devanagari = 'NotoSansDevanagari';

  static const fallback = [devanagari];
}

/// The student palette (student_app #57). Light is today's look, exactly; dark
/// follows the brand kit on the app's own navy.
///
/// The values live in `packages/design-tokens/student.tokens.json`, one source
/// for the app and the web version. Every text pair below meets WCAG AA; the
/// two Light exceptions (white on orange, 2.80:1, and fg3 on bg, 2.45:1) are
/// today's look and are unchanged, as #60 records.
///
/// Dark (on bg #0E1834 unless said):
/// * fg1  #F1F5F9  15.99:1
/// * fg2  #CBD5E1  11.80:1
/// * fg3  #94A3B8   6.83:1
/// * accent #F97316 6.25:1; navy on accent 6.25:1
/// * accentDark #FB923C on surface #152443 6.80:1
/// * success #22C55E 7.69:1, warning #FBBF24 10.49:1,
///   danger #F87171 6.33:1, info #60A5FA 6.89:1
@immutable
class StudentPalette extends ThemeExtension<StudentPalette> {
  const StudentPalette({
    required this.navy,
    required this.navyDeep,
    required this.accent,
    required this.accentDark,
    required this.accentSoft,
    required this.accentTint,
    required this.onAccent,
    required this.white,
    required this.splashStart,
    required this.splashMid,
    required this.splashEnd,
    required this.headerStart,
    required this.headerEnd,
    required this.headerGrid,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.outline,
    required this.fg1,
    required this.fg2,
    required this.fg3,
  });

  factory StudentPalette.fromValues(Map<String, int> values) {
    Color at(String role) => Color(values[role]!);
    return StudentPalette(
      navy: at('navy'),
      navyDeep: at('navyDeep'),
      accent: at('accent'),
      accentDark: at('accentDark'),
      accentSoft: at('accentSoft'),
      accentTint: at('accentTint'),
      onAccent: at('onAccent'),
      white: at('white'),
      splashStart: at('splashStart'),
      splashMid: at('splashMid'),
      splashEnd: at('splashEnd'),
      headerStart: at('headerStart'),
      headerEnd: at('headerEnd'),
      headerGrid: at('headerGrid'),
      success: at('success'),
      successSoft: at('successSoft'),
      warning: at('warning'),
      warningSoft: at('warningSoft'),
      danger: at('danger'),
      dangerSoft: at('dangerSoft'),
      info: at('info'),
      infoSoft: at('infoSoft'),
      bg: at('bg'),
      surface: at('surface'),
      surface2: at('surface2'),
      border: at('border'),
      outline: at('outline'),
      fg1: at('fg1'),
      fg2: at('fg2'),
      fg3: at('fg3'),
    );
  }

  /// Today's light look, byte for byte.
  static final light = StudentPalette.fromValues(StudentTokenValues.light);

  /// The ink-dark palette.
  static final dark = StudentPalette.fromValues(StudentTokenValues.dark);

  final Color navy;
  final Color navyDeep;
  final Color accent;
  final Color accentDark;
  final Color accentSoft;
  final Color accentTint;
  final Color onAccent;
  final Color white;
  final Color splashStart;
  final Color splashMid;
  final Color splashEnd;
  final Color headerStart;
  final Color headerEnd;
  final Color headerGrid;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color outline;
  final Color fg1;
  final Color fg2;
  final Color fg3;

  /// The splash's radial gradient, centre to edge. Navy in both themes.
  List<Color> get splashGradient => [splashStart, splashMid, splashEnd];

  /// The Welcome header's linear gradient, top left to bottom right. Navy in
  /// both themes.
  List<Color> get headerGradient => [headerStart, headerEnd];

  /// The palette of the nearest [Theme]; the light one when none is set (the
  /// error screens that draw before a theme exists).
  static StudentPalette of(BuildContext context) =>
      Theme.of(context).extension<StudentPalette>() ?? light;

  @override
  StudentPalette copyWith() => this;

  @override
  StudentPalette lerp(ThemeExtension<StudentPalette>? other, double t) {
    if (other is! StudentPalette) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return StudentPalette(
      navy: mix(navy, other.navy),
      navyDeep: mix(navyDeep, other.navyDeep),
      accent: mix(accent, other.accent),
      accentDark: mix(accentDark, other.accentDark),
      accentSoft: mix(accentSoft, other.accentSoft),
      accentTint: mix(accentTint, other.accentTint),
      onAccent: mix(onAccent, other.onAccent),
      white: mix(white, other.white),
      splashStart: mix(splashStart, other.splashStart),
      splashMid: mix(splashMid, other.splashMid),
      splashEnd: mix(splashEnd, other.splashEnd),
      headerStart: mix(headerStart, other.headerStart),
      headerEnd: mix(headerEnd, other.headerEnd),
      headerGrid: mix(headerGrid, other.headerGrid),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      info: mix(info, other.info),
      infoSoft: mix(infoSoft, other.infoSoft),
      bg: mix(bg, other.bg),
      surface: mix(surface, other.surface),
      surface2: mix(surface2, other.surface2),
      border: mix(border, other.border),
      outline: mix(outline, other.outline),
      fg1: mix(fg1, other.fg1),
      fg2: mix(fg2, other.fg2),
      fg3: mix(fg3, other.fg3),
    );
  }
}

extension StudentPaletteContext on BuildContext {
  StudentPalette get palette => StudentPalette.of(this);
}
