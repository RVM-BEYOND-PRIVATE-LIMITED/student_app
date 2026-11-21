import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/modules/core_modules_screens.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi() : super(Dio());

  @override
  Future<Map<String, dynamic>> getJson(String path) async => switch (path) {
    '/v1/me/timetable' => {
      'classes': [
        {
          'date': '2026-12-01',
          'start_time': '10:00',
          'end_time': '12:00',
          'faculty_name': 'Faculty A',
          'courses': ['AutoCAD'],
        },
      ],
    },
    '/v1/me/practice-slots' => {
      'slots': [
        {
          'date': '2026-12-02',
          'start_time': '14:00',
          'end_time': '17:00',
          'lab_note': 'Lab 2',
          'branch': {'id': 1, 'name': 'Faridabad', 'call_number': '0000000001'},
        },
      ],
    },
    _ => <String, dynamic>{},
  };
}

void main() {
  testWidgets('hybrid practice timings show beside the timetable', (tester) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    getIt.registerSingleton<StudentApi>(_FakeApi());
    await tester.pumpWidget(localized(const TimetableScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Faculty A'), findsOneWidget);
    expect(find.text('Practice timings'), findsOneWidget);
    expect(find.textContaining('Faridabad'), findsOneWidget);
    expect(find.textContaining('Lab 2'), findsOneWidget);
  });
}
