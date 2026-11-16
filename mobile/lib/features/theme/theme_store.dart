import 'package:core_auth/core_auth.dart';

import '../../core/api/models.dart';

/// What the phone kept from the last run (student_app #59).
class SavedTheme {
  const SavedTheme({
    required this.choice,
    required this.open,
    required this.pending,
  });

  final ThemeChoice choice;
  final bool open;

  /// A choice the server did not take yet; it is retried on the next resume.
  final bool pending;
}

/// Keeps the theme choice on the phone, so the next cold start opens in the
/// right theme even before the server answers. Same store and backup rules as
/// the language choice.
class ThemeStore {
  ThemeStore(this._store);

  final SecureStore _store;

  static const choiceKey = 'student.theme.choice';
  static const openKey = 'student.theme.open';
  static const pendingKey = 'student.theme.pending';

  /// The saved values, or Light/closed when there are none (or a read fails).
  Future<SavedTheme> read() async {
    try {
      final choice = ThemeChoice.fromWire(
        await _store.read(key: choiceKey) ?? 'light',
      );
      final open = await _store.read(key: openKey) == 'true';
      final pending = await _store.read(key: pendingKey) == 'true';
      return SavedTheme(
        choice: open ? choice : ThemeChoice.light,
        open: open,
        pending: open && pending,
      );
    } catch (_) {
      return const SavedTheme(
        choice: ThemeChoice.light,
        open: false,
        pending: false,
      );
    }
  }

  Future<void> write({
    required ThemeChoice choice,
    required bool open,
    required bool pending,
  }) async {
    await _store.write(key: choiceKey, value: choice.name);
    await _store.write(key: openKey, value: '$open');
    await _store.write(key: pendingKey, value: '$pending');
  }

  Future<void> clear() async {
    await _store.delete(key: choiceKey);
    await _store.delete(key: openKey);
    await _store.delete(key: pendingKey);
  }
}
