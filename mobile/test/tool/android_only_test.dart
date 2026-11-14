import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #8, item 13: CI fails when the Flutter project grows a
/// platform other than Android (tool/android_only.sh).
void main() {
  final script = File('tool/android_only.sh').absolute.path;
  final hasBash = Process.runSync('bash', ['--version']).exitCode == 0;

  late Directory project;

  setUp(() {
    project = Directory.systemTemp.createTempSync('rvm_project_');
    addTearDown(() => project.deleteSync(recursive: true));
    Directory('${project.path}/android').createSync();
    Directory('${project.path}/lib').createSync();
  });

  ProcessResult run() => Process.runSync('bash', [script, project.path]);

  String metadata(List<String> platforms) => [
    'project_type: app',
    'migration:',
    '  platforms:',
    for (final p in platforms) ...[
      '    - platform: $p',
      '      create_revision: adc901062556672b4138e18a4dc62a4be8f4b3c2',
    ],
    '  unmanaged_files:',
    "    - 'ios/Runner.xcodeproj/project.pbxproj'",
  ].join('\n');

  test('this project passes', () {
    final result = Process.runSync('bash', [script]);

    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  }, skip: !hasBash);

  test('Android and the root only: passes', () {
    File(
      '${project.path}/.metadata',
    ).writeAsStringSync(metadata(['root', 'android']));

    expect(run().exitCode, 0);
  }, skip: !hasBash);

  for (final platform in ['ios', 'macos', 'web', 'linux', 'windows']) {
    test('a $platform/ folder fails', () {
      Directory('${project.path}/$platform').createSync();
      final result = run();

      expect(result.exitCode, 1);
      expect(result.stdout, contains('Android only'));
      expect(result.stdout, contains('remove $platform/'));
    }, skip: !hasBash);
  }

  test('.metadata listing iOS fails, even without the folder', () {
    File(
      '${project.path}/.metadata',
    ).writeAsStringSync(metadata(['root', 'android', 'ios']));
    final result = run();

    expect(result.exitCode, 1);
    expect(result.stdout, contains('.metadata platform ios'));
  }, skip: !hasBash);
}
