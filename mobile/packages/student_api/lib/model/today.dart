//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Today {
  /// Returns a new [Today] instance.
  Today({
    required this.date,
    this.classes = const [],
    required this.feeHold,
  });

  DateTime date;

  List<ClassItem> classes;

  TodayFeeHold feeHold;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Today &&
    other.date == date &&
    _deepEquality.equals(other.classes, classes) &&
    other.feeHold == feeHold;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (classes.hashCode) +
    (feeHold.hashCode);

  @override
  String toString() => 'Today[date=$date, classes=$classes, feeHold=$feeHold]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'classes'] = this.classes;
      json[r'fee_hold'] = this.feeHold;
    return json;
  }

  /// Returns a new [Today] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Today? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "Today[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "Today[date]" has a null value in JSON.');
        assert(json.containsKey(r'classes'), 'Required key "Today[classes]" is missing from JSON.');
        assert(json[r'classes'] != null, 'Required key "Today[classes]" has a null value in JSON.');
        assert(json.containsKey(r'fee_hold'), 'Required key "Today[fee_hold]" is missing from JSON.');
        assert(json[r'fee_hold'] != null, 'Required key "Today[fee_hold]" has a null value in JSON.');
        return true;
      }());

      return Today(
        date: mapDateTime(json, r'date', r'')!,
        classes: ClassItem.listFromJson(json[r'classes']),
        feeHold: TodayFeeHold.fromJson(json[r'fee_hold'])!,
      );
    }
    return null;
  }

  static List<Today> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Today>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Today.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Today> mapFromJson(dynamic json) {
    final map = <String, Today>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Today.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Today-objects as value to a dart map
  static Map<String, List<Today>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Today>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Today.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'classes',
    'fee_hold',
  };
}

