import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:rvm_student/core/version/version_gate.dart';

/// [SecureStore] in memory. One instance stands for the phone's storage, so
/// a second app or session built on it is a "restart".
class FakeSecureStore extends SecureStore {
  FakeSecureStore([Map<String, String>? values]) : values = {...?values};

  final Map<String, String> values;

  /// Set to make the next calls fail the way a broken store would.
  Object? failReads;
  Object? failWrites;

  int reads = 0;
  int writes = 0;

  @override
  Future<String?> read({required String key}) async {
    reads++;
    if (failReads != null) throw failReads!;
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    writes++;
    if (failWrites != null) throw failWrites!;
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    if (failWrites != null) throw failWrites!;
    values.remove(key);
  }

  @override
  Future<void> deleteAll() async => values.clear();
}

/// What one request looked like when it reached the wire.
class SeenRequest {
  SeenRequest(this.options)
    : headers = {
        for (final e in options.headers.entries)
          e.key.toLowerCase(): '${e.value}',
      };

  final RequestOptions options;
  final Map<String, String> headers;

  String get method => options.method;
  Uri get uri => options.uri;

  String? header(String name) => headers[name.toLowerCase()];

  String? get idempotencyKey => header(IdempotencyInterceptor.header);

  String? get bearer {
    final value = header('Authorization');
    return value?.substring('Bearer '.length);
  }
}

/// An HTTP adapter that answers from a script and records every request.
class ScriptedAdapter implements HttpClientAdapter {
  ScriptedAdapter(this.answer);

  final FutureOr<ResponseBody> Function(RequestOptions options, int call)
  answer;
  final List<SeenRequest> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(SeenRequest(options));
    return answer(options, seen.length);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonReply(int status, Object body) => ResponseBody.fromString(
  json.encode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

/// A [VersionSource] that answers what a test says.
class FakeVersionSource implements VersionSource {
  FakeVersionSource(this.answer);

  final Future<MinimumVersion> Function() answer;
  int calls = 0;

  @override
  Future<MinimumVersion> minimumVersion() {
    calls++;
    return answer();
  }
}
