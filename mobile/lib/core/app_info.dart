import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The installed build, read from Android once at launch.
class AppInfo extends Equatable {
  const AppInfo({
    required this.version,
    required this.buildNumber,
    this.isKnown = true,
  });

  /// The version name (`versionName`), for example `0.1.0`. It is what the
  /// app sends as `X-App-Version` and what the launch check compares.
  final String version;

  /// The version code (`versionCode`), for example `1`.
  final String buildNumber;

  /// False when Android could not say which build this is. The launch check
  /// then lets the app through (it fails open), since `0.0.0` is not this
  /// build's real version.
  final bool isKnown;

  /// Both together, as people read them: `0.1.0 (1)`.
  String get display => '$version ($buildNumber)';

  /// What Android says about this install. On the rare failure the version
  /// reads `0.0.0` and [isKnown] is false.
  static Future<AppInfo> load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return AppInfo(version: info.version, buildNumber: info.buildNumber);
    } catch (_) {
      return const AppInfo(version: '0.0.0', buildNumber: '0', isKnown: false);
    }
  }

  @override
  List<Object?> get props => [version, buildNumber, isKnown];
}
