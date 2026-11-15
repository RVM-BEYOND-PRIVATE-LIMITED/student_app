import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/jobs/bloc/jobs_bloc.dart';

import '../../support/fakes.dart';

final _config = {
  'min_supported_version': '0.1.0',
  'latest_version': '0.1.0',
  'store_url': null,
  'maintenance': {'active': false, 'message': null},
  'jobs_header': {
    'title': 'BadaBhai Campus',
    'subtitle': null,
    'logos': <Object>[],
  },
};

Map<String, dynamic> _access(bool allowed, String? reason) => {
  'allowed': allowed,
  'reason': reason,
  'reasons': reason == null ? <String>[] : [reason],
  'stage': 'registered',
  'checked_at': '2026-11-14T10:00:00Z',
};

StudentApi _api(ScriptedAdapter adapter) => StudentApi(
  Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000'))
    ..httpClientAdapter = adapter
    ..interceptors.add(IdempotencyInterceptor()),
);

void main() {
  test('an open gate asks for the hand-off and returns the link', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.configPath) {
        return jsonReply(200, _config);
      }
      if (options.path == StudentApi.jobsAccessPath) {
        return jsonReply(200, _access(true, null));
      }
      if (options.path == StudentApi.campusHandoffPath) {
        return jsonReply(200, {
          'url': 'https://jobs.rvmcad.org/campus/handoff#token=abc',
          'expires_at': '2026-11-14T10:01:00Z',
        });
      }
      return jsonReply(404, {
        'code': 'NOT_FOUND',
        'message': 'no route',
        'details': null,
        'request_id': 'req-1',
      });
    });
    final bloc = JobsBloc(_api(adapter));
    addTearDown(bloc.close);

    final ready = bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const JobsStarted());
    final state = await ready;
    expect(state.access?.allowed, isTrue);
    expect(state.header?.title, 'BadaBhai Campus');

    final handoff = bloc.stream.firstWhere((s) => s.handoffUrl != null);
    bloc.add(const JobsHandoffRequested());
    final withLink = await handoff;

    expect(withLink.handoffUrl?.host, 'jobs.rvmcad.org');
    final call = adapter.seen.firstWhere(
      (r) => r.uri.path == StudentApi.campusHandoffPath,
    );
    expect(call.method, 'POST');
    expect(call.idempotencyKey, isNotNull);
    // The body the app keeps is only the returned link; it is never a
    // header, a log line or a stored value.
    expect(bloc.state.handoffUrl?.fragment, 'token=abc');
  });

  test('a closed gate asks for no hand-off', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.configPath) {
        return jsonReply(200, _config);
      }
      return jsonReply(200, _access(false, 'fee_pending'));
    });
    final bloc = JobsBloc(_api(adapter));
    addTearDown(bloc.close);

    final ready = bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const JobsStarted());
    await ready;

    bloc.add(const JobsHandoffRequested());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(
      adapter.seen.where((r) => r.uri.path == StudentApi.campusHandoffPath),
      isEmpty,
    );
    expect(bloc.state.access?.reason?.name, 'feePending');
  });
}
