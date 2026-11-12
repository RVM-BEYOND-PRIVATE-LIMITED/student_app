import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../env/student_env.dart';
import '../session/student_session.dart';
import 'dev_host_guard.dart';
import 'student_auth_interceptor.dart';
import 'student_headers_interceptor.dart';

/// Builds the one [Dio] the app uses for the Student API (student_app #1,
/// item 4), from the Team app's core_network parts.
///
/// core_network's `DioFactory` builds only the Team app's clients and carries
/// their User-Agent, so the student client is put together here, in order:
///
/// 1. [DevHostGuard] (dev builds only): no request leaves for a live host.
/// 2. [IdempotencyInterceptor]: one `Idempotency-Key` per POST, PUT, PATCH
///    and DELETE, kept for every retry of it.
/// 3. [StudentHeadersInterceptor]: User-Agent, `X-App-Version` and
///    `Accept-Language` on every call.
/// 4. [RetryInterceptor]: sends again when the connection never opened.
/// 5. [StudentAuthInterceptor]: the session's token, and renewal on a 401.
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
    // Non-2xx replies go to the error path, so typed failures fire.
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  );

  /// The Student API client.
  ///
  /// [adapter] and [retryDelays] exist for tests; the app leaves them out.
  static Dio create({
    required StudentEnv env,
    required String appVersion,
    required String Function() languageTag,
    required StudentSession session,
    SessionRenewer renewer = const NoSessionRenewer(),
    bool logging = kDebugMode,
    HttpClientAdapter? adapter,
    List<Duration>? retryDelays,
  }) {
    final transport = adapter ?? DohHttpClientAdapter.create();
    final dio = Dio(_base(env))..httpClientAdapter = transport;
    final replay = Dio(_base(env))..httpClientAdapter = transport;
    dio.interceptors.addAll([
      if (env.isDev) DevHostGuard(env),
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
