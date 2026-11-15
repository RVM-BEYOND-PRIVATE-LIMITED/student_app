import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import 'theme_store.dart';

/// Holds the student's theme (student_app #57 and #59): Light, Dark or System,
/// and whether the `theme` switch is open to them. Always Light while the
/// switch is closed or unknown. The choice is saved on the phone at once and
/// through `PUT /v1/me/preferences` when the server allows it.
class ThemeController extends ChangeNotifier {
  ThemeController({
    required StudentApi api,
    required ThemeStore store,
    SavedTheme saved = const SavedTheme(
      choice: ThemeChoice.light,
      open: false,
      pending: false,
    ),
  }) : _api = api,
       _store = store,
       _choice = saved.open ? saved.choice : ThemeChoice.light,
       _open = saved.open,
       _pending = saved.pending;

  final StudentApi _api;
  final ThemeStore _store;

  ThemeChoice _choice;
  bool _open;
  bool _pending;

  /// A dev-build preview only; it never saves or calls the server.
  ThemeChoice? _debugChoice;

  ThemeChoice get choice => _choice;

  /// Whether the `theme` switch is open to this student. The Appearance row
  /// is shown only then.
  bool get open => _open;

  /// A choice the server has not taken yet; retried on the next resume.
  bool get pending => _pending;

  /// What MaterialApp uses. Closed or unknown is always Light.
  ThemeMode get mode => _debugChoice != null
      ? switch (_debugChoice!) {
          ThemeChoice.light => ThemeMode.light,
          ThemeChoice.dark => ThemeMode.dark,
          ThemeChoice.system => ThemeMode.system,
        }
      : !_open
      ? ThemeMode.light
      : switch (_choice) {
          ThemeChoice.light => ThemeMode.light,
          ThemeChoice.dark => ThemeMode.dark,
          ThemeChoice.system => ThemeMode.system,
        };

  /// Read the server's copy: on sign-in, on resume and on the first load.
  /// Also retries a choice the server did not take, before reading.
  Future<void> refreshFromServer() async {
    if (_pending) {
      try {
        final saved = await _api.setPreferences(_choice);
        _apply(saved, keepPending: false);
      } on NotFoundFailure {
        await _close();
        return;
      } catch (_) {
        // Still pending; the GET below may still work.
      }
    }
    try {
      _apply(await _api.preferences(), keepPending: false);
    } on NotFoundFailure {
      // The switch is closed to this student (the route answers 404).
      await _close();
    } catch (_) {
      // Keep what the phone knows; the next resume tries again.
    }
  }

  /// The student picked a theme in Profile. Applies at once; a failed save
  /// keeps the choice on the phone and retries on the next resume.
  Future<void> select(ThemeChoice choice) async {
    if (!_open || choice == _choice) return;
    _choice = choice;
    _pending = true;
    notifyListeners();
    await _persist();
    try {
      _apply(await _api.setPreferences(choice), keepPending: false);
    } on NotFoundFailure {
      await _close();
    } catch (_) {
      // The choice holds; pending stays true.
    }
  }

  /// Dev menu only: draw the app in [choice] without saving or calling the
  /// server. Null returns to the server's answer.
  void debugPreview(ThemeChoice? choice) {
    _debugChoice = choice;
    notifyListeners();
  }

  ThemeChoice? get debugChoice => _debugChoice;

  /// Signing out returns the app to Light and clears the kept choice.
  Future<void> signOut() async {
    if (!_open && _choice == ThemeChoice.light && !_pending) return;
    _choice = ThemeChoice.light;
    _open = false;
    _pending = false;
    notifyListeners();
    try {
      await _store.clear();
    } catch (_) {
      // The next launch treats an unreadable store as Light/closed.
    }
  }

  void _apply(ThemePreference preference, {required bool keepPending}) {
    if (!preference.themeOpen) {
      // The rollback path: force Light and forget the kept choice.
      _choice = ThemeChoice.light;
      _open = false;
      _pending = false;
      notifyListeners();
      // No await: the caller does not need the store's answer.
      _store.clear().catchError((_) {});
      return;
    }
    _choice = preference.theme;
    _open = true;
    _pending = keepPending ? _pending : false;
    notifyListeners();
    _persist();
  }

  Future<void> _close() async {
    _choice = ThemeChoice.light;
    _open = false;
    _pending = false;
    notifyListeners();
    try {
      await _store.clear();
    } catch (_) {
      // Light is still what shows.
    }
  }

  Future<void> _persist() async {
    try {
      await _store.write(
        choice: _choice,
        open: _open,
        pending: _pending,
      );
    } catch (_) {
      // The choice still holds for this run.
    }
  }
}
