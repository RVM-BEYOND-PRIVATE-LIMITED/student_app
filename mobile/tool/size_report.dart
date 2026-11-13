// Prints the sizes of the release builds as a Markdown table (student_app #8,
// item 6): the App Bundle, the universal (pilot) APK and one APK per ABI.
//
//   dart run tool/size_report.dart [build folder, default: build]
//
// Run from mobile/ after tool/build_release.sh. A report, not a gate: no
// size budget is agreed yet (student_app #13; #8 check 10). It fails only
// when a build is missing.

import 'dart:io';

/// One build file and its size.
class BuildSize {
  const BuildSize(this.name, this.bytes);

  final String name;
  final int bytes;
}

/// The App Bundle, the universal APK and the per-ABI APKs under [buildDir],
/// in that order.
List<File> releaseOutputs(Directory buildDir) {
  final bundle = File(
    '${buildDir.path}/app/outputs/bundle/release/app-release.aab',
  );
  final apkDir = Directory('${buildDir.path}/app/outputs/flutter-apk');
  final universal = File('${apkDir.path}/app-release.apk');
  final perAbi = RegExp(r'^app-[\w-]+-release\.apk$');
  final apks = <File>[
    if (apkDir.existsSync())
      for (final file in apkDir.listSync().whereType<File>())
        if (perAbi.hasMatch(file.uri.pathSegments.last)) file,
  ]..sort((a, b) => a.path.compareTo(b.path));
  return [
    if (bundle.existsSync()) bundle,
    if (universal.existsSync()) universal,
    ...apks,
  ];
}

String _mib(int bytes) => (bytes / 1048576).toStringAsFixed(2);

/// The report for [sizes], as Markdown.
String sizeReport(List<BuildSize> sizes) {
  final lines = [
    '### Student app release size (App Bundle, pilot APK, per-ABI APKs)',
    '',
    '| Build | Bytes | MiB |',
    '| --- | ---: | ---: |',
    for (final size in sizes)
      '| ${size.name} | ${size.bytes} | ${_mib(size.bytes)} |',
    '',
    'The App Bundle holds every ABI; Play serves each phone only its own '
        'part, so a per-ABI APK is closer to what a student downloads from '
        'Play. app-release.apk, the universal APK handed out for the pilot, '
        'holds every ABI.',
    '',
    'Report only: no size budget is agreed (student_app #13).',
  ];
  return '${lines.join('\n')}\n';
}

void main(List<String> args) {
  final buildDir = Directory(args.isEmpty ? 'build' : args.first);
  final outputs = releaseOutputs(buildDir);
  final hasBundle = outputs.any((f) => f.path.endsWith('.aab'));
  final hasApk = outputs.any((f) => f.path.endsWith('.apk'));
  if (!hasBundle || !hasApk) {
    stderr.writeln(
      'No ${hasBundle ? 'per-ABI APK' : 'App Bundle'} under ${buildDir.path}: '
      'run tool/build_release.sh first.',
    );
    exitCode = 1;
    return;
  }
  stdout.write(
    sizeReport([
      for (final file in outputs)
        BuildSize(file.uri.pathSegments.last, file.lengthSync()),
    ]),
  );
}
