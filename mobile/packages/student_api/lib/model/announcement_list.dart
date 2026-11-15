//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnnouncementList {
  /// Returns a new [AnnouncementList] instance.
  AnnouncementList({
    this.announcements = const [],
  });

  List<AnnouncementListAnnouncementsInner> announcements;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnnouncementList &&
    _deepEquality.equals(other.announcements, announcements);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (announcements.hashCode);

  @override
  String toString() => 'AnnouncementList[announcements=$announcements]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'announcements'] = this.announcements;
    return json;
  }

  /// Returns a new [AnnouncementList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnnouncementList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'announcements'), 'Required key "AnnouncementList[announcements]" is missing from JSON.');
        assert(json[r'announcements'] != null, 'Required key "AnnouncementList[announcements]" has a null value in JSON.');
        return true;
      }());

      return AnnouncementList(
        announcements: AnnouncementListAnnouncementsInner.listFromJson(json[r'announcements']),
      );
    }
    return null;
  }

  static List<AnnouncementList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnnouncementList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnnouncementList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnnouncementList> mapFromJson(dynamic json) {
    final map = <String, AnnouncementList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnnouncementList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnnouncementList-objects as value to a dart map
  static Map<String, List<AnnouncementList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnnouncementList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnnouncementList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'announcements',
  };
}

