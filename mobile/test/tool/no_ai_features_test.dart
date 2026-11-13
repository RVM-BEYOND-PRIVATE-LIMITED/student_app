import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #9: CI fails when the app gains an AI doubt solver, AI
/// counsellor, AI mock interview or resume builder, or a generative-AI SDK
/// (tool/no_ai_features.sh).
void main() {
  final script = File('tool/no_ai_features.sh').absolute.path;
  final hasBash = Process.runSync('bash', ['--version']).exitCode == 0;

  late Directory project;

  File file(String path) => File('${project.path}/$path');

  /// [lines] as a file's text, each line ended.
  String text(List<String> lines) => lines.map((line) => '$line\n').join();

  /// Writes [lines] as the project's [path].
  void write(String path, List<String> lines) =>
      file(path).writeAsStringSync(text(lines));

  /// Adds [lines] to the end of the project's [path].
  void append(String path, List<String> lines) =>
      file(path).writeAsStringSync(text(lines), mode: FileMode.append);

  /// Adds the message [key] to the project's English ARB file.
  void message(String key, String value) {
    final arb = file('lib/l10n/app_en.arb');
    arb.writeAsStringSync(
      arb.readAsStringSync().replaceFirst(
        '"@@locale": "en",',
        '"@@locale": "en",\n  "$key": "$value",',
      ),
    );
  }

  setUp(() {
    project = Directory.systemTemp.createTempSync('rvm_project_');
    addTearDown(() => project.deleteSync(recursive: true));
    Directory('${project.path}/lib/router').createSync(recursive: true);
    Directory('${project.path}/lib/l10n').createSync(recursive: true);
    // A project with names close to the banned ones, all allowed: a
    // counsellor and a mock interview with staff, the word "resume", the
    // rule named in comments, and a commented-out SDK.
    write('pubspec.yaml', [
      'name: rvm_student',
      'dependencies:',
      '  flutter:',
      '    sdk: flutter',
      '  go_router: ^14.0.0',
      '  # google_generative_ai: ^0.4.0',
    ]);
    write('pubspec.lock', [
      'packages:',
      '  go_router:',
      '    dependency: "direct main"',
      '    description:',
      '      name: go_router',
    ]);
    write('lib/router/app_router.dart', [
      '// No AI doubt solver, AI counsellor or resume builder (#9).',
      'abstract final class Routes {',
      "  static const counsellor = '/counsellor';",
      "  static const mockInterview = '/mock-interview';",
      "  static const doubts = '/mail/doubts'; // never an AI counsellor",
      '}',
      '// The screen comes back on AppLifecycleState.resumed.',
    ]);
    write('lib/l10n/app_en.arb', [
      '{',
      '  "@@locale": "en",',
      '  "resumeVideo": "Resume the video",',
      '  "askDoubt": "Ask your trainer a doubt",',
      '  "counsellorCall": "Call your counsellor"',
      '}',
    ]);
    write('lib/l10n/app_hi.arb', [
      '{',
      '  "@@locale": "hi",',
      '  "resumeVideo": "वीडियो फिर से चलाएँ",',
      '  "askDoubt": "अपने ट्रेनर से सवाल पूछें",',
      '  "counsellorCall": "अपने काउंसलर को कॉल करें"',
      '}',
    ]);
  });

  ProcessResult run() => Process.runSync('bash', [script, project.path]);

  void expectFails(String why) {
    final result = run();

    expect(result.exitCode, 1, reason: '${result.stdout}${result.stderr}');
    expect(result.stdout, contains('No AI features (student_app #9)'));
    expect(result.stdout, contains(why));
  }

  test('this project passes', () {
    final result = Process.runSync('bash', [script]);

    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  }, skip: !hasBash);

  test('a counsellor, a mock interview and "resume" alone pass', () {
    final result = run();

    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    expect(result.stdout, contains('No AI features: no generative-AI SDK'));
  }, skip: !hasBash);

  for (final sdk in [
    'google_generative_ai',
    'firebase_vertexai',
    'firebase_ai',
    'dart_openai',
    'openai_dart',
    'anthropic_sdk_dart',
    'langchain',
    'langchain_google',
  ]) {
    test('$sdk in pubspec.yaml fails', () {
      append('pubspec.yaml', ['  $sdk: ^1.0.0']);

      expectFails('pubspec.yaml:7 lists the generative-AI SDK $sdk');
    }, skip: !hasBash);
  }

  test(
    'a generative-AI SDK only in pubspec.lock (a transitive one) fails',
    () {
      append('pubspec.lock', [
        '  langchain_openai:',
        '    dependency: transitive',
      ]);

      expectFails(
        'pubspec.lock:6 lists the generative-AI SDK langchain_openai',
      );
    },
    skip: !hasBash,
  );

  test('a resumeBuilder route fails', () {
    append('lib/router/app_router.dart', [
      "const resumeBuilder = '/profile/resume-builder';",
    ]);

    expectFails(
      'lib/router/app_router.dart:8 names an AI doubt solver, AI counsellor, '
      "AI mock interview or resume builder: const resumeBuilder = '/profile/"
      "resume-builder';",
    );
  }, skip: !hasBash);

  for (final route in [
    "GoRoute(path: 'ai-counsellor', builder: _screen),",
    "GoRoute(path: '/ai/doubts', builder: _screen),",
    'builder: (context, state) => const AIMockInterviewScreen(),',
    "GoRoute(path: 'cv_maker', builder: _screen),",
  ]) {
    test('the route `$route` fails', () {
      append('lib/router/app_router.dart', [route]);

      expectFails('lib/router/app_router.dart:8 names an AI doubt solver');
    }, skip: !hasBash);
  }

  test('a route file of its own under lib/router/ is read too', () {
    write('lib/router/career_routes.dart', [
      "const aiCounsellor = '/career/counsellor';",
    ]);

    expectFails('lib/router/career_routes.dart:1 names');
  }, skip: !hasBash);

  test('an ARB key for an AI doubt solver fails', () {
    message('aiDoubtSolverTitle', 'Ask anything');

    expectFails('lib/l10n/app_en.arb:3 names');
  }, skip: !hasBash);

  test('an ARB text naming a resume builder fails', () {
    message('profileTool', 'Open the CV builder');

    expectFails('"profileTool": "Open the CV builder",');
  }, skip: !hasBash);

  test('the Hindi ARB file is read too', () {
    write('lib/l10n/app_hi.arb', [
      '{',
      '  "@@locale": "hi",',
      '  "aiMockInterview": "मॉक इंटरव्यू"',
      '}',
    ]);

    expectFails('lib/l10n/app_hi.arb:3 names');
  }, skip: !hasBash);

  test('a project with nothing to read fails rather than passes', () {
    Directory('${project.path}/lib/router').deleteSync(recursive: true);

    expectFails('no lib/router/*.dart or lib/l10n/*.arb');
  }, skip: !hasBash);
}
