//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListBranches200Response {
  /// Returns a new [ListBranches200Response] instance.
  ListBranches200Response({
    this.branches = const [],
  });

  List<Branch> branches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListBranches200Response &&
    _deepEquality.equals(other.branches, branches);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (branches.hashCode);

  @override
  String toString() => 'ListBranches200Response[branches=$branches]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'branches'] = this.branches;
    return json;
  }

  /// Returns a new [ListBranches200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListBranches200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'branches'), 'Required key "ListBranches200Response[branches]" is missing from JSON.');
        assert(json[r'branches'] != null, 'Required key "ListBranches200Response[branches]" has a null value in JSON.');
        return true;
      }());

      return ListBranches200Response(
        branches: Branch.listFromJson(json[r'branches']),
      );
    }
    return null;
  }

  static List<ListBranches200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListBranches200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListBranches200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListBranches200Response> mapFromJson(dynamic json) {
    final map = <String, ListBranches200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListBranches200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListBranches200Response-objects as value to a dart map
  static Map<String, List<ListBranches200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListBranches200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListBranches200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'branches',
  };
}

