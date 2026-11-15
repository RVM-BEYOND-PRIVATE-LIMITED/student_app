import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../widgets/states.dart';
import 'api_list_screen.dart';

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
                        Text('${post['comment_count'] ?? 0} · ${post['reaction_count'] ?? 0}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Visits and free lectures', 'विज़िट और मुफ़्त लेक्चर'))),
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

  void _reload() => setState(() {
    _proofs = getIt<StudentApi>().getJson('/v1/me/placement-proofs');
    _referral = getIt<StudentApi>().getJson('/v1/me/referral');
  });

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
    if (ok != true) return;
    final path = file?.files.single.path;
    if (path == null) return;
    try {
      await getIt<StudentApi>().uploadMultipart(
        path: '/v1/me/placement-proofs',
        fields: {
          'company_name': company.text.trim(),
          'role': role.text.trim(),
          'salary_paise': '${(int.tryParse(salary.text.trim()) ?? 0) * 100}',
          'joining_date': date.text.trim(),
        },
        filePath: path,
      );
      _reload();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return ModuleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr(context, 'Your referral code', 'आपका रेफ़रल कोड'), style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text('$code', style: Theme.of(context).textTheme.headlineSmall),
                    if (link != null)
                      TextButton.icon(
                        onPressed: () => Clipboard.setData(ClipboardData(text: '$link')),
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(tr(context, 'Copy link', 'लिंक कॉपी करें')),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: RvmSpacing.md),
          Text(tr(context, 'My proofs', 'मेरे प्रमाण'), style: Theme.of(context).textTheme.titleMedium),
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
  }
}

/* ── Learning: classes, videos, scores, packs (#9) ──────────────────────── */

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});
  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late Future<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)> _future = _load();

  Future<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)> _load() async {
    final api = getIt<StudentApi>();
    final values = await Future.wait([
      api.getJson('/v1/me/online-classes'),
      api.getJson('/v1/me/videos'),
      api.getJson('/v1/me/test-scores'),
      api.getJson('/v1/interview-packs'),
    ]);
    return (values[0], values[1], values[2], values[3]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Learning', 'लर्निंग'))),
      body: FutureBuilder<(Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)>(
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
          final (classes, videos, scores, packs) = snapshot.data!;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${video['title'] ?? ''}'),
                      Text('${tr(context, 'Views left', 'बचे व्यू')}: ${video['views_left'] ?? 0}',
                          style: Theme.of(context).textTheme.bodySmall),
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
