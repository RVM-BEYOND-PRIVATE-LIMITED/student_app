import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/modules/other_modules_screens.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi() : super(Dio());

  @override
  Future<Map<String, dynamic>> getJson(String path) async => switch (path) {
    '/v1/visitor/lectures' => {'lectures': <dynamic>[]},
    '/v1/visitor/quizzes' => {'quizzes': <dynamic>[]},
    '/v1/visitor/visits' => {'visits': <dynamic>[]},
    '/v1/public/courses' => {
      'courses': [
        {
          'id': 'c1',
          'name': 'AutoCAD',
          'price_paise': 1850000,
          'summary': '2D and 3D drafting',
          'duration': '3 months',
          'next_batches': [
            {
              'branch_id': 1,
              'branch': 'Faridabad',
              'start_date': '2026-12-07',
              'days': [1, 3, 5],
              'start_time': '10:00',
              'end_time': '12:00',
            },
          ],
        },
      ],
    },
    '/v1/public/branches' => {
      'branches': [
        {'id': 1, 'name': 'Faridabad'},
      ],
    },
    _ => <String, dynamic>{},
  };
}

void main() {
  testWidgets('the visitor area lists courses with their next batch', (tester) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    getIt.registerSingleton<StudentApi>(_FakeApi());
    await tester.pumpWidget(localized(const VisitorScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Courses'), findsOneWidget);
    expect(find.text('AutoCAD'), findsOneWidget);
    expect(find.textContaining('3 months'), findsOneWidget);
    expect(find.textContaining('Mon, Wed, Fri'), findsOneWidget);
  });
}
