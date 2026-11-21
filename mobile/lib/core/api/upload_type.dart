import 'package:dio/dio.dart';

/// The MIME type a picked ID document or placement letter is sent as, from
/// its extension. The Student API checks the type (JPEG, PNG or PDF), not only
/// the name; a file sent as `application/octet-stream` is refused.
DioMediaType mediaTypeForFile(String path) {
  final name = path.toLowerCase();
  if (name.endsWith('.pdf')) return DioMediaType('application', 'pdf');
  if (name.endsWith('.png')) return DioMediaType('image', 'png');
  return DioMediaType('image', 'jpeg');
}
