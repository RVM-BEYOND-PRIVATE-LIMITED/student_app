//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


enum JobsReason {
  notLinked._(r'not_linked'),
  feePending._(r'fee_pending'),
  consentMissing._(r'consent_missing'),
  ageNotConfirmed._(r'age_not_confirmed'),
  accountBlocked._(r'account_blocked'),
  notOpenYet._(r'not_open_yet'),
  ;

  /// Instantiate a new enum with the provided value.
  const JobsReason._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [JobsReason] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static JobsReason? fromJson(dynamic value) => JobsReasonTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [JobsReason]
  /// that were successfully decoded from the passed [JSON][json].
  static List<JobsReason> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JobsReason>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JobsReason.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [JobsReason] to String,
/// and [decode] dynamic data back to [JobsReason].
class JobsReasonTypeTransformer {
  factory JobsReasonTypeTransformer() => _instance ??= const JobsReasonTypeTransformer._();

  const JobsReasonTypeTransformer._();

  /// Encodes this enum as a value suitable for JSON.
  String encode(JobsReason data) => data._value;

  /// Returns the instance of [JobsReason] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  JobsReason? decode(dynamic data, {bool allowNull = true}) {
    if (data is JobsReason) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'not_linked': return JobsReason.notLinked;
        case r'fee_pending': return JobsReason.feePending;
        case r'consent_missing': return JobsReason.consentMissing;
        case r'age_not_confirmed': return JobsReason.ageNotConfirmed;
        case r'account_blocked': return JobsReason.accountBlocked;
        case r'not_open_yet': return JobsReason.notOpenYet;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static JobsReasonTypeTransformer? _instance;
}

