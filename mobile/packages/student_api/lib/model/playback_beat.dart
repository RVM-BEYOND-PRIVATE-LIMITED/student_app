//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlaybackBeat {
  /// Returns a new [PlaybackBeat] instance.
  PlaybackBeat({
    required this.positionS,
    required this.elapsedS,
  });

  /// Minimum value: 0
  int positionS;

  /// Minimum value: 0
  /// Maximum value: 600
  int elapsedS;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackBeat &&
    other.positionS == positionS &&
    other.elapsedS == elapsedS;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (positionS.hashCode) +
    (elapsedS.hashCode);

  @override
  String toString() => 'PlaybackBeat[positionS=$positionS, elapsedS=$elapsedS]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'position_s'] = this.positionS;
      json[r'elapsed_s'] = this.elapsedS;
    return json;
  }

  /// Returns a new [PlaybackBeat] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlaybackBeat? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'position_s'), 'Required key "PlaybackBeat[position_s]" is missing from JSON.');
        assert(json[r'position_s'] != null, 'Required key "PlaybackBeat[position_s]" has a null value in JSON.');
        assert(json.containsKey(r'elapsed_s'), 'Required key "PlaybackBeat[elapsed_s]" is missing from JSON.');
        assert(json[r'elapsed_s'] != null, 'Required key "PlaybackBeat[elapsed_s]" has a null value in JSON.');
        return true;
      }());

      return PlaybackBeat(
        positionS: mapValueOfType<int>(json, r'position_s')!,
        elapsedS: mapValueOfType<int>(json, r'elapsed_s')!,
      );
    }
    return null;
  }

  static List<PlaybackBeat> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackBeat>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackBeat.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlaybackBeat> mapFromJson(dynamic json) {
    final map = <String, PlaybackBeat>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlaybackBeat.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlaybackBeat-objects as value to a dart map
  static Map<String, List<PlaybackBeat>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlaybackBeat>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlaybackBeat.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'position_s',
    'elapsed_s',
  };
}

