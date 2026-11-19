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

/// The student palette: the RVM brand kit (September 2026 rebrand), as in the
/// Team RVM app (Prakash, 18 Nov 2026): Ironwood, Forge Orange and Ivory.
/// Light is white first; Dark is built on Ironwood, never navy or black. The
/// role names are the handoff's: `navy` and `navyDeep` hold Ironwood now.
///
/// The values live in `packages/design-tokens/student.tokens.json`, one source
/// for the app and the web version. Every text pair below meets WCAG AA; fg3
/// (hints and placeholders, Ironwood 40 %) is 3.17:1 on white, for large or
/// secondary text only. Labels on Forge Orange are Ironwood (`onAccent`):
/// white on it is 3.4:1.
///
/// Light (on bg #FFFFFF unless said):
/// * fg1 #331714 16.49:1, fg2 #6B5A56 6.52:1
/// * accentDark #C2361A 5.47:1; onAccent on accent 4.80:1
/// * success #1B7F3B 5.07:1, warning #8A5300 6.33:1,
///   danger #B3261E 6.54:1, info #2457C5 6.47:1
///
/// Dark (on bg #1C0E0B unless said):
/// * fg1 #F3F5F4 17.17:1, fg2 #CDBFBB 10.53:1, fg3 #B7A7A2 8.11:1
/// * accent #F84E28 5.47:1; onAccent on accent 4.80:1
/// * accentDark #FF8A66 on surface #26130F 7.68:1
/// * success #7BD88F 10.80:1, warning #FFC864 12.26:1,
///   danger #FFB4AB 11.07:1, info #A8C7FA 10.94:1
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

  /// The light palette: white first, Ironwood ink, Forge Orange accents.
  static final light = StudentPalette.fromValues(StudentTokenValues.light);

  /// The dark palette, built on Ironwood (the Team RVM app's dark theme).
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

  /// The splash's radial gradient, centre to edge. Ironwood in both themes.
  List<Color> get splashGradient => [splashStart, splashMid, splashEnd];

  /// The Welcome header's linear gradient, top left to bottom right. The
  /// Ironwood band in both themes.
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
