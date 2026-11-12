import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/app_crash.dart';
import 'package:rvm_student/core/crash/crash_log.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('rvm_crash_log_test');
  });

  tearDown(() async {
    CrashLog.store = MemoryCrashLogStore();
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  CrashRecord record(String summary, {int minute = 0}) => CrashRecord(
    at: DateTime.utc(2026, 11, 12, 10, minute),
    kind: CrashKind.zone,
    summary: summary,
  );

  group('CrashLog.record (item 12)', () {
    test('cleans personal data before anything is kept', () async {
      final store = MemoryCrashLogStore();
      CrashLog.store = store;

      await CrashLog.record(
        StateError(
          'login failed for 9999999999 with otp=482913, '
          'Authorization: Bearer secret-token',
        ),
        StackTrace.fromString('#0 main (file.dart:1)\nphone=9999999999'),
        kind: CrashKind.zone,
        at: DateTime.utc(2026, 11, 12),
      );

      final kept = (await store.read()).single;
      expect(kept.kind, CrashKind.zone);
      expect(kept.at, DateTime.utc(2026, 11, 12));
      for (final secret in ['9999999999', '482913', 'secret-token']) {
        expect(kept.summary, isNot(contains(secret)), reason: secret);
        expect(kept.stack, isNot(contains(secret)), reason: secret);
      }
      expect(kept.summary, contains('login failed'));
    });

    test('clips very long errors', () async {
      final store = MemoryCrashLogStore();
      CrashLog.store = store;

      await CrashLog.record('x' * 5000, null, kind: CrashKind.test);

      final kept = (await store.read()).single;
      expect(kept.summary.length, lessThanOrEqualTo(1001));
      expect(kept.stack, isNull);
    });

    test('never throws, even when storage fails', () async {
      CrashLog.store = _BrokenStore();

      await expectLater(
        CrashLog.record('boom', null, kind: CrashKind.zone),
        completes,
      );
    });
  });

  group('installCrashCapture', () {
    test('framework, dispatcher and zone errors all reach the log', () async {
      final store = MemoryCrashLogStore();
      final previousOnError = FlutterError.onError;
      final previousBuilder = ErrorWidget.builder;
      addTearDown(() {
        FlutterError.onError = previousOnError;
        ErrorWidget.builder = previousBuilder;
        PlatformDispatcher.instance.onError = null;
      });
      TestWidgetsFlutterBinding.ensureInitialized();

      installCrashCapture(store);
      FlutterError.onError!(
        FlutterErrorDetails(exception: StateError('framework 9999999999')),
      );
      final handled = PlatformDispatcher.instance.onError!(
        StateError('dispatcher'),
        StackTrace.empty,
      );
      recordZoneError(StateError('zone'), StackTrace.empty);
      await Future<void>.delayed(Duration.zero);

      final kept = await store.read();
      expect(handled, isTrue);
      expect(kept.map((r) => r.kind), [
        CrashKind.flutter,
        CrashKind.platform,
        CrashKind.zone,
      ]);
      expect(kept.first.summary, isNot(contains('9999999999')));
    });
  });

  group('MemoryCrashLogStore', () {
    test('keeps the newest records only', () async {
      final store = MemoryCrashLogStore(maxRecords: 2);

      for (var i = 0; i < 3; i++) {
        await store.append(record('r$i', minute: i));
      }

      expect((await store.read()).map((r) => r.summary), ['r1', 'r2']);
      await store.clear();
      expect(await store.read(), isEmpty);
    });
  });

  group('FileCrashLogStore (on this phone only)', () {
    test('appends, reads back after a restart, and clears', () async {
      final folder = Future.value(Directory('${dir.path}/rvm_crash_log'));
      await FileCrashLogStore(folder).append(record('first'));
      await FileCrashLogStore(folder).append(record('second', minute: 1));

      // A restart: a new store on the same folder.
      final reopened = FileCrashLogStore(folder);
      expect((await reopened.read()).map((r) => r.summary), [
        'first',
        'second',
      ]);

      await reopened.clear();
      expect(await reopened.read(), isEmpty);
    });

    test('keeps the newest records only', () async {
      final store = FileCrashLogStore(Future.value(dir), maxRecords: 3);

      for (var i = 0; i < 5; i++) {
        await store.append(record('r$i', minute: i));
      }

      expect((await store.read()).map((r) => r.summary), ['r2', 'r3', 'r4']);
    });

    test('writes at the same moment do not tear the file', () async {
      final store = FileCrashLogStore(Future.value(dir), maxRecords: 50);

      await Future.wait([
        for (var i = 0; i < 20; i++) store.append(record('r$i', minute: i)),
      ]);

      expect(await store.read(), hasLength(20));
    });

    test('a torn or unknown line is skipped, the rest still read', () async {
      final store = FileCrashLogStore(Future.value(dir));
      await store.append(record('good'));
      final file = File('${dir.path}/crash_log.jsonl');
      await file.writeAsString(
        '{"at": "nonsense"}\n{"half\n',
        mode: FileMode.append,
      );

      expect((await store.read()).map((r) => r.summary), ['good']);
    });

    test('a phone with no log reads as empty', () async {
      expect(
        await FileCrashLogStore(
          Future.value(Directory('${dir.path}/none')),
        ).read(),
        isEmpty,
      );
    });
  });

  test('a record survives the JSON round trip', () {
    final original = CrashRecord(
      at: DateTime.utc(2026, 11, 12, 10),
      kind: CrashKind.flutter,
      summary: 'summary',
      stack: 'stack',
    );

    expect(CrashRecord.fromJson(original.toJson()), original);
    expect(CrashRecord.fromJson('not a map'), isNull);
    expect(
      CrashRecord.fromJson({'at': 'x', 'kind': 'zone', 'summary': 's'}),
      isNull,
    );
  });
}

class _BrokenStore implements CrashLogStore {
  @override
  Future<void> append(CrashRecord record) async => throw StateError('full');

  @override
  Future<void> clear() async {}

  @override
  Future<List<CrashRecord>> read() async => const [];
}
