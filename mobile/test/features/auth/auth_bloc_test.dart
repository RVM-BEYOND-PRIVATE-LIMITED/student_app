import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/core/session/student_session.dart';
import 'package:rvm_student/features/auth/bloc/auth_bloc.dart';

import '../../support/fakes.dart';

const _me = {
  'id': '11111111-1111-4111-8111-111111111111',
  'phone_masked': '••••••3210',
  'language': 'en',
  'stage': 'registered',
  'fee_fully_paid': false,
  'is_alumni': false,
  'link_state': 'linked',
  'onboarding': {'age_confirmed': true, 'required_consent_given': true},
  'counts': {'placement_prompts': 0, 'consent_requests': 0},
};

const _challenge = {
  'challenge_id': '22222222-2222-4222-8222-222222222222',
  'channel': 'whatsapp',
  'expires_at': '2026-11-14T10:05:00Z',
  'resend_available_at': '2026-11-14T10:01:00Z',
};

const _signedIn = {
  'tokens': {
    'token_type': 'Bearer',
    'access_token': 'access-1',
    'access_expires_at': '2026-11-14T10:15:00Z',
    'refresh_token': 'refresh-1',
    'session_id': '33333333-3333-4333-8333-333333333333',
  },
  'account': _me,
  'created': false,
};

StudentApi _api(ScriptedAdapter adapter) => StudentApi(
  Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000'))
    ..httpClientAdapter = adapter
    ..interceptors.add(IdempotencyInterceptor()),
);

Map<String, dynamic> _error(String code) => {
  'code': code,
  'message': 'refused',
  'details': null,
  'request_id': 'req-1',
};

void main() {
  test('no session: the student is signed out', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(200, _me));
    final store = FakeSecureStore();
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(store),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);

    final done = bloc.stream.firstWhere(
      (state) => state.status == AuthStatus.signedOut,
    );
    bloc.add(const AuthStarted());
    await done;

    expect(adapter.seen, isEmpty);
  });

  test('a session is restored with the account', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(200, _me));
    final store = FakeSecureStore({
      StudentSession.accessTokenKey: 'access-0',
      StudentSession.refreshTokenKey: 'refresh-0',
    });
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(store),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);

    final done = bloc.stream.firstWhere(
      (state) => state.status == AuthStatus.signedIn,
    );
    bloc.add(const AuthStarted());
    final state = await done;

    expect(state.account?.id, _me['id']);
    expect(adapter.seen.single.method, 'GET');
    expect(adapter.seen.single.uri.path, StudentApi.mePath);
  });

  test('requesting a code shows the server challenge', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(201, _challenge));
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(FakeSecureStore()),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);
    bloc.add(const AuthStarted());
    await bloc.stream.firstWhere((s) => s.status == AuthStatus.signedOut);

    final sent = bloc.stream.firstWhere(
      (state) => state.phase == AuthPhase.codeSent,
    );
    bloc.add(const AuthOtpRequested('9876543210'));
    final state = await sent;

    expect(state.challenge?.challengeId, _challenge['challenge_id']);
    expect(state.challenge?.byWhatsApp, isTrue);
    final request = adapter.seen.single;
    expect(request.uri.path, StudentApi.otpRequestPath);
    expect(request.method, 'POST');
    expect(request.idempotencyKey, isNotNull);
  });

  test('a correct code saves the tokens and signs in', () async {
    final adapter = ScriptedAdapter((_, _) => jsonReply(200, _signedIn));
    final store = FakeSecureStore();
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(store),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);
    bloc.add(const AuthStarted());
    await bloc.stream.firstWhere((s) => s.status == AuthStatus.signedOut);
    bloc.add(const AuthOtpRequested('9876543210'));
    await bloc.stream.firstWhere((s) => s.phase == AuthPhase.codeSent);

    final signedIn = bloc.stream.firstWhere(
      (state) => state.status == AuthStatus.signedIn,
    );
    bloc.add(const AuthOtpSubmitted('482913'));
    final state = await signedIn;

    expect(state.account?.stage.name, 'registered');
    expect(store.values[StudentSession.accessTokenKey], 'access-1');
    expect(store.values[StudentSession.refreshTokenKey], 'refresh-1');
    final verify = adapter.seen.last;
    expect(verify.uri.path, StudentApi.otpVerifyPath);
    expect(verify.header('Idempotency-Key'), isNotNull);
  });

  test('a wrong code keeps the session signed out and says why', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.otpRequestPath) {
        return jsonReply(201, _challenge);
      }
      return jsonReply(401, _error('CODE_WRONG'));
    });
    final store = FakeSecureStore();
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(store),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);
    bloc.add(const AuthStarted());
    await bloc.stream.firstWhere((s) => s.status == AuthStatus.signedOut);
    bloc.add(const AuthOtpRequested('9876543210'));
    await bloc.stream.firstWhere((s) => s.phase == AuthPhase.codeSent);

    final refused = bloc.stream.firstWhere((state) => state.failure != null);
    bloc.add(const AuthOtpSubmitted('000000'));
    final state = await refused;

    expect(state.status, AuthStatus.signedOut);
    expect(state.phase, AuthPhase.codeSent);
    expect(state.failure?.code, 'CODE_WRONG');
    expect(store.values.containsKey(StudentSession.accessTokenKey), isFalse);
  });

  test('a second phone asks the centre', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.otpRequestPath) {
        return jsonReply(201, _challenge);
      }
      return jsonReply(409, _error('DEVICE_CHANGE_NEEDS_CENTRE'));
    });
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(FakeSecureStore()),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);
    bloc.add(const AuthStarted());
    await bloc.stream.firstWhere((s) => s.status == AuthStatus.signedOut);
    bloc.add(const AuthOtpRequested('9876543210'));
    await bloc.stream.firstWhere((s) => s.phase == AuthPhase.codeSent);

    final refused = bloc.stream.firstWhere((state) => state.failure != null);
    bloc.add(const AuthOtpSubmitted('482913'));
    final state = await refused;

    expect(state.failure?.code, 'DEVICE_CHANGE_NEEDS_CENTRE');
    expect(state.status, AuthStatus.signedOut);
  });

  test('signing out revokes the session and wipes the tokens', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.logoutPath) return jsonReply(204, {});
      return jsonReply(200, _me);
    });
    final store = FakeSecureStore({
      StudentSession.accessTokenKey: 'access-0',
      StudentSession.refreshTokenKey: 'refresh-0',
    });
    final bloc = AuthBloc(
      api: _api(adapter),
      session: StudentSession(store),
      appVersion: '0.1.0',
    );
    addTearDown(bloc.close);
    bloc.add(const AuthStarted());
    await bloc.stream.firstWhere((s) => s.status == AuthStatus.signedIn);

    final out = bloc.stream.firstWhere(
      (s) => s.status == AuthStatus.signedOut,
    );
    bloc.add(const AuthSignOutRequested());
    await out;

    expect(store.values.containsKey(StudentSession.accessTokenKey), isFalse);
    expect(store.values.containsKey(StudentSession.refreshTokenKey), isFalse);
    expect(
      adapter.seen.map((r) => r.uri.path),
      contains(StudentApi.logoutPath),
    );
  });
}
