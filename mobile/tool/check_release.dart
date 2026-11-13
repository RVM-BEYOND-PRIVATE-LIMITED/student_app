// Checks a release build of the student app (student_app #8, item 5).
//
//   dart run tool/check_release.dart <file.apk | file.aab>...
//
// Run from mobile/ after tool/build_release.sh. It exits 1 and lists every
// problem when a file fails:
//
// * APK: the target API level is at least [minTargetSdk]; the
//   app is not debuggable; cleartext traffic is off; every component in the
//   merged manifest says `android:exported` explicitly, and only the
//   reviewed ones ([reviewedExports]) are exported. Read with aapt2 from the
//   Android SDK's newest build-tools ($ANDROID_HOME or $ANDROID_SDK_ROOT).
// * App Bundle: R8's mapping file is inside, so Play can de-obfuscate crash
//   reports.
// * Both: no keystore, signing file, `.env` or private key is inside.
//
// It needs `unzip` and aapt2, nothing from pub.

import 'dart:convert';
import 'dart:io';

/// The lowest target API level a release build may have: Flutter 3.35.7's
/// default `targetSdkVersion` (36, Android 16), which the build file uses.
/// Play raises its own minimum for new apps and updates every year (API 35
/// since 31 August 2025), always to a level the newest Flutter targets.
const minTargetSdk = 36;

/// The components a release build may export, each reviewed
/// (student_app #8, item 5), with the permission a caller must hold, if any.
///
/// * The launcher activity must be exported for the home screen to start it.
///   It reads no extras.
/// * androidx.profileinstaller's receiver (from the Flutter embedding's
///   AndroidX dependencies) installs the ART baseline profile. Only a caller
///   holding `android.permission.DUMP` (adb shell, the system) can reach it.
const reviewedExports = <String, String?>{
  'com.rvm.rvmstudent.MainActivity': null,
  'androidx.profileinstaller.ProfileInstallReceiver': 'android.permission.DUMP',
};

/// One activity, activity-alias, service, receiver or provider of a merged
/// manifest.
class ManifestComponent {
  const ManifestComponent({
    required this.kind,
    required this.name,
    this.exported,
    this.permission,
  });

  final String kind;
  final String name;

  /// The `android:exported` value, or null when the manifest does not say.
  final bool? exported;

  /// The `android:permission` a caller must hold, if any.
  final String? permission;

  @override
  String toString() => '$kind $name';
}

/// What aapt2's `dump xmltree --file AndroidManifest.xml` says about the
/// `<application>` and its components.
class ManifestFacts {
  const ManifestFacts({
    required this.components,
    this.usesCleartextTraffic,
    this.debuggable,
  });

  final List<ManifestComponent> components;
  final bool? usesCleartextTraffic;
  final bool? debuggable;
}

const _componentKinds = {
  'activity',
  'activity-alias',
  'service',
  'receiver',
  'provider',
};

final _element = RegExp(r'^(\s*)E: ([\w-]+)');
final _attribute = RegExp(
  r'^\s*A: http://schemas\.android\.com/apk/res/android:(\w+)\(0x[0-9a-f]+\)=(.*)$',
);

/// The value of an aapt2 attribute line: `"text" (Raw: "text")`, `true`,
/// `false`, `@0x7f0e0000` or a number.
String _value(String raw) {
  final quoted = RegExp(r'^"([^"]*)"').firstMatch(raw);
  return quoted != null ? quoted[1]! : raw.trim();
}

bool? _bool(String? value) => switch (value) {
  'true' => true,
  'false' => false,
  _ => null,
};

