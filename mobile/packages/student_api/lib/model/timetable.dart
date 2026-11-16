//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Timetable {
  /// Returns a new [Timetable] instance.
  Timetable({
    required this.from,
    required this.to,
    this.classes = const [],
  });

  DateTime from;

  DateTime to;

  List<ClassItem> classes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Timetable &&
    other.from == from &&
    other.to == to &&
    _deepEquality.equals(other.classes, classes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (from.hashCode) +
    (to.hashCode) +
    (classes.hashCode);

  @override
  String toString() => 'Timetable[from=$from, to=$to, classes=$classes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'from'] = _dateFormatter.format(this.from);
      json[r'to'] = _dateFormatter.format(this.to);
      json[r'classes'] = this.classes;
    return json;
  }

  /// Returns a new [Timetable] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Timetable? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'from'), 'Required key "Timetable[from]" is missing from JSON.');
        assert(json[r'from'] != null, 'Required key "Timetable[from]" has a null value in JSON.');
        assert(json.containsKey(r'to'), 'Required key "Timetable[to]" is missing from JSON.');
        assert(json[r'to'] != null, 'Required key "Timetable[to]" has a null value in JSON.');
        assert(json.containsKey(r'classes'), 'Required key "Timetable[classes]" is missing from JSON.');
        assert(json[r'classes'] != null, 'Required key "Timetable[classes]" has a null value in JSON.');
        return true;
      }());

      return Timetable(
        from: mapDateTime(json, r'from', r'')!,
        to: mapDateTime(json, r'to', r'')!,
        classes: ClassItem.listFromJson(json[r'classes']),
      );
    }
    return null;
  }

  static List<Timetable> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Timetable>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Timetable.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Timetable> mapFromJson(dynamic json) {
    final map = <String, Timetable>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Timetable.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Timetable-objects as value to a dart map
  static Map<String, List<Timetable>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Timetable>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Timetable.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'from',
    'to',
    'classes',
  };
}

