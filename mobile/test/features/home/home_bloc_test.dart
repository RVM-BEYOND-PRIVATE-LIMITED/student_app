import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/home/bloc/home_bloc.dart';

import '../../support/fakes.dart';

const _openPrompt = {
  'id': '11111111-1111-4111-8111-111111111111',
  'company_name': 'Tata Motors',
  'job_title': 'Graduate Engineer Trainee',
  'status': 'open',
  'received_at': '2026-11-14T10:00:00Z',
};

const _pendingRequest = {
  'id': '22222222-2222-4222-8222-222222222222',
  'company_name': 'Tata Motors',
  'job_title': 'Graduate Engineer Trainee',
  'question': 'May Tata Motors see your profile?',
  'text_version': 1,
  'status': 'pending',
  'expires_at': '2026-11-20T10:00:00Z',
};

StudentApi _api(ScriptedAdapter adapter) => StudentApi(
  Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000'))
    ..httpClientAdapter = adapter
    ..interceptors.add(IdempotencyInterceptor()),
);

void main() {
  test('the two cards come from the server', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.placementPromptsPath) {
        return jsonReply(200, {
          'prompts': [_openPrompt, {..._openPrompt, 'id': 'x', 'status': 'done'}],
        });
      }
      return jsonReply(200, {
        'requests': [_pendingRequest, {..._pendingRequest, 'status': 'expired'}],
      });
    });
    final bloc = HomeBloc(_api(adapter));
    addTearDown(bloc.close);

    final ready = bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const HomeStarted());
    final state = await ready;

    expect(state.prompts.map((p) => p.id), [_openPrompt['id']]);
    expect(state.consentRequests.map((r) => r.id), [_pendingRequest['id']]);
  });

  test('dismissing a prompt calls the server and removes it', () async {
    var dismissed = 0;
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.placementPromptsPath) {
        return jsonReply(200, {
          'prompts': [_openPrompt],
        });
      }
      if (options.path.endsWith('/dismiss')) {
        dismissed++;
        return jsonReply(200, _openPrompt);
      }
      return jsonReply(200, {'requests': <Object>[]});
    });
    final bloc = HomeBloc(_api(adapter));
    addTearDown(bloc.close);
    bloc.add(const HomeStarted());
    await bloc.stream.firstWhere((s) => !s.loading);

    final gone = bloc.stream.firstWhere((s) => s.prompts.isEmpty);
    bloc.add(HomePromptDismissed(_openPrompt['id']!));
    await gone;

    expect(dismissed, 1);
    final call = adapter.seen.firstWhere(
      (r) => r.uri.path.endsWith('/dismiss'),
    );
    expect(call.method, 'POST');
    expect(call.idempotencyKey, isNotNull);
  });

  test('answering a consent question sends yes and removes it', () async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.consentRequestsPath &&
          options.method == 'GET') {
        return jsonReply(200, {
          'requests': [_pendingRequest],
        });
      }
      if (options.path.endsWith('/answer')) {
        return jsonReply(200, {..._pendingRequest, 'status': 'yes'});
      }
      return jsonReply(200, {'prompts': <Object>[]});
    });
    final bloc = HomeBloc(_api(adapter));
    addTearDown(bloc.close);
    bloc.add(const HomeStarted());
    await bloc.stream.firstWhere((s) => !s.loading);

    final gone = bloc.stream.firstWhere((s) => s.consentRequests.isEmpty);
    bloc.add(HomeConsentAnswered(id: _pendingRequest['id']! as String, yes: true));
    await gone;

    final answer = adapter.seen.firstWhere(
      (r) => r.uri.path.endsWith('/answer'),
    );
    expect((answer.options.data as Map)['answer'], 'yes');
  });
}
