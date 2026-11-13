import 'package:flutter/foundation.dart';

/// The two build configurations (student_app #1, item 12).
enum StudentFlavor {
  /// A developer's build: the Student API runs on the developer's own
  /// computer unless the developer sets another host on purpose.
  dev,

  /// The build students install: the production Student API only.
  prod,
}

/// A build that must not start: an unknown `FLAVOR`, a production build with
/// no Student API host, or a host that is not a plain http(s) address.
class StudentEnvError extends Error {
  StudentEnvError(this.message);

  final String message;

  @override
  String toString() => 'StudentEnvError: $message';
}

/// Which Student API this build talks to, read from two dart-defines:
///
/// * `FLAVOR`: `dev` (the default) or `prod`.
/// * `STUDENT_API_HOST`: the Student API's base address, for example
///   `http://10.0.2.2:3000` (the emulator) or `https://…` for production.
///
/// A dev build with no host goes to [devLoopback], the developer's own
/// computer, and never to a live host: unlike the Team app's
/// `ApiEnvironment`, nothing here defaults to a production address. A prod
/// build with no host refuses to start, so no production address is guessed
/// either; the release pipeline passes it (student_app #20).
@immutable
class StudentEnv {
  const StudentEnv._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.hostSetOnPurpose,
  });

  final StudentFlavor flavor;

  /// The Student API base address every request is sent to.
  final Uri apiBaseUrl;

  /// True when `STUDENT_API_HOST` was set at build time. Only then may a dev
  /// build reach a host other than this computer.
  final bool hostSetOnPurpose;

  bool get isDev => flavor == StudentFlavor.dev;

  /// Where a dev build with no `STUDENT_API_HOST` sends requests: this
  /// computer, reached from a phone with `adb reverse tcp:3000 tcp:3000`.
  /// 3000 is the Scheduler backend's local port (Scheduler_Backend
  /// server.js: `process.env.PORT || 3000`), where the Student API is to run.
  static final Uri devLoopback = Uri.parse('http://127.0.0.1:3000');

  static const _flavorDefine = String.fromEnvironment('FLAVOR');
  static const _hostDefine = String.fromEnvironment('STUDENT_API_HOST');

  /// The configuration this build was made with.
  static StudentEnv fromDefines() =>
      resolve(flavor: _flavorDefine, host: _hostDefine);

  /// The configuration for [flavor] and [host], as the dart-defines give
  /// them. Throws [StudentEnvError] for a configuration that must not start.
  static StudentEnv resolve({required String flavor, required String host}) {
    final resolvedFlavor = switch (flavor.trim().toLowerCase()) {
      '' || 'dev' => StudentFlavor.dev,
      'prod' => StudentFlavor.prod,
      final other => throw StudentEnvError(
        'Unknown FLAVOR "$other". Use --dart-define=FLAVOR=dev or prod.',
      ),
    };
    final trimmed = host.trim();
    if (trimmed.isEmpty) {
      if (resolvedFlavor == StudentFlavor.prod) {
        throw StudentEnvError(
          'A prod build needs the Student API address: '
          '--dart-define=STUDENT_API_HOST=https://…',
        );
      }
      return StudentEnv._(
        flavor: resolvedFlavor,
        apiBaseUrl: devLoopback,
        hostSetOnPurpose: false,
      );
    }
    final uri = Uri.tryParse(trimmed);
    final plainHttp =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        !uri.hasQuery &&
        !uri.hasFragment;
    if (!plainHttp) {
      throw StudentEnvError(
        'STUDENT_API_HOST must be an http(s) address such as '
        'http://10.0.2.2:3000, not "$trimmed".',
      );
    }
    if (resolvedFlavor == StudentFlavor.prod && uri.scheme != 'https') {
      throw StudentEnvError('A prod Student API address must use https.');
    }
    return StudentEnv._(
      flavor: resolvedFlavor,
      apiBaseUrl: _withoutTrailingSlash(uri),
      hostSetOnPurpose: true,
    );
  }

  /// Whether this build may send a request to [uri]. `HostGuard` asks before
  /// every request, in every flavor, and a refused request sends nothing.
  ///
  /// * Only `http` and `https` addresses with a host, in every flavor.
  /// * A prod build sends https only, to any host: plain HTTP never leaves
  ///   it. It has no default host either, so it only knows the address its
  ///   release pipeline gave it.
  /// * A dev build may reach this computer and the host the developer set on
  ///   purpose, over http or https; any other host is refused.
  ///
  /// Android's network security config plays no part: the Flutter Android
  /// embedder does not apply it to Dart sockets, so this is the rule.
  bool allowsRequestTo(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    if ((scheme != 'http' && scheme != 'https') || uri.host.isEmpty) {
      return false;
    }
    if (!isDev) return scheme == 'https';
    if (isLoopbackHost(uri.host)) return true;
    return hostSetOnPurpose &&
        uri.host.toLowerCase() == apiBaseUrl.host.toLowerCase();
  }

  /// True for the developer's own computer: `localhost`, 127.0.0.0/8, ::1,
  /// and 10.0.2.2, the Android emulator's address for the computer it runs on.
  static bool isLoopbackHost(String host) {
    final h = host.toLowerCase();
    if (h == 'localhost' || h == '::1' || h == '[::1]' || h == '10.0.2.2') {
      return true;
    }
    final parts = h.split('.');
    if (parts.length != 4 || parts.first != '127') return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255 && '$n' == p;
    });
  }

  static Uri _withoutTrailingSlash(Uri uri) {
    var path = uri.path;
    while (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return uri.replace(path: path);
  }
}
