import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_release.dart';

/// student_app #8, item 5: the release check. The fixtures are aapt2's real
/// output for this app's universal release APK and for its App Bundle's base
/// module (Flutter 3.35.7, build-tools 36.0.0), both built by
/// tool/build_release.sh; each failure case changes one thing in them.
void main() {
  String fixture(String name) =>
      File('test/tool/fixtures/$name').readAsStringSync();

  final tree = fixture('release_manifest_tree.txt');
  final badging = fixture('release_badging.txt');
  final bundleTree = fixture('bundle_manifest_tree.txt');
  final bundleBadging = fixture('bundle_badging.txt');

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
  const flavorProd =
      'A: http://schemas.android.com/apk/res/android:value(0x01010024)="prod" (Raw: "prod")';

  group('the merged manifest of this release build', () {
    test('passes', () {
      expect(manifestProblems(badging: badging, manifestTree: tree), isEmpty);
    });

    test('is read right: components, exported and permissions', () {
      final facts = parseManifestTree(tree);

      expect(facts.usesCleartextTraffic, isFalse);
      expect(facts.debuggable, isNull);
      expect(facts.metaData, {flavorMetaData: 'prod', 'flutterEmbedding': '2'});
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

  // An App Bundle's manifest is in protobuf form: aapt2 adds `(Raw: "…")`
  // to every value, `true` and `false` included (student_app #8 review).
  group('the App Bundle\'s base module manifest', () {
    test('passes', () {
      expect(
        manifestProblems(badging: bundleBadging, manifestTree: bundleTree),
        isEmpty,
      );
    });

    test('is read right, (Raw: …) values included', () {
      final facts = parseManifestTree(bundleTree);

      expect(facts.usesCleartextTraffic, isFalse);
      expect(facts.debuggable, isNull);
      expect(facts.metaData[flavorMetaData], 'prod');
      expect(
        {for (final c in facts.components) c.name: c.exported},
        {
          'com.rvm.rvmstudent.MainActivity': true,
          'androidx.startup.InitializationProvider': false,
          'androidx.profileinstaller.ProfileInstallReceiver': true,
        },
      );
      expect(
        facts.components.singleWhere((c) => c.kind == 'receiver').permission,
        'android.permission.DUMP',
      );
      expect(parseTargetSdk(bundleBadging), minTargetSdk);
    });

    test('fails the same faults as an APK', () {
      String bundleWith(String from, String to) {
        expect(bundleTree, contains(from));
        return bundleTree.replaceFirst(from, to);
      }

      const cleartext = 'usesCleartextTraffic(0x010104ec)=false (Raw: "false")';
      const providerExported =
          'exported(0x01010010)=false (Raw: "false")\n            A: http://schemas.android.com/apk/res/android:name(0x01010003)="androidx.startup.InitializationProvider"';

      expect(
        manifestProblems(
          badging: bundleBadging,
          manifestTree: bundleWith(
            cleartext,
            'usesCleartextTraffic(0x010104ec)=true (Raw: "true")',
          ),
        ),
        [contains('usesCleartextTraffic')],
      );
      expect(
        manifestProblems(
          badging: bundleBadging,
          manifestTree: bundleWith(
            cleartext,
            '$cleartext\n        A: http://schemas.android.com/apk/res/android:debuggable(0x0101000f)=true (Raw: "true")',
          ),
        ),
        ['the app is debuggable'],
      );
      expect(
        manifestProblems(
          badging: bundleBadging,
          manifestTree: bundleWith(
            providerExported,
            providerExported.replaceFirst(
              '=false (Raw: "false")',
              '=true (Raw: "true")',
            ),
          ),
        ),
        [contains('InitializationProvider is exported but not reviewed')],
      );
      expect(
        manifestProblems(
          badging: bundleBadging.replaceFirst(
            "targetSdkVersion:'36'",
            "targetSdkVersion:'35'",
          ),
          manifestTree: bundleTree,
        ),
        [contains('targetSdkVersion 35')],
      );
      expect(
        manifestProblems(
          badging: bundleBadging,
          manifestTree: bundleWith(
            flavorProd,
            flavorProd.replaceAll('prod', 'dev'),
          ),
        ),
        [contains('FLAVOR=dev')],
      );
    });

    test('is read from these entries of the bundle', () {
      expect(bundleManifestEntries, {
        'base/manifest/AndroidManifest.xml': 'AndroidManifest.xml',
        'base/resources.pb': 'resources.pb',
      });
    });
  });

  group('fails a build that', () {
    test('is a dev build, with the Developer menu and its test switches '
        '(check 7)', () {
      expect(
        manifestProblems(
          badging: badging,
          manifestTree: treeWith(
            flavorProd,
            flavorProd.replaceAll('prod', 'dev'),
          ),
        ),
        [
          'a FLAVOR=dev build: only a prod build may be released (a dev '
              'build has the Developer menu and its test switches)',
        ],
      );
    });

    test('does not record its flavor', () {
      final unnamed = treeWith('"com.rvm.rvmstudent.FLAVOR"', '"other"');

      expect(manifestProblems(badging: badging, manifestTree: unnamed), [
        'no build flavor recorded ($flavorMetaData meta-data)',
      ]);
    });

    test('records its flavor only on a component, not the application', () {
      // Moved under MainActivity: a component's meta-data is not the
      // application's, so the build has no flavor.
      const own =
          '          E: meta-data (line=97)\n            A: http://schemas.android.com/apk/res/android:name(0x01010003)="com.rvm.rvmstudent.FLAVOR" (Raw: "com.rvm.rvmstudent.FLAVOR")\n            $flavorProd\n';
      const activityMetaData = '              E: meta-data (line=82)\n';
      final moved = treeWith(own, '').replaceFirst(
        activityMetaData,
        '              E: meta-data (line=81)\n'
        '                A: http://schemas.android.com/apk/res/android:name(0x01010003)="com.rvm.rvmstudent.FLAVOR" (Raw: "com.rvm.rvmstudent.FLAVOR")\n'
        '                $flavorProd\n'
        '$activityMetaData',
      );

      expect(parseManifestTree(moved).metaData, {'flutterEmbedding': '2'});
      expect(manifestProblems(badging: badging, manifestTree: moved), [
        contains('no build flavor recorded'),
      ]);
    });

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
    test('a keystore, a signing file, a .env, Firebase or service-account '
        'JSON, or a .pem or .key file inside fails', () {
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
          'assets/flutter_assets/google-services.json',
          'assets/service-account.json',
          'assets/play_service_account.json',
          'assets/rvm-serviceaccount-key.json',
          'res/raw/Service_Account_Prod.json',
          'assets/flutter_assets/certs/server.pem',
          'assets/upload.key',
          'res/raw/private.KEY',
          // Real entries of this app's App Bundle: not secrets.
          'base/assets/flutter_assets/AssetManifest.json',
          'base/root/kotlin-tooling-metadata.json',
          'BUNDLE-METADATA/com.android.tools/r8.json',
          'base/root/META-INF/services/H0.a',
          'base/root/META-INF/androidx.core_core.version',
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
          'assets/flutter_assets/google-services.json',
          'assets/service-account.json',
          'assets/play_service_account.json',
          'assets/rvm-serviceaccount-key.json',
          'res/raw/Service_Account_Prod.json',
          'assets/flutter_assets/certs/server.pem',
          'assets/upload.key',
          'res/raw/private.KEY',
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
