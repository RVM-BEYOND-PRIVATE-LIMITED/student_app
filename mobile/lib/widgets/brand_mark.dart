import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/student_tokens.dart';

/// The handoff's gear mark: a dashed outer ring, an orange gear ring with
/// eight teeth and a white hub, drawn in a 128-unit box and scaled. The
/// launcher icon (android/app/src/main/res/drawable/ic_launcher_foreground.xml)
/// draws the same shape.
class GearMark extends StatelessWidget {
  const GearMark({super.key, this.size = 128});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _GearMarkPainter(context.palette)),
      ),
    );
  }
}

class _GearMarkPainter extends CustomPainter {
  const _GearMarkPainter(this.palette);

  final StudentPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 128;
    final c = Offset(size.width / 2, size.height / 2);

    final outer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s
      ..color = palette.white.withValues(alpha: 0.16);
    final circumference = 2 * math.pi * 52 * s;
    final steps = (circumference / (8 * s)).floor().clamp(1, 400);
    final sweep = (2 * s) / (52 * s);
    for (var i = 0; i < steps; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: 52 * s),
        i * 2 * math.pi / steps,
        sweep,
        false,
        outer,
      );
    }

    final gear = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * s
      ..strokeCap = StrokeCap.round
      ..color = palette.accent;
    canvas.drawCircle(c, 26 * s, gear);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(c + dir * (33 * s), c + dir * (43 * s), gear);
    }

    final hub = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * s
      ..color = palette.white;
    canvas.drawCircle(c, 9 * s, hub);
  }

  @override
  bool shouldRepaint(_GearMarkPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

/// "RVM" and the translated word for student, the app's name as a wordmark.
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
    final wordColor = color ?? context.palette.white;
    final base = TextStyle(
      fontFamily: StudentFonts.sans,
      fontFamilyFallback: StudentFonts.fallback,
      fontSize: size,
      height: 1.3,
      color: wordColor,
    );
    return Semantics(
      label: context.l10n.appTitle,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'RVM',
              style: base.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: context.l10n.brandStudent,
              style: base.copyWith(
                fontWeight: FontWeight.w400,
                color: context.palette.accent,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// The faint graph-paper grid of the handoff's navy headers.
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
