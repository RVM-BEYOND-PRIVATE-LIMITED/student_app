import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/tr.dart';
import '../../router/app_router.dart';

/// The Stage 3/4 entry points. The server's stage and each screen's own API
/// decide what is open; this tab only lists the places.
class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.receipt_long_rounded, tr(context, 'Fees and receipts', 'फीस और रसीदें'), Routes.fees),
      (Icons.fact_check_outlined, tr(context, 'Attendance', 'उपस्थिति'), Routes.attendance),
      (Icons.calendar_month_outlined, tr(context, 'Timetable', 'समय-सारिणी'), Routes.timetable),
      (Icons.campaign_outlined, tr(context, 'Announcements', 'घोषणाएँ'), Routes.announcements),
      (Icons.notifications_outlined, tr(context, 'Notifications', 'सूचनाएँ'), Routes.notifications),
      (Icons.support_agent_rounded, tr(context, 'Complaints', 'शिकायतें'), Routes.complaints),
      (Icons.forum_outlined, tr(context, 'Community', 'समुदाय'), Routes.community),
      (Icons.explore_outlined, tr(context, 'Visits and free lectures', 'विज़िट और मुफ़्त लेक्चर'), Routes.visitor),
      (Icons.workspace_premium_outlined, tr(context, 'Placement and referral', 'प्लेसमेंट और रेफ़रल'), Routes.placement),
      (Icons.play_circle_outline_rounded, tr(context, 'Learning', 'लर्निंग'), Routes.learning),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final (icon, label, route) = items[index];
        return ListTile(
          leading: Icon(icon),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push(route),
        );
      },
    );
  }
}
