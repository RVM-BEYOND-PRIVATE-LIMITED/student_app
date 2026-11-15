import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/models.dart';
import 'package:rvm_student/features/modules/more_tab.dart';

import '../../support/screen.dart';

void main() {
  test('a registration reads the contract fields it shows', () {
    final registration = Registration.fromJson({
      'id': 'r1',
      'status': 'submitted',
      'branch_id': 2,
      'student_name': 'Aman Verma',
      'email': 'aman@example.com',
      'date_of_birth': '2004-01-02',
      'current_address': 'Pune',
      'permanent_address': 'Pune',
      'father_name': 'Ramesh Verma',
      'father_phone': '9000000000',
      'id_type': 'aadhaar',
      'courses': [
        {'id': 'c1', 'name': 'AutoCAD', 'price_paise': 1500000},
      ],
      'total_paise': 1500000,
      'undertaking': {
        'version': 1,
        'video_started_at': '2026-12-01T10:00:00Z',
        'video_completed_at': '2026-12-01T10:10:00Z',
        'terms_accepted': ['fees_non_refundable'],
      },
      'id_document': {'id_type': 'aadhaar', 'last4': '1234', 'uploaded_at': '2026-12-01T10:11:00Z'},
      'submitted_at': '2026-12-01T10:12:00Z',
      'missing': <String>[],
    });

    expect(registration.studentName, 'Aman Verma');
    expect(registration.courses.single.name, 'AutoCAD');
    expect(registration.totalPaise, 1500000);
    expect(registration.videoDone, isTrue);
    expect(registration.idUploaded, isTrue);
    expect(registration.submitted, isTrue);
    expect(registration.missing, isEmpty);
  });

  test('the undertaking exposes the video and terms', () {
    final undertaking = Undertaking.fromJson({
      'version': 1,
      'video': {'youtube_id': 'abc', 'seconds': 420},
      'terms': [
        {'key': 'fees_non_refundable', 'text': 'Non-refundable', 'required': true},
      ],
    });
    expect(undertaking.videoUri.toString(), contains('abc'));
    expect(undertaking.terms.single.required, isTrue);
  });

  testWidgets('the More tab lists the modules in English and Hindi', (tester) async {
    await tester.pumpWidget(localized(const Scaffold(body: MoreTab())));
    expect(find.text('Fees and receipts'), findsOneWidget);
    expect(find.text('Complaints'), findsOneWidget);

    await tester.pumpWidget(localized(const Scaffold(body: MoreTab()), locale: hindi));
    await tester.pumpAndSettle();
    expect(find.text('फीस और रसीदें'), findsOneWidget);
    expect(find.text('शिकायतें'), findsOneWidget);
  });
}
