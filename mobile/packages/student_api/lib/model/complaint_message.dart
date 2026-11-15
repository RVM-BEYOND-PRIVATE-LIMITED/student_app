//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ComplaintMessage {
  /// Returns a new [ComplaintMessage] instance.
  ComplaintMessage({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
  });

  String id;

  ComplaintMessageAuthorEnum author;

  String body;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ComplaintMessage &&
    other.id == id &&
    other.author == author &&
    other.body == body &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (author.hashCode) +
    (body.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'ComplaintMessage[id=$id, author=$author, body=$body, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'author'] = this.author;
      json[r'body'] = this.body;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ComplaintMessage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ComplaintMessage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ComplaintMessage[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ComplaintMessage[id]" has a null value in JSON.');
        assert(json.containsKey(r'author'), 'Required key "ComplaintMessage[author]" is missing from JSON.');
        assert(json[r'author'] != null, 'Required key "ComplaintMessage[author]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "ComplaintMessage[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "ComplaintMessage[body]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "ComplaintMessage[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "ComplaintMessage[created_at]" has a null value in JSON.');
        return true;
      }());

      return ComplaintMessage(
        id: mapValueOfType<String>(json, r'id')!,
        author: ComplaintMessageAuthorEnum.fromJson(json[r'author'])!,
        body: mapValueOfType<String>(json, r'body')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
      );
    }
    return null;
  }

  static List<ComplaintMessage> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintMessage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintMessage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ComplaintMessage> mapFromJson(dynamic json) {
    final map = <String, ComplaintMessage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ComplaintMessage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ComplaintMessage-objects as value to a dart map
  static Map<String, List<ComplaintMessage>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ComplaintMessage>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ComplaintMessage.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'author',
    'body',
    'created_at',
  };
}


enum ComplaintMessageAuthorEnum {
  student._(r'student'),
  staff._(r'staff'),
  ;

  /// Instantiate a new enum with the provided value.
  const ComplaintMessageAuthorEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ComplaintMessageAuthorEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ComplaintMessageAuthorEnum? fromJson(dynamic value) => ComplaintMessageAuthorEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ComplaintMessageAuthorEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ComplaintMessageAuthorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintMessageAuthorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintMessageAuthorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ComplaintMessageAuthorEnum] to String,
/// and [decode] dynamic data back to [ComplaintMessageAuthorEnum].
class ComplaintMessageAuthorEnumTypeTransformer {
  factory ComplaintMessageAuthorEnumTypeTransformer() => _instance ??= const ComplaintMessageAuthorEnumTypeTransformer._();

  const ComplaintMessageAuthorEnumTypeTransformer._();

  String encode(ComplaintMessageAuthorEnum data) => data._value;

  /// Returns the instance of [ComplaintMessageAuthorEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ComplaintMessageAuthorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ComplaintMessageAuthorEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'student': return ComplaintMessageAuthorEnum.student;
        case r'staff': return ComplaintMessageAuthorEnum.staff;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ComplaintMessageAuthorEnumTypeTransformer? _instance;
}


