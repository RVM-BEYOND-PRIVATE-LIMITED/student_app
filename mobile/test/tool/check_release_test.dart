import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_release.dart';

/// student_app #8, item 5: the release check. The fixtures are aapt2's real
/// output for this app's arm64 release APK (Flutter 3.35.7, build-tools
/// 36.0.0); each failure case changes one thing in them.
void main() {
  final tree = File(
    'test/tool/fixtures/release_manifest_tree.txt',
  ).readAsStringSync();
  final badging = File(
    'test/tool/fixtures/release_badging.txt',
  ).readAsStringSync();

  /// [tree] with [from] replaced by [to]; [from] must be in it.
  String treeWith(String from, String to) {
    expect(tree, contains(from));
    return tree.replaceFirst(from, to);
  }

  const exportedTrue =
      'A: http://schemas.android.com/apk/res/android:exported(0x01010010)=true';
  const exportedFalse =
      'A: http://schemas.android.com/apk/res/android:exported(0x01010010)=false';
  const cleartextOff =
      'A: http://schemas.android.com/apk/res/android:usesCleartextTraffic(0x010104ec)=false';

  group('the merged manifest of this release build', () {
    test('passes', () {
      expect(manifestProblems(badging: badging, manifestTree: tree), isEmpty);
    });

    test('is read right: components, exported and permissions', () {
      final facts = parseManifestTree(tree);

      expect(facts.usesCleartextTraffic, isFalse);
      expect(facts.debuggable, isNull);
      expect(
        {for (final c in facts.components) c.name: c.exported},
        {
          'com.rvm.rvmstudent.MainActivity': true,
          'androidx.startup.InitializationProvider': false,
          'androidx.profileinstaller.ProfileInstallReceiver': true,
        },
      );
      final receiver = facts.components.singleWhere(
        (c) => c.kind == 'receiver',
      );
      expect(receiver.permission, 'android.permission.DUMP');
      // The activity's meta-data and intent-filter names are not its own.
      expect(
        facts.components.where((c) => c.kind == 'activity').single.name,
        'com.rvm.rvmstudent.MainActivity',
      );
    });

    test('targets Flutter\'s default API level', () {
      expect(parseTargetSdk(badging), minTargetSdk);
    });
  });

  group('fails a build that', () {
    test('targets an older API level', () {
      expect(
        manifestProblems(
          badging: badging.replaceFirst(
            "targetSdkVersion:'36'",
            "targetSdkVersion:'34'",
          ),
          manifestTree: tree,
        ),
        [contains('targetSdkVersion 34')],
      );
      expect(manifestProblems(badging: '', manifestTree: tree), [
        contains('no targetSdkVersion'),
      ]);
    });

    test('allows cleartext traffic, or does not say', () {
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith(
            cleartextOff,
            cleartextOff.replaceFirst('=false', '=true'),
          ),
        ),
        [contains('usesCleartextTraffic')],
      );
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith(cleartextOff, ''),
        ),
        [contains('usesCleartextTraffic')],
      );
    });

    test('is debuggable', () {
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith(
            cleartextOff,
            '$cleartextOff\n        A: http://schemas.android.com/apk/res/android:debuggable(0x0101000f)=true',
          ),
        ),
        ['the app is debuggable'],
      );
    });

    test('exports a component nobody reviewed', () {
      final provider = treeWith(
        '$exportedFalse\n            A: http://schemas.android.com/apk/res/android:authorities',
        '$exportedTrue\n            A: http://schemas.android.com/apk/res/android:authorities',
      );

      expect(manifestProblems(badging: badging, manifestTree: provider), [
        contains(
          'provider androidx.startup.InitializationProvider is exported '
          'but not reviewed',
        ),
      ]);
    });

    test('has a component that does not say whether it is exported', () {
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith('$exportedFalse\n', ''),
        ),
        [contains('does not set android:exported')],
      );
    });

    test('exports the profile receiver without its permission', () {
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith('"android.permission.DUMP"', '"none"'),
        ),
        [
          contains(
            'ProfileInstallReceiver is exported without '
            'android.permission.DUMP',
          ),
        ],
      );
    });
  });

  group('contents', () {
    test('a keystore, a signing file or a .env inside fails', () {
      expect(
        forbiddenEntries([
          'classes.dex',
          'lib/arm64-v8a/libapp.so',
          'assets/flutter_assets/AssetManifest.bin',
          'assets/upload-keystore.jks',
          'res/raw/release.keystore',
          'key.properties',
          'assets/flutter_assets/.env',
          'assets/flutter_assets/.env.prod',
          'assets/prod.env',
          'android/local.properties',
          'cert/store.p12',
        ]),
        [
          'assets/upload-keystore.jks',
          'res/raw/release.keystore',
          'key.properties',
          'assets/flutter_assets/.env',
          'assets/flutter_assets/.env.prod',
          'assets/prod.env',
          'android/local.properties',
          'cert/store.p12',
        ],
      );
    });

    test('a private key anywhere inside fails', () {
      List<int> bytes(String s) => latin1.encode(s);

      expect(
        containsPrivateKey(bytes('x\u0000-----BEGIN PRIVATE KEY-----\nMII')),
        isTrue,
      );
      expect(
        containsPrivateKey(bytes('-----BEGIN RSA PRIVATE KEY-----')),
        isTrue,
      );
      expect(containsPrivateKey(bytes('-----BEGIN CERTIFICATE-----')), isFalse);
      expect(containsPrivateKey([0, 255, 128, 10]), isFalse);
    });

    test('an App Bundle must carry R8\'s mapping file', () {
      const entries = ['base/dex/classes.dex', bundleMappingEntry];

      expect(
        contentProblems(file: 'app-release.aab', entries: entries, content: []),
        isEmpty,
      );
      expect(
        contentProblems(
          file: 'app-release.aab',
          entries: entries.sublist(0, 1),
          content: [],
        ),
        [contains('mapping file')],
      );
      // An APK has no such entry; its mapping is kept beside it.
      expect(
        contentProblems(
          file: 'app-arm64-v8a-release.apk',
          entries: const ['classes.dex'],
          content: [],
        ),
        isEmpty,
      );
    });
  });

  group('aapt2', () {
    late Directory sdk;

    setUp(() {
      sdk = Directory.systemTemp.createTempSync('rvm_sdk_');
      addTearDown(() => sdk.deleteSync(recursive: true));
    });

    void tools(String version, {bool aapt2 = true}) {
      final dir = Directory('${sdk.path}/build-tools/$version')
        ..createSync(recursive: true);
      if (aapt2) File('${dir.path}/aapt2').writeAsStringSync('');
    }

    test('comes from the newest build-tools that has it', () {
      tools('34.0.0');
      tools('36.0.0');
      tools('36.1.0', aapt2: false);
      tools('36.1.0-rc1');
      tools('9.0.0');

      expect(
        findAapt2({'ANDROID_HOME': sdk.path}),
        '${sdk.path}/build-tools/36.0.0/aapt2',
      );
      expect(
        findAapt2({'ANDROID_SDK_ROOT': sdk.path}),
        '${sdk.path}/build-tools/36.0.0/aapt2',
      );
    });

    test('says so when there is none', () {
      expect(() => findAapt2({}), throwsStateError);
      expect(() => findAapt2({'ANDROID_HOME': sdk.path}), throwsStateError);
    });
  });
}
