import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../env/student_env.dart';

/// Refused because the request's address is one this build may not reach.
class HostBlocked implements Exception {
  const HostBlocked({
    required this.scheme,
    required this.host,
    required this.isDev,
  });

  final String scheme;
  final String host;

  /// Which rule refused it: the dev rule or the prod rule.
  final bool isDev;

  @override
  String toString() => isDev
      ? 'HostBlocked: a dev build may not call "$scheme://$host". Dev builds '
            'reach this computer only, or the host set with --dart-define='
            'STUDENT_API_HOST (student_app #1).'
      : 'HostBlocked: a prod build sends https only, so "$scheme://$host" '
            'was refused (student_app #1).';
}

/// Decides, in Dart, which addresses the Student API client may reach
/// (student_app #1, item 12 and check 7). It runs before every interceptor
/// the app adds, on every request (a retry and the replay after a renewal
/// included), in every flavor:
///
/// * a dev build reaches this computer, and the host set on purpose with
///   `STUDENT_API_HOST`, over http or https; any other host is refused;
/// * a prod build sends https only: plain HTTP never leaves it.
///
/// See [StudentEnv.allowsRequestTo] for the rule itself. Nothing goes on the
/// wire for a refused request. Its error passes through every interceptor
/// after the guard, like any other error, so the caller gets a typed
/// [Failure] (an [UnknownFailure] whose message names the refusal) and
/// [refusalOf] tells which rule refused it.
///
/// This is the only rule that covers the app's API traffic. dio sends it
/// through `dart:io`'s `HttpClient`, and the Flutter 3.35.7 Android embedder
/// does not apply Android's network security config to Dart sockets: it
/// reads a domain policy only from an `io.flutter.network-policy` meta-data
/// entry (which this app does not declare) and otherwise lets Dart connect
/// insecurely to every domain.
///
/// Redirects are never followed. `HttpClient` follows a 3xx below the
/// interceptors, so a redirect could reach a host this guard refuses, or
/// plain HTTP from an https address, without passing through it again. The
/// guard turns [RequestOptions.followRedirects] off on every request, so a
/// 3xx reply reaches the caller as an error instead.
class HostGuard extends Interceptor {
  HostGuard(this.env);

  final StudentEnv env;

  static const _blockedKey = 'student.host.blocked';

  /// The [HostBlocked] that stopped [error]'s request, or null when the guard
  /// let it through.
  static HostBlocked? refusalOf(DioException error) {
    final blocked = error.requestOptions.extra[_blockedKey];
    return blocked is HostBlocked ? blocked : null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.followRedirects = false;
    final uri = options.uri;
    if (env.allowsRequestTo(uri)) {
      options.extra.remove(_blockedKey);
      handler.next(options);
      return;
    }
    final blocked = HostBlocked(
      scheme: uri.scheme,
      host: uri.host,
      isDev: env.isDev,
    );
    options.extra[_blockedKey] = blocked;
    handler.reject(
      DioException(
        requestOptions: options,
        error: UnknownFailure(blocked.toString()),
        message: blocked.toString(),
      ),
      // The following error interceptors run too (logging, then
      // ErrorMappingInterceptor), as for every other error.
      true,
    );
  }
}
