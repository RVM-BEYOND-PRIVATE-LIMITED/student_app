//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListConsentRequests200Response {
  /// Returns a new [ListConsentRequests200Response] instance.
  ListConsentRequests200Response({
    this.requests = const [],
  });

  List<ConsentRequest> requests;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListConsentRequests200Response &&
    _deepEquality.equals(other.requests, requests);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (requests.hashCode);

  @override
  String toString() => 'ListConsentRequests200Response[requests=$requests]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'requests'] = this.requests;
    return json;
  }

  /// Returns a new [ListConsentRequests200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListConsentRequests200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'requests'), 'Required key "ListConsentRequests200Response[requests]" is missing from JSON.');
        assert(json[r'requests'] != null, 'Required key "ListConsentRequests200Response[requests]" has a null value in JSON.');
        return true;
      }());

      return ListConsentRequests200Response(
        requests: ConsentRequest.listFromJson(json[r'requests']),
      );
    }
    return null;
  }

  static List<ListConsentRequests200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListConsentRequests200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListConsentRequests200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListConsentRequests200Response> mapFromJson(dynamic json) {
    final map = <String, ListConsentRequests200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListConsentRequests200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListConsentRequests200Response-objects as value to a dart map
  static Map<String, List<ListConsentRequests200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListConsentRequests200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListConsentRequests200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'requests',
  };
}

