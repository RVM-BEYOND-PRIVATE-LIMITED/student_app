//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CorrectionRequest {
  /// Returns a new [CorrectionRequest] instance.
  CorrectionRequest({
    required this.batchId,
    required this.date,
    required this.reason,
  });

  String batchId;

  DateTime date;

  String reason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CorrectionRequest &&
    other.batchId == batchId &&
    other.date == date &&
    other.reason == reason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (batchId.hashCode) +
    (date.hashCode) +
    (reason.hashCode);

  @override
  String toString() => 'CorrectionRequest[batchId=$batchId, date=$date, reason=$reason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'batch_id'] = this.batchId;
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'reason'] = this.reason;
    return json;
  }

  /// Returns a new [CorrectionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CorrectionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'batch_id'), 'Required key "CorrectionRequest[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "CorrectionRequest[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'date'), 'Required key "CorrectionRequest[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "CorrectionRequest[date]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "CorrectionRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "CorrectionRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return CorrectionRequest(
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        date: mapDateTime(json, r'date', r'')!,
        reason: mapValueOfType<String>(json, r'reason')!,
      );
    }
    return null;
  }

  static List<CorrectionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CorrectionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CorrectionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CorrectionRequest> mapFromJson(dynamic json) {
    final map = <String, CorrectionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CorrectionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CorrectionRequest-objects as value to a dart map
  static Map<String, List<CorrectionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CorrectionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CorrectionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'batch_id',
    'date',
    'reason',
  };
}

