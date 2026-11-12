import 'package:equatable/equatable.dart';

/// What the server says about the oldest build it still serves.
sealed class MinimumVersion extends Equatable {
  const MinimumVersion();

  @override
  List<Object?> get props => const [];
}

/// Nobody could say: not published, not reachable, or not readable.
final class MinimumVersionUnknown extends MinimumVersion {
  const MinimumVersionUnknown();
}

/// Builds older than [version] must update.
final class MinimumVersionKnown extends MinimumVersion {
  const MinimumVersionKnown(this.version);

  final String version;

  @override
  List<Object?> get props => [version];
}

/// Where the launch check reads the minimum version from.
abstract interface class VersionSource {
  Future<MinimumVersion> minimumVersion();
}

/// The source this build uses.
///
/// The Student API does not publish a minimum version yet: it comes with
/// Scheduler_Backend #158 (item 13), and its address with the contract
/// (student_app #10). No address is guessed here, so the answer is always
/// [MinimumVersionUnknown] and the launch check lets the app through.
class UnpublishedVersionSource implements VersionSource {
  const UnpublishedVersionSource();

  @override
  Future<MinimumVersion> minimumVersion() async =>
      const MinimumVersionUnknown();
}

/// The launch check's verdict.
sealed class GateDecision extends Equatable {
  const GateDecision();

  @override
  List<Object?> get props => const [];
}

/// Open the app.
final class GatePass extends GateDecision {
  const GatePass();
}

/// This build is older than [minimumVersion]: the app stays blocked on the
/// Update-required screen.
final class GateUpdateRequired extends GateDecision {
  const GateUpdateRequired(this.minimumVersion);

  final String minimumVersion;

  @override
  List<Object?> get props => [minimumVersion];
}

/// The version check at launch (student_app #1, item 10).
///
/// It fails open, as the Team app's gate does: when the minimum cannot be
/// read (no network, a slow reply, an error, a value that is not a version),
/// the app opens. A weak network must never lock a student out, and the
/// server refuses a too-old build on its own from the `X-App-Version` every
/// call carries. Only a minimum that was read, and that is newer than the
/// installed build, blocks the app.
class VersionGate {
  VersionGate({
    required VersionSource source,
    required this.installedVersion,
    this.timeout = const Duration(seconds: 5),
  }) : _source = source;

  final VersionSource _source;

  /// The installed build's version name, for example `0.1.0`.
  final String installedVersion;

  /// How long the check may take before the app opens anyway.
  final Duration timeout;

  Future<GateDecision> check() async {
    try {
      final minimum = await _source.minimumVersion().timeout(timeout);
      if (minimum is MinimumVersionKnown &&
          AppVersion.isOlder(installedVersion, minimum.version)) {
        return GateUpdateRequired(minimum.version);
      }
      return const GatePass();
    } catch (_) {
      return const GatePass();
    }
  }
}

/// Dotted version numbers, as Android's version name carries them.
abstract final class AppVersion {
  /// `1.2.3` as `[1, 2, 3]`. A `+build` or `-pre` suffix is ignored. Null when
  /// [text] is not a version, so a value nobody can read never blocks a build.
  static List<int>? parse(String text) {
    final core = text.trim().split('+').first.split('-').first;
    if (core.isEmpty) return null;
    final parts = core.split('.');
    if (parts.length > 3) return null;
    final numbers = <int>[];
    for (final part in parts) {
      if (!RegExp(r'^\d{1,9}$').hasMatch(part)) return null;
      numbers.add(int.parse(part));
    }
    while (numbers.length < 3) {
      numbers.add(0);
    }
    return numbers;
  }

  /// True only when both are versions and [installed] is older than
  /// [minimum].
  static bool isOlder(String installed, String minimum) {
    final a = parse(installed);
    final b = parse(minimum);
    if (a == null || b == null) return false;
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i] < b[i];
    }
    return false;
  }
}
