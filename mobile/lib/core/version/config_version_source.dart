import 'version_gate.dart';

/// Reads the minimum version from `GET /v1/config` (contract 0.1.0), which
/// is the launch setting the server changes without an app release
/// (student_app #1, item 10).
///
/// It answers [MinimumVersionUnknown] when the server cannot be read, so
/// [VersionGate] fails open: a weak network never locks a student out, and
/// the server still refuses an old build from the `X-App-Version` every call
/// carries.
class ConfigVersionSource implements VersionSource {
  ConfigVersionSource(this._read);

  /// The contract's config call, as a function so this class needs no client.
  final Future<String> Function() _read;

  @override
  Future<MinimumVersion> minimumVersion() async {
    try {
      final minimum = (await _read()).trim();
      return minimum.isEmpty
          ? const MinimumVersionUnknown()
          : MinimumVersionKnown(minimum);
    } catch (_) {
      return const MinimumVersionUnknown();
    }
  }
}
