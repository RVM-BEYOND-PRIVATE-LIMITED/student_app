import 'dart:convert';

import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/models.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/onboarding/bloc/consent_bloc.dart';

import '../../support/fakes.dart';

const _account = {
  'id': '11111111-1111-4111-8111-111111111111',
  'phone_masked': '••••••3210',
  'language': 'en',
  'stage': 'visitor',
  'fee_fully_paid': false,
  'is_alumni': false,
  'link_state': 'unlinked',
  'onboarding': {'age_confirmed': false, 'required_consent_given': false},
  'counts': {'placement_prompts': 0, 'consent_requests': 0},
};

const _texts = {
  'texts': [
    {
      'purpose': 'share_profile',
      'version': 3,
      'language': 'en',
      'text': 'Share my profile with companies I apply to.',
      'required': true,
    },
    {
      'purpose': 'marketing_story',
      'version': 2,
      'language': 'en',
      'text': 'Use my placement story in marketing.',
      'required': false,
    },
  ],
};

void main() {
  late ScriptedAdapter adapter;
  late ConsentBloc bloc;

  setUp(() {
    adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.consentTextsPath) {
        return jsonReply(200, _texts);
      }
      if (options.path == StudentApi.ageConfirmationPath) {
        return jsonReply(200, _account);
      }
      if (options.path == StudentApi.consentsPath) {
        if (options.method == 'PUT') {
          return jsonReply(200, {
            'consents': [
              {
                'purpose': 'share_profile',
                'granted': true,
                'text_version': 3,
                'granted_at': '2026-11-14T10:00:00Z',
                'withdrawn_at': null,
              },
              {
                'purpose': 'marketing_story',
                'granted': false,
                'text_version': 2,
                'granted_at': null,
                'withdrawn_at': null,
              },
            ],
          });
        }
      }
      if (options.path == StudentApi.mePath) {
        return jsonReply(200, {
          ..._account,
          'onboarding': {
            'age_confirmed': true,
            'required_consent_given': true,
          },
        });
      }
      return jsonReply(404, {
        'code': 'NOT_FOUND',
        'message': 'no route',
        'details': null,
        'request_id': 'req-1',
      });
    });
    final api = StudentApi(
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000'))
        ..httpClientAdapter = adapter
        ..interceptors.add(IdempotencyInterceptor()),
    );
    bloc = ConsentBloc(api);
    addTearDown(bloc.close);
  });

  test('the lines come from the server with their versions', () async {
    final ready = bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(
      ConsentStarted(
        language: 'en',
        account: StudentAccountForTest.visitor(),
      ),
    );
    final state = await ready;

    expect(state.shareProfileText?.version, 3);
    expect(state.shareProfileText?.required, isTrue);
    expect(state.marketingText?.version, 2);
    expect(state.ageConfirmed, isFalse);
    expect(state.canSubmit, isFalse);
  });

  test('the 18+ tick and the required line unlock Continue', () async {
    bloc.add(
      ConsentStarted(
        language: 'en',
        account: StudentAccountForTest.visitor(),
      ),
    );
    await bloc.stream.firstWhere((s) => !s.loading);

    bloc.add(const ConsentAgeChanged(true));
    await bloc.stream.firstWhere((s) => s.ageConfirmed);
    expect(bloc.state.canSubmit, isFalse, reason: 'the required line is unticked');

    bloc.add(const ConsentShareProfileChanged(true));
    await bloc.stream.firstWhere((s) => s.shareProfile);
    expect(bloc.state.canSubmit, isTrue);
  });

  test('submitting sends back the versions shown and saves the account', () async {
    bloc.add(
      ConsentStarted(
        language: 'en',
        account: StudentAccountForTest.visitor(),
      ),
    );
    await bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const ConsentAgeChanged(true));
    await bloc.stream.firstWhere((s) => s.ageConfirmed);
    bloc.add(const ConsentShareProfileChanged(true));
    await bloc.stream.firstWhere((s) => s.shareProfile);

    final saved = bloc.stream.firstWhere((s) => s.savedAccount != null);
    bloc.add(const ConsentSubmitted());
    final state = await saved;

    expect(state.savedAccount?.onboardingComplete, isTrue);

    final put = adapter.seen.firstWhere(
      (r) => r.uri.path == StudentApi.consentsPath && r.method == 'PUT',
    );
    final body = put.options.data as Map<String, dynamic>;
    expect(body['share_profile'], isTrue);
    expect(body['marketing_story'], isFalse);
    expect(body['text_versions'], {'share_profile': 3, 'marketing_story': 2});
    expect(
      adapter.seen.map((r) => r.uri.path),
      containsAll([
        StudentApi.ageConfirmationPath,
        StudentApi.consentsPath,
        StudentApi.mePath,
      ]),
    );
  });
}

/// The visitor account, decoded from the test's own JSON.
abstract final class StudentAccountForTest {
  static StudentAccount visitor() => StudentAccount.fromJson(
    jsonDecode(jsonEncode(_account)) as Map<String, dynamic>,
  );
}
