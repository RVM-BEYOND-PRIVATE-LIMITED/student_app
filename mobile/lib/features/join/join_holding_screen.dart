import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';

/// "I want to join" until the joining flow lands in #3 (student_app #2,
/// item 4): the centres and their call buttons, from the server. No price and
/// no payment step is shown for jobs or joining here.
class JoinHoldingScreen extends StatefulWidget {
  const JoinHoldingScreen({super.key});

  @override
  State<JoinHoldingScreen> createState() => _JoinHoldingScreenState();
}

class _JoinHoldingScreenState extends State<JoinHoldingScreen> {
  late Future<List<Branch>> _branches = getIt<StudentApi>().branches();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.doorJoinTitle)),
      body: FutureBuilder<List<Branch>>(
        future: _branches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 3);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: () => setState(
                () => _branches = getIt<StudentApi>().branches(),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              Text(l10n.joinHoldingTitle, style: text.headlineSmall),
              const SizedBox(height: RvmSpacing.sm),
              Text(
                l10n.joinHoldingBody,
                style: text.bodyMedium?.copyWith(color: context.palette.fg2),
              ),
              const SizedBox(height: RvmSpacing.lg),
              for (final branch in snapshot.data ?? const <Branch>[])
                Container(
                  margin: const EdgeInsets.only(bottom: RvmSpacing.sm),
                  padding: const EdgeInsets.all(RvmSpacing.md),
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(RvmRadii.md),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(branch.name)),
                      if (branch.phoneUri != null)
                        TextButton.icon(
                          onPressed: () => launchUrl(branch.phoneUri!),
                          icon: const Icon(Icons.call_rounded, size: 18),
                          label: Text(l10n.alreadyPaidCall),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
