import 'package:core_ui/core_ui.dart';
import 'package:intl/intl.dart';

/// How the app shows money (student_app #1, item 9).
///
/// The server decides every amount and sends it as whole paise. The app only
/// shows it: no sums, discounts or splits are ever worked out on the phone.
/// The text comes from core_ui's [RvmMoney], the one formatter the Team app
/// uses too, which builds it from the integer's digits, so nothing is rounded.
abstract final class MoneyText {
  /// `123456789` paise as `₹12,34,567.89`; `100000` as `₹1,000`.
  static String fromPaise(int paise) => RvmMoney.fromPaise(paise);
}

/// How the app shows a moment in time: always India Standard Time
/// (student_app #1, item 9), whatever time zone the phone is set to.
///
/// IST is UTC+05:30 all year (India has no daylight saving), so a fixed
/// offset is exact and needs no time-zone database.
abstract final class IstTime {
  static const offset = Duration(hours: 5, minutes: 30);

  /// The IST wall-clock reading of [instant], as a UTC [DateTime] whose
  /// fields are the IST date and time. Only for showing: never compare it,
  /// send it or store it as a moment.
  static DateTime wallClock(DateTime instant) => instant.toUtc().add(offset);

  /// `Nov 12, 2026` (English) or `12 नव॰ 2026` (Hindi), in IST.
  static String date(DateTime instant, String locale) =>
      DateFormat.yMMMd(locale).format(wallClock(instant));

  /// `9:05 AM` (English) or `9:05 पूर्वाह्न` (Hindi), in IST.
  ///
  /// intl writes Hindi's day period in Latin letters (`am`, `pm`), so a
  /// Hindi time uses the Hindi words for forenoon and afternoon instead: a
  /// Hindi screen shows no English.
  static String time(DateTime instant, String locale) {
    final wall = wallClock(instant);
    if (locale == 'hi' ||
        locale.startsWith('hi-') ||
        locale.startsWith('hi_')) {
      final period = wall.hour < 12 ? 'पूर्वाह्न' : 'अपराह्न';
      return '${DateFormat('h:mm', locale).format(wall)} $period';
    }
    return DateFormat.jm(locale).format(wall);
  }

  /// The date and the time, in IST.
  static String dateTime(DateTime instant, String locale) =>
      '${date(instant, locale)}, ${time(instant, locale)}';

  /// An ISO 8601 moment from the server, such as `2026-11-12T10:00:00Z` or
  /// `2026-11-12T15:30:00+05:30`. Null for anything that is not a moment,
  /// including a time with no `Z` or offset: read as phone-local time, it
  /// would shift with the phone's time-zone setting.
  static DateTime? parseInstant(String? text) {
    if (text == null) return null;
    final trimmed = text.trim();
    if (!_hasZone.hasMatch(trimmed)) return null;
    return DateTime.tryParse(trimmed)?.toUtc();
  }

  static final _hasZone = RegExp(
    r'T.*(Z|[+-]\d{2}:?\d{2})$',
    caseSensitive: false,
  );
}
