import 'dart:math';

import 'package:core_auth/core_auth.dart';

/// The student's session on this phone (student_app #1, item 5): an access
/// token, a refresh token and an install id, all in [SecureStore].
///
/// The tokens are opaque strings: the app never reads anything inside them.
/// The Student API will issue them at sign-in (Scheduler_Backend #159,
/// student_app #2); until then both slots stay empty.
///
/// The install id is made on this phone the first time it is asked for and
/// kept until the app is uninstalled. Signing out keeps it. The backup rules
/// (android/app/src/main/res/xml) keep it out of backups, so a restored or
/// new phone makes its own.
///
/// [SecureStore] wipes itself when Android can no longer decrypt it (a backup
/// restored without its Keystore key): the student then signs in again and
/// the phone gets a new install id.
class StudentSession {
  StudentSession(this._store, {Random? random})
    : _random = random ?? Random.secure();

  final SecureStore _store;
  final Random _random;

  static const accessTokenKey = 'student.session.access_token';
  static const refreshTokenKey = 'student.session.refresh_token';
  static const installIdKey = 'student.install_id';

  String? _accessToken;
  String? _refreshToken;
  Future<void>? _loading;
  Future<String>? _installId;

  /// Reads the session into memory, so later reads cost nothing, and makes
  /// the install id if this phone has none yet. Safe to call more than once.
  Future<void> load() async {
    final pending = _loading ??= _load();
    try {
      await pending;
    } catch (_) {
      // A failed read is tried again on the next call.
      if (identical(_loading, pending)) _loading = null;
      rethrow;
    }
  }

  Future<void> _load() async {
    _accessToken = _nonEmpty(await _store.read(key: accessTokenKey));
    _refreshToken = _nonEmpty(await _store.read(key: refreshTokenKey));
    await installId();
  }

  /// The access token, or null when the student is signed out.
  Future<String?> accessToken() async {
    await load();
    return _accessToken;
  }

  /// The refresh token, or null when there is no session to renew.
  Future<String?> refreshToken() async {
    await load();
    return _refreshToken;
  }

  /// True when a session was restored or saved and has not ended.
  Future<bool> hasSession() async {
    await load();
    return _accessToken != null || _refreshToken != null;
  }

  /// This install's id: a random version 4 UUID, made once.
  Future<String> installId() async {
    final pending = _installId ??= _readOrMakeInstallId();
    try {
      return await pending;
    } catch (_) {
      // The saved id could not be read: ask again next time rather than
      // making a new id that would replace it.
      if (identical(_installId, pending)) _installId = null;
      rethrow;
    }
  }

  /// Keeps the tokens a sign-in or a renewal returned.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await load();
    await _store.write(key: accessTokenKey, value: accessToken);
    await _store.write(key: refreshTokenKey, value: refreshToken);
    _accessToken = _nonEmpty(accessToken);
    _refreshToken = _nonEmpty(refreshToken);
  }

  /// Ends the session: both tokens go, the install id stays.
  Future<void> endSession() async {
    _accessToken = null;
    _refreshToken = null;
    await _store.delete(key: accessTokenKey);
    await _store.delete(key: refreshTokenKey);
  }

  Future<String> _readOrMakeInstallId() async {
    final saved = _nonEmpty(await _store.read(key: installIdKey));
    if (saved != null) return saved;
    final made = _uuidV4();
    try {
      await _store.write(key: installIdKey, value: made);
    } catch (_) {
      // The id still serves this run; the next launch tries to keep one again.
    }
    return made;
  }

  String _uuidV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // RFC 4122 variant
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  static String? _nonEmpty(String? value) =>
      value == null || value.isEmpty ? null : value;
}
