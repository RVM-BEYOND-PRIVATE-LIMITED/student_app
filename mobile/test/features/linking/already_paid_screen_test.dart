import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_network/core_network.dart';
import 'package:rvm_student/core/api/models.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/linking/already_paid_screen.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi({this.linkedAdmission, this.linkState}) : super(Dio());

  final Admission? linkedAdmission;
  final LinkResultState? linkState;
  int autoCalls = 0;

  @override
  Future<Admission> admission() async {
    final value = linkedAdmission;
    if (value == null) throw const NotFoundFailure();
    return value;
  }

  @override
  Future<LinkResult> linkAutomatically() async {
    autoCalls += 1;
    final state = linkState;
    if (state == null) {
      throw const BadResponseFailure(
        'This account is already linked to an admission.',
        statusCode: 409,
        code: 'ALREADY_LINKED',
      );
    }
    return LinkResult(state: state, account: _account);
  }

  @override
  Future<List<Branch>> branches() async =>
      const [Branch(id: 2, name: 'Pune', callNumber: '9000000002')];
}

const _account = StudentAccount(
  id: '11111111-1111-4111-8111-111111111111',
  phoneMasked: '••••••3210',
  language: 'en',
  stage: StudentStage.registered,
  feeFullyPaid: false,
  isAlumni: false,
  linkState: LinkState.linked,
  ageConfirmed: true,
  requiredConsentGiven: true,
  placementPrompts: 0,
  consentRequests: 0,
);

Admission _admission() => const Admission(
  admissionNumber: 'RVM/TEST/0001',
  name: 'Test Student',
  courses: ['CNC'],
  branchId: 2,
  branchName: 'Pune',
  paidFigures: 'current',
  totalFeesPaise: 100000,
  totalPaidPaise: 40000,
  remainingDuePaise: 60000,
  plan: [],
);

Future<void> _pump(WidgetTester tester, _FakeApi api) async {
  await getIt.reset();
  addTearDown(getIt.reset);
  getIt.registerSingleton<StudentApi>(api);
  await tester.pumpWidget(localized(const AlreadyPaidScreen()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('an already-linked account shows its admission, not "Request not completed"',
      (tester) async {
    final api = _FakeApi(linkedAdmission: _admission());
    await _pump(tester, api);

    expect(find.text('RVM/TEST/0001'), findsOneWidget);
    expect(find.text('Request not completed'), findsNothing);
    expect(api.autoCalls, 0);
  });

  testWidgets('an unlinked account asks the centre and lists the branches',
      (tester) async {
    final api = _FakeApi(linkState: LinkResultState.needsCentre);
    await _pump(tester, api);

    expect(find.text('Pune'), findsOneWidget);
    expect(api.autoCalls, 1);
  });
}
