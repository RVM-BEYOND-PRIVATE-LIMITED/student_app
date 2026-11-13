import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/states.dart';

/// The splash (student_app #1): the logo while the session is restored and
/// the version checked. The router moves on once the launch state is known.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: StudentColors.splashGradient[1],
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.55),
              radius: 1.1,
              colors: StudentColors.splashGradient,
              stops: [0, 0.45, 1],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: GridPaperPainter()),
              ),
              SafeArea(
                child: ScrollableCenter(
                  child: Padding(
                    padding: const EdgeInsets.all(RvmSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GearMark(size: 128),
                        const SizedBox(height: RvmSpacing.lg + 4),
                        const StudentWordmark(size: 30),
                        const SizedBox(height: RvmSpacing.lg),
                        const _DotProgress(),
                        const SizedBox(height: RvmSpacing.sm + 4),
                        Text(
                          l10n.splashLoading,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: StudentColors.fg3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three dots that light in turn; still when the phone asks for less motion.
class _DotProgress extends StatefulWidget {
  const _DotProgress();

  @override
  State<_DotProgress> createState() => _DotProgressState();
}

class _DotProgressState extends State<_DotProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final active = (_controller.value * 3).floor() % 3;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == active
                        ? StudentColors.accent
                        : StudentColors.white.withValues(alpha: 0.25),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
