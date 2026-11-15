//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UndertakingTermsInner {
  /// Returns a new [UndertakingTermsInner] instance.
  UndertakingTermsInner({
    required this.key,
    required this.text,
    required this.required_,
  });

  String key;

  String text;

  bool required_;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UndertakingTermsInner &&
    other.key == key &&
    other.text == text &&
    other.required_ == required_;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (text.hashCode) +
    (required_.hashCode);

  @override
  String toString() => 'UndertakingTermsInner[key=$key, text=$text, required_=$required_]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'text'] = this.text;
      json[r'required'] = this.required_;
    return json;
  }

  /// Returns a new [UndertakingTermsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UndertakingTermsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "UndertakingTermsInner[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "UndertakingTermsInner[key]" has a null value in JSON.');
        assert(json.containsKey(r'text'), 'Required key "UndertakingTermsInner[text]" is missing from JSON.');
        assert(json[r'text'] != null, 'Required key "UndertakingTermsInner[text]" has a null value in JSON.');
        assert(json.containsKey(r'required'), 'Required key "UndertakingTermsInner[required]" is missing from JSON.');
        assert(json[r'required'] != null, 'Required key "UndertakingTermsInner[required]" has a null value in JSON.');
        return true;
      }());

      return UndertakingTermsInner(
        key: mapValueOfType<String>(json, r'key')!,
        text: mapValueOfType<String>(json, r'text')!,
        required_: mapValueOfType<bool>(json, r'required')!,
      );
    }
    return null;
  }

  static List<UndertakingTermsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UndertakingTermsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UndertakingTermsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UndertakingTermsInner> mapFromJson(dynamic json) {
    final map = <String, UndertakingTermsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UndertakingTermsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UndertakingTermsInner-objects as value to a dart map
  static Map<String, List<UndertakingTermsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UndertakingTermsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UndertakingTermsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'text',
    'required',
  };
}

