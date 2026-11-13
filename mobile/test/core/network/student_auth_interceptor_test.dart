import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/env/student_env.dart';
import 'package:rvm_student/core/network/student_auth_interceptor.dart';
import 'package:rvm_student/core/network/student_dio.dart';
import 'package:rvm_student/core/session/student_session.dart';

import '../../support/fakes.dart';

/// Renews by storing [next] tokens, after waiting for [gate] when given.
class _FakeRenewer implements SessionRenewer {
  _FakeRenewer(this.session, {this.succeeds = true, this.gate});

  final StudentSession session;
  final bool succeeds;
  final Completer<void>? gate;
  int calls = 0;

  @override
  Future<bool> renew() async {
    calls++;
    await gate?.future;
    if (!succeeds) return false;
    await session.saveTokens(
      accessToken: 'access-$calls-renewed',
      refreshToken: 'refresh-$calls-renewed',
    );
    return true;
  }
}

class _ThrowingRenewer implements SessionRenewer {
  @override
  Future<bool> renew() => throw StateError('renewal broke');
}

void main() {
  late FakeSecureStore store;
  late StudentSession session;

  setUp(() async {
    store = FakeSecureStore();
    session = StudentSession(store);
    await session.saveTokens(
      accessToken: 'access-0',
      refreshToken: 'refresh-0',
    );
  });

  Dio client(ScriptedAdapter adapter, SessionRenewer renewer) =>
      StudentDio.create(
        env: StudentEnv.resolve(flavor: 'dev', host: ''),
        appVersion: '0.1.0',
        languageTag: () => 'hi',
        session: session,
        renewer: renewer,
        logging: false,
        adapter: adapter,
        retryDelays: const [Duration.zero],
      );

  /// 401 for the first token, 200 once a renewed token is sent.
  ScriptedAdapter refusesOldToken() => ScriptedAdapter((options, _) {
    final auth = '${options.headers['Authorization']}';
    return auth.contains('renewed')
        ? jsonReply(200, {'ok': true})
        : jsonReply(401, {'code': 'ANY'});
  });

  test('a refused token is renewed once and the request sent again, with '
      'the same headers and Idempotency-Key', () async {
    final adapter = refusesOldToken();
    final renewer = _FakeRenewer(session);

    final res = await client(
      adapter,
      renewer,
    ).post<dynamic>('/a', data: {'x': 1});

    expect(res.statusCode, 200);
    expect(renewer.calls, 1);
    expect(adapter.seen, hasLength(2));
    final first = adapter.seen[0];
    final second = adapter.seen[1];
    expect(first.bearer, 'access-0');
    expect(second.bearer, 'access-1-renewed');
    expect(second.idempotencyKey, first.idempotencyKey);
    expect(second.header('X-App-Version'), '0.1.0');
    expect(second.header('Accept-Language'), 'hi');
    expect(await session.hasSession(), isTrue);
  });

  test('requests refused together share one renewal', () async {
    final adapter = refusesOldToken();
    final gate = Completer<void>();
    final renewer = _FakeRenewer(session, gate: gate);
    final dio = client(adapter, renewer);

    final calls = [
      dio.get<dynamic>('/a'),
      dio.get<dynamic>('/b'),
      dio.get<dynamic>('/c'),
    ];
    await Future<void>.delayed(Duration.zero);
    gate.complete();
    final replies = await Future.wait(calls);

    expect(replies.map((r) => r.statusCode), everyElement(200));
    expect(renewer.calls, 1);
  });

  test('a request refused after another renewed is sent again with the new '
      'token, without a second renewal', () async {
    final adapter = refusesOldToken();
    final renewer = _FakeRenewer(session);
    final dio = client(adapter, renewer);

    await dio.get<dynamic>('/a');
    // A request that left with the old token comes back refused later.
    final stale = ScriptedAdapter((options, _) {
      return jsonReply(200, {'ok': true});
    });
    expect(stale.seen, isEmpty);
    final late = await dio.get<dynamic>(
      '/b',
      options: Options(headers: {'Authorization': 'Bearer access-0'}),
    );

    expect(late.statusCode, 200);
    expect(renewer.calls, 1);
  });

  test(
    'when renewal fails the session ends and the 401 reaches the screen',
    () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));
      final renewer = _FakeRenewer(session, succeeds: false);

      final error = await client(adapter, renewer)
          .get<dynamic>('/a')
          .then<DioException?>(
            (_) => null,
            onError: (Object e) => e as DioException,
          );

      expect(error!.asFailure, isA<UnauthorizedFailure>());
      expect(renewer.calls, 1);
      expect(adapter.seen, hasLength(1));
      expect(await session.hasSession(), isFalse);
      expect(await session.installId(), isNotEmpty, reason: 'install id stays');
    },
  );

  test('a renewer that throws counts as a failed renewal', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));

    await expectLater(
      client(adapter, _ThrowingRenewer()).get<dynamic>('/a'),
      throwsA(isA<DioException>()),
    );
    expect(await session.hasSession(), isFalse);
  });

  test('a token refused again after renewal ends the session', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));
    final renewer = _FakeRenewer(session);

    await expectLater(
      client(adapter, renewer).get<dynamic>('/a'),
      throwsA(isA<DioException>()),
    );
    expect(renewer.calls, 1);
    expect(adapter.seen, hasLength(2));
    expect(await session.hasSession(), isFalse);
  });

  test('the default renewer makes no request and ends the session', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));

    await expectLater(
      client(adapter, const NoSessionRenewer()).get<dynamic>('/a'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.seen, hasLength(1), reason: 'no refresh call was made');
    expect(await session.hasSession(), isFalse);
  });

  test(
    'a 401 on a request marked to skip auth leaves the session alone',
    () async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));
      final renewer = _FakeRenewer(session);

      await expectLater(
        client(adapter, renewer).post<dynamic>(
          '/a',
          data: {'x': 1},
          options: Options(extra: {StudentAuthInterceptor.skipAuthKey: true}),
        ),
        throwsA(isA<DioException>()),
      );
      expect(renewer.calls, 0);
      expect(await session.hasSession(), isTrue);
    },
  );

  test('a 401 with no session to renew is passed on as it is', () async {
    await session.endSession();
    final adapter = ScriptedAdapter((_, _) => jsonReply(401, {'code': 'X'}));
    final renewer = _FakeRenewer(session);

    await expectLater(
      client(adapter, renewer).get<dynamic>('/a'),
      throwsA(isA<DioException>()),
    );
    expect(renewer.calls, 0);
  });

  test('other errors never touch the session', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(403, {'code': 'X'}));
    final renewer = _FakeRenewer(session);

    await expectLater(
      client(adapter, renewer).get<dynamic>('/a'),
      throwsA(isA<DioException>()),
    );
    expect(renewer.calls, 0);
    expect(await session.hasSession(), isTrue);
  });

  test('a session read that hangs does not hold the request: it goes on '
      'without a token once the read runs out of time', () async {
    // A fresh launch whose secure storage never answers (a stuck Keystore).
    final stuck = FakeSecureStore({StudentSession.accessTokenKey: 'access-9'})
      ..holdReads = Completer<void>();
    final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
    final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        StudentAuthInterceptor(
          session: StudentSession(stuck),
          replayDio: Dio(),
          sessionTimeout: const Duration(milliseconds: 50),
        ),
      );

    final res = await dio.get<dynamic>('/a');

    expect(res.statusCode, 200);
    expect(adapter.seen.single.header('Authorization'), isNull);
    stuck.holdReads!.complete();
  });

  test('session reads wait five seconds at most by default', () {
    expect(
      StudentAuthInterceptor(session: session, replayDio: Dio()).sessionTimeout,
      const Duration(seconds: 5),
    );
  });
}
