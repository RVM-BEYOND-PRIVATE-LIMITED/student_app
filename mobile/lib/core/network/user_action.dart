import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

/// One thing the student did: one form sent, one button pressed.
///
/// The action makes its `Idempotency-Key` once. Every attempt of the same
/// action sends that key: the automatic retry after a connection that never
/// opened, and the student's own "Try again" after a connection that dropped
/// mid-way. The server can then tell a repeat from a second action. The next
/// action makes a new key (student_app #1, item 4; team_app #50).
class UserAction {
  UserAction() : key = IdempotencyInterceptor.newKey();

  /// The action's key: a random version 4 UUID.
  final String key;

  /// [base] with this action's key added, for the request's `options:`.
  Options options([Options? base]) {
    final extra = <String, dynamic>{
      ...?base?.extra,
      IdempotencyInterceptor.extraKey: key,
    };
    return (base ?? Options()).copyWith(extra: extra);
  }
}
