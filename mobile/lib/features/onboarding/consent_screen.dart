import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../auth/bloc/auth_bloc.dart';
import 'bloc/consent_bloc.dart';

/// The 18+ tick and the server's consent lines, shown once after the first
/// sign-in and again whenever the required line is missing (student_app #2,
/// item 2). Nothing is hard-coded: the text and its version come from
/// `/v1/consent-texts`, and the app sends back the versions it showed.
class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.select((AuthBloc bloc) => bloc.state.account);
    if (account == null) return const SizedBox.shrink();
    return BlocProvider<ConsentBloc>(
      create: (_) => ConsentBloc(getIt<StudentApi>())..add(
        ConsentStarted(
          language: Localizations.localeOf(context).languageCode,
          account: account,
        ),
      ),
      child: const _ConsentView(),
    );
  }
}

class _ConsentView extends StatelessWidget {
  const _ConsentView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BlocListener<ConsentBloc, ConsentState>(
      listenWhen: (p, c) => c.savedAccount != null && p.savedAccount == null,
      listener: (context, state) {
        context.read<AuthBloc>().add(AuthAccountUpdated(state.savedAccount!));
      },
      child: BlocBuilder<ConsentBloc, ConsentState>(
        builder: (context, state) {
          final bloc = context.read<ConsentBloc>();
          return Scaffold(
            appBar: AppBar(title: Text(l10n.consentTitle)),
            body: state.loading
                ? const SkeletonList(count: 3)
                : state.texts.isEmpty
                ? StudentErrorState(
                    failure: state.failure ?? const UnknownFailure(),
                    onRetry: () => bloc.add(
                      ConsentStarted(
                        language: Localizations.localeOf(
                          context,
                        ).languageCode,
                        account: context.read<AuthBloc>().state.account!,
                      ),
                    ),
                  )
                : SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(RvmSpacing.lg),
                      children: [
                        Text(
                          l10n.consentIntro,
                          style: text.bodyLarge?.copyWith(
                            color: context.palette.fg2,
                          ),
                        ),
                        const SizedBox(height: RvmSpacing.lg),
                        _Tick(
                          value: state.ageConfirmed,
                          onChanged: (value) =>
                              bloc.add(ConsentAgeChanged(value)),
                          title: l10n.consentAgeTitle,
                          subtitle: l10n.consentAgeBody,
                        ),
                        const SizedBox(height: RvmSpacing.md),
                        _ConsentLine(
                          text: state.shareProfileText,
                          value: state.shareProfile,
                          onChanged: (value) =>
                              bloc.add(ConsentShareProfileChanged(value)),
                          requiredLabel: l10n.consentRequired,
                        ),
                        if (state.marketingText != null) ...[
                          const SizedBox(height: RvmSpacing.md),
                          _ConsentLine(
                            text: state.marketingText,
                            value: state.marketingStory,
                            onChanged: (value) =>
                                bloc.add(ConsentMarketingChanged(value)),
                            requiredLabel: l10n.consentOptional,
                          ),
                        ],
                        if (state.failure != null) ...[
                          const SizedBox(height: RvmSpacing.md),
                          Text(
                            failureLine(state.failure!, l10n),
                            style: text.bodyMedium?.copyWith(
                              color: context.palette.danger,
                            ),
                          ),
                        ],
                        const SizedBox(height: RvmSpacing.xl),
                        FilledButton(
                          onPressed: state.canSubmit
                              ? () => bloc.add(const ConsentSubmitted())
                              : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: state.saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.consentContinue),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _ConsentLine extends StatelessWidget {
  const _ConsentLine({
    required this.text,
    required this.value,
    required this.onChanged,
    required this.requiredLabel,
  });

  final ConsentText? text;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String requiredLabel;

  @override
  Widget build(BuildContext context) {
    final line = text;
    if (line == null) return const SizedBox.shrink();
    return _Tick(
      value: value,
      onChanged: onChanged,
      title: requiredLabel,
      subtitle: line.text,
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({
    required this.value,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, RvmSpacing.md, 12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: (next) => onChanged(next ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleSmall),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: text.bodyMedium?.copyWith(color: context.palette.fg2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


