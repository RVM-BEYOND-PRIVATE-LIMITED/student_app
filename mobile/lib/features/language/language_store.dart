import 'package:core_auth/core_auth.dart';

import '../../l10n/l10n.dart';

/// Keeps the student's language choice on the phone, so it survives a
/// restart (student_app #1, item 8, check 2).
///
/// It lives in [SecureStore]: the app has no other on-device store, and the
/// Team app's workspace has no shared_preferences. The backup rules keep it
/// on this phone with the session.
class LanguageStore {
  LanguageStore(this._store);

  final SecureStore _store;

  static const key = 'student.language';

  /// The saved choice, or null when there is none (or it cannot be read).
  Future<AppLanguage?> read() async {
    try {
      return AppLanguage.fromCode(await _store.read(key: key));
    } catch (_) {
      return null;
    }
  }

  Future<void> write(AppLanguage language) =>
      _store.write(key: key, value: language.name);
}
