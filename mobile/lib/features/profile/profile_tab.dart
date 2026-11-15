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
import '../jobs/campus_web_view.dart';
import '../language/bloc/language_bloc.dart';
import '../theme/theme_controller.dart';

/// Profile (student_app #2, item 13): read-only details, the language, each
/// consent with its date and a withdraw action, the bound phone and sign-out.
/// Only contact preferences are editable later (#4); this build changes the
/// language and the consents.
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<List<ConsentRecord>> _consents;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _consents = getIt<StudentApi>().consents();
  }

  void _reload() {
    setState(() => _consents = getIt<StudentApi>().consents());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final account = context.watch<AuthBloc>().state.account;
    final language = context.watch<LanguageBloc>().state.language;
    final theme = getIt<ThemeController>();
    if (account == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        _Row(label: l10n.profilePhone, value: account.phoneMasked),
        _Row(label: l10n.profileStage, value: _stageName(account, l10n)),
        _Row(
          label: l10n.profileLinked,
          value: switch (account.linkState) {
            LinkState.linked => l10n.profileLinkedYes,
            LinkState.requested => l10n.profileLinkedRequested,
            LinkState.unlinked => l10n.profileLinkedNo,
          },
        ),
        const SizedBox(height: RvmSpacing.lg),
        Text(l10n.profileLanguage, style: text.titleSmall),
        const SizedBox(height: RvmSpacing.sm),
        SegmentedButton<AppLanguage>(
          segments: const [
            ButtonSegment(value: AppLanguage.en, label: Text('English')),
            ButtonSegment(value: AppLanguage.hi, label: Text('हिन्दी')),
          ],
          selected: {language},
          onSelectionChanged: (selection) => _setLanguage(selection.first),
        ),
        if (theme.open) ...[
          const SizedBox(height: RvmSpacing.lg),
          Text(l10n.profileAppearance, style: text.titleSmall),
          const SizedBox(height: RvmSpacing.sm),
          ListenableBuilder(
            listenable: theme,
            builder: (context, _) => _AppearanceRow(
              label: _themeName(theme.choice, l10n),
              note: theme.choice == ThemeChoice.system
                  ? l10n.appearanceSystemNote
                  : null,
              onTap: () => _pickTheme(theme),
            ),
          ),
        ],
        const SizedBox(height: RvmSpacing.lg),
        Text(l10n.profileConsents, style: text.titleSmall),
        const SizedBox(height: RvmSpacing.sm),
        FutureBuilder<List<ConsentRecord>>(
          future: _consents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                children: [
                  SkeletonCard(),
                  SizedBox(height: RvmSpacing.sm),
                  SkeletonCard(),
                ],
              );
            }
            if (snapshot.hasError) {
              final error = snapshot.error;
              return StudentErrorState(
                failure: error is Failure ? error : const UnknownFailure(),
                onRetry: _reload,
              );
            }
            final records = snapshot.data ?? const <ConsentRecord>[];
            if (records.isEmpty) {
              return Text(
                l10n.profileNoConsents,
                style: text.bodyMedium?.copyWith(color: context.palette.fg2),
              );
            }
            return Column(
              children: [
                for (final record in records)
                  _ConsentRow(
                    record: record,
                    busy: _busy,
                    onToggle: () => _withdraw(record),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: RvmSpacing.xl),
        OutlinedButton.icon(
          onPressed: _busy ? null : _signOut,
          icon: const Icon(Icons.logout_rounded),
          label: Text(l10n.profileSignOut),
        ),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          l10n.profileSignOutNote,
          style: text.bodySmall?.copyWith(color: context.palette.fg3),
        ),
        const SizedBox(height: RvmSpacing.lg),
        OutlinedButton.icon(
          onPressed: _busy ? null : _requestDeletion,
          icon: const Icon(Icons.delete_outline_rounded),
          label: Text(l10n.profileDeleteRequest),
        ),
      ],
    );
  }

  Future<void> _pickTheme(ThemeController theme) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(
            RvmSpacing.lg,
            0,
            RvmSpacing.lg,
            RvmSpacing.lg,
          ),
          child: ListenableBuilder(
            listenable: theme,
            builder: (context, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.appearanceTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: RvmSpacing.sm),
                RadioGroup<ThemeChoice>(
                  groupValue: theme.choice,
                  onChanged: (value) {
                    if (value != null) theme.select(value);
                  },
                  child: Column(
                    children: [
                      for (final choice in ThemeChoice.values)
                        RadioListTile<ThemeChoice>(
                          value: choice,
                          title: Text(_themeName(choice, l10n)),
                          subtitle: choice == ThemeChoice.system
                              ? Text(l10n.appearanceSystemNote)
                              : null,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: RvmSpacing.sm),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(l10n.appearanceDone),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  static String _themeName(ThemeChoice choice, AppLocalizations l10n) =>
      switch (choice) {
        ThemeChoice.light => l10n.appearanceLight,
        ThemeChoice.dark => l10n.appearanceDark,
        ThemeChoice.system => l10n.appearanceSystem,
      };

  Future<void> _setLanguage(AppLanguage language) async {
    final bloc = context.read<LanguageBloc>();
    final auth = context.read<AuthBloc>();
    bloc.add(LanguageSelected(language));
    try {
      final account = await getIt<StudentApi>().setLanguage(language.name);
      auth.add(AuthAccountUpdated(account));
    } catch (_) {
      // The choice is kept on the phone; the server's copy retries on the
      // next change.
    }
  }

  Future<void> _withdraw(ConsentRecord record) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final records = await getIt<StudentApi>().consents();
      final share = records.firstWhere(
        (r) => r.purpose == 'share_profile',
        orElse: () => record,
      );
      final marketing = records.firstWhere(
        (r) => r.purpose == 'marketing_story',
        orElse: () => record,
      );
      await getIt<StudentApi>().setConsents(
        shareProfile:
            share.purpose == 'share_profile' ? false : share.granted,
        marketingStory:
            marketing.purpose == 'marketing_story' ? false : marketing.granted,
        shareProfileVersion: share.textVersion ?? 1,
        marketingStoryVersion: marketing.textVersion ?? 1,
      );
      _reload();
    } catch (_) {
      // The row keeps its state; the student can try again.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestDeletion() async {
    final l10n = context.l10n;
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileDeleteTitle),
        content: TextField(
          controller: reason,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(hintText: l10n.profileDeleteReason),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.profileDeleteCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.profileDeleteSend)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/me/deletion-request',
        {'reason': reason.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileDeleteSent)),
      );
    } catch (_) {
      // The student can try again.
    }
  }

  Future<void> _signOut() async {
    await clearCampusCookies();
    if (!mounted) return;
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  static String _stageName(StudentAccount account, AppLocalizations l10n) =>
      switch (account.stage) {
        StudentStage.alumni => l10n.homeStageAlumni,
        StudentStage.fullyPaid => l10n.homeStageFullyPaid,
        StudentStage.registered => l10n.homeStageRegistered,
        StudentStage.visitor => l10n.homeStageVisitor,
      };
}

