import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../core/security/secure_screen.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import 'api_list_screen.dart';
import 'learning_quizzes.dart';
import 'video_player_screen.dart';

/* ── Complaints (#5) ────────────────────────────────────────────────────── */

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});
  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/me/complaints');

  void _reload() => setState(
    () => _future = getIt<StudentApi>().getJson('/v1/me/complaints'),
  );

  Future<void> _raise() async {
    final category = TextEditingController(text: 'machines');
    final description = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Raise a complaint', 'शिकायत दर्ज करें')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: category,
              decoration: InputDecoration(
                labelText: tr(context, 'Category', 'श्रेणी'),
                helperText: tr(context, 'For example machines, fees, faculty', 'जैसे machines, fees, faculty'),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: description,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: tr(context, 'What happened?', 'क्या हुआ?'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Send', 'भेजें'))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await getIt<StudentApi>().postJson('/v1/me/complaints', {
        'category': category.text.trim(),
        'description': description.text.trim(),
      });
      _reload();
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    }
  }

  Future<void> _open(Map<String, dynamic> complaint) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _ComplaintDetail(id: '${complaint['id']}'),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Complaints', 'शिकायतें'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _raise,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr(context, 'New', 'नई')),
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
              onRetry: _reload,
            );
          }
          final rows = (snapshot.data?['complaints'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          if (rows.isEmpty) {
            return StudentEmptyState(
              icon: Icons.support_agent_rounded,
              title: tr(context, 'No complaints.', 'कोई शिकायत नहीं।'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                  child: ModuleCard(
                    onTap: () => _open(row),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${row['ref'] ?? ''} · ${row['category_name'] ?? ''}',
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text('${row['description'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('${row['status'] ?? ''}', style: Theme.of(context).textTheme.bodySmall),
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

class _ComplaintDetail extends StatefulWidget {
  const _ComplaintDetail({required this.id});
  final String id;
  @override
  State<_ComplaintDetail> createState() => _ComplaintDetailState();
}

class _ComplaintDetailState extends State<_ComplaintDetail> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/me/complaints/${widget.id}');
  final _message = TextEditingController();

  Future<void> _send() async {
    final body = _message.text.trim();
    if (body.isEmpty) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/me/complaints/${widget.id}/messages',
        {'body': body},
      );
      _message.clear();
      setState(() => _future = getIt<StudentApi>().getJson('/v1/me/complaints/${widget.id}'));
    } catch (_) {}
  }

  Future<void> _reopen() async {
    try {
      await getIt<StudentApi>().postJson('/v1/me/complaints/${widget.id}/reopen', {});
      setState(() => _future = getIt<StudentApi>().getJson('/v1/me/complaints/${widget.id}'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final json = snapshot.data!;
        final complaint = (json['complaint'] as Map<String, dynamic>?) ?? json;
        final messages = (json['messages'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('${complaint['ref'] ?? ''}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('${complaint['description'] ?? ''}'),
              const SizedBox(height: 8),
              Text('${complaint['status'] ?? ''}'),
              const SizedBox(height: 12),
              for (final message in messages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ModuleCard(
                    child: Text('${message['body'] ?? message['message'] ?? ''}'),
                  ),
                ),
              if (complaint['can_reopen'] == true)
                OutlinedButton(
                  onPressed: _reopen,
                  child: Text(tr(context, 'Reopen', 'फिर खोलें')),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                        hintText: tr(context, 'Write a message', 'संदेश लिखें'),
                      ),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ── Community (#5) ─────────────────────────────────────────────────────── */

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ApiListScreen(
      title: tr(context, 'Community', 'समुदाय'),
      path: '/v1/community/groups',
      listKey: 'groups',
      emptyText: tr(context, 'No groups yet.', 'अभी कोई समूह नहीं।'),
      itemBuilder: (context, group) => ModuleCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _GroupPosts(
              groupId: '${group['id']}',
              name: '${group['name'] ?? ''}',
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text('${group['name'] ?? ''}')),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _GroupPosts extends StatefulWidget {
  const _GroupPosts({required this.groupId, required this.name});
  final String groupId;
  final String name;
  @override
  State<_GroupPosts> createState() => _GroupPostsState();
}

class _GroupPostsState extends State<_GroupPosts> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/community/groups/${widget.groupId}/posts');

  void _reload() => setState(
    () => _future = getIt<StudentApi>().getJson('/v1/community/groups/${widget.groupId}/posts'),
  );

  Future<void> _post() async {
    final body = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'New post', 'नई पोस्ट')),
        content: TextField(controller: body, minLines: 2, maxLines: 5),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Post', 'पोस्ट'))),
        ],
      ),
    );
    if (ok != true || body.text.trim().isEmpty) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/groups/${widget.groupId}/posts',
        {'body': body.text.trim()},
      );
      _reload();
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    }
  }

  Future<void> _react(Map<String, dynamic> post) async {
    try {
      final id = '${post['id']}';
      if (post['reacted'] == true) {
        await getIt<StudentApi>().deletePath('/v1/community/posts/$id/reaction');
      } else {
        await getIt<StudentApi>().putJson('/v1/community/posts/$id/reaction');
      }
      _reload();
    } catch (_) {}
  }

  Future<void> _report(Map<String, dynamic> post) async {
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Report post', 'पोस्ट रिपोर्ट करें')),
        content: TextField(
          controller: reason,
          decoration: InputDecoration(hintText: tr(context, 'Why?', 'क्यों?')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Report', 'रिपोर्ट'))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/posts/${post['id']}/report',
        {'reason': reason.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'Reported.', 'रिपोर्ट कर दिया।'))),
      );
      _reload();
    } catch (_) {}
  }

  Future<void> _open(Map<String, dynamic> post) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PostComments(postId: '${post['id']}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: _post,
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 3);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: _reload,
            );
          }
          final posts = (snapshot.data?['posts'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              for (final post in posts)
                Padding(
                  padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                  child: ModuleCard(
                    onTap: () => _open(post),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${post['author'] ?? ''}', style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text('${post['body'] ?? ''}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('${post['comment_count'] ?? 0} · ${post['reaction_count'] ?? 0}',
                                style: Theme.of(context).textTheme.bodySmall),
                            const Spacer(),
                            IconButton(
                              tooltip: tr(context, 'React', 'रिएक्ट'),
                              onPressed: () => _react(post),
                              icon: Icon(
                                post['reacted'] == true
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 18,
                              ),
                            ),
                            IconButton(
                              tooltip: tr(context, 'Report', 'रिपोर्ट'),
                              onPressed: () => _report(post),
                              icon: const Icon(Icons.flag_outlined, size: 18),
                            ),
                          ],
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

class _PostComments extends StatefulWidget {
  const _PostComments({required this.postId});
  final String postId;
  @override
  State<_PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<_PostComments> {
  late Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/community/posts/${widget.postId}/comments');
  final _body = TextEditingController();

  Future<void> _send() async {
    if (_body.text.trim().isEmpty) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/posts/${widget.postId}/comments',
        {'body': _body.text.trim()},
      );
      _body.clear();
      setState(() => _future = getIt<StudentApi>().getJson('/v1/community/posts/${widget.postId}/comments'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          final comments = (snapshot.data?['comments'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return ListView(
            shrinkWrap: true,
            children: [
              for (final comment in comments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ModuleCard(child: Text('${comment['body'] ?? ''}')),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _body,
                      decoration: InputDecoration(hintText: tr(context, 'Write a comment', 'टिप्पणी लिखें')),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ── Visitor: lectures, quizzes, visits (#6) ────────────────────────────── */

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});
  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  late Future<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)> _future =
      _load();

  Future<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)> _load() async {
    final api = getIt<StudentApi>();
    final values = await Future.wait([
      api.getJson('/v1/visitor/lectures'),
      api.getJson('/v1/visitor/quizzes'),
      api.getJson('/v1/visitor/visits'),
    ]);
    return (values[0], values[1], values[2]);
  }

  Future<void> _book() async {
    final location = TextEditingController();
    final at = TextEditingController();
    var kind = 'demo_class';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(tr(context, 'Book a visit', 'विज़िट बुक करें')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: kind,
                decoration: InputDecoration(labelText: tr(context, 'Kind', 'प्रकार')),
                items: [
                  DropdownMenuItem(value: 'demo_class', child: Text(tr(context, 'Demo class', 'डेमो क्लास'))),
                  DropdownMenuItem(value: 'centre_visit', child: Text(tr(context, 'Centre visit', 'सेंटर विज़िट'))),
                  DropdownMenuItem(value: 'counsellor_call', child: Text(tr(context, 'Counsellor call', 'काउंसलर कॉल'))),
                ],
                onChanged: (value) => setDialog(() => kind = value ?? 'demo_class'),
              ),
              TextField(controller: location, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr(context, 'Centre id', 'सेंटर आईडी'))),
              TextField(controller: at, decoration: InputDecoration(labelText: tr(context, 'When (YYYY-MM-DDTHH:MM:SS+05:30)', 'कब'))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Book', 'बुक'))),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      await getIt<StudentApi>().postJson('/v1/visitor/visits', {
        'kind': kind,
        'location_id': int.tryParse(location.text.trim()) ?? 0,
        'preferred_at': at.text.trim(),
      });
      if (!mounted) return;
      setState(() => _future = _load());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Visits and free lectures', 'विज़िट और मुफ़्त लेक्चर'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _book,
        icon: const Icon(Icons.event_available_rounded),
        label: Text(tr(context, 'Book', 'बुक')),
      ),
      body: FutureBuilder<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final (lectures, quizzes, visits) = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              _heading(context, tr(context, 'Free lectures', 'मुफ़्त लेक्चर')),
              for (final lecture in (lectures['lectures'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  onTap: () => launchUrl(Uri.parse('https://www.youtube.com/watch?v=${lecture['video_youtube_id']}')),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_outline_rounded),
                      const SizedBox(width: 12),
                      Expanded(child: Text('${lecture['title'] ?? ''}')),
                    ],
                  ),
                ),
              _heading(context, tr(context, 'Quizzes', 'क्विज़')),
              for (final quiz in (quizzes['quizzes'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => _QuizScreen(id: '${quiz['id']}', title: '${quiz['title'] ?? ''}')),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.quiz_outlined),
                      const SizedBox(width: 12),
                      Expanded(child: Text('${quiz['title'] ?? ''}')),
                    ],
                  ),
                ),
              _heading(context, tr(context, 'My visits', 'मेरी विज़िट')),
              for (final visit in (visits['visits'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  child: Text('${visit['kind'] ?? ''} · ${dateText(visit['preferred_at']?.toString())} · ${visit['status'] ?? ''}'),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _QuizScreen extends StatefulWidget {
  const _QuizScreen({required this.id, required this.title});
  final String id;
  final String title;
  @override
  State<_QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<_QuizScreen> {
  late final Future<Map<String, dynamic>> _future =
      getIt<StudentApi>().getJson('/v1/visitor/quizzes/${widget.id}');
  final Map<String, String> _answers = {};
  String? _result;

  Future<void> _submit() async {
    try {
      final result = await getIt<StudentApi>().postJson(
        '/v1/visitor/quizzes/${widget.id}/attempts',
        {'answers': _answers},
      );
      setState(() => _result = '${result['score'] ?? 0}/${result['max_score'] ?? 0}');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final questions = (snapshot.data?['questions'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              for (final question in questions) ...[
                Text('${question['prompt'] ?? ''}', style: Theme.of(context).textTheme.titleSmall),
                RadioGroup<String>(
                  groupValue: _answers['${question['id']}'],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _answers['${question['id']}'] = value);
                  },
                  child: Column(
                    children: [
                      for (final option in (question['options'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                        RadioListTile<String>(
                          value: '${option['key']}',
                          title: Text('${option['label'] ?? ''}'),
                        ),
                    ],
                  ),
                ),
              ],
              if (_result != null) Text('${tr(context, 'Score', 'स्कोर')}: $_result'),
              FilledButton(onPressed: _submit, child: Text(tr(context, 'Submit', 'जमा करें'))),
            ],
          );
        },
      ),
    );
  }
}

/* ── Placement proof and referral (#6) ──────────────────────────────────── */

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});
  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  late Future<Map<String, dynamic>> _proofs = getIt<StudentApi>().getJson('/v1/me/placement-proofs');
  late Future<Map<String, dynamic>> _referral = getIt<StudentApi>().getJson('/v1/me/referral');
  late Future<Map<String, dynamic>> _payout = getIt<StudentApi>().getJson('/v1/me/payout-account');

  void _reload() => setState(() {
    _proofs = getIt<StudentApi>().getJson('/v1/me/placement-proofs');
    _referral = getIt<StudentApi>().getJson('/v1/me/referral');
    _payout = getIt<StudentApi>().getJson('/v1/me/payout-account');
  });

  Future<void> _shareReferral(String code, String? link) async {
    final text = link == null
        ? 'Join RVM with my referral code $code.'
        : 'Join RVM with my referral code $code: $link';
    await SharePlus.instance.share(ShareParams(text: text, subject: 'RVM referral'));
  }

  Future<void> _setPayout() async {
    final holder = TextEditingController();
    final upi = TextEditingController();
    final account = TextEditingController();
    final ifsc = TextEditingController();
    var kind = 'upi';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(tr(context, 'Where rewards go', 'इनाम कहाँ जाएँ')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'upi', label: Text('UPI')),
                    ButtonSegment(value: 'bank', label: Text('Bank')),
                  ],
                  selected: {kind},
                  onSelectionChanged: (selection) =>
                      setDialogState(() => kind = selection.first),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: holder,
                  decoration: InputDecoration(
                    labelText: tr(context, 'Account holder name', 'खाताधारक का नाम'),
                  ),
                ),
                if (kind == 'upi')
                  TextField(
                    controller: upi,
                    decoration: InputDecoration(
                      labelText: tr(context, 'UPI ID', 'UPI आईडी'),
                    ),
                  )
                else ...[
                  TextField(
                    controller: account,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: tr(context, 'Account number', 'खाता संख्या'),
                    ),
                  ),
                  TextField(
                    controller: ifsc,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: tr(context, 'IFSC', 'IFSC'),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  tr(context, 'Only the holder name and last 4 characters are kept.',
                      'केवल खाताधारक का नाम और अंतिम 4 अक्षर रखे जाते हैं।'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(context, 'Cancel', 'रद्द')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'Save', 'सहेजें')),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final name = holder.text.trim();
    if (name.length < 2) return;
    try {
      await getIt<StudentApi>().putJson('/v1/me/payout-account', {
        'kind': kind,
        'holder_name': name,
        if (kind == 'upi') 'upi_id': upi.text.trim(),
        if (kind == 'bank') 'account_number': account.text.trim(),
        if (kind == 'bank') 'ifsc': ifsc.text.trim().toUpperCase(),
      });
      _reload();
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    }
  }

  Future<void> _sendProof() async {
    final company = TextEditingController();
    final role = TextEditingController();
    final salary = TextEditingController();
    final date = TextEditingController();
    FilePickerResult? file;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Send placement proof', 'प्लेसमेंट प्रमाण भेजें')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: company, decoration: InputDecoration(labelText: tr(context, 'Company', 'कंपनी'))),
            TextField(controller: role, decoration: InputDecoration(labelText: tr(context, 'Role', 'पद'))),
            TextField(controller: salary, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr(context, 'Monthly salary (₹)', 'मासिक वेतन (₹)'))),
            TextField(controller: date, decoration: InputDecoration(labelText: tr(context, 'Joining date (YYYY-MM-DD)', 'जॉइनिंग तारीख'))),
            TextButton(
              onPressed: () async {
                file = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
              },
              child: Text(tr(context, 'Choose letter', 'पत्र चुनें')),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'Cancel', 'रद्द'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr(context, 'Send', 'भेजें'))),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final picked = file?.files.single;
    final path = picked?.path;
    final salaryPaise = (int.tryParse(salary.text.trim()) ?? 0) * 100;
    if (path == null ||
        company.text.trim().length < 2 ||
        role.text.trim().length < 2 ||
        salaryPaise < 1 ||
        DateTime.tryParse(date.text.trim()) == null ||
        (picked?.size ?? 0) > 5 * 1024 * 1024) {
      _toast(
        tr(context, 'Fill every field and choose a letter up to 5 MB.',
            'हर जानकारी भरें और 5 MB तक का पत्र चुनें।'),
      );
      return;
    }
    try {
      await getIt<StudentApi>().uploadMultipart(
        path: '/v1/me/placement-proofs',
        fields: {
          'company_name': company.text.trim(),
          'role': role.text.trim(),
          'salary_paise': '$salaryPaise',
          'joining_date': date.text.trim(),
        },
        filePath: path,
      );
      _reload();
    } catch (error) {
      _toastError(error);
    }
  }

  void _toast(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _toastError(Object error) {
    if (!mounted) return;
    final failure = error is Failure ? error : const UnknownFailure();
    _toast(failureLine(failure, context.l10n));
  }

  @override
  Widget build(BuildContext context) {
    return SecureScreen(
      child: Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Placement and referral', 'प्लेसमेंट और रेफ़रल'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendProof,
        icon: const Icon(Icons.upload_file_rounded),
        label: Text(tr(context, 'Proof', 'प्रमाण')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(RvmSpacing.lg),
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _referral,
            builder: (context, snapshot) {
              final code = snapshot.data?['code'];
              final link = snapshot.data?['link'];
              if (code == null) return const SizedBox.shrink();
              final counts = snapshot.data?['referrals'];
              return ModuleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr(context, 'Your referral code', 'आपका रेफ़रल कोड'), style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text('$code', style: Theme.of(context).textTheme.headlineSmall),
                    if (counts is Map)
                      Text(
                        '${tr(context, 'Joined', 'जुड़े')}: ${counts['joined'] ?? 0} · '
                        '${tr(context, 'Rewarded', 'इनाम')}: ${counts['rewarded'] ?? 0}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (link != null)
                      Wrap(
                        spacing: 4,
                        children: [
                          TextButton.icon(
                            onPressed: () => Clipboard.setData(ClipboardData(text: '$link')),
                            icon: const Icon(Icons.copy_rounded),
                            label: Text(tr(context, 'Copy link', 'लिंक कॉपी करें')),
                          ),
                          TextButton.icon(
                            onPressed: () => _shareReferral('$code', '$link'),
                            icon: const Icon(Icons.share_rounded),
                            label: Text(tr(context, 'Share', 'साझा करें')),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: RvmSpacing.md),
          Text(tr(context, 'Payout account', 'भुगतान खाता'), style: Theme.of(context).textTheme.titleMedium),
          FutureBuilder<Map<String, dynamic>>(
            future: _payout,
            builder: (context, snapshot) {
              final account = snapshot.data?['account'];
              final row = account is Map ? account : null;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ModuleCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row == null
                                  ? tr(context, 'No account yet.', 'अभी कोई खाता नहीं।')
                                  : '${row['kind'] == 'upi' ? 'UPI' : tr(context, 'Bank', 'बैंक')} · '
                                      '${row['holder_name'] ?? ''} · ••••${row['last4'] ?? ''}',
                            ),
                            if (row != null)
                              Text(
                                '${row['status'] ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _setPayout,
                        child: Text(row == null
                            ? tr(context, 'Add', 'जोड़ें')
                            : tr(context, 'Change', 'बदलें')),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: RvmSpacing.md),
          Text(tr(context, 'My proofs', 'मेरे प्रमाण'), style: Theme.of(context).textTheme.titleMedium),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              tr(context, 'The marketing-use consent is in Profile.', 'मार्केटिंग उपयोग की सहमति प्रोफ़ाइल में है।'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _proofs,
            builder: (context, snapshot) {
              final rows = (snapshot.data?['proofs'] as List<dynamic>? ?? const [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
              return Column(
                children: [
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ModuleCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${row['company_name'] ?? ''} · ${row['role'] ?? ''}'),
                            Text('${row['status'] ?? ''}', style: Theme.of(context).textTheme.bodySmall),
                            if (row['reason'] != null)
                              Text(
                                '${row['reason']}',
                                style: TextStyle(color: context.palette.danger),
                              ),
                            if (row['reward'] is Map)
                              Text(
                                '${tr(context, 'Reward', 'इनाम')}: '
                                '${money((asMap(row['reward'])['amount_paise'] as num?)?.toInt() ?? 0)} · '
                                '${asMap(row['reward'])['status'] ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
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
    ),
    );
  }
}

/* ── Learning: classes, videos, scores, packs, quizzes (#9) ─────────────── */

class LearningData {
  const LearningData({
    required this.classes,
    required this.videos,
    required this.scores,
    required this.packs,
    required this.dailyQuiz,
    required this.mockRoles,
  });

  final Map<String, dynamic> classes;
  final Map<String, dynamic> videos;
  final Map<String, dynamic> scores;
  final Map<String, dynamic> packs;
  final Map<String, dynamic> dailyQuiz;
  final Map<String, dynamic> mockRoles;
}

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});
  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late Future<LearningData> _future = _load();

  Future<LearningData> _load() async {
    final api = getIt<StudentApi>();
    final values = await Future.wait([
      api.getJson('/v1/me/online-classes'),
      api.getJson('/v1/me/videos'),
      api.getJson('/v1/me/test-scores'),
      api.getJson('/v1/interview-packs'),
      api.getJson('/v1/quizzes/daily'),
      api.getJson('/v1/quizzes/mock/roles'),
    ]);
    return LearningData(
      classes: values[0],
      videos: values[1],
      scores: values[2],
      packs: values[3],
      dailyQuiz: values[4],
      mockRoles: values[5],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Learning', 'लर्निंग'))),
      body: FutureBuilder<LearningData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final data = snapshot.data!;
          final classes = data.classes;
          final videos = data.videos;
          final scores = data.scores;
          final packs = data.packs;
          final dailyQuiz = data.dailyQuiz;
          final mockRoles = data.mockRoles;
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              _heading(context, tr(context, 'Online classes', 'ऑनलाइन क्लास')),
              for (final item in (classes['classes'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  onTap: item['can_join'] == true && item['link'] != null
                      ? () => launchUrl(Uri.parse('${item['link']}'))
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['batch_name'] ?? ''} · ${dateText(item['date']?.toString())}'),
                      Text('${item['start'] ?? ''}–${item['end'] ?? ''} · ${item['status'] ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              _heading(context, tr(context, 'Videos', 'वीडियो')),
              for (final video in (videos['videos'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  onTap: () async {
                    if (!await confirmCountedPlay(context, video)) return;
                    if (!context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoPlaybackScreen(video: video),
                      ),
                    );
                    if (context.mounted) setState(() => _future = _load());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${video['title'] ?? ''}'),
                      Text('${tr(context, 'Views left', 'बचे व्यू')}: ${video['views_left'] ?? 0}',
                          style: Theme.of(context).textTheme.bodySmall),
                      if (video['locked_reason'] != null)
                        Text(
                          '${video['locked_reason']}',
                          style: TextStyle(color: context.palette.warning),
                        ),
                    ],
                  ),
                ),
              _heading(context, tr(context, 'Test scores', 'टेस्ट स्कोर')),
              ModuleCard(
                child: Text('${tr(context, 'Overall', 'कुल')}: ${scores['overall_pct'] ?? 0}%'),
              ),
              for (final test in (scores['tests'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  child: Text('${test['module_name'] ?? ''} · ${test['marks'] ?? 0}/${test['max_marks'] ?? 0}'),
                ),
              _heading(context, tr(context, 'Interview packs', 'इंटरव्यू पैक')),
              for (final role in (packs['roles'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                for (final pack in (role['packs'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                  ModuleCard(child: Text('${role['name'] ?? ''} · ${pack['title'] ?? ''}')),
              _heading(context, tr(context, 'Quiz of the day', 'आज की क्विज़')),
              ModuleCard(
                onTap: dailyQuiz['available'] == true
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DailyQuizScreen(quiz: dailyQuiz),
                        ),
                      )
                    : null,
                child: Text(
                  dailyQuiz['available'] != true
                      ? tr(context, 'No quiz today.', 'आज कोई क्विज़ नहीं।')
                      : dailyQuiz['answered'] == true
                      ? '${tr(context, 'Answered', 'जवाब दिया')} · ${tr(context, 'Score', 'स्कोर')}: '
                          '${dailyQuiz['score'] ?? 0}/${dailyQuiz['max_score'] ?? 0}'
                      : tr(context, 'Answer today\'s quiz', 'आज की क्विज़ के जवाब दें'),
                ),
              ),
              _heading(context, tr(context, 'Mock interview', 'मॉक इंटरव्यू')),
              for (final role in (mockRoles['roles'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>())
                ModuleCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MockQuizScreen(role: role)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('${role['name'] ?? ''}')),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}
