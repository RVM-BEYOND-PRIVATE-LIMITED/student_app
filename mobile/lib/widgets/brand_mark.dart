import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/student_tokens.dart';

/// The RVM logo (September 2026 rebrand): the lowercase blocky "rvm"
/// wordmark, drawn from the vector of the brand guidelines (the Team RVM
/// design system, assets › Logos), in Forge Orange (`palette.accent`). It is
/// never retyped, stretched or recoloured. The launcher icon
/// (android/app/src/main/res/drawable/ic_launcher_foreground.xml) draws the
/// same shape on Ironwood.
class RvmMark extends StatelessWidget {
  const RvmMark({super.key, this.size = 160});

  /// The mark's width; its height follows the 495.83 × 123.41 drawing.
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size * _kWordmarkHeight / _kWordmarkWidth,
        child: CustomPaint(painter: _RvmMarkPainter(context.palette.accent)),
      ),
    );
  }
}

const double _kWordmarkWidth = 495.83;
const double _kWordmarkHeight = 123.41;

/// The wordmark's outline, as in the brand's SVG (absolute M, L, C and Z).
const String _kWordmark =
    'M87.07 0.79C87.07 0.37 86.72 0.02 86.29 0.02L43.53 0.02L43.53 0L0 0L0 0.02L0 43.55L0 122.63C0 123.06 0.35 123.41 0.77 123.41L42.76 123.41C43.19 123.41 43.53 123.06 43.53 122.63L43.53 44.33C43.53 43.9 43.88 43.55 44.31 43.55L86.29 43.55C86.72 43.55 87.07 43.21 87.07 42.78L87.07 0.79Z '
    'M452.3 0L407.79 0L364.25 0L319.74 0L276.98 0C276.55 0 276.21 0.35 276.21 0.77L276.21 43.53L276.21 122.63C276.21 123.06 276.55 123.41 276.98 123.41L318.97 123.41C319.39 123.41 319.74 123.06 319.74 122.63L319.74 44.31C319.74 43.88 320.09 43.53 320.51 43.53L363.48 43.53C363.91 43.53 364.25 43.88 364.25 44.31L364.25 122.63C364.25 123.06 364.6 123.41 365.03 123.41L407.01 123.41C407.44 123.41 407.79 123.06 407.79 122.63L407.79 44.31C407.79 43.88 408.13 43.53 408.56 43.53L451.52 43.53C451.95 43.53 452.3 43.88 452.3 44.31L452.3 122.63C452.3 123.06 452.64 123.41 453.07 123.41L495.06 123.41C495.49 123.41 495.83 123.06 495.83 122.63L495.83 43.53L495.83 0.77C495.83 0.35 495.49 0 495.06 0L452.3 0Z '
    'M213.42 0L213.41 0.02L199.74 35.97L181.75 83.28L181.53 83.28L171.43 56.73L171.44 56.73L150.06 0.5C149.94 0.2 149.66 0 149.33 0L104.41 0C103.87 0 103.49 0.54 103.69 1.05L109.18 15.49L130.74 72.2L134.96 83.28L150.02 122.91C150.13 123.21 150.42 123.41 150.74 123.41L172.58 123.41L190.7 123.41L212.53 123.41C212.86 123.41 213.14 123.21 213.26 122.91L224.43 93.52L240.43 51.44L254.1 15.49L259.59 1.05C259.78 0.54 259.41 0 258.87 0L213.42 0Z';

/// The outline as a [Path] in the drawing's own units.
@visibleForTesting
Path rvmWordmarkPath() {
  final tokens = RegExp(r'[MLCZ]|-?\d*\.?\d+')
      .allMatches(_kWordmark)
      .map((m) => m.group(0)!)
      .toList();
  final path = Path();
  var i = 0;
  var command = 'M';
  double next() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    final token = tokens[i];
    if (token == 'M' || token == 'L' || token == 'C' || token == 'Z') {
      i++;
      command = token;
      if (token == 'Z') path.close();
      continue;
    }
    switch (command) {
      case 'M':
        path.moveTo(next(), next());
        command = 'L';
      case 'L':
        path.lineTo(next(), next());
      case 'C':
        path.cubicTo(next(), next(), next(), next(), next(), next());
      default:
        i++;
    }
  }
  return path;
}

final Path _wordmarkPath = rvmWordmarkPath();

class _RvmMarkPainter extends CustomPainter {
  const _RvmMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _kWordmarkWidth;
    canvas
      ..save()
      ..scale(scale, scale)
      ..drawPath(_wordmarkPath, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_RvmMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// The product name beside or under the rvm mark (the House of RVM lockup:
/// rvm · Student), in white on the Ironwood band and splash. It is read out
/// as the app's whole name.
class StudentWordmark extends StatelessWidget {
  const StudentWordmark({
    super.key,
    this.size = 30,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.appTitle,
      excludeSemantics: true,
      child: Text(
        context.l10n.brandStudent,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: StudentFonts.sans,
          fontFamilyFallback: StudentFonts.fallback,
          fontSize: size,
          height: 1.3,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: color ?? context.palette.white,
        ),
      ),
    );
  }
}

/// The faint graph-paper grid of the Ironwood headers (the brand's dashed
/// construction grid).
class GridPaperPainter extends CustomPainter {
  const GridPaperPainter({required this.color, this.gap = 26});

  final Color color;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPaperPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.gap != gap;
}
