import 'dart:io';

import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/env/student_env.dart';
import 'package:rvm_student/core/network/dev_host_guard.dart';
import 'package:rvm_student/core/network/student_auth_interceptor.dart';
import 'package:rvm_student/core/network/student_dio.dart';
import 'package:rvm_student/core/network/student_headers_interceptor.dart';
import 'package:rvm_student/core/network/user_action.dart';
import 'package:rvm_student/core/session/student_session.dart';

import '../../support/fakes.dart';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

/// A connection that never opened (refused): retried automatically.
DioException _refused(RequestOptions options) => DioException(
  requestOptions: options,
  error: const SocketException(
    'Connection refused',
    osError: OSError('Connection refused', 111),
  ),
);

/// A connection that dropped after the request went out (reset): not retried
/// automatically, since the server may have acted on it.
DioException _reset(RequestOptions options) => DioException(
  requestOptions: options,
  error: const SocketException(
    'Connection reset by peer',
    osError: OSError('Connection reset by peer', 104),
  ),
);

void main() {
  late FakeSecureStore store;
  late StudentSession session;
  var language = 'en';

  setUp(() {
    store = FakeSecureStore();
    session = StudentSession(store);
    language = 'en';
  });

  Dio client(
    ScriptedAdapter adapter, {
    StudentEnv? env,
    bool logging = false,
  }) => StudentDio.create(
    env: env ?? StudentEnv.resolve(flavor: 'dev', host: ''),
    appVersion: '0.1.0',
    languageTag: () => language,
    session: session,
    logging: logging,
    adapter: adapter,
    retryDelays: const [Duration.zero],
  );

  group('every call carries the student headers', () {
    test('User-Agent, X-App-Version and Accept-Language', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      final dio = client(adapter);

      await dio.get<dynamic>('/a');
      await dio.post<dynamic>('/b', data: {'x': 1});

      for (final request in adapter.seen) {
        expect(request.header('User-Agent'), 'RVM-Student/0.1.0 (Android)');
        expect(request.header('X-App-Version'), '0.1.0');
        expect(request.header('Accept-Language'), 'en');
      }
      expect(
        StudentHeadersInterceptor.userAgentFor('0.1.0'),
        isNot(DioFactory.userAgent),
        reason: 'the student app has its own User-Agent',
      );
    });

    test('Accept-Language follows a language switch at once', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      final dio = client(adapter);

      await dio.get<dynamic>('/a');
      language = 'hi';
      await dio.get<dynamic>('/a');

      expect(adapter.seen.map((r) => r.header('Accept-Language')), [
        'en',
        'hi',
      ]);
    });

    test('requests go to the configured base address', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));

      await client(adapter).get<dynamic>('/v/a');

      expect(adapter.seen.single.uri.toString(), 'http://127.0.0.1:3000/v/a');
    });
  });

  group('Idempotency-Key', () {
    test('on every POST, PUT, PATCH and DELETE, never on a read', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      final dio = client(adapter);

      await dio.post<dynamic>('/a', data: {'x': 1});
      await dio.put<dynamic>('/a', data: {'x': 1});
      await dio.patch<dynamic>('/a', data: {'x': 1});
      await dio.delete<dynamic>('/a');
      await dio.get<dynamic>('/a');

      final keys = adapter.seen.map((r) => r.idempotencyKey).toList();
      expect(keys.take(4), everyElement(matches(_uuidV4)));
      expect(keys.take(4).toSet(), hasLength(4));
      expect(keys.last, isNull);
    });

    test('check 5: a POST sent again after the connection failed carries the '
        'same key', () async {
      final adapter = ScriptedAdapter((options, call) {
        if (call == 1) throw _refused(options);
        return jsonReply(201, {'ok': true});
      });

      final res = await client(adapter).post<dynamic>('/a', data: {'x': 1});

      expect(res.statusCode, 201);
      expect(adapter.seen, hasLength(2));
      final keys = adapter.seen.map((r) => r.idempotencyKey).toSet();
      expect(keys, hasLength(1));
      expect(keys.single, matches(_uuidV4));
    });

    test(
      'check 5: after a dropped connection, the student\'s own retry of the '
      'same action carries the same key; the next action a new one',
      () async {
        final adapter = ScriptedAdapter((options, call) {
          if (call == 1) throw _reset(options);
          return jsonReply(201, {'ok': true});
        });
        final dio = client(adapter);
        final action = UserAction();

        // The connection dropped mid-way: not retried on its own, because the
        // server may already have acted on it.
        await expectLater(
          dio.post<dynamic>('/a', data: {'x': 1}, options: action.options()),
          throwsA(
            isA<DioException>().having(
              (e) => e.asFailure,
              'failure',
              isA<NoConnectionFailure>(),
            ),
          ),
        );
        expect(adapter.seen, hasLength(1));

        // The student taps "Try again" on the same form.
        await dio.post<dynamic>(
          '/a',
          data: {'x': 1},
          options: action.options(),
        );
        // A new form is a new action.
        await dio.post<dynamic>(
          '/a',
          data: {'x': 2},
          options: UserAction().options(),
        );

        final keys = adapter.seen.map((r) => r.idempotencyKey).toList();
        expect(keys[0], action.key);
        expect(keys[1], action.key);
        expect(keys[2], isNot(action.key));
        expect(keys[2], matches(_uuidV4));
      },
    );

    test('UserAction keeps the other options it is given', () {
      final options = UserAction().options(
        Options(extra: {'x': 1}, headers: {'h': 'v'}),
      );

      expect(options.extra?['x'], 1);
      expect(options.headers?['h'], 'v');
      expect(options.extra?[IdempotencyInterceptor.extraKey], matches(_uuidV4));
    });
  });

  group('check 7: a dev build with no host set never calls a live host', () {
    test('an absolute live URL is stopped before anything is sent', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      final dio = client(adapter);

      for (final url in [
        // A live RVM host, and any other public host.
        'https://scheduler.rvmcad.org/',
        'https://example.com/',
      ]) {
        await expectLater(
          dio.get<dynamic>(url),
          throwsA(
            isA<DioException>().having(
              (e) => e.error,
              'error',
              isA<DevHostBlocked>(),
            ),
          ),
        );
      }
      expect(adapter.seen, isEmpty, reason: 'nothing reached the wire');
    });

    test('loopback calls go through', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      final dio = client(adapter);

      await dio.get<dynamic>('/a');
      await dio.get<dynamic>('http://10.0.2.2:3000/a');

      expect(adapter.seen, hasLength(2));
    });

    test('a prod build has no dev guard', () {
      final dio = client(
        ScriptedAdapter((_, _) => jsonReply(200, {})),
        env: StudentEnv.resolve(
          flavor: 'prod',
          host: 'https://api.example.test',
        ),
      );

      expect(dio.interceptors.whereType<DevHostGuard>(), isEmpty);
    });
  });

  group('logging', () {
    test('a release build logs no request', () {
      final dio = client(
        ScriptedAdapter((_, _) => jsonReply(200, {})),
        logging: false,
      );

      expect(dio.interceptors.whereType<LoggingInterceptor>(), isEmpty);
    });

    test('logging is on only when asked, and the default is debug only', () {
      final dio = client(
        ScriptedAdapter((_, _) => jsonReply(200, {})),
        logging: true,
      );

      expect(dio.interceptors.whereType<LoggingInterceptor>(), hasLength(1));
      // `logging` defaults to kDebugMode, which is false in every release
      // build. The test runner is a debug build.
      final byDefault = StudentDio.create(
        env: StudentEnv.resolve(flavor: 'dev', host: ''),
        appVersion: '0.1.0',
        languageTag: () => 'en',
        session: session,
        adapter: ScriptedAdapter((_, _) => jsonReply(200, {})),
      );
      expect(
        byDefault.interceptors.whereType<LoggingInterceptor>().isNotEmpty,
        kDebugMode,
      );
    });
  });

  group('errors become typed failures (item 7)', () {
    test(
      'the {code, message, details, request_id} shape keeps its request id',
      () async {
        final adapter = ScriptedAdapter(
          (_, _) => jsonReply(409, {
            'code': 'EXAMPLE_CONFLICT',
            'message': 'Example message.',
            'details': {'field': 'x'},
            'request_id': 'req-0001',
          }),
        );

        final error = await client(adapter)
            .post<dynamic>('/a', data: {'x': 1})
            .then<DioException?>(
              (_) => null,
              onError: (Object e) => e as DioException,
            );

        final failure = error!.asFailure;
        expect(failure, isA<BadResponseFailure>());
        expect(failure.statusCode, 409);
        expect(failure.code, 'EXAMPLE_CONFLICT');
        expect(failure.message, 'Example message.');
        expect(failure.requestId, 'req-0001');
      },
    );

    test('a 5xx keeps its request id too', () async {
      final adapter = ScriptedAdapter(
        (_, _) => jsonReply(503, {'code': 'X', 'request_id': 'req-0002'}),
      );

      final error = await client(adapter)
          .get<dynamic>('/a')
          .then<DioException?>(
            (_) => null,
            onError: (Object e) => e as DioException,
          );

      expect(error!.asFailure, isA<ServerFailure>());
      expect(error.asFailure.requestId, 'req-0002');
    });

    test('a reply without a request id has none', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(404, {'error': 'x'}));

      final error = await client(adapter)
          .get<dynamic>('/a')
          .then<DioException?>(
            (_) => null,
            onError: (Object e) => e as DioException,
          );

      expect(error!.asFailure, isA<NotFoundFailure>());
      expect(error.asFailure.requestId, isNull);
    });
  });

  group('the session token', () {
    test('rides on every call once there is a session', () async {
      await session.saveTokens(accessToken: 'access-1', refreshToken: 'r-1');
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));

      await client(adapter).get<dynamic>('/a');

      expect(adapter.seen.single.bearer, 'access-1');
    });

    test('is left off a request marked to skip it', () async {
      await session.saveTokens(accessToken: 'access-1', refreshToken: 'r-1');
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));

      await client(adapter).post<dynamic>(
        '/a',
        data: {'x': 1},
        options: Options(extra: {StudentAuthInterceptor.skipAuthKey: true}),
      );

      expect(adapter.seen.single.header('Authorization'), isNull);
    });

    test('is not sent when signed out', () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));

      await client(adapter).get<dynamic>('/a');

      expect(adapter.seen.single.header('Authorization'), isNull);
    });
  });
}
