import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/upload_type.dart';

void main() {
  test('an upload carries the MIME type its extension names', () {
    expect(mediaTypeForFile('/tmp/letter.pdf').mimeType, 'application/pdf');
    expect(mediaTypeForFile('/tmp/letter.PNG').mimeType, 'image/png');
    expect(mediaTypeForFile('/tmp/letter.jpg').mimeType, 'image/jpeg');
    expect(mediaTypeForFile('/tmp/letter.jpeg').mimeType, 'image/jpeg');
  });
}
