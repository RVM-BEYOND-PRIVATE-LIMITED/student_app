import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/env/student_env.dart';

void main() {
  group('StudentEnv.resolve', () {
    test('no FLAVOR and no host is a dev build on this computer', () {
      final env = StudentEnv.resolve(flavor: '', host: '');

      expect(env.flavor, StudentFlavor.dev);
      expect(env.isDev, isTrue);
      expect(env.apiBaseUrl, StudentEnv.devLoopback);
      expect(env.apiBaseUrl.toString(), 'http://127.0.0.1:3000');
      expect(env.hostSetOnPurpose, isFalse);
      expect(StudentEnv.isLoopbackHost(env.apiBaseUrl.host), isTrue);
    });

    test('FLAVOR is read without regard to case or spaces', () {
      expect(
        StudentEnv.resolve(flavor: ' DEV ', host: '').flavor,
        StudentFlavor.dev,
      );
      expect(
        StudentEnv.resolve(
          flavor: 'Prod',
          host: 'https://api.example.test',
        ).flavor,
        StudentFlavor.prod,
      );
    });

    test('a host set on purpose is used, without a trailing slash', () {
      final env = StudentEnv.resolve(
        flavor: 'dev',
        host: 'http://10.0.2.2:3000/',
      );

      expect(env.apiBaseUrl.toString(), 'http://10.0.2.2:3000');
      expect(env.hostSetOnPurpose, isTrue);
    });

    test('a prod build with no host refuses to start', () {
      expect(
        () => StudentEnv.resolve(flavor: 'prod', host: ''),
        throwsA(
          isA<StudentEnvError>().having(
            (e) => e.message,
            'message',
            contains('STUDENT_API_HOST'),
          ),
        ),
      );
    });

    test('a prod host must use https', () {
      expect(
        () =>
            StudentEnv.resolve(flavor: 'prod', host: 'http://api.example.test'),
        throwsA(isA<StudentEnvError>()),
      );
      expect(
        StudentEnv.resolve(
          flavor: 'prod',
          host: 'https://api.example.test',
        ).apiBaseUrl.toString(),
        'https://api.example.test',
      );
    });

    test('an unknown FLAVOR refuses to start', () {
      expect(
        () => StudentEnv.resolve(flavor: 'staging', host: ''),
        throwsA(isA<StudentEnvError>()),
      );
    });

    test('a host that is not a plain http(s) address refuses to start', () {
      for (final host in [
        'api.example.test',
        'ftp://api.example.test',
        'https://user:pass@api.example.test',
        'https://api.example.test/?debug=1',
        'https://api.example.test/#x',
        'not a url',
      ]) {
        expect(
          () => StudentEnv.resolve(flavor: 'dev', host: host),
          throwsA(isA<StudentEnvError>()),
          reason: host,
        );
      }
    });

    test('the build itself is a dev build on this computer', () {
      // The test run passes no dart-defines, which is the safe default.
      final env = StudentEnv.fromDefines();

      expect(env.isDev, isTrue);
      expect(env.apiBaseUrl, StudentEnv.devLoopback);
    });
  });

  group('which hosts a dev build may reach (check 7)', () {
    test('with no host set: this computer only, never a live host', () {
      final env = StudentEnv.resolve(flavor: 'dev', host: '');

      expect(env.allowsRequestTo(Uri.parse('http://127.0.0.1:3000/x')), isTrue);
      expect(env.allowsRequestTo(Uri.parse('http://localhost:8080/x')), isTrue);
      expect(env.allowsRequestTo(Uri.parse('http://10.0.2.2:3000/x')), isTrue);
      for (final live in [
        'https://scheduler.rvmcad.org/api/x',
        'https://team-api.rvmcad.org/api/ess/x',
        'https://student-api.rvmcad.org/v1/x',
        'https://example.com/x',
        'http://192.168.1.10:3000/x',
      ]) {
        expect(env.allowsRequestTo(Uri.parse(live)), isFalse, reason: live);
      }
    });

    test('with a host set on purpose: that host and this computer', () {
      final env = StudentEnv.resolve(
        flavor: 'dev',
        host: 'https://api.example.test',
      );

      expect(
        env.allowsRequestTo(Uri.parse('https://API.example.test/a')),
        isTrue,
      );
      expect(env.allowsRequestTo(Uri.parse('http://127.0.0.1:3000/a')), isTrue);
      expect(
        env.allowsRequestTo(Uri.parse('https://other.example.test/a')),
        isFalse,
      );
    });

    test('a prod build is not limited by the dev rule', () {
      final env = StudentEnv.resolve(
        flavor: 'prod',
        host: 'https://api.example.test',
      );

      expect(
        env.allowsRequestTo(Uri.parse('https://api.example.test/a')),
        isTrue,
      );
    });

    test('loopback means 127.0.0.0/8, ::1, localhost and 10.0.2.2', () {
      for (final host in [
        '127.0.0.1',
        '127.1.2.3',
        'localhost',
        '::1',
        '10.0.2.2',
      ]) {
        expect(StudentEnv.isLoopbackHost(host), isTrue, reason: host);
      }
      for (final host in [
        '127.0.0',
        '127.0.0.256',
        '128.0.0.1',
        '10.0.2.3',
        '0.0.0.0',
        'localhost.example.com',
      ]) {
        expect(StudentEnv.isLoopbackHost(host), isFalse, reason: host);
      }
    });
  });
}
