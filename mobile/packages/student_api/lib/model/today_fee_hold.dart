//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TodayFeeHold {
  /// Returns a new [TodayFeeHold] instance.
  TodayFeeHold({
    required this.onHold,
    required this.since,
  });

  bool onHold;

  DateTime? since;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TodayFeeHold &&
    other.onHold == onHold &&
    other.since == since;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (onHold.hashCode) +
    (since == null ? 0 : since!.hashCode);

  @override
  String toString() => 'TodayFeeHold[onHold=$onHold, since=$since]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'on_hold'] = this.onHold;
    if (this.since != null) {
      json[r'since'] = _dateFormatter.format(this.since!);
    } else {
      json[r'since'] = null;
    }
    return json;
  }

  /// Returns a new [TodayFeeHold] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TodayFeeHold? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'on_hold'), 'Required key "TodayFeeHold[on_hold]" is missing from JSON.');
        assert(json[r'on_hold'] != null, 'Required key "TodayFeeHold[on_hold]" has a null value in JSON.');
        assert(json.containsKey(r'since'), 'Required key "TodayFeeHold[since]" is missing from JSON.');
        return true;
      }());

      return TodayFeeHold(
        onHold: mapValueOfType<bool>(json, r'on_hold')!,
        since: mapDateTime(json, r'since', r''),
      );
    }
    return null;
  }

  static List<TodayFeeHold> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TodayFeeHold>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TodayFeeHold.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TodayFeeHold> mapFromJson(dynamic json) {
    final map = <String, TodayFeeHold>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TodayFeeHold.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TodayFeeHold-objects as value to a dart map
  static Map<String, List<TodayFeeHold>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TodayFeeHold>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TodayFeeHold.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'on_hold',
    'since',
  };
}

