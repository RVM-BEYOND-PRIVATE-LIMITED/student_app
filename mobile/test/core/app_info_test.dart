import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rvm_student/core/app_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Runs first: nothing answers the platform call yet, as when Android
  // cannot say which build this is.
  test('when Android cannot say, the version is marked unknown', () async {
    final info = await AppInfo.load();

    expect(info.version, '0.0.0');
    expect(info.isKnown, isFalse);
  });

  test('reads the installed build from Android', () async {
    PackageInfo.setMockInitialValues(
      appName: 'RVM Student',
      packageName: 'com.rvm.rvmstudent',
      version: '0.1.0',
      buildNumber: '1',
      buildSignature: '',
    );

    final info = await AppInfo.load();

    expect(info.version, '0.1.0');
    expect(info.buildNumber, '1');
    expect(info.isKnown, isTrue);
    expect(info.display, '0.1.0 (1)');
  });
}
