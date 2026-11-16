//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Attendance {
  /// Returns a new [Attendance] instance.
  Attendance({
    required this.from,
    required this.to,
    required this.overall,
    this.batches = const [],
    this.sessions = const [],
  });

  DateTime from;

  DateTime to;

  AttendanceSummary overall;

  List<AttendanceSummary> batches;

  List<AttendanceSessionsInner> sessions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Attendance &&
    other.from == from &&
    other.to == to &&
    other.overall == overall &&
    _deepEquality.equals(other.batches, batches) &&
    _deepEquality.equals(other.sessions, sessions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (from.hashCode) +
    (to.hashCode) +
    (overall.hashCode) +
    (batches.hashCode) +
    (sessions.hashCode);

  @override
  String toString() => 'Attendance[from=$from, to=$to, overall=$overall, batches=$batches, sessions=$sessions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'from'] = _dateFormatter.format(this.from);
      json[r'to'] = _dateFormatter.format(this.to);
      json[r'overall'] = this.overall;
      json[r'batches'] = this.batches;
      json[r'sessions'] = this.sessions;
    return json;
  }

  /// Returns a new [Attendance] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Attendance? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'from'), 'Required key "Attendance[from]" is missing from JSON.');
        assert(json[r'from'] != null, 'Required key "Attendance[from]" has a null value in JSON.');
        assert(json.containsKey(r'to'), 'Required key "Attendance[to]" is missing from JSON.');
        assert(json[r'to'] != null, 'Required key "Attendance[to]" has a null value in JSON.');
        assert(json.containsKey(r'overall'), 'Required key "Attendance[overall]" is missing from JSON.');
        assert(json[r'overall'] != null, 'Required key "Attendance[overall]" has a null value in JSON.');
        assert(json.containsKey(r'batches'), 'Required key "Attendance[batches]" is missing from JSON.');
        assert(json[r'batches'] != null, 'Required key "Attendance[batches]" has a null value in JSON.');
        assert(json.containsKey(r'sessions'), 'Required key "Attendance[sessions]" is missing from JSON.');
        assert(json[r'sessions'] != null, 'Required key "Attendance[sessions]" has a null value in JSON.');
        return true;
      }());

      return Attendance(
        from: mapDateTime(json, r'from', r'')!,
        to: mapDateTime(json, r'to', r'')!,
        overall: AttendanceSummary.fromJson(json[r'overall'])!,
        batches: AttendanceSummary.listFromJson(json[r'batches']),
        sessions: AttendanceSessionsInner.listFromJson(json[r'sessions']),
      );
    }
    return null;
  }

  static List<Attendance> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Attendance>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Attendance.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Attendance> mapFromJson(dynamic json) {
    final map = <String, Attendance>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Attendance.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Attendance-objects as value to a dart map
  static Map<String, List<Attendance>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Attendance>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Attendance.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'from',
    'to',
    'overall',
    'batches',
    'sessions',
  };
}

