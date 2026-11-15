import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/theme/student_tokens.dart';

/// student_app #57: every Dark text pair meets WCAG AA. Light keeps today's
/// look, including the two pairs #60 lists for Prakash (white on orange and
/// fg3 on bg).
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('Dark text and status colours meet AA on the Dark ground', () {
    final d = StudentPalette.dark;
    final pairs = <String, (Color, Color)>{
      'fg1': (d.fg1, d.bg),
      'fg2': (d.fg2, d.bg),
      'fg3': (d.fg3, d.bg),
      'fg1 on surface': (d.fg1, d.surface),
      'accent': (d.accent, d.bg),
      'text on accent': (d.onAccent, d.accent),
      'accentDark on surface': (d.accentDark, d.surface),
      'success': (d.success, d.bg),
      'warning': (d.warning, d.bg),
      'danger': (d.danger, d.bg),
      'info': (d.info, d.bg),
    };
    for (final entry in pairs.entries) {
      expect(
        _contrast(entry.value.$1, entry.value.$2),
        greaterThanOrEqualTo(4.5),
        reason: '${entry.key} is below AA in Dark',
      );
    }
  });

  test('Light keeps the handoff values exactly', () {
    final l = StudentPalette.light;
    expect(l.navy, const Color(0xFF1E305E));
    expect(l.accent, const Color(0xFFF97316));
    expect(l.bg, const Color(0xFFF8FAFC));
    expect(l.surface, const Color(0xFFFFFFFF));
    expect(l.fg1, const Color(0xFF1E293B));
    expect(l.splashGradient, const [
      Color(0xFF25396B),
      Color(0xFF1A2B53),
      Color(0xFF0E1834),
    ]);
  });
}
