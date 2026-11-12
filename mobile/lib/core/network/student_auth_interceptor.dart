import 'package:dio/dio.dart';

import '../session/student_session.dart';

/// Renews the student's access token with the refresh token.
abstract interface class SessionRenewer {
  /// True when a fresh access token is now kept in the session.
  Future<bool> renew();
}

/// The renewer this build uses: none.
///
/// The Student API has no refresh call yet. Student tokens and their renewal
/// come with Scheduler_Backend #158 (item 7) and #159, and the contract
/// (student_app #10) will name the call. Until then nothing can renew a
/// session, every refused token ends it, and no request is ever made here.
class NoSessionRenewer implements SessionRenewer {
  const NoSessionRenewer();

  @override
  Future<bool> renew() async => false;
}

/// Student API auth, modelled on the Team app's `EssAuthInterceptor`
/// (team_app core_network): attaches the access token and, when the server
/// refuses it with a 401, renews the session once and sends the request
/// again. A refusal that renewal cannot fix ends the session, so the app goes
/// back to sign-in instead of showing the same 401 on every screen.
///
/// * Renewals that overlap are one call, shared by every request waiting on
///   it.
/// * A request whose token is already older than the session's current one
///   is sent again with the current token, without another renewal.
/// * The second attempt goes through [replayDio], a client with no
///   interceptors, so a 401 on it cannot start another renewal. It replays
///   the same request options, so it carries the same `Idempotency-Key`,
///   `X-App-Version` and `Accept-Language` as the first attempt.
/// * A request marked with [skipAuthKey] (a sign-in step) carries no token,
///   and its 401 is about what it sent, so it never touches the session.
///
/// Until the Student API's error contract exists (student_app #10), every 401
/// on an authenticated request counts as a refused token.
class StudentAuthInterceptor extends Interceptor {
  StudentAuthInterceptor({
    required StudentSession session,
    required Dio replayDio,
    SessionRenewer renewer = const NoSessionRenewer(),
  }) : _session = session,
       _replayDio = replayDio,
       _renewer = renewer;

  final StudentSession _session;
  final Dio _replayDio;
  final SessionRenewer _renewer;

  /// `Options(extra: {StudentAuthInterceptor.skipAuthKey: true})` for a
  /// request that must not carry the session's token.
  static const skipAuthKey = 'student.auth.skip';

  static const _retriedKey = 'student.auth.retried';

  Future<bool>? _renewing;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] != true) {
      final token = await _currentToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final sent = options.headers['Authorization'];
    if (err.response?.statusCode != 401 ||
        options.extra[skipAuthKey] == true ||
        sent == null) {
      handler.next(err);
      return;
    }
    if (options.extra[_retriedKey] == true) {
      await _endSession();
      handler.next(err);
      return;
    }

    var token = await _currentToken();
    final renewedElsewhere = token != null && sent != 'Bearer $token';
    if (!renewedElsewhere) {
      if (!await _renew()) {
        await _endSession();
        handler.next(err);
        return;
      }
      token = await _currentToken();
      if (token == null) {
        await _endSession();
        handler.next(err);
        return;
      }
    }

    options
      ..extra[_retriedKey] = true
      ..headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await _replayDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) await _endSession();
      handler.next(e);
    }
  }

  /// One renewal at a time: a request that arrives while one runs waits for
  /// it instead of starting its own.
  Future<bool> _renew() async {
    final pending = _renewing ??= _renewOnce();
    try {
      return await pending;
    } finally {
      if (identical(_renewing, pending)) _renewing = null;
    }
  }

  Future<bool> _renewOnce() async {
    try {
      return await _renewer.renew();
    } catch (_) {
      return false;
    }
  }

  Future<String?> _currentToken() async {
    try {
      final token = await _session.accessToken();
      return token == null || token.isEmpty ? null : token;
    } catch (_) {
      // Secure storage could not be read: send the request without a token
      // and let the server answer.
      return null;
    }
  }

  Future<void> _endSession() async {
    try {
      await _session.endSession();
    } catch (_) {
      // The refusal still reaches the screen.
    }
  }
}
