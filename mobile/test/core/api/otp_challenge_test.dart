import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/models.dart';

/// Contract 0.30.0 (Scheduler_Backend #570 and #203): the sign-in code reply's
/// two optional fields, and the defaults an older backend's reply gets.
void main() {
  const base = {
    'challenge_id': '22222222-2222-4222-8222-222222222222',
    'channel': 'whatsapp',
    'expires_at': '2026-12-01T10:05:00Z',
    'resend_available_at': '2026-12-01T10:00:30Z',
  };

  test('reads pilot: true, and has no fallback time then', () {
    final c = OtpChallenge.fromJson({...base, 'channel': 'sms', 'pilot': true});
    expect(c.pilot, isTrue);
    expect(c.smsFallbackAt, isNull);
    expect(c.byWhatsApp, isFalse);
  });

  test('reads sms_fallback_at for a WhatsApp code', () {
    final c = OtpChallenge.fromJson({
      ...base,
      'sms_fallback_at': '2026-12-01T10:00:30Z',
    });
    expect(c.pilot, isFalse);
    expect(
      c.smsFallbackAt!.isAtSameMomentAs(DateTime.utc(2026, 12, 1, 10, 0, 30)),
      isTrue,
    );
  });

  test('a reply without either field is not pilot and has no fallback', () {
    final c = OtpChallenge.fromJson(base);
    expect(c.pilot, isFalse);
    expect(c.smsFallbackAt, isNull);
    expect(c.byWhatsApp, isTrue);
  });
}
