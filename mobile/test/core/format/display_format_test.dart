import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rvm_student/core/format/display_format.dart';

void main() {
  setUpAll(() async {
    // In the app, flutter_localizations loads these with the translations.
    await initializeDateFormatting('en');
    await initializeDateFormatting('hi');
  });

  group('MoneyText (item 9)', () {
    test('whole paise as rupees, Indian grouping, no rounding', () {
      expect(MoneyText.fromPaise(0), '₹0');
      expect(MoneyText.fromPaise(1), '₹0.01');
      expect(MoneyText.fromPaise(99), '₹0.99');
      expect(MoneyText.fromPaise(100), '₹1');
      expect(MoneyText.fromPaise(100000), '₹1,000');
      expect(MoneyText.fromPaise(1234550), '₹12,345.50');
      expect(MoneyText.fromPaise(123456789), '₹12,34,567.89');
      expect(MoneyText.fromPaise(1000000000), '₹1,00,00,000');
      expect(MoneyText.fromPaise(-250), '-₹2.50');
    });

    test('amounts a double could not hold exactly stay exact', () {
      // 2^53 + 1 paise: a double would round it.
      expect(MoneyText.fromPaise(9007199254740993), '₹9,00,71,99,25,47,409.93');
    });
  });

  group('IstTime (item 9)', () {
    // 2026-11-12 18:30 UTC is 2026-11-13 00:00 in India.
    final lateEvening = DateTime.utc(2026, 11, 12, 18, 30);

    test('the wall clock is UTC+05:30, whatever the phone\'s zone', () {
      final ist = IstTime.wallClock(lateEvening);

      expect(
        [ist.year, ist.month, ist.day, ist.hour, ist.minute],
        [2026, 11, 13, 0, 0],
      );
      // The same moment given in another zone reads the same in IST.
      expect(
        IstTime.wallClock(DateTime.parse('2026-11-12T13:30:00-05:00')),
        ist,
      );
      expect(IstTime.wallClock(lateEvening.toLocal()), ist);
    });

    test('dates and times read in IST, in English', () {
      expect(IstTime.date(lateEvening, 'en'), 'Nov 13, 2026');
      expect(IstTime.time(DateTime.utc(2026, 11, 12, 3, 35), 'en'), '9:05 AM');
      expect(
        IstTime.dateTime(DateTime.utc(2026, 11, 12, 3, 35), 'en'),
        'Nov 12, 2026, 9:05 AM',
      );
    });

    test('dates and times read in IST, in Hindi, with no Latin letters', () {
      expect(IstTime.date(lateEvening, 'hi'), '13 नव॰ 2026');
      expect(
        IstTime.time(DateTime.utc(2026, 11, 12, 3, 35), 'hi'),
        '9:05 पूर्वाह्न',
      );
      expect(
        IstTime.time(DateTime.utc(2026, 11, 12, 12), 'hi-IN'),
        '5:30 अपराह्न',
      );
      // 00:00 IST is the start of the forenoon.
      expect(IstTime.time(lateEvening, 'hi'), '12:00 पूर्वाह्न');
      expect(
        IstTime.dateTime(lateEvening, 'hi'),
        isNot(matches(RegExp('[A-Za-z]'))),
      );
    });

    test('only a moment with a zone is read', () {
      expect(
        IstTime.parseInstant('2026-11-12T10:00:00Z'),
        DateTime.utc(2026, 11, 12, 10),
      );
      expect(
        IstTime.parseInstant('2026-11-12T15:30:00+05:30'),
        DateTime.utc(2026, 11, 12, 10),
      );
      expect(
        IstTime.parseInstant(' 2026-11-12T15:30:00.000+0530 '),
        DateTime.utc(2026, 11, 12, 10),
      );
      // No zone: phone-local time would shift with the phone's setting.
      expect(IstTime.parseInstant('2026-11-12T10:00:00'), isNull);
      expect(IstTime.parseInstant('2026-11-12'), isNull);
      expect(IstTime.parseInstant('soon'), isNull);
      expect(IstTime.parseInstant(null), isNull);
    });
  });
}
