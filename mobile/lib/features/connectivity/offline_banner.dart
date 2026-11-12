import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import 'connectivity_bloc.dart';

/// The bar that says the phone has no internet (student_app #1, shared
/// states). It sits under the status bar, above every screen.
class OfflineBar extends StatelessWidget {
  const OfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: StudentColors.white,
      fontSize: 13.5,
    );
    return Material(
      color: StudentColors.navy,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: RvmSpacing.md,
            vertical: RvmSpacing.sm,
          ),
          child: Semantics(
            liveRegion: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 16,
                  color: StudentColors.warning,
                ),
                const SizedBox(width: RvmSpacing.sm),
                Flexible(
                  child: Text(
                    context.l10n.offlineBanner,
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Puts [OfflineBar] above [child] while the phone is offline.
///
/// The bar takes the status-bar inset itself, so while it shows, [child] is
/// told the top inset is used and does not pad for the status bar twice.
class OfflineBannerHost extends StatelessWidget {
  const OfflineBannerHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (previous, current) => previous.online != current.online,
      builder: (context, state) {
        final offline = !state.online;
        return Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: offline
                  ? const OfflineBar()
                  : const SizedBox(width: double.infinity),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: offline,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
