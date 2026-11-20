import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/core/security/secure_window.dart';
import 'package:rvm_student/features/modules/other_modules_screens.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi({required this.rewardsOpen}) : super(Dio());

  final bool rewardsOpen;

  @override
  Future<Map<String, dynamic>> getJson(String path) async {
    if (!rewardsOpen) {
      throw const ServerFailure.status(503, code: 'MODULE_OFF');
    }
    if (path == '/v1/me/referral') {
      return {'code': 'RVMTEST', 'referrals': {'joined': 0, 'rewarded': 0}};
    }
    if (path == '/v1/me/payout-account') return {'account': null};
    if (path == '/v1/me/placement-proofs') return {'proofs': <dynamic>[]};
    return <String, dynamic>{};
  }
}

Future<void> _pump(WidgetTester tester, {required bool rewardsOpen}) async {
  await getIt.reset();
  addTearDown(getIt.reset);
  getIt.registerSingleton<StudentApi>(_FakeApi(rewardsOpen: rewardsOpen));
  await tester.pumpWidget(localized(const PlacementScreen()));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(SecureWindow.channelName);
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('with student_rewards off it says so and offers no Add or Proof',
      (tester) async {
    await _pump(tester, rewardsOpen: false);
    expect(find.text('Placement and referral is not open yet'), findsOneWidget);
    expect(find.text('Proof'), findsNothing);
    expect(find.text('Add'), findsNothing);
  });

  testWidgets('with the module open the payout Add and Proof actions appear',
      (tester) async {
    await _pump(tester, rewardsOpen: true);
    expect(find.text('Placement and referral is not open yet'), findsNothing);
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Proof'), findsOneWidget);
  });
}
