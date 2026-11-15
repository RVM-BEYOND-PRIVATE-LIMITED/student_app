//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class JobsAccess {
  /// Returns a new [JobsAccess] instance.
  JobsAccess({
    required this.allowed,
    required this.reason,
    this.reasons = const [],
    required this.stage,
    required this.checkedAt,
  });

  bool allowed;

  /// The first of `reasons`, or null when allowed.
  JobsReason? reason;

  List<JobsReason> reasons;

  Stage stage;

  DateTime checkedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JobsAccess &&
    other.allowed == allowed &&
    other.reason == reason &&
    _deepEquality.equals(other.reasons, reasons) &&
    other.stage == stage &&
    other.checkedAt == checkedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (allowed.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (reasons.hashCode) +
    (stage.hashCode) +
    (checkedAt.hashCode);

  @override
  String toString() => 'JobsAccess[allowed=$allowed, reason=$reason, reasons=$reasons, stage=$stage, checkedAt=$checkedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'allowed'] = this.allowed;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'reasons'] = this.reasons;
      json[r'stage'] = this.stage;
      json[r'checked_at'] = this.checkedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [JobsAccess] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static JobsAccess? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'allowed'), 'Required key "JobsAccess[allowed]" is missing from JSON.');
        assert(json[r'allowed'] != null, 'Required key "JobsAccess[allowed]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "JobsAccess[reason]" is missing from JSON.');
        assert(json.containsKey(r'reasons'), 'Required key "JobsAccess[reasons]" is missing from JSON.');
        assert(json[r'reasons'] != null, 'Required key "JobsAccess[reasons]" has a null value in JSON.');
        assert(json.containsKey(r'stage'), 'Required key "JobsAccess[stage]" is missing from JSON.');
        assert(json[r'stage'] != null, 'Required key "JobsAccess[stage]" has a null value in JSON.');
        assert(json.containsKey(r'checked_at'), 'Required key "JobsAccess[checked_at]" is missing from JSON.');
        assert(json[r'checked_at'] != null, 'Required key "JobsAccess[checked_at]" has a null value in JSON.');
        return true;
      }());

      return JobsAccess(
        allowed: mapValueOfType<bool>(json, r'allowed')!,
        reason: JobsReason.fromJson(json[r'reason']),
        reasons: JobsReason.listFromJson(json[r'reasons']),
        stage: Stage.fromJson(json[r'stage'])!,
        checkedAt: mapDateTime(json, r'checked_at', r'')!,
      );
    }
    return null;
  }

  static List<JobsAccess> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JobsAccess>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JobsAccess.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, JobsAccess> mapFromJson(dynamic json) {
    final map = <String, JobsAccess>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JobsAccess.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of JobsAccess-objects as value to a dart map
  static Map<String, List<JobsAccess>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<JobsAccess>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = JobsAccess.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'allowed',
    'reason',
    'reasons',
    'stage',
    'checked_at',
  };
}

