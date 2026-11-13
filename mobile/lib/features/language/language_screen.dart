import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../router/app_router.dart';
import '../../theme/student_tokens.dart';
import 'bloc/language_bloc.dart';

/// Language (student_app #1, item 8): English or Hindi.
///
/// Shown before anything else on the first launch, and from the welcome
/// screen or the Developer menu later. A tap switches the whole app at once
/// and saves the choice; Continue moves on.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final canGoBack = context.canPop();
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: canGoBack ? AppBar() : null,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      RvmSpacing.lg,
                      canGoBack ? RvmSpacing.sm : RvmSpacing.xl,
                      RvmSpacing.lg,
                      RvmSpacing.lg,
                    ),
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: StudentColors.accentSoft,
                            borderRadius: BorderRadius.circular(RvmRadii.md),
                          ),
                          child: const Icon(
                            Icons.translate_rounded,
                            color: StudentColors.accentDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: RvmSpacing.md + 4),
                      Text(l10n.languageTitle, style: text.headlineMedium),
                      const SizedBox(height: RvmSpacing.sm),
                      Text(
                        l10n.languageSubtitle,
                        style: text.bodyLarge?.copyWith(
                          color: StudentColors.fg2,
                        ),
                      ),
                      const SizedBox(height: RvmSpacing.lg),
                      for (final language in AppLanguage.values) ...[
                        _LanguageOption(
                          language: language,
                          selected: state.language == language,
                          selectedLabel: l10n.languageSelected,
                          onTap: () => context.read<LanguageBloc>().add(
                            LanguageSelected(language),
                          ),
                        ),
                        const SizedBox(height: RvmSpacing.sm + 4),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    RvmSpacing.lg,
                    0,
                    RvmSpacing.lg,
                    RvmSpacing.md,
                  ),
                  child: FilledButton(
                    onPressed: () => _continue(context, state),
                    child: Text(l10n.languageContinue),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _continue(BuildContext context, LanguageState state) async {
    final bloc = context.read<LanguageBloc>();
    if (!bloc.state.hasChosen) {
      // The language the phone suggested becomes the student's choice. Wait
      // for it to land: the router only lets a student past this screen once
      // a language is chosen.
      bloc.add(LanguageSelected(state.language));
      await bloc.stream.firstWhere((s) => s.hasChosen);
    }
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.welcome);
    }
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.selectedLabel,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final String selectedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(RvmRadii.md);
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: language.endonym,
      value: selected ? selectedLabel : null,
      excludeSemantics: true,
      child: Material(
        color: selected ? StudentColors.accentTint : StudentColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? StudentColors.accent : StudentColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RvmSpacing.md + 2,
                vertical: RvmSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      language.endonym,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: RvmSpacing.sm),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? StudentColors.accent : StudentColors.fg3,
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
