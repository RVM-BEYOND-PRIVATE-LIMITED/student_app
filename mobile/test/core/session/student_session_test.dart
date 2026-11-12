import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/session/student_session.dart';

import '../../support/fakes.dart';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  late FakeSecureStore store;

  setUp(() => store = FakeSecureStore());

  group('tokens (item 5)', () {
    test('a new phone has no session', () async {
      final session = StudentSession(store);

      expect(await session.hasSession(), isFalse);
      expect(await session.accessToken(), isNull);
      expect(await session.refreshToken(), isNull);
    });

    test(
      'saved tokens are kept in SecureStore and survive a restart',
      () async {
        await StudentSession(
          store,
        ).saveTokens(accessToken: 'access-1', refreshToken: 'refresh-1');

        expect(store.values[StudentSession.accessTokenKey], 'access-1');
        expect(store.values[StudentSession.refreshTokenKey], 'refresh-1');

        // A restart: a new session on the same phone storage.
        final restored = StudentSession(store);
        expect(await restored.hasSession(), isTrue);
        expect(await restored.accessToken(), 'access-1');
        expect(await restored.refreshToken(), 'refresh-1');
      },
    );

    test(
      'ending the session removes both tokens and keeps the install id',
      () async {
        final session = StudentSession(store);
        await session.saveTokens(accessToken: 'a', refreshToken: 'r');
        final id = await session.installId();

        await session.endSession();

        expect(await session.hasSession(), isFalse);
        expect(
          store.values.containsKey(StudentSession.accessTokenKey),
          isFalse,
        );
        expect(
          store.values.containsKey(StudentSession.refreshTokenKey),
          isFalse,
        );
        expect(store.values[StudentSession.installIdKey], id);
        expect(await StudentSession(store).installId(), id);
      },
    );

    test('an empty saved token counts as none', () async {
      store.values[StudentSession.accessTokenKey] = '';
      store.values[StudentSession.refreshTokenKey] = '';

      expect(await StudentSession(store).hasSession(), isFalse);
    });

    test('the store is read once, then served from memory', () async {
      final session = StudentSession(store);
      await session.load();
      final reads = store.reads;

      await session.accessToken();
      await session.refreshToken();
      await session.hasSession();

      expect(store.reads, reads);
    });

    test('a failed read is tried again on the next call', () async {
      store.values[StudentSession.accessTokenKey] = 'access-1';
      store.failReads = StateError('keystore busy');
      final session = StudentSession(store);

      await expectLater(session.load(), throwsStateError);

      store.failReads = null;
      expect(await session.accessToken(), 'access-1');
    });
  });

  group('install id (item 5)', () {
    test('is a version 4 UUID, made once and kept', () async {
      final session = StudentSession(store);

      final first = await session.installId();
      final again = await session.installId();

      expect(first, matches(_uuidV4));
      expect(again, first);
      expect(store.values[StudentSession.installIdKey], first);
    });

    test('calls at the same moment share one id', () async {
      final session = StudentSession(store);

      final ids = await Future.wait([
        session.installId(),
        session.installId(),
        session.load().then((_) => session.installId()),
      ]);

      expect(ids.toSet(), hasLength(1));
      expect(store.writes, 1);
    });

    test('survives a restart', () async {
      final id = await StudentSession(store).installId();

      expect(await StudentSession(store).installId(), id);
    });

    test('another phone makes its own', () async {
      final mine = await StudentSession(FakeSecureStore()).installId();
      final theirs = await StudentSession(FakeSecureStore()).installId();

      expect(mine, isNot(theirs));
    });

    test('a saved id that cannot be read is not replaced', () async {
      store.values[StudentSession.installIdKey] = 'kept-id';
      store.failReads = StateError('keystore busy');
      final session = StudentSession(store);

      await expectLater(session.installId(), throwsStateError);
      expect(store.values[StudentSession.installIdKey], 'kept-id');

      store.failReads = null;
      expect(await session.installId(), 'kept-id');
    });

    test('an id that cannot be saved still serves this run', () async {
      store.failWrites = StateError('disk full');
      final session = StudentSession(store);

      final id = await session.installId();

      expect(id, matches(_uuidV4));
      expect(await session.installId(), id);
    });
  });
}
