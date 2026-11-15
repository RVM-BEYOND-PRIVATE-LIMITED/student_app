import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #57 item 6: colours come from the palette, never from a raw
/// literal in a screen. `lib/theme/` is the one place a colour may be written;
/// `Colors.transparent` is layout, not colour.
void main() {
  test('no raw Colour literals outside lib/theme', () {
    final offenders = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.startsWith('lib/theme/'));

    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final withoutAllowed = line.replaceAll('Colors.transparent', '');
        if (withoutAllowed.contains('Color(0x') ||
            withoutAllowed.contains('Colors.')) {
          offenders.add('${file.path}:${i + 1}: ${line.trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Use context.palette (lib/theme/student_tokens.dart) instead:\n'
          '${offenders.join('\n')}',
    );
  });
}
