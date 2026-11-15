import 'package:core_network/core_network.dart';
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
import 'bloc/jobs_bloc.dart';

/// The Jobs tab (student_app #2, items 7, 8 and 11). The gate is asked on
/// every open; a closed answer says why and the next step, and no hand-off is
/// requested. An open answer asks for the one-minute link and loads it in the
/// in-app web view; the link is never stored, logged or shown.
class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobsBloc>(
      create: (_) => JobsBloc(getIt<StudentApi>())..add(const JobsStarted()),
      child: const _JobsView(),
    );
  }
}

class _JobsView extends StatelessWidget {
  const _JobsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobsBloc, JobsState>(
      listenWhen: (p, c) => p.handoffUrl != c.handoffUrl,
      listener: (context, state) {
        final url = state.handoffUrl;
        if (url == null) return;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;
          await context.push<void>(Routes.campus, extra: url);
          if (!context.mounted) return;
          context.read<JobsBloc>().add(const JobsRetried());
        });
      },
      builder: (context, state) {
        if (state.loading) return const SkeletonList(count: 3);
        if (state.failure != null && state.access == null) {
          return StudentErrorState(
            failure: state.failure!,
            onRetry: () => context.read<JobsBloc>().add(const JobsRetried()),
          );
        }
        final access = state.access;
        if (access == null) return const SizedBox.shrink();
        if (!access.allowed) {
          return _Closed(access: access);
        }
        return _Allowed(
          header: state.header,
          requesting: state.requesting,
          failure: state.failure,
        );
      },
    );
  }
}

class _Allowed extends StatelessWidget {
  const _Allowed({
    required this.header,
    required this.requesting,
    required this.failure,
  });

  final JobsHeader? header;
  final bool requesting;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        if (header != null) _HeaderBar(header: header!),
        const SizedBox(height: RvmSpacing.md),
        Text(l10n.jobsOpenTitle, style: text.headlineSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          l10n.jobsOpenBody,
          style: text.bodyMedium?.copyWith(color: context.palette.fg2),
        ),
        if (failure != null) ...[
          const SizedBox(height: RvmSpacing.md),
          Text(
            failureLine(failure!, l10n),
            style: text.bodyMedium?.copyWith(color: context.palette.danger),
          ),
        ],
        const SizedBox(height: RvmSpacing.lg),
        FilledButton.icon(
          onPressed: requesting
              ? null
              : () => context.read<JobsBloc>().add(
                  const JobsHandoffRequested(),
                ),
          icon: requesting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.open_in_new_rounded),
          label: Text(l10n.jobsOpenButton),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
      ],
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.header});

  final JobsHeader header;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              for (final logo in header.logos) ...[
                _Logo(logo: logo),
                const SizedBox(width: RvmSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: RvmSpacing.sm),
          Text(header.title, style: text.titleMedium),
          if (header.subtitle != null)
            Text(
              header.subtitle!,
              style: text.bodySmall?.copyWith(color: context.palette.fg2),
            ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.logo});

  final JobLogo logo;

  @override
  Widget build(BuildContext context) {
    final uri = logo.uri;
    if (uri == null) return const SizedBox.shrink();
    return SizedBox(
      width: 28,
      height: 28,
      child: Image.network(
        uri.toString(),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(Icons.business_rounded, size: 24),
      ),
    );
  }
}

class _Closed extends StatelessWidget {
  const _Closed({required this.access});

  final JobsAccess access;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final reason = access.reason;
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 40,
          color: context.palette.fg3,
        ),
        const SizedBox(height: RvmSpacing.md),
        Text(l10n.jobsClosedTitle, style: text.headlineSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          _reasonCopy(reason, l10n),
          style: text.bodyLarge?.copyWith(color: context.palette.fg2),
        ),
        const SizedBox(height: RvmSpacing.md),
        Text(l10n.jobsClosedNext, style: text.titleSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          _nextStep(reason, l10n),
          style: text.bodyMedium?.copyWith(color: context.palette.fg2),
        ),
        const SizedBox(height: RvmSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => context.read<JobsBloc>().add(const JobsRetried()),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l10n.jobsCheckAgain),
        ),
      ],
    );
  }

  static String _reasonCopy(JobsReason? reason, AppLocalizations l10n) =>
      switch (reason) {
        JobsReason.notLinked => l10n.jobsReasonNotLinked,
        JobsReason.feePending => l10n.jobsReasonFeePending,
        JobsReason.consentMissing => l10n.jobsReasonConsentMissing,
        JobsReason.ageNotConfirmed => l10n.jobsReasonAge,
        JobsReason.accountBlocked => l10n.jobsReasonBlocked,
        JobsReason.notOpenYet => l10n.jobsReasonNotOpen,
        null => l10n.jobsReasonUnknown,
      };

  static String _nextStep(JobsReason? reason, AppLocalizations l10n) =>
      switch (reason) {
        JobsReason.notLinked => l10n.jobsNextNotLinked,
        JobsReason.feePending => l10n.jobsNextFeePending,
        JobsReason.consentMissing => l10n.jobsNextConsentMissing,
        JobsReason.ageNotConfirmed => l10n.jobsNextAge,
        JobsReason.accountBlocked => l10n.jobsNextBlocked,
        JobsReason.notOpenYet => l10n.jobsNextNotOpen,
        null => l10n.jobsNextUnknown,
      };
}
