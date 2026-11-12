import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_info.dart';
import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../startup/bloc/startup_bloc.dart';

/// Update required (student_app #1, item 10): the server no longer serves
/// this build, so the app stays here.
///
/// The app is not on the Play Store yet, so there is no store page to open:
/// the screen says how to get the new build instead. "Check again" runs the
/// check once more, for a phone that was updated meanwhile.
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final installed = context.read<AppInfo>().version;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<StartupBloc, StartupState>(
            builder: (context, state) {
              return ScrollableCenter(
                child: Padding(
                  padding: const EdgeInsets.all(RvmSpacing.lg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: StudentColors.accentSoft,
                            borderRadius: BorderRadius.circular(RvmRadii.lg),
                          ),
                          child: const Icon(
                            Icons.system_update_rounded,
                            size: 30,
                            color: StudentColors.accentDark,
                          ),
                        ),
                        const SizedBox(height: RvmSpacing.md + 4),
                        Text(
                          l10n.updateRequiredTitle,
                          textAlign: TextAlign.center,
                          style: text.headlineMedium,
                        ),
                        const SizedBox(height: RvmSpacing.sm + 4),
                        Text(
                          l10n.updateRequiredBody(
                            installed,
                            state.minimumVersion ?? '',
                          ),
                          textAlign: TextAlign.center,
                          style: text.bodyLarge?.copyWith(
                            color: StudentColors.fg2,
                          ),
                        ),
                        const SizedBox(height: RvmSpacing.lg),
                        _HowToUpdate(
                          title: l10n.updateRequiredHowTitle,
                          body: l10n.updateRequiredHowBody,
                        ),
                        const SizedBox(height: RvmSpacing.lg),
                        FilledButton.icon(
                          onPressed: state.rechecking
                              ? null
                              : () => context.read<StartupBloc>().add(
                                  const StartupRetried(),
                                ),
                          icon: state.rechecking
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh_rounded, size: 20),
                          label: Text(l10n.updateRequiredCheckAgain),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HowToUpdate extends StatelessWidget {
  const _HowToUpdate({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: StudentColors.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: StudentColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 22,
            color: StudentColors.navy,
          ),
          const SizedBox(width: RvmSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleSmall),
                const SizedBox(height: RvmSpacing.xs),
                Text(
                  body,
                  style: text.bodyMedium?.copyWith(color: StudentColors.fg2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
