import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/models.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/theme/theme_controller.dart';
import 'package:rvm_student/features/theme/theme_store.dart';

import '../../support/fakes.dart';

/// A StudentApi whose preferences calls are scripted; nothing touches the
/// network. The other routes are unused here.
class _FakeApi extends StudentApi {
  _FakeApi() : super(Dio());

  ThemePreference nextGet = const ThemePreference(
    theme: ThemeChoice.light,
    themeOpen: false,
  );
  Object? getError;
  Object? putError;
  final puts = <ThemeChoice>[];

  @override
  Future<ThemePreference> preferences() async {
    if (getError != null) throw getError!;
    return nextGet;
  }

  @override
  Future<ThemePreference> setPreferences(ThemeChoice theme) async {
    puts.add(theme);
    if (putError != null) throw putError!;
    nextGet = ThemePreference(theme: theme, themeOpen: true);
    return nextGet;
  }
}

void main() {
  test('closed forces Light even when the saved choice says Dark', () async {
    final store = FakeSecureStore({
      ThemeStore.choiceKey: 'dark',
      ThemeStore.openKey: 'false',
      ThemeStore.pendingKey: 'true',
    });
    final controller = ThemeController(
      api: _FakeApi(),
      store: ThemeStore(store),
      saved: await ThemeStore(store).read(),
    );

    expect(controller.mode, ThemeMode.light);
    expect(controller.open, isFalse);
  });

  test('an open saved choice is used before the server answers', () async {
    final store = FakeSecureStore({
      ThemeStore.choiceKey: 'dark',
      ThemeStore.openKey: 'true',
    });
    final controller = ThemeController(
      api: _FakeApi(),
      store: ThemeStore(store),
      saved: await ThemeStore(store).read(),
    );

    expect(controller.mode, ThemeMode.dark);
    expect(controller.open, isTrue);
  });

  test('a choice applies at once and is saved through the API', () async {
    final api = _FakeApi()
      ..nextGet = const ThemePreference(
        theme: ThemeChoice.light,
        themeOpen: true,
      );
    final store = FakeSecureStore();
    final controller = ThemeController(
      api: api,
      store: ThemeStore(store),
      saved: const SavedTheme(
        choice: ThemeChoice.light,
        open: true,
        pending: false,
      ),
    );

    await controller.select(ThemeChoice.dark);

    expect(controller.mode, ThemeMode.dark);
    expect(controller.pending, isFalse);
    expect(api.puts, [ThemeChoice.dark]);
    expect(store.values[ThemeStore.choiceKey], 'dark');
  });

  test('a failed save keeps the choice and retries on the next resume', () async {
    final api = _FakeApi()
      ..nextGet = const ThemePreference(
        theme: ThemeChoice.light,
        themeOpen: true,
      )
      ..putError = const UnknownFailure();
    final store = FakeSecureStore();
    final controller = ThemeController(
      api: api,
      store: ThemeStore(store),
      saved: const SavedTheme(
        choice: ThemeChoice.light,
        open: true,
        pending: false,
      ),
    );

    await controller.select(ThemeChoice.dark);
    expect(controller.mode, ThemeMode.dark);
    expect(controller.pending, isTrue);

    api.putError = null;
    await controller.refreshFromServer();
    expect(api.puts, [ThemeChoice.dark, ThemeChoice.dark]);
    expect(controller.pending, isFalse);
  });

  test('a closed switch on the server forces Light and clears the choice', () async {
    final api = _FakeApi()
      ..nextGet = const ThemePreference(
        theme: ThemeChoice.light,
        themeOpen: false,
      );
    final store = FakeSecureStore({
      ThemeStore.choiceKey: 'dark',
      ThemeStore.openKey: 'true',
    });
    final controller = ThemeController(
      api: api,
      store: ThemeStore(store),
      saved: await ThemeStore(store).read(),
    );

    await controller.refreshFromServer();

    expect(controller.mode, ThemeMode.light);
    expect(controller.open, isFalse);
    expect(store.values.containsKey(ThemeStore.choiceKey), isFalse);
  });

  test('a 404 on GET is the rollback path, not a failure', () async {
    final api = _FakeApi()
      ..getError = const NotFoundFailure(null, null, 'req-theme');
    final controller = ThemeController(
      api: api,
      store: ThemeStore(FakeSecureStore()),
      saved: const SavedTheme(
        choice: ThemeChoice.dark,
        open: true,
        pending: false,
      ),
    );

    await controller.refreshFromServer();

    expect(controller.mode, ThemeMode.light);
    expect(controller.open, isFalse);
  });

  test('signing out returns the app to Light and clears the phone', () async {
    final store = FakeSecureStore({
      ThemeStore.choiceKey: 'dark',
      ThemeStore.openKey: 'true',
    });
    final controller = ThemeController(
      api: _FakeApi(),
      store: ThemeStore(store),
      saved: await ThemeStore(store).read(),
    );

    await controller.signOut();

    expect(controller.mode, ThemeMode.light);
    expect(controller.open, isFalse);
    expect(store.values, isEmpty);
  });
}
