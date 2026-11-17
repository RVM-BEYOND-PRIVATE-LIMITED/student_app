import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/auth/otp_screen.dart';
import 'package:rvm_student/features/auth/sign_in_screen.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';

import '../../support/app_harness.dart';
import '../../support/fakes.dart';

/// Scheduler_Backend #570: while the app is open only to a pilot list, the
/// server answers the same way whether or not a code was sent, so the code
/// screen must never say "We sent a code on WhatsApp" then.
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

Future<void> _reachCodeScreen(
  WidgetTester tester,
  Map<String, Object?> challenge,
) async {
  final adapter = ScriptedAdapter((options, _) {
    if (options.path == StudentApi.otpRequestPath) {
      return jsonReply(201, challenge);
    }
    if (options.path == StudentApi.configPath) {
      return jsonReply(200, _config);
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
}

void main() {
  testWidgets('a pilot reply gets wording that is true either way', (
    tester,
  ) async {
    await _reachCodeScreen(tester, {
      'challenge_id': '22222222-2222-4222-8222-222222222222',
      'channel': 'whatsapp',
      'expires_at': '2026-11-14T10:05:00Z',
      'resend_available_at': '2026-11-14T10:01:00Z',
      'pilot': true,
    });
    expect(find.textContaining('is on the pilot list'), findsOneWidget);
    expect(find.textContaining('We sent a code'), findsNothing);
  });

  testWidgets('a reply outside pilot still names the channel', (tester) async {
    await _reachCodeScreen(tester, {
      'challenge_id': '22222222-2222-4222-8222-222222222222',
      'channel': 'whatsapp',
      'expires_at': '2026-11-14T10:05:00Z',
      'resend_available_at': '2026-11-14T10:01:00Z',
    });
    expect(find.textContaining('We sent a code on WhatsApp'), findsOneWidget);
    expect(find.textContaining('is on the pilot list'), findsNothing);
  });
}
