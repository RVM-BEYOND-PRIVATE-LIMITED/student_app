import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #8 review follow-up: what the release docs must keep saying
/// (`flutter test` runs in mobile/).
void main() {
  final readme = File('README.md').readAsStringSync();

  /// The README section that starts with the heading [title], up to the
  /// next heading (a `#` comment inside a code block is not one).
  String section(String title) {
    final start = readme.indexOf('### $title');
    expect(start, isNot(-1), reason: title);
    final next = RegExp(r'\n#{2,3} ').firstMatch(readme.substring(start + 4));
    return readme.substring(
      start,
      next == null ? readme.length : start + 4 + next.start,
    );
  }

  test('the versionCode scheme is written down for #20, with the pilot '
      'build as the universal APK', () {
    final codes = section('Version codes (for student_app #20 to confirm)');

    for (final row in [
      '| App Bundle (`app-release.aab`), what Play serves | the build number (1) |',
      '| Universal APK (`app-release.apk`), the pilot build | the build number (1) |',
      '| `app-armeabi-v7a-release.apk` | 1000 + the build number (1001) |',
      '| `app-arm64-v8a-release.apk` | 2000 + the build number (2001) |',
      '| `app-x86_64-release.apk` | 4000 + the build number (4001) |',
    ]) {
      expect(codes, contains(row));
    }
    expect(codes, contains('the pilot build is\nalways the universal APK'));
  });

  test('how to read an obfuscated crash: symbols, the per-ABI obfuscation '
      'map and R8\'s mapping', () {
    final crash = section('Reading an obfuscated crash');

    expect(crash, contains('flutter symbolize -d build/symbols/appbundle/'));
    expect(
      crash,
      contains(
        'build/symbols/appbundle/app.android-arm64.obfuscation.map.json',
      ),
    );
    expect(crash, contains('jq -r --arg name'));
    expect(crash, contains('cmdline-tools/latest/bin/retrace'));
    expect(crash, contains("the trace's `arch:` line"));
  });

  test('docs/device-checks.md holds the on-phone steps of check 1', () {
    final doc = File('docs/device-checks.md').readAsStringSync();

    for (final step in [
      'flutter run --dart-define=FLAVOR=dev',
      'Capture guard test',
      'adb exec-out screencap -p > 2-marked.png',
      'adb shell screenrecord --time-limit 5 /sdcard/3-marked.mp4',
      'adb shell input keyevent KEYCODE_APP_SWITCH',
      'adb exec-out screencap -p > 4-after.png',
    ]) {
      expect(doc, contains(step), reason: step);
    }
    // Marked, then captured again after leaving: both halves of check 1.
    expect(doc.indexOf('2-marked.png'), lessThan(doc.indexOf('4-after.png')));
    expect(readme, contains('docs/device-checks.md'));
  });

  test('the Developer menu path the doc walks exists', () {
    final router = File('lib/router/app_router.dart').readAsStringSync();
    final en = File('lib/l10n/app_en.arb').readAsStringSync();

    expect(router, contains("devCaptureGuard = '/dev/capture-guard'"));
    expect(en, contains('"openDeveloperMenu": "Developer menu"'));
    expect(en, contains('"devCaptureGuard": "Capture guard test"'));
    expect(en, contains('"languageContinue": "Continue"'));
  });
}