class _AppearanceRow extends StatelessWidget {
  const _AppearanceRow({
    required this.label,
    required this.note,
    required this.onTap,
  });

  final String label;
  final String? note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RvmSpacing.md,
            vertical: RvmSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RvmRadii.sm + 2),
            border: Border.all(color: context.palette.border),
          ),
          child: Row(
            children: [
              Icon(Icons.contrast_rounded, color: context.palette.fg2),
              const SizedBox(width: RvmSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.bodyMedium),
                    if (note != null)
                      Text(
                        note!,
                        style: text.bodySmall?.copyWith(
                          color: context.palette.fg3,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.palette.fg3),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(color: context.palette.fg2),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: text.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.record,
    required this.busy,
    required this.onToggle,
  });

  final ConsentRecord record;
  final bool busy;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final date = record.withdrawnAt ?? record.grantedAt;
    final dateText = date == null
        ? ''
        : MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
    final purpose = record.purpose == 'share_profile'
        ? l10n.consentShareProfileName
        : l10n.consentMarketingName;
    return Container(
      margin: const EdgeInsets.only(bottom: RvmSpacing.sm),
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(purpose, style: text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  record.granted
                      ? l10n.consentGivenOn(dateText)
                      : l10n.consentWithdrawnOn(dateText),
                  style: text.bodySmall?.copyWith(color: context.palette.fg2),
                ),
              ],
            ),
          ),
          if (record.granted)
            TextButton(
              onPressed: busy ? null : onToggle,
              child: Text(l10n.consentWithdraw),
            ),
        ],
      ),
    );
  }
}
