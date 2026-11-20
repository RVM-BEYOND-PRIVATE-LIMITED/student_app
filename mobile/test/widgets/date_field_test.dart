import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/widgets/date_field.dart';

void main() {
  test('a picked date is sent as YYYY-MM-DD', () {
    expect(PickedDate.isoDate(DateTime(2026, 12, 5)), '2026-12-05');
    expect(PickedDate.isoDate(DateTime(2026, 1, 9)), '2026-01-09');
  });

  test('a picked visit time is sent as IST with its offset', () {
    expect(
      PickedDate.isoDateTimeIst(DateTime(2026, 12, 5, 10, 30)),
      '2026-12-05T10:30:00+05:30',
    );
  });
}
