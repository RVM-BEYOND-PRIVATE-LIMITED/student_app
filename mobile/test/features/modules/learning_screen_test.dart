import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/modules/other_modules_screens.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi(this.answers) : super(Dio());

  /// path -> a map, or a Failure to throw.
  final Map<String, Object> answers;

  @override
  Future<Map<String, dynamic>> getJson(String path) async => switch (answers[path]) {
    final Map<String, dynamic> data => data,
    final Failure failure => throw failure,
    _ => <String, dynamic>{},
  };
}

Future<void> _pump(WidgetTester tester, Map<String, Object> answers) async {
  await getIt.reset();
  addTearDown(getIt.reset);
  getIt.registerSingleton<StudentApi>(_FakeApi(answers));
  await tester.pumpWidget(localized(const LearningScreen()));
  await tester.pumpAndSettle();
}

const _off = ServerFailure.status(503, code: 'MODULE_OFF');

Map<String, Object> _allOff() => {
  '/v1/me/online-classes': _off,
  '/v1/me/videos': _off,
  '/v1/me/test-scores': _off,
  '/v1/interview-packs': _off,
  '/v1/quizzes/daily': _off,
  '/v1/quizzes/mock/roles': _off,
};

void main() {
  testWidgets('every section off says Learning is not open yet, not a server error',
      (tester) async {
    await _pump(tester, _allOff());
    expect(find.text('Learning is not open yet'), findsOneWidget);
    expect(find.text('Server problem'), findsNothing);
  });

  testWidgets('one section on still shows that section', (tester) async {
    await _pump(tester, {
      ..._allOff(),
      '/v1/me/online-classes': {
        'classes': [
          {'batch_name': 'Batch A', 'date': '2026-12-01', 'start': '10:00', 'end': '11:00', 'status': 'scheduled'},
        ],
      },
    });
    expect(find.textContaining('Batch A'), findsOneWidget);
    expect(find.text('Learning is not open yet'), findsNothing);
    expect(find.text('Server problem'), findsNothing);
  });

  testWidgets('scores that need a link say so, with the other sections still usable',
      (tester) async {
    await _pump(tester, {
      ..._allOff(),
      '/v1/me/online-classes': {'classes': <dynamic>[]},
      '/v1/me/test-scores': const ServerFailure.status(409, code: 'NOT_LINKED'),
    });
    expect(find.text('Link your account to your admission first.'), findsOneWidget);
    expect(find.text('Server problem'), findsNothing);
  });
}
