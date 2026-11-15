import 'dart:convert';
import 'dart:io';

import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import 'api_list_screen.dart';

/* ── Fees, receipts and payments (#4) ──────────────────────────────────── */

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});
  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  late Future<Map<String, dynamic>> _fees = _load();
  late Future<Map<String, dynamic>> _receipts = _loadReceipts();
  bool _paying = false;

  Future<Map<String, dynamic>> _load() =>
      getIt<StudentApi>().getJson('/v1/me/fees');
  Future<Map<String, dynamic>> _loadReceipts() =>
      getIt<StudentApi>().getJson('/v1/me/receipts');

  void _reload() => setState(() {
    _fees = _load();
    _receipts = _loadReceipts();
  });

  Future<void> _pay(Map<String, dynamic> row) async {
    if (_paying) return;
    setState(() => _paying = true);
    try {
      final order = await getIt<StudentApi>().postJson(
        '/v1/me/payment-orders',
        {
          'purpose': 'instalment',
          'due_date': row['due_date'],
          'accept_non_refundable': true,
          'text_version': 1,
        },
      );
      if (!mounted) return;
      final dry = order['mode'] == 'dry_run';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            dry
                ? tr(context, 'Payment is not live yet. Your centre will confirm it.',
                      'भुगतान अभी लाइव नहीं है। आपका सेंटर इसे पुष्ट करेगा।')
                : tr(context, 'Payment started. Finish it to make the receipt.',
                      'भुगतान शुरू हुआ। रसीद के लिए इसे पूरा करें।'),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Future<void> _shareReceipt(Map<String, dynamic> row) async {
    final id = '${row['id'] ?? ''}';
    if (id.isEmpty) return;
    final subject = tr(context, 'RVM receipt', 'RVM रसीद');
    try {
      final json = await getIt<StudentApi>().getJson('/v1/me/receipts/$id/pdf');
      final base64 = '${json['pdf_base64'] ?? ''}';
      if (base64.isEmpty) return;
      final dir = await getTemporaryDirectory();
      final name = '${json['filename'] ?? 'receipt.pdf'}';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(base64Decode(base64), flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: subject,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Fees and receipts', 'फीस और रसीदें'))),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: _reload,
            );
          }
          final fees = snapshot.data ?? const <String, dynamic>{};
          final plan = (fees['plan'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return RefreshIndicator(
            onRefresh: () async {
              _reload();
              await _fees;
            },
            child: ListView(
              padding: const EdgeInsets.all(RvmSpacing.lg),
              children: [
                ModuleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(money((fees['total_paise'] as num?)?.toInt() ?? 0),
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(tr(context, 'Course fee', 'कोर्स फीस')),
                      const SizedBox(height: RvmSpacing.sm),
                      _kv(context, tr(context, 'Paid', 'चुकाया'),
                          money((fees['paid_paise'] as num?)?.toInt() ?? 0)),
                      _kv(context, tr(context, 'Due', 'बाकी'),
                          money((fees['due_paise'] as num?)?.toInt() ?? 0)),
                      if (fees['next_due_date'] != null)
                        _kv(context, tr(context, 'Next due', 'अगली तारीख'),
                            dateText('${fees['next_due_date']}')),
                      if (fees['on_hold'] == true)
                        Text(
                          tr(context, 'Fees are on hold.', 'फीस होल्ड पर है।'),
                          style: TextStyle(color: context.palette.danger),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: RvmSpacing.md),
                Text(tr(context, 'Plan', 'प्लान'),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: RvmSpacing.sm),
                for (final row in plan)
                  Padding(
                    padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                    child: ModuleCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${row['due_date'] ?? ''}'),
                                Text(
                                  '${tr(context, 'Due', 'बाकी')}: ${money((row['balance_due_paise'] as num?)?.toInt() ?? 0)} · ${row['status'] ?? ''}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if ((row['balance_due_paise'] as num?)?.toInt() != 0)
                            FilledButton(
                              onPressed: _paying ? null : () => _pay(row),
                              child: Text(tr(context, 'Pay', 'भुगतान')),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: RvmSpacing.md),
                Text(tr(context, 'Receipts', 'रसीदें'),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: RvmSpacing.sm),
                FutureBuilder<Map<String, dynamic>>(
                  future: _receipts,
                  builder: (context, receipts) {
                    final rows = (receipts.data?['receipts'] as List<dynamic>? ??
                            const [])
                        .whereType<Map<String, dynamic>>()
                        .toList();
                    if (rows.isEmpty) {
                      return Text(tr(context, 'No receipts yet.', 'अभी कोई रसीद नहीं।'));
                    }
                    return Column(
                      children: [
                        for (final row in rows)
                          Padding(
                            padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                            child: ModuleCard(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${row['receipt_number'] ?? ''}'),
                                        Text(
                                          '${dateText(row['payment_date']?.toString())} · ${money((row['amount_paise'] as num?)?.toInt() ?? 0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: tr(context, 'Share PDF', 'PDF साझा करें'),
                                    onPressed: () => _shareReceipt(row),
                                    icon: const Icon(Icons.ios_share_rounded),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _kv(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

/* ── Attendance (#4) ────────────────────────────────────────────────────── */

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/me/attendance');

  void _reload() => setState(
    () => _future = getIt<StudentApi>().getJson('/v1/me/attendance'),
  );

  Future<void> _askCorrection(Map<String, dynamic> session) async {
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Ask for a correction', 'सुधार के लिए कहें')),
        content: TextField(
          controller: reason,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: tr(context, 'Why were you in this class?', 'आप इस क्लास में क्यों थे?'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Send', 'भेजें'))),
        ],
      ),
    );
    if (ok != true || reason.text.trim().length < 5) return;
    try {
      await getIt<StudentApi>().postJson('/v1/me/attendance-corrections', {
        'batch_id': session['batch_id'],
        'date': session['date'],
        'reason': reason.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'Sent to your centre.', 'आपके सेंटर को भेज दिया।'))),
      );
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Attendance', 'उपस्थिति'))),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: _reload,
            );
          }
          final json = snapshot.data ?? const <String, dynamic>{};
          final overall = (json['overall'] as Map<String, dynamic>?) ??
              const <String, dynamic>{};
          final sessions = (json['sessions'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              ModuleCard(
                child: Row(
                  children: [
                    Text('${overall['percent'] ?? 0}%',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(width: RvmSpacing.md),
                    Expanded(
                      child: Text(
                        '${tr(context, 'Present', 'उपस्थित')}: ${overall['present'] ?? 0}/${overall['marked'] ?? 0}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RvmSpacing.md),
              for (final session in sessions)
                Padding(
                  padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                  child: ModuleCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${dateText(session['date']?.toString())} · ${session['status'] ?? ''}',
                          ),
                        ),
                        if (session['status'] != 'present')
                          TextButton(
                            onPressed: () => _askCorrection(session),
                            child: Text(tr(context, 'Ask', 'पूछें')),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/* ── Timetable (#4) ─────────────────────────────────────────────────────── */

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ApiListScreen(
      title: tr(context, 'Timetable', 'समय-सारिणी'),
      path: '/v1/me/timetable',
      listKey: 'classes',
      emptyText: tr(context, 'No classes yet.', 'अभी कोई क्लास नहीं।'),
      itemBuilder: (context, item) => ModuleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dateText(item['date']?.toString())} · ${item['start_time'] ?? ''}–${item['end_time'] ?? ''}'),
            if (item['faculty_name'] != null)
              Text('${item['faculty_name']}', style: Theme.of(context).textTheme.bodySmall),
            if (item['courses'] is List)
              Text((item['courses'] as List).join(', '), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/* ── Announcements (#4) ─────────────────────────────────────────────────── */

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ApiListScreen(
      title: tr(context, 'Announcements', 'घोषणाएँ'),
      path: '/v1/me/announcements',
      listKey: 'announcements',
      emptyText: tr(context, 'No announcements.', 'कोई घोषणा नहीं।'),
      itemBuilder: (context, item) => ModuleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item['title'] ?? ''}', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('${item['message'] ?? ''}'),
            const SizedBox(height: 4),
            Text(dateText(item['created_at']?.toString()), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/* ── Notifications (#4) ─────────────────────────────────────────────────── */

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/me/notifications');

  Future<void> _markRead() async {
    try {
      await getIt<StudentApi>().postJson('/v1/me/notifications/read', {});
      if (!mounted) return;
      setState(() => _future = getIt<StudentApi>().getJson('/v1/me/notifications'));
    } catch (_) {
      // The list still shows; the student can try again.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'Notifications', 'सूचनाएँ')),
        actions: [
          TextButton(onPressed: _markRead, child: Text(tr(context, 'Read all', 'सभी पढ़ें'))),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: () => setState(
                () => _future = getIt<StudentApi>().getJson('/v1/me/notifications'),
              ),
            );
          }
          final rows = (snapshot.data?['notifications'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          if (rows.isEmpty) {
            return StudentEmptyState(
              icon: Icons.notifications_none_rounded,
              title: tr(context, 'No notifications.', 'कोई सूचना नहीं।'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                  child: ModuleCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${row['title'] ?? ''}',
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text('${row['body'] ?? ''}'),
                        const SizedBox(height: 4),
                        Text(dateText(row['created_at']?.toString()),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
