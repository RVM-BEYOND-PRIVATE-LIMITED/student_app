import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #57 item 4: one token source. The generated Dart constants must
/// be exactly what `packages/design-tokens/student.tokens.json` says.
void main() {
  test('the generated Dart matches the token JSON', () {
    final json = jsonDecode(
      File('../packages/design-tokens/student.tokens.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final generated = File(
      'lib/theme/student_tokens.g.dart',
    ).readAsStringSync();

    int fromJson(String hex) {
      final value = hex.replaceFirst('#', '').toUpperCase();
      return int.parse(value.length == 8 ? value : 'FF$value', radix: 16);
    }

    Map<String, int> fromDart(String theme) {
      final block = RegExp(
        'static const $theme = <String, int>\\{(.*?)\\};',
        dotAll: true,
      ).firstMatch(generated);
      expect(block, isNotNull, reason: 'no $theme map in the generated file');
      return {
        for (final match in RegExp(
          "'([^']+)': 0x([0-9A-F]+),",
        ).allMatches(block!.group(1)!))
          match.group(1)!: int.parse(match.group(2)!, radix: 16),
      };
    }

    for (final theme in ['light', 'dark']) {
      final expected = {
        for (final entry in (json[theme] as Map<String, dynamic>).entries)
          entry.key: fromJson(entry.value as String),
      };
      expect(fromDart(theme), expected, reason: '$theme drifted from the JSON');
    }
  });
}
