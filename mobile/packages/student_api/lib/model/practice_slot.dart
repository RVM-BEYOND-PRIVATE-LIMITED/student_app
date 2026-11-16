//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PracticeSlot {
  /// Returns a new [PracticeSlot] instance.
  PracticeSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.labNote,
    required this.branch,
  });

  DateTime date;

  String startTime;

  String endTime;

  String? labNote;

  PracticeSlotBranch branch;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PracticeSlot &&
    other.date == date &&
    other.startTime == startTime &&
    other.endTime == endTime &&
    other.labNote == labNote &&
    other.branch == branch;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (startTime.hashCode) +
    (endTime.hashCode) +
    (labNote == null ? 0 : labNote!.hashCode) +
    (branch.hashCode);

  @override
  String toString() => 'PracticeSlot[date=$date, startTime=$startTime, endTime=$endTime, labNote=$labNote, branch=$branch]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'start_time'] = this.startTime;
      json[r'end_time'] = this.endTime;
    if (this.labNote != null) {
      json[r'lab_note'] = this.labNote;
    } else {
      json[r'lab_note'] = null;
    }
      json[r'branch'] = this.branch;
    return json;
  }

  /// Returns a new [PracticeSlot] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PracticeSlot? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "PracticeSlot[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "PracticeSlot[date]" has a null value in JSON.');
        assert(json.containsKey(r'start_time'), 'Required key "PracticeSlot[start_time]" is missing from JSON.');
        assert(json[r'start_time'] != null, 'Required key "PracticeSlot[start_time]" has a null value in JSON.');
        assert(json.containsKey(r'end_time'), 'Required key "PracticeSlot[end_time]" is missing from JSON.');
        assert(json[r'end_time'] != null, 'Required key "PracticeSlot[end_time]" has a null value in JSON.');
        assert(json.containsKey(r'lab_note'), 'Required key "PracticeSlot[lab_note]" is missing from JSON.');
        assert(json.containsKey(r'branch'), 'Required key "PracticeSlot[branch]" is missing from JSON.');
        assert(json[r'branch'] != null, 'Required key "PracticeSlot[branch]" has a null value in JSON.');
        return true;
      }());

      return PracticeSlot(
        date: mapDateTime(json, r'date', r'')!,
        startTime: mapValueOfType<String>(json, r'start_time')!,
        endTime: mapValueOfType<String>(json, r'end_time')!,
        labNote: mapValueOfType<String>(json, r'lab_note'),
        branch: PracticeSlotBranch.fromJson(json[r'branch'])!,
      );
    }
    return null;
  }

  static List<PracticeSlot> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PracticeSlot>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PracticeSlot.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PracticeSlot> mapFromJson(dynamic json) {
    final map = <String, PracticeSlot>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PracticeSlot.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PracticeSlot-objects as value to a dart map
  static Map<String, List<PracticeSlot>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PracticeSlot>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PracticeSlot.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'start_time',
    'end_time',
    'lab_note',
    'branch',
  };
}

