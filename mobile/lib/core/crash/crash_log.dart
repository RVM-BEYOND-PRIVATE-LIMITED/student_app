import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../redact/student_redact.dart';

/// Where an error was caught.
enum CrashKind {
  /// A Flutter framework error (`FlutterError.onError`).
  flutter,

  /// An error the platform dispatcher caught (`PlatformDispatcher.onError`).
  platform,

  /// An error that escaped every handler (`runZonedGuarded`).
  zone,

  /// A test record made from the Developer menu.
  test,
}

/// One caught error, already cleaned of personal data.
@immutable
class CrashRecord extends Equatable {
  const CrashRecord({
    required this.at,
    required this.kind,
    required this.summary,
    this.stack,
  });

  /// When it happened, in UTC.
  final DateTime at;
  final CrashKind kind;

  /// The error's text, redacted and clipped.
  final String summary;

  /// The stack trace, redacted and clipped.
  final String? stack;

  Map<String, Object?> toJson() => {
    'at': at.toUtc().toIso8601String(),
    'kind': kind.name,
    'summary': summary,
    if (stack != null) 'stack': stack,
  };

  /// Null for a line that is not a record (a torn write, an old format).
  static CrashRecord? fromJson(Object? json) {
    if (json is! Map) return null;
    final at = DateTime.tryParse('${json['at']}');
    final kind = CrashKind.values.asNameMap()['${json['kind']}'];
    final summary = json['summary'];
    if (at == null || kind == null || summary is! String) return null;
    final stack = json['stack'];
    return CrashRecord(
      at: at.toUtc(),
      kind: kind,
      summary: summary,
      stack: stack is String ? stack : null,
    );
  }

  @override
  List<Object?> get props => [at, kind, summary, stack];
}

/// Where crash records are kept.
abstract interface class CrashLogStore {
  /// The kept records, oldest first.
  Future<List<CrashRecord>> read();

  Future<void> append(CrashRecord record);

  Future<void> clear();
}

/// Records in memory: for tests, and the fallback when no file can be used.
class MemoryCrashLogStore implements CrashLogStore {
  MemoryCrashLogStore({this.maxRecords = CrashLog.maxRecords});

  final int maxRecords;
  final List<CrashRecord> _records = [];

  @override
  Future<List<CrashRecord>> read() async => List.unmodifiable(_records);

  @override
  Future<void> append(CrashRecord record) async {
    _records.add(record);
    if (_records.length > maxRecords) {
      _records.removeRange(0, _records.length - maxRecords);
    }
  }

  @override
  Future<void> clear() async => _records.clear();
}

/// Records in one file on this phone: `crash_log.jsonl` in the app's private
/// `rvm_crash_log/` folder, one JSON record per line, the last
/// [maxRecords] kept.
///
/// The folder is in the app's own storage, which other apps cannot read, and
/// the backup rules keep it out of backups. Nothing here sends it anywhere:
/// whether crash reports may leave the phone is student_app #12, which waits
/// for the owner's decision.
class FileCrashLogStore implements CrashLogStore {
  FileCrashLogStore(this._directory, {this.maxRecords = CrashLog.maxRecords});

  /// The store in the app's support folder (Android's `filesDir`).
  factory FileCrashLogStore.inAppStorage() => FileCrashLogStore(
    getApplicationSupportDirectory().then(
      (dir) => Directory('${dir.path}/rvm_crash_log'),
    ),
  );

  final Future<Directory> _directory;
  final int maxRecords;

  /// Writes run one after another, so two crashes at once cannot tear the
  /// file.
  Future<void> _queue = Future<void>.value();

  Future<File> get _file async =>
      File('${(await _directory).path}/crash_log.jsonl');

  @override
  Future<List<CrashRecord>> read() async {
    await _queue;
    final file = await _file;
    if (!await file.exists()) return const [];
    final lines = await file.readAsLines();
    return [
      for (final line in lines)
        if (_decode(line) case final CrashRecord record) record,
    ];
  }

  @override
  Future<void> append(CrashRecord record) => _enqueue(() async {
    final file = await _file;
    await file.parent.create(recursive: true);
    final kept = await file.exists() ? await file.readAsLines() : <String>[];
    kept.add(jsonEncode(record.toJson()));
    final tail = kept.length > maxRecords
        ? kept.sublist(kept.length - maxRecords)
        : kept;
    await file.writeAsString('${tail.join('\n')}\n', flush: true);
  });

  @override
  Future<void> clear() => _enqueue(() async {
    final file = await _file;
    if (await file.exists()) await file.delete();
  });

  Future<void> _enqueue(Future<void> Function() write) {
    final next = _queue.then((_) => write());
    // A failed write must not block the ones after it.
    _queue = next.catchError((Object _) {});
    return next;
  }

  static CrashRecord? _decode(String line) {
    if (line.trim().isEmpty) return null;
    try {
      return CrashRecord.fromJson(jsonDecode(line));
    } catch (_) {
      return null;
    }
  }
}

/// Crash capture with no personal data, kept on this phone (student_app #1,
/// item 12).
///
/// Every error passes through [StudentRedact] before anything is kept, so no
/// phone number, OTP, token or name lands in the log. Nothing is printed in a
/// release build, so the device log stays clean too. Sending reports off the
/// phone (Crashlytics) is student_app #12 and needs the owner's OK first;
/// until then the records stay here and the Developer menu shows them.
abstract final class CrashLog {
  static const maxRecords = 20;
  static const _maxSummary = 1000;
  static const _maxStack = 4000;

  /// Where records go. `installCrashCapture` sets the on-device file store.
  static CrashLogStore store = MemoryCrashLogStore();

  /// Keeps [error] (cleaned) and never throws: reporting must not crash the
  /// app it watches.
  static Future<void> record(
    Object error,
    StackTrace? stack, {
    required CrashKind kind,
    DateTime? at,
  }) async {
    final record = CrashRecord(
      at: (at ?? DateTime.now()).toUtc(),
      kind: kind,
      summary: _clip(StudentRedact.text('$error'), _maxSummary),
      stack: stack == null
          ? null
          : _clip(StudentRedact.text('$stack'), _maxStack),
    );
    if (kDebugMode) {
      debugPrint('RVM Student ${kind.name} error: ${record.summary}');
    }
    try {
      await store.append(record);
    } catch (_) {
      // Storage failed too; the error is lost rather than crashing the app.
    }
  }

  static String _clip(String value, int max) =>
      value.length <= max ? value : '${value.substring(0, max)}…';
}
