import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Set-up for every test in test/goldens/ (student_app #11).
///
/// 1. The app's bundled fonts are loaded, so the goldens show real Geist,
///    Fraunces and Noto Sans Devanagari letters and Material icons. Without
///    this, flutter_test draws every letter as the same square box, and a
///    clipped Hindi vowel sign could never show.
/// 2. Images are compared with a small tolerance for anti-aliasing noise.
///    The goldens are made and checked on Linux only (the CI runner's OS):
///    other systems draw text a little differently.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadBundledFonts();
  final current = goldenFileComparator;
  if (current is LocalFileComparator) {
    goldenFileComparator = TolerantGoldenComparator(
      current.basedir.resolve('golden_test.dart'),
    );
  }
  await testMain();
}

/// Loads every font family pubspec.yaml bundles (and Material's icon font)
/// from the test asset bundle's font manifest.
Future<void> loadBundledFonts() async {
  final manifest =
      json.decode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

/// A golden comparator that accepts up to [tolerance] of the pixels
/// differing (0.001 is 0.1 %), and fails with the usual diff images above
/// it.
class TolerantGoldenComparator extends LocalFileComparator {
  TolerantGoldenComparator(super.testFile, {this.tolerance = 0.001});

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
