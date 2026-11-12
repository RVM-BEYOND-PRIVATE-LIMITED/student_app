import 'package:core_bloc/core_bloc.dart';
import 'package:core_ui/core_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_info.dart';
import '../../core/crash/crash_log.dart';
import '../../core/env/student_env.dart';
import '../../core/session/student_session.dart';
import '../../l10n/l10n.dart';
import '../../router/app_router.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/data_text.dart';
import '../../widgets/states.dart';
import '../language/bloc/language_bloc.dart';

/// What the Developer menu reads from the phone.
class DevMenuInfo extends Equatable {
  const DevMenuInfo({
    required this.installId,
    required this.signedIn,
    required this.crashCount,
  });

  final String installId;
  final bool signedIn;
  final int crashCount;

  static Future<DevMenuInfo> read(
    StudentSession session,
    CrashLogStore crashLog,
  ) async => DevMenuInfo(
    installId: await session.installId(),
    signedIn: await session.hasSession(),
    crashCount: (await crashLog.read()).length,
  );

  @override
  List<Object?> get props => [installId, signedIn, crashCount];
}

/// The Developer menu (student_app #1), in dev builds only: what this build
/// talks to, what the server does not publish yet, the session, the
/// language, and the diagnostics (shared states, the on-device crash log).
class DevMenuScreen extends StatelessWidget {
  const DevMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.read<StudentSession>();
    final crashLog = context.read<CrashLogStore>();
    return BlocProvider(
      create: (_) =>
          LoadBloc<DevMenuInfo>(() => DevMenuInfo.read(session, crashLog))
            ..add(const LoadRequested()),
      child: const _DevMenuView(),
    );
  }
}

class _DevMenuView extends StatelessWidget {
  const _DevMenuView();

  /// The issue that will publish what the menu cannot show yet.
  static const _waitsFor = 'Scheduler_Backend #158';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final env = context.read<StudentEnv>();
    final appInfo = context.read<AppInfo>();
    final language = context.watch<LanguageBloc>().state.language;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.devMenuTitle)),
      body: BlocBuilder<LoadBloc<DevMenuInfo>, LoadState<DevMenuInfo>>(
        builder: (context, state) {
          final info = state.data;
          return ListView(
            padding: const EdgeInsets.only(bottom: RvmSpacing.xl),
            children: [
              _Section(
                title: l10n.devSectionBuild,
                children: [
                  _InfoRow(
                    label: l10n.devFlavor,
                    value: Text(
                      env.isDev ? l10n.devFlavorDev : l10n.devFlavorProd,
                    ),
                  ),
                  _InfoRow(
                    label: l10n.devAppVersion,
                    value: DataText(appInfo.display),
                  ),
                  _InfoRow(
                    label: l10n.devApiHost,
                    value: DataText(env.apiBaseUrl.toString()),
                    note: env.hostSetOnPurpose
                        ? l10n.devHostSet
                        : l10n.devHostDefault,
                  ),
                ],
              ),
              _Section(
                title: l10n.devSectionServer,
                children: [
                  for (final label in [
                    l10n.devMock,
                    l10n.devSwitches,
                    l10n.devMinimumVersion,
                  ])
                    _InfoRow(
                      label: label,
                      value: Text(l10n.devNotYet),
                      data: _waitsFor,
                    ),
                ],
              ),
              _Section(
                title: l10n.devSectionSession,
                children: [
                  _InfoRow(
                    label: l10n.devInstallId,
                    value: info == null
                        ? const ShimmerBox(width: 220, height: 14)
                        : DataText(info.installId),
                  ),
                  _InfoRow(
                    label: l10n.devSignedIn,
                    value: info == null
                        ? const ShimmerBox(width: 60, height: 14)
                        : Text(info.signedIn ? l10n.devYes : l10n.devNo),
                  ),
                ],
              ),
              _Section(
                title: l10n.devSectionLanguage,
                children: [
                  ListTile(
                    leading: const Icon(Icons.translate_rounded),
                    title: Text(language.endonym),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.language),
                  ),
                ],
              ),
              _Section(
                title: l10n.devSectionDiagnostics,
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard_customize_outlined),
                    title: Text(l10n.devSharedStates),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.devStates),
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: Text(l10n.devCrashLog),
                    subtitle: info == null
                        ? null
                        : Text(l10n.devCrashLogCount(info.crashCount)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _openCrashLog(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.science_outlined),
                    title: Text(l10n.devRecordTestError),
                    onTap: () => _recordTestError(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(l10n.devLicences),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: appInfo.display,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openCrashLog(BuildContext context) async {
    final bloc = context.read<LoadBloc<DevMenuInfo>>();
    await context.push(Routes.devCrashLog);
    bloc.add(const LoadRefreshed());
  }

  Future<void> _recordTestError(BuildContext context) async {
    final bloc = context.read<LoadBloc<DevMenuInfo>>();
    final messenger = ScaffoldMessenger.of(context);
    final recorded = context.l10n.devTestErrorRecorded;
    await CrashLog.record(
      StateError('Test error recorded from the Developer menu'),
      StackTrace.current,
      kind: CrashKind.test,
    );
    bloc.add(const LoadRefreshed());
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(recorded)));
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RvmSpacing.md,
        RvmSpacing.lg - 4,
        RvmSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: RvmSpacing.xs,
              bottom: RvmSpacing.sm,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: StudentColors.accentDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) const Divider(indent: RvmSpacing.md),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.note,
    this.data,
  });

  final String label;
  final Widget value;

  /// A line of words under the value.
  final String? note;

  /// A technical value under the value, such as an issue number.
  final String? data;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: RvmSpacing.md,
        vertical: RvmSpacing.sm + 4,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: text.labelMedium),
            const SizedBox(height: RvmSpacing.xs),
            DefaultTextStyle.merge(style: text.bodyMedium, child: value),
            if (note != null) ...[
              const SizedBox(height: 2),
              Text(note!, style: text.bodySmall),
            ],
            if (data != null) ...[
              const SizedBox(height: 2),
              DataText(data!, size: 12, color: StudentColors.fg2),
            ],
          ],
        ),
      ),
    );
  }
}
