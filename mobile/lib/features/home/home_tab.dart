import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../router/app_router.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../auth/bloc/auth_bloc.dart';
import 'bloc/home_bloc.dart';

/// Home (student_app #2, items 4 and 12): the two doors for a student who has
/// not linked an admission, the status of a linked one, and the two in-app
/// cards the server sends.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    // The fee and stage are read live by the server. Re-read them when Home
    // opens, so a payment recorded by the centre does not leave the old
    // "your course fee still has a balance" line on screen until a restart.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthBloc>().add(const AuthAccountRefreshed());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(getIt<StudentApi>())..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AuthBloc>().state.account;
    if (account == null) return const SizedBox.shrink();
    final unlinked = account.stage == StudentStage.visitor;
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        if (unlinked) const _TwoDoors() else _StatusCard(account: account),
        const SizedBox(height: RvmSpacing.md),
        const _Cards(),
      ],
    );
  }
}

class _TwoDoors extends StatelessWidget {
  const _TwoDoors();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.doorsTitle, style: text.headlineSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          l10n.doorsIntro,
          style: text.bodyMedium?.copyWith(color: context.palette.fg2),
        ),
        const SizedBox(height: RvmSpacing.lg),
        _DoorCard(
          icon: Icons.receipt_long_rounded,
          title: l10n.doorPaidTitle,
          body: l10n.doorPaidBody,
          primary: true,
          onTap: () => context.push(Routes.alreadyPaid),
        ),
        const SizedBox(height: RvmSpacing.md),
        _DoorCard(
          icon: Icons.school_rounded,
          title: l10n.doorJoinTitle,
          body: l10n.doorJoinBody,
          onTap: () => context.push(Routes.joinHolding),
        ),
      ],
    );
  }
}

class _DoorCard extends StatelessWidget {
  const _DoorCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: primary ? context.palette.surface : context.palette.surface2,
      borderRadius: BorderRadius.circular(RvmRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(RvmRadii.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(RvmSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RvmRadii.md),
            border: Border.all(color: context.palette.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: context.palette.fg2),
              const SizedBox(width: RvmSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: text.bodyMedium?.copyWith(
                        color: context.palette.fg2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.account});

  final StudentAccount account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final stage = account.stage;
    final feeLine = account.feeFullyPaid
        ? l10n.homeFeePaid
        : l10n.homeFeeDue;
    return Container(
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.homeHello, style: text.titleLarge),
          const SizedBox(height: 4),
          Text(
            stage == StudentStage.alumni
                ? l10n.homeStageAlumni
                : stage == StudentStage.fullyPaid
                ? l10n.homeStageFullyPaid
                : l10n.homeStageRegistered,
            style: text.bodyMedium?.copyWith(color: context.palette.fg2),
          ),
          const SizedBox(height: RvmSpacing.sm),
          Text(feeLine, style: text.bodyMedium),
          if (account.linkState == LinkState.requested) ...[
            const SizedBox(height: RvmSpacing.sm),
            Text(
              l10n.homeLinkRequested,
              style: text.bodyMedium?.copyWith(color: context.palette.fg2),
            ),
          ],
        ],
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loading) {
          return Column(
            children: const [
              SkeletonCard(),
              SizedBox(height: RvmSpacing.md),
              SkeletonCard(),
            ],
          );
        }
        if (state.failure != null && state.prompts.isEmpty &&
            state.consentRequests.isEmpty) {
          return StudentErrorState(
            failure: state.failure!,
            onRetry: () => context.read<HomeBloc>().add(const HomeStarted()),
          );
        }
        if (state.prompts.isEmpty && state.consentRequests.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final prompt in state.prompts) ...[
              _PromptCard(prompt: prompt),
              const SizedBox(height: RvmSpacing.md),
            ],
            for (final request in state.consentRequests) ...[
              _ConsentCard(request: request),
              const SizedBox(height: RvmSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.prompt});

  final PlacementPrompt prompt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.proofPromptTitle, style: text.titleSmall),
          const SizedBox(height: 4),
          Text(
            l10n.proofPromptBody(prompt.companyName, prompt.jobTitle),
            style: text.bodyMedium?.copyWith(color: context.palette.fg2),
          ),
          const SizedBox(height: RvmSpacing.sm),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.proofPromptTitle),
                      content: Text(l10n.proofFormLater),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
                  ),
                  child: Text(l10n.proofUpload),
                ),
              ),
              const SizedBox(width: RvmSpacing.sm),
              TextButton(
                onPressed: () => context.read<HomeBloc>().add(
                  HomePromptDismissed(prompt.id),
                ),
                child: Text(l10n.dismiss),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard({required this.request});

  final ConsentRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final bloc = context.read<HomeBloc>();
    return Container(
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.consentQuestionTitle, style: text.titleSmall),
          const SizedBox(height: 4),
          Text(
            request.question,
            style: text.bodyMedium?.copyWith(color: context.palette.fg2),
          ),
          const SizedBox(height: RvmSpacing.sm),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => bloc.add(
                    HomeConsentAnswered(id: request.id, yes: true),
                  ),
                  child: Text(l10n.answerYes),
                ),
              ),
              const SizedBox(width: RvmSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => bloc.add(
                    HomeConsentAnswered(id: request.id, yes: false),
                  ),
                  child: Text(l10n.answerNo),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
