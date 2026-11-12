import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../widgets/states.dart';
import '../connectivity/offline_banner.dart';

/// The shared states, one per tab, so they can be checked on a real phone
/// (student_app #1, check 8): the skeleton, the empty state, the error with
/// its request id and retry, and the offline bar.
class StatesGalleryScreen extends StatelessWidget {
  const StatesGalleryScreen({super.key});

  /// Shown in the error preview. It is a placeholder, not a server's id.
  static const sampleRequestId = 'sample-request-id';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.devSharedStates),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.gallerySkeleton),
              Tab(text: l10n.galleryEmpty),
              Tab(text: l10n.galleryError),
              Tab(text: l10n.galleryOffline),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const SkeletonList(),
            StudentEmptyState(
              icon: Icons.inbox_outlined,
              title: l10n.emptyTitle,
              message: l10n.emptyBody,
            ),
            StudentErrorState(
              failure: const ServerFailure.status(
                503,
                requestId: sampleRequestId,
              ),
              onRetry: () {},
            ),
            Column(
              children: [
                const OfflineBar(),
                Expanded(
                  child: StudentEmptyState(
                    icon: Icons.inbox_outlined,
                    title: l10n.emptyTitle,
                    message: l10n.emptyBody,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
