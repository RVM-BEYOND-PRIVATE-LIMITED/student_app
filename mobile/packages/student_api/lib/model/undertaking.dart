//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Undertaking {
  /// Returns a new [Undertaking] instance.
  Undertaking({
    required this.version,
    required this.video,
    this.terms = const [],
  });

  /// Minimum value: 1
  int version;

  UndertakingVideo video;

  List<UndertakingTermsInner> terms;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Undertaking &&
    other.version == version &&
    other.video == video &&
    _deepEquality.equals(other.terms, terms);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (version.hashCode) +
    (video.hashCode) +
    (terms.hashCode);

  @override
  String toString() => 'Undertaking[version=$version, video=$video, terms=$terms]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'version'] = this.version;
      json[r'video'] = this.video;
      json[r'terms'] = this.terms;
    return json;
  }

  /// Returns a new [Undertaking] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Undertaking? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'version'), 'Required key "Undertaking[version]" is missing from JSON.');
        assert(json[r'version'] != null, 'Required key "Undertaking[version]" has a null value in JSON.');
        assert(json.containsKey(r'video'), 'Required key "Undertaking[video]" is missing from JSON.');
        assert(json[r'video'] != null, 'Required key "Undertaking[video]" has a null value in JSON.');
        assert(json.containsKey(r'terms'), 'Required key "Undertaking[terms]" is missing from JSON.');
        assert(json[r'terms'] != null, 'Required key "Undertaking[terms]" has a null value in JSON.');
        return true;
      }());

      return Undertaking(
        version: mapValueOfType<int>(json, r'version')!,
        video: UndertakingVideo.fromJson(json[r'video'])!,
        terms: UndertakingTermsInner.listFromJson(json[r'terms']),
      );
    }
    return null;
  }

  static List<Undertaking> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Undertaking>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Undertaking.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Undertaking> mapFromJson(dynamic json) {
    final map = <String, Undertaking>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Undertaking.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Undertaking-objects as value to a dart map
  static Map<String, List<Undertaking>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Undertaking>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Undertaking.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'version',
    'video',
    'terms',
  };
}

