import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../env/student_env.dart';
import '../session/student_session.dart';
import 'host_guard.dart';
import 'student_auth_interceptor.dart';
import 'student_headers_interceptor.dart';

/// Builds the one [Dio] the app uses for the Student API (student_app #1,
/// item 4), from the Team app's core_network parts.
///
/// core_network's `DioFactory` builds only the Team app's clients and carries
/// their User-Agent, so the student client is put together here, in order:
///
/// 1. [HostGuard], in every flavor: a dev build reaches this computer and
///    the host set on purpose only, a prod build sends https only, and no
///    redirect is followed.
/// 2. [IdempotencyInterceptor]: one `Idempotency-Key` per POST, PUT, PATCH
///    and DELETE, kept for every retry of it.
/// 3. [StudentHeadersInterceptor]: User-Agent, `X-App-Version` and
///    `Accept-Language` on every call.
/// 4. [RetryInterceptor]: sends again when the connection never opened.
/// 5. [StudentAuthInterceptor]: the session's token, on requests to the
///    Student API's own address only, and renewal on a 401.
/// 6. [LoggingInterceptor], only when [logging] is on. It is off in every
///    release build, so a release build logs no request at all.
/// 7. [ErrorMappingInterceptor]: every error becomes a typed [Failure],
///    carrying the server's `request_id` when the reply has one.
///
/// No Student API call exists yet: the generated client comes with the
/// published contract (student_app #10). This client is ready for it.
abstract final class StudentDio {
  static const timeout = Duration(seconds: 30);

  static BaseOptions _base(StudentEnv env) => BaseOptions(
    baseUrl: env.apiBaseUrl.toString(),
    connectTimeout: timeout,
    receiveTimeout: timeout,
    sendTimeout: timeout,
    contentType: Headers.jsonContentType,
    // dart:io follows redirects below the interceptors, past [HostGuard]; a
    // 3xx is an error instead. The guard also turns it off per request.
    followRedirects: false,
    // Non-2xx replies go to the error path, so typed failures fire.
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  );

  /// The Student API client.
  ///
  /// [appVersion] is null when the installed build's version is unknown;
  /// the client then sends no `X-App-Version`.
  ///
  /// [adapter] and [retryDelays] exist for tests; the app leaves them out.
  static Dio create({
    required StudentEnv env,
    required String? appVersion,
    required String Function() languageTag,
    required StudentSession session,
    SessionRenewer renewer = const NoSessionRenewer(),
    bool logging = kDebugMode,
    HttpClientAdapter? adapter,
    List<Duration>? retryDelays,
  }) {
    final transport = adapter ?? DohHttpClientAdapter.create();
    final dio = Dio(_base(env))..httpClientAdapter = transport;
    // The auth interceptor's second attempt: the guard only, so a replay is
    // checked too and a 401 on it cannot start another renewal.
    final replay = Dio(_base(env))
      ..httpClientAdapter = transport
      ..interceptors.add(HostGuard(env));
    dio.interceptors.addAll([
      HostGuard(env),
      IdempotencyInterceptor(),
      StudentHeadersInterceptor(
        appVersion: appVersion,
        languageTag: languageTag,
      ),
      if (retryDelays == null)
        RetryInterceptor(dio: dio)
      else
        RetryInterceptor(dio: dio, delays: retryDelays),
      StudentAuthInterceptor(
        apiBaseUrl: env.apiBaseUrl,
        session: session,
        replayDio: replay,
        renewer: renewer,
      ),
      if (logging) LoggingInterceptor(),
      const ErrorMappingInterceptor(),
    ]);
    return dio;
  }
}
