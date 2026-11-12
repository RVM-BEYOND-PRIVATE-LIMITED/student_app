import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/env/student_env.dart';
import '../../l10n/l10n.dart';
import '../../router/app_router.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/brand_mark.dart';

/// Where the app lands after the language choice, until sign-in
/// (student_app #2) takes this place. It says so plainly, offers the
/// language switch, and in a dev build the Developer menu.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final isDev = context.read<StudentEnv>().isDev;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            const _Header(),
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.all(RvmSpacing.lg),
                  children: [
                    Text(l10n.welcomeTitle, style: text.headlineMedium),
                    const SizedBox(height: RvmSpacing.sm + 2),
                    Text(
                      l10n.welcomeBody,
                      style: text.bodyLarge?.copyWith(color: StudentColors.fg2),
                    ),
                    const SizedBox(height: RvmSpacing.lg),
                    OutlinedButton.icon(
                      onPressed: () => context.push(Routes.language),
                      icon: const Icon(Icons.translate_rounded, size: 20),
                      label: Text(l10n.changeLanguage),
                    ),
                    if (isDev) ...[
                      const SizedBox(height: RvmSpacing.sm + 4),
                      TextButton.icon(
                        onPressed: () => context.push(Routes.devMenu),
                        icon: const Icon(
                          Icons.developer_mode_rounded,
                          size: 20,
                        ),
                        label: Text(l10n.openDeveloperMenu),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The handoff's navy header with the faint grid, the mark and the wordmark.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF25396B), Color(0xFF1A2B53)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(RvmRadii.xl),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(RvmRadii.xl),
        ),
        child: CustomPaint(
          painter: const GridPaperPainter(color: Color(0x0FFFFFFF), gap: 24),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                RvmSpacing.lg,
                RvmSpacing.lg,
                RvmSpacing.lg,
                RvmSpacing.xl,
              ),
              child: Row(
                children: [
                  const GearMark(size: 64),
                  const SizedBox(width: RvmSpacing.md),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: const StudentWordmark(size: 26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
