import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/env/student_env.dart';
import 'package:rvm_student/core/network/host_guard.dart';
import 'package:rvm_student/core/network/student_dio.dart';
import 'package:rvm_student/core/session/student_session.dart';

import '../../support/fakes.dart';

/// A plain TCP listener on this computer that counts every connection made
/// to it and answers each one with `200 {}`.
class _CountingServer {
  _CountingServer._(this._socket) {
    _socket.listen((client) {
      connections++;
      var answered = false;
      client.listen((_) {
        if (answered) return;
        answered = true;
        client
          ..write(
            'HTTP/1.1 200 OK\r\n'
            'content-type: application/json\r\n'
            'content-length: 2\r\n'
            'connection: close\r\n\r\n{}',
          )
          ..close();
      }, onError: (Object _) {});
    });
  }

  static Future<_CountingServer> start() async => _CountingServer._(
    await ServerSocket.bind(InternetAddress.loopbackIPv4, 0),
  );

  final ServerSocket _socket;
  int connections = 0;

  String get url => 'http://127.0.0.1:${_socket.port}/a';

  Future<void> close() => _socket.close();
}

/// The app's real transport (core_network's DohHttpClientAdapter over
/// dart:io), with no stand-in adapter: what these tests see is what the
/// phone's Dart sockets would do. Android's network security config plays
/// no part in it, which is why the rule lives in [HostGuard].
void main() {
  Dio realClient(StudentEnv env) => StudentDio.create(
    env: env,
    appVersion: '0.1.0',
    languageTag: () => 'en',
    session: StudentSession(FakeSecureStore()),
    logging: false,
    retryDelays: const [Duration.zero],
  );

  final prod = StudentEnv.resolve(
    flavor: 'prod',
    host: 'https://api.example.test',
  );

  test('a prod build opens no connection for a plain HTTP address', () async {
    final server = await _CountingServer.start();
    addTearDown(server.close);

    await expectLater(
      realClient(prod).get<dynamic>(server.url),
      throwsA(
        isA<DioException>().having((e) => e.error, 'error', isA<HostBlocked>()),
      ),
    );
    expect(server.connections, 0, reason: 'no TCP connection was opened');

    // The same address from a dev build does connect: the listener counts.
    final res = await realClient(
      StudentEnv.resolve(flavor: 'dev', host: ''),
    ).get<dynamic>(server.url);
    expect(res.statusCode, 200);
    expect(server.connections, 1);
  });

  group('a redirect is never followed', () {
    late HttpServer first;
    late HttpServer second;
    var secondHits = 0;

    setUp(() async {
      secondHits = 0;
      second = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      second.listen((request) {
        secondHits++;
        request.response
          ..statusCode = 200
          ..close();
      });
      first = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      first.listen((request) {
        request.response
          ..statusCode = HttpStatus.found
          ..headers.set(
            HttpHeaders.locationHeader,
            'http://127.0.0.1:${second.port}/elsewhere',
          )
          ..close();
      });
    });

    tearDown(() async {
      await first.close(force: true);
      await second.close(force: true);
    });

    for (final asks in [false, true]) {
      test(
        asks ? 'even when the request asks to follow it' : 'by default',
        () async {
          final dio = realClient(StudentEnv.resolve(flavor: 'dev', host: ''));

          await expectLater(
            dio.get<dynamic>(
              'http://127.0.0.1:${first.port}/a',
              options: asks ? Options(followRedirects: true) : null,
            ),
            throwsA(
              isA<DioException>().having(
                (e) => e.response?.statusCode,
                'status',
                HttpStatus.found,
              ),
            ),
          );
          expect(secondHits, 0, reason: 'dart:io did not follow the 302');
        },
      );
    }
  });
}
