import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/redact/student_redact.dart';

void main() {
  const mask = StudentRedact.mask;

  String clean(String input) => StudentRedact.text(input);

  group('StudentRedact (item 12)', () {
    test('phone numbers, in every usual shape', () {
      for (final phone in [
        '9999999999',
        '+919999999999',
        '+91 99999 99999',
        '999-999-9999',
      ]) {
        final out = clean('call $phone now');
        expect(out, isNot(contains('9999')), reason: phone);
        expect(out, contains(mask), reason: phone);
      }
    });

    test('an Aadhaar-length number', () {
      expect(clean('id 999999999999 given'), isNot(contains('999999999999')));
    });

    test('bearer tokens and JWTs', () {
      const jwt =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0In0.c2lnbmF0dXJlLXRlc3Q';

      expect(
        clean('Authorization: Bearer abc.def-ghi'),
        isNot(contains('abc')),
      );
      expect(clean('token $jwt'), isNot(contains('eyJ')));
      expect(clean('header Bearer $jwt'), 'header Bearer $mask');
    });

    test('values of secret keys, in query, JSON and map form', () {
      final out = clean(
        'refresh_token=r-123&x=1 {"accessToken": "a-456", "otp": "4321"} '
        'password: hunter2 session_id=s-789',
      );

      for (final secret in ['r-123', 'a-456', '4321', 'hunter2', 's-789']) {
        expect(out, isNot(contains(secret)), reason: secret);
      }
      expect(out, contains('x=1'));
      expect(out, contains('"accessToken": "$mask"'));
    });

    test('one-time codes written after OTP, code or PIN', () {
      expect(clean('OTP is 482913'), isNot(contains('482913')));
      expect(clean('your code: 5521'), isNot(contains('5521')));
      expect(clean('PIN 1234 entered'), isNot(contains('1234')));
    });

    test('names under a name key', () {
      final out = clean('{"full_name": "Test Student", "batch": "B-12"}');

      expect(out, isNot(contains('Test Student')));
      expect(out, contains('B-12'));
    });

    test('email addresses, wherever they are', () {
      for (final email in [
        'test.student@example.com',
        'Test_Student+rvm@mail.example.co.in',
      ]) {
        final out = clean('StateError: no account for $email (code 7)');
        expect(out, isNot(contains('@')), reason: email);
        expect(out, 'StateError: no account for $mask (code 7)', reason: email);
      }
      expect(
        clean('{"email": "test.student@example.com"}'),
        '{"email": "$mask"}',
      );
    });

    test('ordinary text, dates, times, status codes and short ids stay', () {
      const text =
          'StateError: list empty at 2026-11-12 10:30, HTTP 503, item 42, '
          'request req-0001';

      expect(clean(text), text);
    });
  });
}
