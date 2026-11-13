import 'package:dio/dio.dart';

/// The headers every Student API call carries (student_app #1, items 4, 8, 10):
///
/// * `User-Agent: RVM-Student/<version> (Android)`, the student app's own,
///   not the Team app's `DioFactory.userAgent`.
/// * `X-App-Version: <version>`, so the server can refuse a build that is too
///   old even when the launch check could not run.
/// * `Accept-Language: en` or `hi`, the language the student is using now.
///
/// When Android could not say which build this is (`AppInfo.isKnown` is
/// false), the version is unknown: no `X-App-Version` is sent and the
/// User-Agent names no version, so a server minimum never refuses a build
/// over a version it does not really have.
///
/// The language is read on every request, so a switch in the app applies to
/// the very next call.
class StudentHeadersInterceptor extends Interceptor {
  StudentHeadersInterceptor({
    required this.appVersion,
    required this.languageTag,
  });

  /// The installed build's version name, for example `0.1.0`, or null when
  /// it is unknown.
  final String? appVersion;

  /// The language the app shows right now, as a language tag.
  final String Function() languageTag;

  static const appVersionHeader = 'X-App-Version';

  static String userAgentFor(String? appVersion) => appVersion == null
      ? 'RVM-Student (Android)'
      : 'RVM-Student/$appVersion (Android)';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final version = appVersion;
    options.headers['User-Agent'] = userAgentFor(version);
    if (version == null) {
      options.headers.remove(appVersionHeader);
    } else {
      options.headers[appVersionHeader] = version;
    }
    options.headers['Accept-Language'] = languageTag();
    handler.next(options);
  }
}
