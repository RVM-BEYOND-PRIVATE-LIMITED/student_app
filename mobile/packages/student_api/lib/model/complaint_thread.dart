//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ComplaintThread {
  /// Returns a new [ComplaintThread] instance.
  ComplaintThread({
    required this.complaint,
    this.messages = const [],
  });

  Complaint complaint;

  List<ComplaintMessage> messages;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ComplaintThread &&
    other.complaint == complaint &&
    _deepEquality.equals(other.messages, messages);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (complaint.hashCode) +
    (messages.hashCode);

  @override
  String toString() => 'ComplaintThread[complaint=$complaint, messages=$messages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'complaint'] = this.complaint;
      json[r'messages'] = this.messages;
    return json;
  }

  /// Returns a new [ComplaintThread] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ComplaintThread? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'complaint'), 'Required key "ComplaintThread[complaint]" is missing from JSON.');
        assert(json[r'complaint'] != null, 'Required key "ComplaintThread[complaint]" has a null value in JSON.');
        assert(json.containsKey(r'messages'), 'Required key "ComplaintThread[messages]" is missing from JSON.');
        assert(json[r'messages'] != null, 'Required key "ComplaintThread[messages]" has a null value in JSON.');
        return true;
      }());

      return ComplaintThread(
        complaint: Complaint.fromJson(json[r'complaint'])!,
        messages: ComplaintMessage.listFromJson(json[r'messages']),
      );
    }
    return null;
  }

  static List<ComplaintThread> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintThread>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintThread.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ComplaintThread> mapFromJson(dynamic json) {
    final map = <String, ComplaintThread>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ComplaintThread.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ComplaintThread-objects as value to a dart map
  static Map<String, List<ComplaintThread>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ComplaintThread>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ComplaintThread.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'complaint',
    'messages',
  };
}

