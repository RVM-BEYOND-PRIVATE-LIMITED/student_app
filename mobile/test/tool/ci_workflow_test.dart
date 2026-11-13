import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #8, items 5, 6 and 13: what mobile-ci.yml runs on every pull
/// request that touches mobile/. Read from the workflow file (`flutter test`
/// runs in mobile/).
void main() {
  final workflow = File(
    '../.github/workflows/mobile-ci.yml',
  ).readAsStringSync();

  /// The index of the step called [name]; it must exist.
  int step(String name) {
    final at = workflow.indexOf('- name: $name');
    expect(at, isNot(-1), reason: name);
    return at;
  }

  test('the Android-only check runs first, before Flutter is installed', () {
    final check = step('Android only');

    expect(
      workflow.substring(check),
      startsWith(
        '- name: Android only\n        run: bash tool/android_only.sh',
      ),
    );
    expect(
      check,
      lessThan(step(r'Install Flutter ${{ env.FLUTTER_VERSION }}')),
    );
  });

  test('the release builds are the obfuscated App Bundle and per-ABI APKs, '
      'signed only with the throwaway debug key', () {
    final build = workflow.substring(
      step('Release builds'),
      step('Release check'),
    );

    expect(build, contains('run: bash tool/build_release.sh'));
    expect(build, contains("RVM_CI_SIZE_REPORT: 'true'"));
    // No other release build: each one goes through the script.
    expect(workflow, isNot(contains('flutter build')));
  });

  test('every release build is checked, then its size reported', () {
    final check = workflow.substring(
      step('Release check'),
      step('Size report'),
    );
    final report = workflow.substring(step('Size report'));

    expect(check, contains('dart run tool/check_release.dart'));
    expect(check, contains('build/app/outputs/bundle/release/app-release.aab'));
    expect(check, contains('build/app/outputs/flutter-apk/app-*-release.apk'));
    expect(report, contains('dart run tool/size_report.dart'));
    expect(report, contains(r'"$GITHUB_STEP_SUMMARY"'));
  });
}
