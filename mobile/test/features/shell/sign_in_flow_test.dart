import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/auth/otp_screen.dart';
import 'package:rvm_student/features/auth/sign_in_screen.dart';
import 'package:rvm_student/features/home/home_shell.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';

import '../../support/app_harness.dart';
import '../../support/fakes.dart';

const _account = {
  'id': '11111111-1111-4111-8111-111111111111',
  'phone_masked': '••••••3210',
  'language': 'en',
  'stage': 'registered',
  'fee_fully_paid': false,
  'is_alumni': false,
  'link_state': 'linked',
  'onboarding': {'age_confirmed': true, 'required_consent_given': true},
  'counts': {'placement_prompts': 0, 'consent_requests': 0},
};

const _challenge = {
  'challenge_id': '22222222-2222-4222-8222-222222222222',
  'channel': 'whatsapp',
  'expires_at': '2026-11-14T10:05:00Z',
  'resend_available_at': '2026-11-14T10:01:00Z',
};

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

void main() {
  testWidgets('phone and code sign-in lands on Home; a fee due closes Jobs', (
    tester,
  ) async {
    final adapter = ScriptedAdapter((options, _) {
      if (options.path == StudentApi.otpRequestPath) {
        return jsonReply(201, _challenge);
      }
      if (options.path == StudentApi.otpVerifyPath) {
        return jsonReply(200, {
          'tokens': {
            'token_type': 'Bearer',
            'access_token': 'access-1',
            'access_expires_at': '2026-11-14T10:15:00Z',
            'refresh_token': 'refresh-1',
            'session_id': '33333333-3333-4333-8333-333333333333',
          },
          'account': _account,
          'created': false,
        });
      }
      if (options.path == StudentApi.placementPromptsPath) {
        return jsonReply(200, {'prompts': <Object>[]});
      }
      if (options.path == StudentApi.consentRequestsPath) {
        return jsonReply(200, {'requests': <Object>[]});
      }
      if (options.path == StudentApi.configPath) {
        return jsonReply(200, _config);
      }
      if (options.path == StudentApi.jobsAccessPath) {
        return jsonReply(200, {
          'allowed': false,
          'reason': 'fee_pending',
          'reasons': ['fee_pending'],
          'stage': 'registered',
          'checked_at': '2026-11-14T10:00:00Z',
        });
      }
      return jsonReply(404, {
        'code': 'NOT_FOUND',
        'message': 'no route',
        'details': null,
        'request_id': 'req-1',
      });
    });

    await AppHarness(
      store: FakeSecureStore({LanguageStore.key: 'en'}),
      httpAdapter: adapter,
    ).launch(tester);
    expect(find.byType(WelcomeScreen), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '9876543210');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.byType(OtpScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField), '482913');
    await tester.pumpAndSettle();
    expect(find.byType(HomeShell), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.text('Jobs'));
    await tester.pumpAndSettle();
    expect(find.text('Jobs is not open yet'), findsOneWidget);
    expect(
      find.text('Your course fee still has a balance.'),
      findsOneWidget,
    );

    // The code was sent once, with the app version and language headers.
    final request = adapter.seen.firstWhere(
      (r) => r.uri.path == StudentApi.otpRequestPath,
    );
    expect(request.header('X-App-Version'), '0.1.0');
    expect(request.header('Accept-Language'), 'en');
    // The sign-in steps carry no session token.
    expect(request.header('Authorization'), isNull);
  });
}
