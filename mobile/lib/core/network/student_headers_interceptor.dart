import 'package:dio/dio.dart';

/// The headers every Student API call carries (student_app #1, items 4, 8, 10):
///
/// * `User-Agent: RVM-Student/<version> (Android)`, the student app's own,
///   not the Team app's `DioFactory.userAgent`.
/// * `X-App-Version: <version>`, so the server can refuse a build that is too
///   old even when the launch check could not run.
/// * `Accept-Language: en` or `hi`, the language the student is using now.
///
/// The language is read on every request, so a switch in the app applies to
/// the very next call.
class StudentHeadersInterceptor extends Interceptor {
  StudentHeadersInterceptor({
    required this.appVersion,
    required this.languageTag,
  });

  /// The installed build's version name, for example `0.1.0`.
  final String appVersion;

  /// The language the app shows right now, as a language tag.
  final String Function() languageTag;

  static const appVersionHeader = 'X-App-Version';

  static String userAgentFor(String appVersion) =>
      'RVM-Student/$appVersion (Android)';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = userAgentFor(appVersion);
    options.headers[appVersionHeader] = appVersion;
    options.headers['Accept-Language'] = languageTag();
    handler.next(options);
  }
}
