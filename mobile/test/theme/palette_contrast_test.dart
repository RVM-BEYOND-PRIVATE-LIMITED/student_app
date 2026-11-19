import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/theme/student_tokens.dart';
import 'package:rvm_student/widgets/brand_mark.dart';

/// The RVM brand kit in the student app (Prakash, 18 Nov 2026): every text
/// pair meets WCAG AA in both themes; fg3 (hints) reaches 3:1 on white.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void _expectAa(StudentPalette p, String theme) {
  final pairs = <String, (Color, Color)>{
    'fg1': (p.fg1, p.bg),
    'fg2': (p.fg2, p.bg),
    'fg1 on surface': (p.fg1, p.surface),
    'fg2 on surface2': (p.fg2, p.surface2),
    'text on accent': (p.onAccent, p.accent),
    'accentDark on surface': (p.accentDark, p.surface),
    'accentDark on accentTint': (p.accentDark, p.accentTint),
    'white on the header': (p.white, p.navy),
    'white on the header gradient end': (p.white, p.headerEnd),
    'success': (p.success, p.bg),
    'warning': (p.warning, p.bg),
    'danger': (p.danger, p.bg),
    'info': (p.info, p.bg),
  };
  for (final entry in pairs.entries) {
    expect(
      _contrast(entry.value.$1, entry.value.$2),
      greaterThanOrEqualTo(4.5),
      reason: '${entry.key} is below AA in $theme',
    );
  }
}

void main() {
  test('Light text and status colours meet AA', () {
    _expectAa(StudentPalette.light, 'Light');
    final l = StudentPalette.light;
    expect(_contrast(l.fg3, l.bg), greaterThanOrEqualTo(3.0));
    expect(_contrast(l.outline, l.surface), greaterThanOrEqualTo(3.0));
  });

  test('Dark text and status colours meet AA on the Dark ground', () {
    _expectAa(StudentPalette.dark, 'Dark');
    final d = StudentPalette.dark;
    expect(_contrast(d.fg3, d.bg), greaterThanOrEqualTo(4.5));
    expect(_contrast(d.accent, d.bg), greaterThanOrEqualTo(4.5));
  });

  test('Light is the RVM brand kit, white first', () {
    final l = StudentPalette.light;
    expect(l.navy, const Color(0xFF331714)); // Ironwood
    expect(l.accent, const Color(0xFFF84E28)); // Forge Orange
    expect(l.onAccent, const Color(0xFF331714)); // labels on orange are Ironwood
    expect(l.bg, const Color(0xFFFFFFFF));
    expect(l.surface, const Color(0xFFFFFFFF));
    expect(l.fg1, const Color(0xFF331714));
    expect(l.splashGradient, const [
      Color(0xFF52201A),
      Color(0xFF331714),
      Color(0xFF1C0E0B),
    ]);
  });

  test('Dark is built on Ironwood, never navy or black', () {
    final d = StudentPalette.dark;
    expect(d.bg, const Color(0xFF1C0E0B));
    expect(d.surface, const Color(0xFF26130F));
    for (final c in [d.bg, d.surface, d.surface2, d.navy, d.navyDeep]) {
      expect(c.b, lessThanOrEqualTo(c.r), reason: 'a dark ground is warm, not navy');
      expect(c.computeLuminance(), greaterThan(0.004), reason: 'not black');
    }
  });

  test('the rvm wordmark draws its three letters at the brand size', () {
    final bounds = rvmWordmarkPath().getBounds();
    expect(bounds.left, closeTo(0, 0.01));
    expect(bounds.top, closeTo(0, 0.01));
    expect(bounds.width, closeTo(495.83, 0.01));
    expect(bounds.height, closeTo(123.41, 0.01));
  });
}
