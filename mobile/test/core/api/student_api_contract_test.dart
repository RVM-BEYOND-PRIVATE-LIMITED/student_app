import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';

/// The client is built against the published contract, never a guess
/// (student_app #2, and hard rule 4). This reads `packages/openapi/openapi.yaml`
/// (run from `mobile/`) and fails when a path in the contract is not called
/// here, or a path here is not in the contract.
void main() {
  test('every contract path is a client path, and nothing else', () {
    final contract = File(
      '../packages/openapi/openapi.yaml',
    ).readAsStringSync();
    final paths = RegExp(
      r'^  (/v1\S*):',
      multiLine: true,
    ).allMatches(contract).map((match) => match.group(1)!).toSet();

    expect(paths, isNotEmpty, reason: 'the published contract is empty');
    expect(StudentApi.paths, paths);
  });
}
