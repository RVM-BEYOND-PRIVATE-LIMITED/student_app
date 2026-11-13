import 'package:core_bloc/core_bloc.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/crash/crash_log.dart';
import '../../core/format/display_format.dart';
import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/data_text.dart';
import '../../widgets/load_state_view.dart';
import '../../widgets/states.dart';

/// The crash records kept on this phone, newest first (student_app #1,
/// item 12). They are already cleaned of personal data, and they never
/// leave the phone until student_app #12 is decided.
class CrashLogScreen extends StatelessWidget {
  const CrashLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<CrashLogStore>();
    return BlocProvider(
      create: (_) => LoadBloc<List<CrashRecord>>(
        () async => (await store.read()).reversed.toList(),
        isEmpty: (records) => records.isEmpty,
      )..add(const LoadRequested()),
      child: const _CrashLogView(),
    );
  }
}

class _CrashLogView extends StatelessWidget {
  const _CrashLogView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<LoadBloc<List<CrashRecord>>>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.devCrashLog),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<CrashLogStore>().clear();
              bloc.add(const LoadRefreshed());
            },
            child: Text(l10n.devCrashLogClear),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: StudentColors.surface2,
            padding: const EdgeInsets.symmetric(
              horizontal: RvmSpacing.md,
              vertical: RvmSpacing.sm + 4,
            ),
            child: Text(
              l10n.devCrashLogNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child:
                BlocBuilder<
                  LoadBloc<List<CrashRecord>>,
                  LoadState<List<CrashRecord>>
                >(
                  builder: (context, state) => LoadStateView<List<CrashRecord>>(
                    state: state,
                    onRetry: () => bloc.add(const LoadRefreshed()),
                    empty: (context) => StudentEmptyState(
                      icon: Icons.verified_outlined,
                      title: l10n.devCrashLogEmpty,
                    ),
                    builder: (context, records) => ListView.separated(
                      padding: const EdgeInsets.all(RvmSpacing.md),
                      itemCount: records.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: RvmSpacing.sm + 4),
                      itemBuilder: (context, index) =>
                          _RecordCard(record: records[index]),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final CrashRecord record;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(RvmSpacing.md - 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: RvmSpacing.sm,
              runSpacing: RvmSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RvmSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: StudentColors.danger.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DataText(
                    record.kind.name,
                    size: 11.5,
                    color: StudentColors.danger,
                  ),
                ),
                DataText(
                  IstTime.dateTime(record.at, locale),
                  size: 12,
                  color: StudentColors.fg2,
                ),
              ],
            ),
            const SizedBox(height: RvmSpacing.sm),
            DataText(record.summary, size: 12.5),
            if (record.stack != null) ...[
              const SizedBox(height: RvmSpacing.sm),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 160),
                padding: const EdgeInsets.all(RvmSpacing.sm),
                decoration: BoxDecoration(
                  color: StudentColors.surface2,
                  borderRadius: BorderRadius.circular(RvmRadii.xs),
                ),
                child: SingleChildScrollView(
                  child: DataText(
                    record.stack!,
                    size: 11,
                    color: StudentColors.fg2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
