import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The Android settings this issue relies on, read from the project files
/// (`flutter test` runs in the package folder).
void main() {
  String read(String path) => File(path).readAsStringSync();

  const mainManifest = 'android/app/src/main/AndroidManifest.xml';
  const debugManifest = 'android/app/src/debug/AndroidManifest.xml';
  const buildFile = 'android/app/build.gradle.kts';
  const backupRules = 'android/app/src/main/res/xml/backup_rules.xml';
  const extractionRules =
      'android/app/src/main/res/xml/data_extraction_rules.xml';

  /// The `<exclude …/>` entries of one rules block, as `domain:path`.
  Set<String> excludes(String xml) => {
    for (final m in RegExp(
      r'<exclude\s+domain="([^"]+)"\s+path="([^"]+)"\s*/>',
    ).allMatches(xml))
      '${m[1]}:${m[2]}',
  };

  const mustStayOnPhone = {
    // flutter_secure_storage: tokens, install id, language choice.
    'sharedpref:FlutterSecureStorage.xml',
    'sharedpref:FlutterSecureKeyStorage.xml',
    // The on-device crash log (lib/core/crash/crash_log.dart).
    'file:rvm_crash_log/',
  };

  group('backup exclusions (item 5)', () {
    test('the manifest points at both rule files', () {
      final manifest = read(mainManifest);

      expect(
        manifest,
        contains('android:fullBackupContent="@xml/backup_rules"'),
      );
      expect(
        manifest,
        contains('android:dataExtractionRules="@xml/data_extraction_rules"'),
      );
    });

    test('Android 11 and older: secure storage and crash log stay out', () {
      expect(excludes(read(backupRules)), containsAll(mustStayOnPhone));
    });

    test('Android 12+: out of cloud backup and device transfer alike', () {
      final xml = read(extractionRules);
      String block(String tag) =>
          RegExp('<$tag>(.*?)</$tag>', dotAll: true).firstMatch(xml)![1]!;

      expect(excludes(block('cloud-backup')), containsAll(mustStayOnPhone));
      expect(excludes(block('device-transfer')), containsAll(mustStayOnPhone));
    });
  });

  group('the Android project (item 1)', () {
    test('application id and name are the development defaults', () {
      expect(read(buildFile), contains('applicationId = "com.rvm.rvmstudent"'));
      expect(read(mainManifest), contains('android:label="@string/app_name"'));
    });

    test('the launcher label is in English and in Hindi, the same words as '
        'the app title', () {
      String label(String values) => RegExp(
        r'<string name="app_name">([^<]+)</string>',
      ).firstMatch(read('android/app/src/main/res/$values/strings.xml'))![1]!;
      String title(String arb) =>
          (jsonDecode(read('lib/l10n/$arb')) as Map)['appTitle'] as String;

      expect(label('values'), 'RVM Student');
      expect(label('values'), title('app_en.arb'));
      expect(label('values-hi'), 'RVM स्टूडेंट');
      expect(label('values-hi'), title('app_hi.arb'));
    });

    test('release builds carry no signing key unless CI measures size', () {
      final gradle = read(buildFile);

      expect(gradle, isNot(contains('storeFile')));
      expect(gradle, isNot(contains('key.properties')));
      // The only signing line is the CI size report's throwaway debug key.
      expect(RegExp('signingConfig\\s*=').allMatches(gradle), hasLength(1));
      expect(gradle, contains('System.getenv("RVM_CI_SIZE_REPORT") == "true"'));
    });

    test('no keystore is committed', () {
      final keystores = Directory('android')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (f) => f.path.endsWith('.jks') || f.path.endsWith('.keystore'),
          );

      expect(keystores, isEmpty);
    });

    test('Android only: no iOS, web or desktop target', () {
      for (final platform in ['ios', 'web', 'macos', 'linux', 'windows']) {
        expect(Directory(platform).existsSync(), isFalse, reason: platform);
      }
    });

    // This file covers Android's own network stack (Java and Kotlin code)
    // only. The app's API traffic goes through dart:io, which the Flutter
    // embedder does not hold to it: that rule is HostGuard's, tested with
    // real sockets in test/core/network/host_guard_test.dart.
    test('Android\'s own network stack (not Dart): plain HTTP only to this '
        'computer, only in debug builds', () {
      // Off everywhere (student_app #8, item 5); the debug build's network
      // security config takes precedence over the attribute.
      expect(
        read(mainManifest),
        contains('android:usesCleartextTraffic="false"'),
      );
      expect(read(mainManifest), isNot(contains('networkSecurityConfig')));
      expect(read(debugManifest), contains('@xml/network_security_config'));

      final config = read(
        'android/app/src/debug/res/xml/network_security_config.xml',
      );
      final domains = {
        for (final m in RegExp(
          r'<domain[^>]*>([^<]+)</domain>',
        ).allMatches(config))
          m[1]!.trim(),
      };
      expect(domains, {'127.0.0.1', 'localhost', '10.0.2.2'});
      expect(config, isNot(contains('<base-config')));
    });
  });

  group('release hardening (student_app #8, item 5)', () {
    /// The `release { ... }` block of the build file.
    String releaseBlock() {
      final gradle = read(buildFile);
      final start = gradle.indexOf('release {');
      expect(start, isNot(-1));
      var depth = 0;
      for (var i = start; i < gradle.length; i++) {
        if (gradle[i] == '{') depth++;
        if (gradle[i] == '}' && --depth == 0) {
          return gradle.substring(start, i + 1);
        }
      }
      fail('the release block does not close');
    }

    test('R8 code and resource shrinking are pinned on for release', () {
      final release = releaseBlock();

      expect(release, contains('isMinifyEnabled = true'));
      expect(release, contains('isShrinkResources = true'));
      expect(read(buildFile), isNot(contains('isMinifyEnabled = false')));
    });

    test('the target API level is Flutter\'s default, not a pinned number', () {
      expect(read(buildFile), contains('targetSdk = flutter.targetSdkVersion'));
      expect(read(buildFile), isNot(contains(RegExp(r'targetSdk\s*=\s*\d'))));
    });

    test('every component in the manifest says whether it is exported', () {
      final manifest = read(mainManifest);
      final components = RegExp(
        r'<(activity|activity-alias|service|receiver|provider)\b[^>]*>',
      ).allMatches(manifest).toList();

      expect(components, isNotEmpty);
      for (final c in components) {
        expect(c[0], contains('android:exported='), reason: c[0]);
      }
      // The launcher activity is the only one exported on purpose.
      expect(
        RegExp('android:exported="true"').allMatches(manifest),
        hasLength(1),
      );
    });

    test('release builds are obfuscated and keep their symbol files', () {
      final script = read('tool/build_release.sh');

      for (final kind in ['appbundle', 'apk --split-per-abi']) {
        expect(script, contains('build $kind'), reason: kind);
      }
      expect(script, contains('--obfuscate'));
      expect(script, contains(r'--split-debug-info="$symbols/$kind"'));
      expect(script, contains('cp "\$mapping" "\$symbols/\$kind/mapping.txt"'));
      // Symbol files never enter git (mobile/.gitignore).
      expect(read('.gitignore'), contains('app.*.symbols'));
      expect(read('.gitignore'), contains('/build/'));
    });
  });
}
