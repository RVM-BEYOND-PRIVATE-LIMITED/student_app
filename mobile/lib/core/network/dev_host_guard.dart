import 'package:dio/dio.dart';

import '../env/student_env.dart';

/// Refused because a dev build tried to reach a host it may not reach.
class DevHostBlocked implements Exception {
  const DevHostBlocked(this.host);

  final String host;

  @override
  String toString() =>
      'DevHostBlocked: a dev build may not call "$host". Dev builds reach '
      'this computer only, or the host set with --dart-define='
      'STUDENT_API_HOST (student_app #1).';
}

/// Stops a dev build from calling a live host (student_app #1, check 7).
///
/// The base address of a dev build is loopback unless the developer set
/// another one on purpose, but a request can still name a full URL of its
/// own. This guard checks every request, a retry included, before anything
/// is sent: a host the build may not reach ends the request with
/// [DevHostBlocked] and nothing goes on the wire.
class DevHostGuard extends Interceptor {
  DevHostGuard(this.env);

  final StudentEnv env;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    if (env.allowsRequestTo(uri)) {
      handler.next(options);
      return;
    }
    handler.reject(
      DioException(
        requestOptions: options,
        error: DevHostBlocked(uri.host),
        message: DevHostBlocked(uri.host).toString(),
      ),
    );
  }
}
