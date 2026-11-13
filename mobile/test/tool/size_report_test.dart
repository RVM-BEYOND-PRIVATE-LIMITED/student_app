import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/size_report.dart';

/// student_app #8, item 6: the size report CI prints. A report only: no
/// budget is agreed (student_app #13).
void main() {
  late Directory build;

  setUp(() {
    build = Directory.systemTemp.createTempSync('rvm_build_');
    addTearDown(() => build.deleteSync(recursive: true));
  });

  File put(String path, int bytes) => File('${build.path}/$path')
    ..createSync(recursive: true)
    ..writeAsBytesSync(List.filled(bytes, 0));

  test('finds the App Bundle first, then each per-ABI APK', () {
    put('app/outputs/flutter-apk/app-x86_64-release.apk', 3);
    put('app/outputs/flutter-apk/app-arm64-v8a-release.apk', 2);
    put('app/outputs/flutter-apk/app-armeabi-v7a-release.apk', 1);
    put('app/outputs/bundle/release/app-release.aab', 4);
    // Not per-ABI release builds.
    put('app/outputs/flutter-apk/app-release.apk', 5);
    put('app/outputs/flutter-apk/app-debug.apk', 6);
    put('app/outputs/flutter-apk/app-arm64-v8a-release.apk.sha1', 7);

    expect(
      [for (final f in releaseOutputs(build)) f.uri.pathSegments.last],
      [
        'app-release.aab',
        'app-arm64-v8a-release.apk',
        'app-armeabi-v7a-release.apk',
        'app-x86_64-release.apk',
      ],
    );
  });

  test('nothing built: nothing found', () {
    expect(releaseOutputs(build), isEmpty);
  });

  test('prints bytes and MiB, and says no budget is set', () {
    final report = sizeReport(const [
      BuildSize('app-release.aab', 41317228),
      BuildSize('app-arm64-v8a-release.apk', 17273221),
    ]);

    expect(report, contains('| app-release.aab | 41317228 | 39.40 |'));
    expect(
      report,
      contains('| app-arm64-v8a-release.apk | 17273221 | 16.47 |'),
    );
    expect(report, contains('no size budget is agreed (student_app #13)'));
    expect(report, isNot(contains('budget:')));
  });
}
