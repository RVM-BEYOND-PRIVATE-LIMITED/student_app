//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListBatches200Response {
  /// Returns a new [ListBatches200Response] instance.
  ListBatches200Response({
    this.batches = const [],
  });

  List<BatchOption> batches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListBatches200Response &&
    _deepEquality.equals(other.batches, batches);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (batches.hashCode);

  @override
  String toString() => 'ListBatches200Response[batches=$batches]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'batches'] = this.batches;
    return json;
  }

  /// Returns a new [ListBatches200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListBatches200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'batches'), 'Required key "ListBatches200Response[batches]" is missing from JSON.');
        assert(json[r'batches'] != null, 'Required key "ListBatches200Response[batches]" has a null value in JSON.');
        return true;
      }());

      return ListBatches200Response(
        batches: BatchOption.listFromJson(json[r'batches']),
      );
    }
    return null;
  }

  static List<ListBatches200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListBatches200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListBatches200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListBatches200Response> mapFromJson(dynamic json) {
    final map = <String, ListBatches200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListBatches200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListBatches200Response-objects as value to a dart map
  static Map<String, List<ListBatches200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListBatches200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListBatches200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'batches',
  };
}

