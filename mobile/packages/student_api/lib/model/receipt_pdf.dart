//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReceiptPdf {
  /// Returns a new [ReceiptPdf] instance.
  ReceiptPdf({
    required this.filename,
    required this.contentType,
    required this.pdfBase64,
  });

  String filename;

  ReceiptPdfContentTypeEnum contentType;

  String pdfBase64;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReceiptPdf &&
    other.filename == filename &&
    other.contentType == contentType &&
    other.pdfBase64 == pdfBase64;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (filename.hashCode) +
    (contentType.hashCode) +
    (pdfBase64.hashCode);

  @override
  String toString() => 'ReceiptPdf[filename=$filename, contentType=$contentType, pdfBase64=$pdfBase64]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'filename'] = this.filename;
      json[r'content_type'] = this.contentType;
      json[r'pdf_base64'] = this.pdfBase64;
    return json;
  }

  /// Returns a new [ReceiptPdf] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReceiptPdf? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'filename'), 'Required key "ReceiptPdf[filename]" is missing from JSON.');
        assert(json[r'filename'] != null, 'Required key "ReceiptPdf[filename]" has a null value in JSON.');
        assert(json.containsKey(r'content_type'), 'Required key "ReceiptPdf[content_type]" is missing from JSON.');
        assert(json[r'content_type'] != null, 'Required key "ReceiptPdf[content_type]" has a null value in JSON.');
        assert(json.containsKey(r'pdf_base64'), 'Required key "ReceiptPdf[pdf_base64]" is missing from JSON.');
        assert(json[r'pdf_base64'] != null, 'Required key "ReceiptPdf[pdf_base64]" has a null value in JSON.');
        return true;
      }());

      return ReceiptPdf(
        filename: mapValueOfType<String>(json, r'filename')!,
        contentType: ReceiptPdfContentTypeEnum.fromJson(json[r'content_type'])!,
        pdfBase64: mapValueOfType<String>(json, r'pdf_base64')!,
      );
    }
    return null;
  }

  static List<ReceiptPdf> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReceiptPdf>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReceiptPdf.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReceiptPdf> mapFromJson(dynamic json) {
    final map = <String, ReceiptPdf>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReceiptPdf.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReceiptPdf-objects as value to a dart map
  static Map<String, List<ReceiptPdf>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReceiptPdf>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReceiptPdf.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'filename',
    'content_type',
    'pdf_base64',
  };
}


enum ReceiptPdfContentTypeEnum {
  applicationSlashPdf._(r'application/pdf'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReceiptPdfContentTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReceiptPdfContentTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReceiptPdfContentTypeEnum? fromJson(dynamic value) => ReceiptPdfContentTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReceiptPdfContentTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReceiptPdfContentTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReceiptPdfContentTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReceiptPdfContentTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReceiptPdfContentTypeEnum] to String,
/// and [decode] dynamic data back to [ReceiptPdfContentTypeEnum].
class ReceiptPdfContentTypeEnumTypeTransformer {
  factory ReceiptPdfContentTypeEnumTypeTransformer() => _instance ??= const ReceiptPdfContentTypeEnumTypeTransformer._();

  const ReceiptPdfContentTypeEnumTypeTransformer._();

  String encode(ReceiptPdfContentTypeEnum data) => data._value;

  /// Returns the instance of [ReceiptPdfContentTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReceiptPdfContentTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReceiptPdfContentTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'application/pdf': return ReceiptPdfContentTypeEnum.applicationSlashPdf;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReceiptPdfContentTypeEnumTypeTransformer? _instance;
}