/// Reads [tree], the output of `aapt2 dump xmltree --file AndroidManifest.xml`.
///
/// An attribute line belongs to the element line above it. A component's
/// own attributes come before its children (intent-filter, meta-data), whose
/// attributes are not read.
ManifestFacts parseManifestTree(String tree) {
  final components = <ManifestComponent>[];
  Map<String, String>? application;
  Map<String, String>? component;
  Map<String, String>? attributesOf;
  var componentKind = '';
  var componentIndent = -1;

  void closeComponent() {
    final attributes = component;
    if (attributes != null) {
      components.add(
        ManifestComponent(
          kind: componentKind,
          name: attributes['name'] ?? '?',
          exported: _bool(attributes['exported']),
          permission: attributes['permission'],
        ),
      );
    }
    component = null;
  }

  for (final line in const LineSplitter().convert(tree)) {
    final element = _element.firstMatch(line);
    if (element != null) {
      final indent = element[1]!.length;
      final tag = element[2]!;
      if (component != null && indent <= componentIndent) closeComponent();
      if (tag == 'application') {
        attributesOf = application = {};
      } else if (_componentKinds.contains(tag) && component == null) {
        attributesOf = component = {};
        componentKind = tag;
        componentIndent = indent;
      } else {
        attributesOf = null;
      }
      continue;
    }
    final attribute = _attribute.firstMatch(line);
    if (attribute != null && attributesOf != null) {
      attributesOf[attribute[1]!] = _value(attribute[2]!);
    }
  }
  closeComponent();

  return ManifestFacts(
    components: components,
    usesCleartextTraffic: _bool(application?['usesCleartextTraffic']),
    debuggable: _bool(application?['debuggable']),
  );
}

/// The `targetSdkVersion` in aapt2's `dump badging` output, or null.
int? parseTargetSdk(String badging) {
  final match = RegExp(
    r"^targetSdkVersion:'(\d+)'",
    multiLine: true,
  ).firstMatch(badging);
  return match == null ? null : int.parse(match[1]!);
}

/// What is wrong with an APK's manifest, given aapt2's badging and xmltree
/// output. Empty when nothing is.
List<String> manifestProblems({
  required String badging,
  required String manifestTree,
}) {
  final problems = <String>[];
  final target = parseTargetSdk(badging);
  if (target == null) {
    problems.add('no targetSdkVersion found');
  } else if (target < minTargetSdk) {
    problems.add('targetSdkVersion $target is below $minTargetSdk');
  }

  final facts = parseManifestTree(manifestTree);
  if (facts.debuggable == true) problems.add('the app is debuggable');
  if (facts.usesCleartextTraffic != false) {
    problems.add('android:usesCleartextTraffic is not false');
  }
  if (facts.components.isEmpty) problems.add('no component found');
  for (final component in facts.components) {
    if (component.exported == null) {
      problems.add('$component does not set android:exported');
      continue;
    }
    if (!component.exported!) continue;
    if (!reviewedExports.containsKey(component.name)) {
      problems.add(
        '$component is exported but not reviewed '
        '(tool/check_release.dart, reviewedExports)',
      );
      continue;
    }
    final needed = reviewedExports[component.name];
    if (needed != null && component.permission != needed) {
      problems.add('$component is exported without $needed');
    }
  }
  return problems;
}

/// Entries that must never be inside a build: keystores, signing and SDK
/// property files, `.env` files.
List<String> forbiddenEntries(Iterable<String> entries) => [
  for (final entry in entries)
    if (_isForbidden(entry.split('/').last.toLowerCase())) entry,
];

bool _isForbidden(String file) =>
    file.endsWith('.jks') ||
    file.endsWith('.keystore') ||
    file.endsWith('.p12') ||
    file.endsWith('.pfx') ||
    file == 'key.properties' ||
    file == 'local.properties' ||
    file == '.env' ||
    file.startsWith('.env.') ||
    file.endsWith('.env');

final _privateKey = RegExp(r'-----BEGIN [A-Z ]*PRIVATE KEY-----');

/// True when [content] (every entry of a build, uncompressed) holds a PEM
/// private key.
bool containsPrivateKey(List<int> content) =>
    _privateKey.hasMatch(latin1.decode(content, allowInvalid: true));

