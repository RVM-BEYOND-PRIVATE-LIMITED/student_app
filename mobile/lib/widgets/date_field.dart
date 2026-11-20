import 'package:flutter/material.dart';

/// Date selection in the student app (2026-11-17): every date is picked from
/// the platform calendar, never typed. The server still receives ISO 8601.
abstract final class PickedDate {
  /// `2026-12-05`.
  static String isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// `2026-12-05T10:30:00+05:30`: the date and time the student picked, read
  /// as India Standard Time (the app shows every moment in IST).
  static String isoDateTimeIst(DateTime date) =>
      '${isoDate(date)}T'
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}:00+05:30';

  /// The date as the student reads it: `5 Dec 2026` (or its Hindi form).
  static String show(BuildContext context, DateTime date) =>
      MaterialLocalizations.of(context).formatMediumDate(date);

  /// The time as the student reads it.
  static String showTime(BuildContext context, TimeOfDay time) =>
      MaterialLocalizations.of(context).formatTimeOfDay(time);

  /// The platform date picker. [first] and [last] bound what may be chosen.
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initial,
    DateTime? first,
    DateTime? last,
  }) {
    final today = DateUtils.dateOnly(DateTime.now());
    final start = first ?? DateTime(1900);
    final end = last ?? DateTime(today.year + 2, 12, 31);
    var current = initial ?? today;
    if (current.isBefore(start)) current = start;
    if (current.isAfter(end)) current = end;
    return showDatePicker(
      context: context,
      initialDate: current,
      firstDate: start,
      lastDate: end,
    );
  }
}
