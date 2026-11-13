import 'package:flutter/material.dart';

/// The student design handoff's colours (flutterapps
/// design/design_handoff_rvm_student_app/lib_reference/rvm_theme.dart), light
/// theme. Spacing and radii come from core_ui (`RvmSpacing`, `RvmRadii`),
/// whose steps match the handoff's.
abstract final class StudentColors {
  // Brand.
  static const navy = Color(0xFF1E305E);
  static const navyDeep = Color(0xFF152443);
  static const accent = Color(0xFFF97316);
  static const accentDark = Color(0xFFEA580C);
  static const accentSoft = Color(0x1FF97316);

  /// The splash's radial gradient, centre to edge.
  static const splashGradient = [
    Color(0xFF25396B),
    Color(0xFF1A2B53),
    Color(0xFF0E1834),
  ];

  /// The Welcome header's linear gradient, top left to bottom right: the
  /// splash's first two steps.
  static const headerGradient = [Color(0xFF25396B), Color(0xFF1A2B53)];

  /// The faint grid drawn over the navy header (white at about 6 %).
  static const headerGrid = Color(0x0FFFFFFF);

  /// The fill of a chosen option, such as the selected language.
  static const accentTint = Color(0xFFFFF7ED);

  // Meaning.
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFE31E24);
  static const info = Color(0xFF3B82F6);

  // Surfaces and text (the handoff's "Cloud-Depth" light palette).
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF1F5F9);
  static const border = Color(0xFFE2E8F0);
  static const fg1 = Color(0xFF1E293B);
  static const fg2 = Color(0xFF475569);
  static const fg3 = Color(0xFF94A3B8);
  static const white = Color(0xFFFFFFFF);
}

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