/// The App Bundle entry that carries R8's mapping file.
const bundleMappingEntry =
    'BUNDLE-METADATA/com.android.tools.build.obfuscation/proguard.map';

/// What is wrong with the contents of [file], given its entry names and
/// every entry's bytes, uncompressed. Empty when nothing is.
List<String> contentProblems({
  required String file,
  required List<String> entries,
  required List<int> content,
}) => [
  for (final entry in forbiddenEntries(entries)) '$entry must not be inside',
  if (containsPrivateKey(content)) 'a private key is inside',
  if (file.endsWith('.aab') && !entries.contains(bundleMappingEntry))
    'R8\'s mapping file ($bundleMappingEntry) is missing',
];

/// aapt2 from the newest build-tools of the Android SDK.
String findAapt2(Map<String, String> environment) {
  final sdk = environment['ANDROID_HOME'] ?? environment['ANDROID_SDK_ROOT'];
  if (sdk == null) {
    throw StateError('Set ANDROID_HOME to the Android SDK to find aapt2.');
  }
  final buildTools = Directory('$sdk/build-tools');
  final versions = <String>[
    if (buildTools.existsSync())
      for (final dir in buildTools.listSync().whereType<Directory>())
        if (RegExp(r'^\d+\.\d+\.\d+$').hasMatch(dir.path.split('/').last))
          dir.path.split('/').last,
  ]..sort(_compareVersions);
  for (final version in versions.reversed) {
    final aapt2 = File('${buildTools.path}/$version/aapt2');
    if (aapt2.existsSync()) return aapt2.path;
  }
  throw StateError('No aapt2 in $sdk/build-tools.');
}

int _compareVersions(String a, String b) {
  final x = a.split('.').map(int.parse).toList();
  final y = b.split('.').map(int.parse).toList();
  for (var i = 0; i < 3; i++) {
    if (x[i] != y[i]) return x[i].compareTo(y[i]);
  }
  return 0;
}

Future<String> _run(String executable, List<String> arguments) async {
  final result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    throw StateError(
      '$executable ${arguments.join(' ')} failed: ${result.stderr}',
    );
  }
  return result.stdout as String;
}

Future<List<int>> _runBytes(String executable, List<String> arguments) async {
  final result = await Process.run(executable, arguments, stdoutEncoding: null);
  if (result.exitCode != 0) {
    throw StateError(
      '$executable ${arguments.join(' ')} failed: ${result.stderr}',
    );
  }
  return result.stdout as List<int>;
}

/// Checks [path] and returns what is wrong with it.
Future<List<String>> checkFile(String path, {String? aapt2}) async {
  if (!File(path).existsSync()) return ['$path does not exist'];
  final entries = const LineSplitter()
      .convert(await _run('unzip', ['-Z1', path]))
      .where((e) => e.isNotEmpty)
      .toList();
  final problems = contentProblems(
    file: path,
    entries: entries,
    content: await _runBytes('unzip', ['-p', path]),
  );
  if (path.endsWith('.apk')) {
    final tool = aapt2 ?? findAapt2(Platform.environment);
    problems.addAll(
      manifestProblems(
        badging: await _run(tool, ['dump', 'badging', path]),
        manifestTree: await _run(tool, [
          'dump',
          'xmltree',
          '--file',
          'AndroidManifest.xml',
          path,
        ]),
      ),
    );
  }
  return problems;
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run tool/check_release.dart <apk|aab>...');
    exitCode = 64;
    return;
  }
  var failed = false;
  for (final path in args) {
    final problems = await checkFile(path);
    if (problems.isEmpty) {
      stdout.writeln('ok  $path');
    } else {
      failed = true;
      stdout.writeln('FAIL $path');
      for (final problem in problems) {
        stdout.writeln('     - $problem');
      }
    }
  }
  if (failed) exitCode = 1;
}
