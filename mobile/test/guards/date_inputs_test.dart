import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every date in the student app is picked from the platform calendar. A
/// screen that asks for `YYYY-MM-DD` typed by hand is the regression this
/// guard catches; the one helper that formats the API's ISO values is
/// `lib/widgets/date_field.dart`.
void main() {
  test('no screen asks for a date typed as YYYY-MM-DD', () {
    final offenders = <String>[];
    for (final entity in Directory('lib/features').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final text = entity.readAsStringSync();
      if (text.contains('YYYY-MM-DD') || text.contains('YYYY')) {
        offenders.add(entity.path);
      }
      if (RegExp(r'DateTime\.tryParse\([^)]*\.text').hasMatch(text)) {
        offenders.add(entity.path);
      }
    }
    expect(offenders, isEmpty);
  });
}
