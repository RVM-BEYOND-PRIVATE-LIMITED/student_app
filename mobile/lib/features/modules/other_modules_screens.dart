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
import '../../widgets/date_field.dart';
import '../../widgets/states.dart';
import 'api_list_screen.dart';
import '../join/join_screen.dart';
import 'learning_quizzes.dart';
import 'video_player_screen.dart';

/* ── Complaints (#5) ────────────────────────────────────────────────────── */

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});
  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  late Future<Map<String, dynamic>> _future = getIt<StudentApi>().getJson(
    '/v1/me/complaints',
  );

  void _reload() => setState(
    () => _future = getIt<StudentApi>().getJson('/v1/me/complaints'),
  );

  Future<void> _raise() async {
    final List<Map<String, dynamic>> categories;
    try {
      final reply = await getIt<StudentApi>().getJson(
        '/v1/complaint-categories',
      );
      categories = (reply['categories'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .where((row) => '${row['slug'] ?? ''}'.trim().isNotEmpty)
          .toList();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
      return;
    }
    if (!mounted) return;
    if (categories.isEmpty) {
      showFailureSnackBar(context, const UnknownFailure());
      return;
    }
    final description = TextEditingController();
    var category = '${categories.first['slug'] ?? ''}';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(tr(context, 'Raise a complaint', 'शिकायत दर्ज करें')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: InputDecoration(
                  labelText: tr(context, 'Category', 'श्रेणी'),
                ),
                items: [
                  for (final row in categories)
                    if ('${row['slug'] ?? ''}'.isNotEmpty)
                      DropdownMenuItem(
                        value: '${row['slug']}',
                        child: Text('${row['name'] ?? row['slug']}'),
                      ),
                ],
                onChanged: (value) =>
                    setDialog(() => category = value ?? category),
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
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(context, 'Cancel', 'रद्द')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'Send', 'भेजें')),
            ),
          ],
        ),
      ),
    );
    if (ok != true || category.isEmpty) return;
    try {
      await getIt<StudentApi>().postJson('/v1/me/complaints', {
        'category': category,
        'description': description.text.trim(),
      });
      _reload();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
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
          final rows =
              (snapshot.data?['complaints'] as List<dynamic>? ?? const [])
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
                        Text(
                          '${row['ref'] ?? ''} · ${row['category_name'] ?? ''}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${row['description'] ?? ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${row['status'] ?? ''}',
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
  late Future<Map<String, dynamic>> _future = getIt<StudentApi>().getJson(
    '/v1/me/complaints/${widget.id}',
  );
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
      setState(
        () => _future = getIt<StudentApi>().getJson(
          '/v1/me/complaints/${widget.id}',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<void> _reopen() async {
    try {
      await getIt<StudentApi>().postJson(
        '/v1/me/complaints/${widget.id}/reopen',
        {},
      );
      setState(
        () => _future = getIt<StudentApi>().getJson(
          '/v1/me/complaints/${widget.id}',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
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
              Text(
                '${complaint['ref'] ?? ''}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('${complaint['description'] ?? ''}'),
              const SizedBox(height: 8),
              Text('${complaint['status'] ?? ''}'),
              const SizedBox(height: 12),
              for (final message in messages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ModuleCard(
                    child: Text(
                      '${message['body'] ?? message['message'] ?? ''}',
                    ),
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
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
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
      actions: [
        IconButton(
          tooltip: tr(context, 'Moderation', 'मॉडरेशन'),
          icon: const Icon(Icons.shield_outlined),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const _ModerationScreen())),
        ),
      ],
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
  List<Map<String, dynamic>> _posts = [];
  String? _next;
  bool _loading = true;
  bool _loadingMore = false;
  Failure? _failure;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool older = false}) async {
    if (older) {
      if (_loadingMore || _next == null) return;
      setState(() => _loadingMore = true);
    } else {
      setState(() {
        _loading = true;
        _failure = null;
      });
    }
    var path = '/v1/community/groups/${widget.groupId}/posts';
    if (older && _next != null) {
      path += '?before=${Uri.encodeQueryComponent(_next!)}';
    }
    try {
      final json = await getIt<StudentApi>().getJson(path);
      final rows = (json['posts'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
      if (!mounted) return;
      setState(() {
        if (older) {
          _posts = [..._posts, ...rows];
        } else {
          _posts = rows;
        }
        _next = json['next']?.toString();
        _loading = false;
        _loadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        if (!older) {
          _failure = error is Failure ? error : const UnknownFailure();
        }
        _loading = false;
        _loadingMore = false;
      });
      if (older) showFailureSnackBar(context, error);
    }
  }

  Future<void> _post() async {
    final body = TextEditingController();
    final options = [TextEditingController(), TextEditingController()];
    var withPoll = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(tr(context, 'New post', 'नई पोस्ट')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: body,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: tr(context, 'Post', 'पोस्ट'),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(tr(context, 'Add a poll', 'पोल जोड़ें')),
                  value: withPoll,
                  onChanged: (value) => setDialog(() => withPoll = value),
                ),
                if (withPoll)
                  for (var i = 0; i < options.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TextField(
                        controller: options[i],
                        decoration: InputDecoration(
                          labelText:
                              '${tr(context, 'Option', 'विकल्प')} ${i + 1}',
                        ),
                      ),
                    ),
                if (withPoll && options.length < 6)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () =>
                          setDialog(() => options.add(TextEditingController())),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(tr(context, 'Add option', 'विकल्प जोड़ें')),
                    ),
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
              child: Text(tr(context, 'Post', 'पोस्ट')),
            ),
          ],
        ),
      ),
    );
    if (ok != true || body.text.trim().isEmpty) return;
    final poll = options
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    if (withPoll && poll.length < 2) {
      if (!mounted) return;
      showFailureSnackBar(context, const UnknownFailure());
      return;
    }
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/groups/${widget.groupId}/posts',
        {'body': body.text.trim(), if (withPoll) 'poll_options': poll},
      );
      await _load();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<void> _react(Map<String, dynamic> post) async {
    try {
      final id = '${post['id']}';
      if (post['reacted'] == true) {
        await getIt<StudentApi>().deletePath(
          '/v1/community/posts/$id/reaction',
        );
      } else {
        await getIt<StudentApi>().putJson('/v1/community/posts/$id/reaction');
      }
      await _load();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<void> _vote(Map<String, dynamic> post, String optionId) async {
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/posts/${post['id']}/vote',
        {'option_id': optionId},
      );
      await _load();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'Cancel', 'रद्द')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'Report', 'रिपोर्ट')),
          ),
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
      await _load();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
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
      body: _loading
          ? const SkeletonList(count: 3)
          : _failure != null && _posts.isEmpty
          ? StudentErrorState(failure: _failure!, onRetry: () => _load())
          : _posts.isEmpty
          ? StudentEmptyState(
              icon: Icons.forum_outlined,
              title: tr(context, 'No posts yet.', 'अभी कोई पोस्ट नहीं।'),
            )
          : RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView(
                padding: const EdgeInsets.all(RvmSpacing.lg),
                children: [
                  for (final post in _posts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: RvmSpacing.sm),
                      child: ModuleCard(
                        onTap: () => _open(post),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${post['author'] ?? ''}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text('${post['body'] ?? ''}'),
                            if (asMap(post['poll']).isNotEmpty) ...[
                              const SizedBox(height: RvmSpacing.sm),
                              _Poll(post: post, onVote: _vote),
                            ],
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${post['comment_count'] ?? 0} · ${post['reaction_count'] ?? 0}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
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
                                  onPressed: post['mine'] == true
                                      ? null
                                      : () => _report(post),
                                  icon: const Icon(
                                    Icons.flag_outlined,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_next != null)
                    Center(
                      child: TextButton(
                        onPressed: _loadingMore
                            ? null
                            : () => _load(older: true),
                        child: _loadingMore
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                tr(
                                  context,
                                  'Load older posts',
                                  'पुरानी पोस्ट लोड करें',
                                ),
                              ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _Poll extends StatelessWidget {
  const _Poll({required this.post, required this.onVote});

  final Map<String, dynamic> post;
  final Future<void> Function(Map<String, dynamic>, String) onVote;

  @override
  Widget build(BuildContext context) {
    final poll = asMap(post['poll']);
    final myVote = '${poll['my_vote'] ?? ''}';
    final options = (poll['options'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in options)
          InkWell(
            borderRadius: BorderRadius.circular(RvmRadii.sm),
            onTap: myVote.isEmpty
                ? () => onVote(post, '${option['id'] ?? ''}')
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                children: [
                  Icon(
                    myVote == '${option['id']}'
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: myVote == '${option['id']}'
                        ? Theme.of(context).colorScheme.primary
                        : context.palette.fg2,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${option['label'] ?? ''}')),
                  Text(
                    '${option['vote_count'] ?? 0}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        Text(
          '${tr(context, 'Votes', 'वोट')}: ${poll['vote_count'] ?? 0}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
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
  late Future<Map<String, dynamic>> _future = getIt<StudentApi>().getJson(
    '/v1/community/posts/${widget.postId}/comments',
  );
  final _body = TextEditingController();

  Future<void> _send() async {
    if (_body.text.trim().isEmpty) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/posts/${widget.postId}/comments',
        {'body': _body.text.trim()},
      );
      _body.clear();
      setState(
        () => _future = getIt<StudentApi>().getJson(
          '/v1/community/posts/${widget.postId}/comments',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<void> _report(Map<String, dynamic> comment) async {
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Report comment', 'टिप्पणी रिपोर्ट करें')),
        content: TextField(
          controller: reason,
          decoration: InputDecoration(hintText: tr(context, 'Why?', 'क्यों?')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'Cancel', 'रद्द')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'Report', 'रिपोर्ट')),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await getIt<StudentApi>().postJson(
        '/v1/community/comments/${comment['id']}/report',
        {'reason': reason.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'Reported.', 'रिपोर्ट कर दिया।'))),
      );
      setState(
        () => _future = getIt<StudentApi>().getJson(
          '/v1/community/posts/${widget.postId}/comments',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          final comments =
              (snapshot.data?['comments'] as List<dynamic>? ?? const [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
          return ListView(
            shrinkWrap: true,
            children: [
              for (final comment in comments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ModuleCard(
                    child: Row(
                      children: [
                        Expanded(child: Text('${comment['body'] ?? ''}')),
                        IconButton(
                          tooltip: tr(context, 'Report', 'रिपोर्ट'),
                          onPressed: comment['mine'] == true
                              ? null
                              : () => _report(comment),
                          icon: const Icon(Icons.flag_outlined, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _body,
                      decoration: InputDecoration(
                        hintText: tr(
                          context,
                          'Write a comment',
                          'टिप्पणी लिखें',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModerationScreen extends StatefulWidget {
  const _ModerationScreen();
  @override
  State<_ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends State<_ModerationScreen> {
  late Future<(Map<String, dynamic>, Map<String, dynamic>)> _future = _load();

  Future<(Map<String, dynamic>, Map<String, dynamic>)> _load() async {
    final api = getIt<StudentApi>();
    final posts = await api.getJson('/v1/community/mod/reports');
    Map<String, dynamic> comments = const {'reports': []};
    try {
      comments = await api.getJson('/v1/community/mod/comment-reports');
    } catch (_) {
      // Comment reports are a setting and can be off; the post queue still works.
      comments = const {'reports': []};
    }
    return (posts, comments);
  }

  void _reload() => setState(() => _future = _load());

  Future<String?> _reason(String title) async {
    final text = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: text, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'Cancel', 'रद्द')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'Send', 'भेजें')),
          ),
        ],
      ),
    );
    final value = text.text.trim();
    return ok == true && value.length >= 3 ? value : null;
  }

  Future<bool> _confirm(String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'Cancel', 'रद्द')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'Yes', 'हाँ')),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _act(String path, Map<String, dynamic> body) async {
    try {
      await getIt<StudentApi>().postJson(path, body);
      if (!mounted) return;
      _reload();
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<void> _hidePost(Map<String, dynamic> row) async {
    final reason = await _reason(tr(context, 'Hide post', 'पोस्ट छिपाएँ'));
    if (reason == null) return;
    await _act('/v1/community/mod/posts/${row['post_id']}/hide', {
      'reason': reason,
    });
  }

  Future<void> _restorePost(Map<String, dynamic> row) async {
    if (!await _confirm(
      tr(context, 'Restore this post?', 'यह पोस्ट बहाल करें?'),
    )) {
      return;
    }
    await _act('/v1/community/mod/posts/${row['post_id']}/restore', {});
  }

  Future<void> _warn(Map<String, dynamic> row) async {
    final reason = await _reason(
      tr(context, 'Warn member', 'सदस्य को चेतावनी'),
    );
    if (reason == null) return;
    await _act('/v1/community/mod/members/${row['author_account_id']}/warn', {
      'reason': reason,
      'post_id': row['post_id'],
    });
  }

  Future<void> _hideComment(Map<String, dynamic> row) async {
    final reason = await _reason(tr(context, 'Hide comment', 'टिप्पणी छिपाएँ'));
    if (reason == null) return;
    await _act('/v1/community/mod/comments/${row['comment_id']}/hide', {
      'reason': reason,
    });
  }

  Future<void> _restoreComment(Map<String, dynamic> row) async {
    final note = await _reason(
      tr(context, 'Restore comment', 'टिप्पणी बहाल करें'),
    );
    await _act('/v1/community/mod/comments/${row['comment_id']}/restore', {
      if (note != null) 'note': note,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Moderation', 'मॉडरेशन'))),
      body: FutureBuilder<(Map<String, dynamic>, Map<String, dynamic>)>(
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
          final (posts, comments) = snapshot.data!;
          final postRows = (posts['reports'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          final commentRows =
              (comments['reports'] as List<dynamic>? ?? const [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
          if (postRows.isEmpty && commentRows.isEmpty) {
            return StudentEmptyState(
              icon: Icons.shield_outlined,
              title: tr(
                context,
                'Nothing to review.',
                'समीक्षा के लिए कुछ नहीं।',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              if (postRows.isNotEmpty)
                Text(
                  tr(context, 'Reported posts', 'रिपोर्ट की गई पोस्ट'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              for (final row in postRows)
                Padding(
                  padding: const EdgeInsets.only(top: RvmSpacing.sm),
                  child: ModuleCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${row['group_name'] ?? ''} · ${row['author'] ?? ''}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('${row['body'] ?? ''}'),
                        Text(
                          '${row['report_count'] ?? 0} · ${(row['reasons'] as List<dynamic>? ?? const []).join(', ')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _hidePost(row),
                              child: Text(tr(context, 'Hide', 'छिपाएँ')),
                            ),
                            TextButton(
                              onPressed: () => _restorePost(row),
                              child: Text(tr(context, 'Restore', 'बहाल')),
                            ),
                            TextButton(
                              onPressed: row['author_account_id'] == null
                                  ? null
                                  : () => _warn(row),
                              child: Text(tr(context, 'Warn', 'चेतावनी')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (commentRows.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: RvmSpacing.lg),
                  child: Text(
                    tr(
                      context,
                      'Reported comments',
                      'रिपोर्ट की गई टिप्पणियाँ',
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              for (final row in commentRows)
                Padding(
                  padding: const EdgeInsets.only(top: RvmSpacing.sm),
                  child: ModuleCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${row['group_name'] ?? ''} · ${row['author'] ?? ''}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('${row['body'] ?? ''}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _hideComment(row),
                              child: Text(tr(context, 'Hide', 'छिपाएँ')),
                            ),
                            TextButton(
                              onPressed: () => _restoreComment(row),
                              child: Text(tr(context, 'Restore', 'बहाल')),
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

/* ── Visitor: lectures, quizzes, visits (#6) ────────────────────────────── */

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});
  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  late Future<
    (
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
    )
  >
  _future = _load();

  Future<
    (
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
      Map<String, dynamic>,
    )
  >
  _load() async {
    final api = getIt<StudentApi>();
    final values = await Future.wait([
      api.getJson('/v1/visitor/lectures'),
      api.getJson('/v1/visitor/quizzes'),
      api.getJson('/v1/visitor/visits'),
      api.getJson('/v1/public/courses'),
      api.getJson('/v1/public/branches'),
    ]);
    return (values[0], values[1], values[2], values[3], values[4]);
  }

  Future<void> _joinCourse(String courseId) async {
    try {
      await getIt<StudentApi>().postJson('/v1/visitor/events', {
        'kind': 'want_to_join',
        'course_id': courseId,
      });
    } catch (_) {
      // The join screen still opens; the CRM event is best effort.
    }
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const JoinScreen()));
  }

  Future<void> _book(List<Map<String, dynamic>> branches) async {
    if (branches.isEmpty) return;
    final at = TextEditingController();
    var kind = 'demo_class';
    var locationId = (branches.first['id'] as num?)?.toInt();
    DateTime? preferred;
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
                decoration: InputDecoration(
                  labelText: tr(context, 'Kind', 'प्रकार'),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'demo_class',
                    child: Text(tr(context, 'Demo class', 'डेमो क्लास')),
                  ),
                  DropdownMenuItem(
                    value: 'centre_visit',
                    child: Text(tr(context, 'Centre visit', 'सेंटर विज़िट')),
                  ),
                  DropdownMenuItem(
                    value: 'counsellor_call',
                    child: Text(tr(context, 'Counsellor call', 'काउंसलर कॉल')),
                  ),
                ],
                onChanged: (value) =>
                    setDialog(() => kind = value ?? 'demo_class'),
              ),
              DropdownButtonFormField<int>(
                initialValue: locationId,
                decoration: InputDecoration(
                  labelText: tr(context, 'Centre', 'सेंटर'),
                ),
                items: [
                  for (final branch in branches)
                    DropdownMenuItem(
                      value: (branch['id'] as num?)?.toInt(),
                      child: Text('${branch['name'] ?? ''}'),
                    ),
                ],
                onChanged: (value) => setDialog(() => locationId = value),
              ),
              TextField(
                controller: at,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: tr(context, 'When', 'कब'),
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
                onTap: () async {
                  final day = await PickedDate.pickDate(
                    context,
                    first: DateTime.now(),
                    last: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (day == null || !context.mounted) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 0),
                    helpText: tr(context, 'Pick a time', 'समय चुनें'),
                  );
                  if (time == null) return;
                  final picked = DateTime(
                    day.year,
                    day.month,
                    day.day,
                    time.hour,
                    time.minute,
                  );
                  setDialog(() {
                    preferred = picked;
                    at.text =
                        '${PickedDate.show(context, picked)}, '
                        '${PickedDate.showTime(context, time)}';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(context, 'Cancel', 'रद्द')),
            ),
            FilledButton(
              onPressed: preferred == null || locationId == null
                  ? null
                  : () => Navigator.pop(context, true),
              child: Text(tr(context, 'Book', 'बुक')),
            ),
          ],
        ),
      ),
    );
    if (ok != true || preferred == null || locationId == null) return;
    try {
      await getIt<StudentApi>().postJson('/v1/visitor/visits', {
        'kind': kind,
        'location_id': locationId,
        'preferred_at': PickedDate.isoDateTimeIst(preferred!),
      });
      if (!mounted) return;
      setState(() => _future = _load());
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(context, 'Visits and free lectures', 'विज़िट और मुफ़्त लेक्चर'),
        ),
      ),
      body:
          FutureBuilder<
            (
              Map<String, dynamic>,
              Map<String, dynamic>,
              Map<String, dynamic>,
              Map<String, dynamic>,
              Map<String, dynamic>,
            )
          >(
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
              final (lectures, quizzes, visits, courses, branchesJson) =
                  snapshot.data!;
              final branches =
                  (branchesJson['branches'] as List<dynamic>? ?? const [])
                      .whereType<Map<String, dynamic>>()
                      .toList();
              final courseRows =
                  (courses['courses'] as List<dynamic>? ?? const [])
                      .whereType<Map<String, dynamic>>()
                      .toList();
              return Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: branches.isEmpty ? null : () => _book(branches),
                  icon: const Icon(Icons.event_available_rounded),
                  label: Text(tr(context, 'Book', 'बुक')),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(RvmSpacing.lg),
                  children: [
                    _heading(
                      context,
                      tr(context, 'Free lectures', 'मुफ़्त लेक्चर'),
                    ),
                    for (final lecture
                        in (lectures['lectures'] as List<dynamic>? ?? const [])
                            .whereType<Map<String, dynamic>>())
                      ModuleCard(
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://www.youtube.com/watch?v=${lecture['video_youtube_id']}',
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_outline_rounded),
                            const SizedBox(width: 12),
                            Expanded(child: Text('${lecture['title'] ?? ''}')),
                          ],
                        ),
                      ),
                    _heading(context, tr(context, 'Quizzes', 'क्विज़')),
                    for (final quiz
                        in (quizzes['quizzes'] as List<dynamic>? ?? const [])
                            .whereType<Map<String, dynamic>>())
                      ModuleCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => _QuizScreen(
                              id: '${quiz['id']}',
                              title: '${quiz['title'] ?? ''}',
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.quiz_outlined),
                            const SizedBox(width: 12),
                            Expanded(child: Text('${quiz['title'] ?? ''}')),
                          ],
                        ),
                      ),
                    _heading(context, tr(context, 'Courses', 'कोर्स')),
                    for (final course in courseRows)
                      ModuleCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${course['name'] ?? ''}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                ),
                                Text(
                                  money(
                                    (course['price_paise'] as num?)?.toInt() ??
                                        0,
                                  ),
                                ),
                              ],
                            ),
                            if (course['summary'] != null)
                              Text(
                                '${course['summary']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if (course['duration'] != null)
                              Text(
                                '${course['duration']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            for (final batch
                                in (course['next_batches'] as List<dynamic>? ??
                                        const [])
                                    .whereType<Map<String, dynamic>>())
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${batch['branch'] ?? ''} · ${dateText(batch['start_date']?.toString())}'
                                  ' · ${_days(batch['days'])}'
                                  '${batch['start_time'] == null ? '' : ' ${batch['start_time']}–${batch['end_time']}'}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: '${course['id'] ?? ''}'.isEmpty
                                    ? null
                                    : () => _joinCourse('${course['id']}'),
                                child: Text(tr(context, 'Join', 'जुड़ें')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _heading(context, tr(context, 'My visits', 'मेरी विज़िट')),
                    for (final visit
                        in (visits['visits'] as List<dynamic>? ?? const [])
                            .whereType<Map<String, dynamic>>())
                      ModuleCard(
                        child: Text(
                          '${visit['kind'] ?? ''} · ${dateText(visit['preferred_at']?.toString())} · ${visit['status'] ?? ''}',
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  String _days(Object? raw) {
    final names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final days = (raw as List<dynamic>? ?? const [])
        .whereType<num>()
        .map((day) => day.toInt())
        .where((day) => day >= 0 && day <= 6)
        .map((day) => names[day])
        .join(', ');
    return days;
  }
}

class _QuizScreen extends StatefulWidget {
  const _QuizScreen({required this.id, required this.title});
  final String id;
  final String title;
  @override
  State<_QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<_QuizScreen> {
  late final Future<Map<String, dynamic>> _future = getIt<StudentApi>().getJson(
    '/v1/visitor/quizzes/${widget.id}',
  );
  final Map<String, String> _answers = {};
  String? _result;
  Map<String, dynamic>? _suggested;

  Future<void> _submit() async {
    try {
      final result = await getIt<StudentApi>().postJson(
        '/v1/visitor/quizzes/${widget.id}/attempts',
        {'answers': _answers},
      );
      final suggested = asMap(result['suggested_course']);
      setState(() {
        _result = '${result['score'] ?? 0}/${result['max_score'] ?? 0}';
        _suggested = suggested.isEmpty ? null : suggested;
      });
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final questions =
              (snapshot.data?['questions'] as List<dynamic>? ?? const [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              for (final question in questions) ...[
                Text(
                  '${question['prompt'] ?? ''}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                RadioGroup<String>(
                  groupValue: _answers['${question['id']}'],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _answers['${question['id']}'] = value);
                  },
                  child: Column(
                    children: [
                      for (final option
                          in (question['options'] as List<dynamic>? ?? const [])
                              .whereType<Map<String, dynamic>>())
                        RadioListTile<String>(
                          value: '${option['key']}',
                          title: Text('${option['label'] ?? ''}'),
                        ),
                    ],
                  ),
                ),
              ],
              if (_result != null)
                Text('${tr(context, 'Score', 'स्कोर')}: $_result'),
              if (_suggested != null) ...[
                ModuleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, 'A course for you', 'आपके लिए एक कोर्स'),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_suggested!['name'] ?? ''} · '
                        '${money((_suggested!['price_paise'] as num?)?.toInt() ?? 0)}',
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              await getIt<StudentApi>()
                                  .postJson('/v1/visitor/events', {
                                    'kind': 'want_to_join',
                                    'course_id': '${_suggested!['id'] ?? ''}',
                                  });
                            } catch (_) {}
                            if (!context.mounted) return;
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const JoinScreen(),
                              ),
                            );
                          },
                          child: Text(
                            tr(
                              context,
                              'Join this course',
                              'इस कोर्स में जुड़ें',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              FilledButton(
                onPressed: _submit,
                child: Text(tr(context, 'Submit', 'जमा करें')),
              ),
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
  late Future<Map<String, dynamic>> _proofs = getIt<StudentApi>().getJson(
    '/v1/me/placement-proofs',
  );
  late Future<Map<String, dynamic>> _referral = _loadReferral();
  late Future<Map<String, dynamic>> _payout = getIt<StudentApi>().getJson(
    '/v1/me/payout-account',
  );

  /// The module's own answer, read from the referral route, decides whether
  /// Add and Proof may be offered. With `student_rewards` off the server
  /// answers 503 `MODULE_OFF` to every rewards route; before this the screen
  /// silently drew Add and Proof and every tap failed with "Server problem".
  bool _gateDone = false;
  Failure? _gateFailure;

  bool get _moduleOff =>
      _gateFailure?.code == 'MODULE_OFF' || _gateFailure?.code == 'NOT_READY';

  Future<Map<String, dynamic>> _loadReferral() async {
    try {
      final value = await getIt<StudentApi>().getJson('/v1/me/referral');
      if (mounted) {
        setState(() {
          _gateDone = true;
          _gateFailure = null;
        });
      }
      return value;
    } on Failure catch (failure) {
      if (mounted) {
        setState(() {
          _gateDone = true;
          _gateFailure = failure;
        });
      }
      rethrow;
    }
  }

  void _reload() => setState(() {
    _gateDone = false;
    _gateFailure = null;
    _proofs = getIt<StudentApi>().getJson('/v1/me/placement-proofs');
    _referral = _loadReferral();
    _payout = getIt<StudentApi>().getJson('/v1/me/payout-account');
  });

  Future<void> _shareReferral(String code, String? link) async {
    final text = link == null
        ? 'Join RVM with my referral code $code.'
        : 'Join RVM with my referral code $code: $link';
    await SharePlus.instance.share(
      ShareParams(text: text, subject: 'RVM referral'),
    );
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
                    labelText: tr(
                      context,
                      'Account holder name',
                      'खाताधारक का नाम',
                    ),
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
                  tr(
                    context,
                    'Only the holder name and last 4 characters are kept.',
                    'केवल खाताधारक का नाम और अंतिम 4 अक्षर रखे जाते हैं।',
                  ),
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
    DateTime? joinedOn;
    FilePickerResult? file;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(
            tr(context, 'Send placement proof', 'प्लेसमेंट प्रमाण भेजें'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: company,
                decoration: InputDecoration(
                  labelText: tr(context, 'Company', 'कंपनी'),
                ),
              ),
              TextField(
                controller: role,
                decoration: InputDecoration(
                  labelText: tr(context, 'Role', 'पद'),
                ),
              ),
              TextField(
                controller: salary,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr(
                    context,
                    'Monthly salary (₹)',
                    'मासिक वेतन (₹)',
                  ),
                ),
              ),
              TextField(
                controller: date,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: tr(context, 'Joining date', 'जॉइनिंग तारीख'),
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
                onTap: () async {
                  final picked = await PickedDate.pickDate(
                    context,
                    last: DateTime.now(),
                  );
                  if (picked == null || !context.mounted) return;
                  setDialog(() {
                    joinedOn = picked;
                    date.text = PickedDate.show(context, picked);
                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  file = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                  );
                  if (file != null) setDialog(() {});
                },
                child: Text(
                  file == null
                      ? tr(context, 'Choose letter', 'पत्र चुनें')
                      : tr(context, 'Letter chosen', 'पत्र चुना गया'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(context, 'Cancel', 'रद्द')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'Send', 'भेजें')),
            ),
          ],
        ),
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
        joinedOn == null ||
        (picked?.size ?? 0) > 5 * 1024 * 1024) {
      _toast(
        tr(
          context,
          'Fill every field and choose a letter up to 5 MB.',
          'हर जानकारी भरें और 5 MB तक का पत्र चुनें।',
        ),
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
          'joining_date': PickedDate.isoDate(joinedOn!),
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
    final gateFailure = _gateFailure;
    return SecureScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr(context, 'Placement and referral', 'प्लेसमेंट और रेफ़रल'),
          ),
        ),
        floatingActionButton: _gateDone && gateFailure == null
            ? FloatingActionButton.extended(
                onPressed: _sendProof,
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(tr(context, 'Proof', 'प्रमाण')),
              )
            : null,
        body: gateFailure != null
            ? (_moduleOff
                  ? StudentEmptyState(
                      icon: Icons.lock_clock_rounded,
                      title: tr(
                        context,
                        'Placement and referral is not open yet',
                        'प्लेसमेंट और रेफ़रल अभी खुला नहीं है',
                      ),
                      message: tr(
                        context,
                        'Your centre opens this for pilot students. Check again later.',
                        'आपका सेंटर इसे पायलट छात्रों के लिए खोलता है। बाद में फिर देखें।',
                      ),
                      action: TextButton(
                        onPressed: _reload,
                        child: Text(tr(context, 'Check again', 'फिर देखें')),
                      ),
                    )
                  : StudentErrorState(failure: gateFailure, onRetry: _reload))
            : ListView(
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
                            Text(
                              tr(
                                context,
                                'Your referral code',
                                'आपका रेफ़रल कोड',
                              ),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$code',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
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
                                    onPressed: () => Clipboard.setData(
                                      ClipboardData(text: '$link'),
                                    ),
                                    icon: const Icon(Icons.copy_rounded),
                                    label: Text(
                                      tr(
                                        context,
                                        'Copy link',
                                        'लिंक कॉपी करें',
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () =>
                                        _shareReferral('$code', '$link'),
                                    icon: const Icon(Icons.share_rounded),
                                    label: Text(
                                      tr(context, 'Share', 'साझा करें'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Text(
                    tr(context, 'Payout account', 'भुगतान खाता'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                                          ? tr(
                                              context,
                                              'No account yet.',
                                              'अभी कोई खाता नहीं।',
                                            )
                                          : '${row['kind'] == 'upi' ? 'UPI' : tr(context, 'Bank', 'बैंक')} · '
                                                '${row['holder_name'] ?? ''} · ••••${row['last4'] ?? ''}',
                                    ),
                                    if (row != null)
                                      Text(
                                        '${row['status'] ?? ''}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _setPayout,
                                child: Text(
                                  row == null
                                      ? tr(context, 'Add', 'जोड़ें')
                                      : tr(context, 'Change', 'बदलें'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Text(
                    tr(context, 'My proofs', 'मेरे प्रमाण'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      tr(
                        context,
                        'The marketing-use consent is in Profile.',
                        'मार्केटिंग उपयोग की सहमति प्रोफ़ाइल में है।',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _proofs,
                    builder: (context, snapshot) {
                      final rows =
                          (snapshot.data?['proofs'] as List<dynamic>? ??
                                  const [])
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
                                    Text(
                                      '${row['company_name'] ?? ''} · ${row['role'] ?? ''}',
                                    ),
                                    Text(
                                      '${row['status'] ?? ''}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    if (row['reason'] != null)
                                      Text(
                                        '${row['reason']}',
                                        style: TextStyle(
                                          color: context.palette.danger,
                                        ),
                                      ),
                                    if (row['reward'] is Map)
                                      Text(
                                        '${tr(context, 'Reward', 'इनाम')}: '
                                        '${money((asMap(row['reward'])['amount_paise'] as num?)?.toInt() ?? 0)} · '
                                        '${asMap(row['reward'])['status'] ?? ''}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
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

class LearningPart {
  const LearningPart({this.data, this.failure});

  final Map<String, dynamic>? data;
  final Failure? failure;

  /// The server keeps this part switched off for this student.
  bool get isOff =>
      failure?.code == 'MODULE_OFF' || failure?.code == 'NOT_READY';
}

class LearningData {
  const LearningData({
    required this.classes,
    required this.videos,
    required this.scores,
    required this.packs,
    required this.dailyQuiz,
    required this.mockRoles,
  });

  final LearningPart classes;
  final LearningPart videos;
  final LearningPart scores;
  final LearningPart packs;
  final LearningPart dailyQuiz;
  final LearningPart mockRoles;

  List<LearningPart> get parts => [
    classes,
    videos,
    scores,
    packs,
    dailyQuiz,
    mockRoles,
  ];

  bool get anyAvailable => parts.any((p) => p.data != null);
  bool get allOff => parts.every((p) => p.isOff);

  Failure? get firstFailure {
    for (final part in parts) {
      final failure = part.failure;
      if (failure != null) return failure;
    }
    return null;
  }
}

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});
  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late Future<LearningData> _future = _load();

  /// Each part is loaded on its own: the four switches (`online_classes`,
  /// `student_videos`, `test_scores`, `interview_prep`) and the stage gate are
  /// independent, so one part being off must not hide the others. Before
  /// this, one 503 `MODULE_OFF` turned the whole Learning tab into
  /// "Server problem".
  Future<LearningData> _load() async {
    final api = getIt<StudentApi>();
    final values = await Future.wait([
      _part(api.getJson('/v1/me/online-classes')),
      _part(api.getJson('/v1/me/videos')),
      _part(api.getJson('/v1/me/test-scores')),
      _part(api.getJson('/v1/interview-packs')),
      _part(api.getJson('/v1/quizzes/daily')),
      _part(api.getJson('/v1/quizzes/mock/roles')),
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

  Future<void> _openPack(Map<String, dynamic> pack) async {
    final id = '${pack['id'] ?? ''}';
    if (id.isEmpty) return;
    try {
      final reply = await getIt<StudentApi>().getJson(
        '/v1/interview-packs/$id/file',
      );
      final url = Uri.tryParse('${reply['url'] ?? ''}');
      if (url == null) {
        if (!mounted) return;
        showFailureSnackBar(context, const UnknownFailure());
        return;
      }
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        showFailureSnackBar(context, const UnknownFailure());
      }
    } catch (error) {
      if (!mounted) return;
      showFailureSnackBar(context, error);
    }
  }

  Future<LearningPart> _part(Future<Map<String, dynamic>> call) async {
    try {
      return LearningPart(data: await call);
    } on Failure catch (failure) {
      return LearningPart(failure: failure);
    } catch (_) {
      return const LearningPart(failure: UnknownFailure());
    }
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
          if (!data.anyAvailable) {
            final failure = data.firstFailure;
            if (data.allOff || failure == null) {
              return StudentEmptyState(
                icon: Icons.lock_clock_rounded,
                title: tr(
                  context,
                  'Learning is not open yet',
                  'लर्निंग अभी खुली नहीं है',
                ),
                message: tr(
                  context,
                  'Your centre opens classes, videos and tests for pilot students. Check again later.',
                  'आपका सेंटर पायलट छात्रों के लिए क्लास, वीडियो और टेस्ट खोलता है। बाद में फिर देखें।',
                ),
                action: TextButton(
                  onPressed: () => setState(() => _future = _load()),
                  child: Text(tr(context, 'Check again', 'फिर देखें')),
                ),
              );
            }
            return StudentErrorState(
              failure: failure,
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final classes = data.classes.data;
          final videos = data.videos.data;
          final scores = data.scores.data;
          final packs = data.packs.data;
          final dailyQuiz = data.dailyQuiz.data;
          final mockRoles = data.mockRoles.data;
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              if (classes != null) ...[
                _heading(
                  context,
                  tr(context, 'Online classes', 'ऑनलाइन क्लास'),
                ),
                for (final item
                    in (classes['classes'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
                  ModuleCard(
                    onTap: item['can_join'] == true && item['link'] != null
                        ? () => launchUrl(Uri.parse('${item['link']}'))
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['batch_name'] ?? ''} · ${dateText(item['date']?.toString())}',
                        ),
                        Text(
                          '${item['start'] ?? ''}–${item['end'] ?? ''} · ${item['status'] ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
              ] else if (!data.classes.isOff)
                _notice(context, data.classes),
              if (videos != null) ...[
                _heading(context, tr(context, 'Videos', 'वीडियो')),
                for (final video
                    in (videos['videos'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
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
                        Text(
                          '${tr(context, 'Views left', 'बचे व्यू')}: ${video['views_left'] ?? 0}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (video['locked_reason'] != null)
                          Text(
                            '${video['locked_reason']}',
                            style: TextStyle(color: context.palette.warning),
                          ),
                      ],
                    ),
                  ),
              ] else if (!data.videos.isOff)
                _notice(context, data.videos),
              if (scores != null) ...[
                _heading(context, tr(context, 'Test scores', 'टेस्ट स्कोर')),
                ModuleCard(
                  child: Text(
                    '${tr(context, 'Overall', 'कुल')}: ${scores['overall_pct'] ?? 0}%',
                  ),
                ),
                for (final course
                    in (scores['courses'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
                  ModuleCard(
                    child: Text(
                      '${course['name'] ?? ''} · ${course['score_pct'] ?? 0}%'
                      ' · ${course['tests'] ?? 0} ${tr(context, 'tests', 'टेस्ट')}',
                    ),
                  ),
                for (final test
                    in (scores['tests'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
                  ModuleCard(
                    child: Text(
                      '${test['module_name'] ?? ''} · ${test['marks'] ?? 0}/${test['max_marks'] ?? 0}',
                    ),
                  ),
              ] else if (!data.scores.isOff)
                _notice(context, data.scores),
              if (packs != null) ...[
                _heading(
                  context,
                  tr(context, 'Interview packs', 'इंटरव्यू पैक'),
                ),
                for (final role
                    in (packs['roles'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
                  for (final pack
                      in (role['packs'] as List<dynamic>? ?? const [])
                          .whereType<Map<String, dynamic>>())
                    ModuleCard(
                      onTap: () => _openPack(pack),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${role['name'] ?? ''} · ${pack['title'] ?? ''}',
                            ),
                          ),
                          const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        ],
                      ),
                    ),
              ],
              if (dailyQuiz != null) ...[
                _heading(
                  context,
                  tr(context, 'Quiz of the day', 'आज की क्विज़'),
                ),
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
                        : tr(
                            context,
                            'Answer today\'s quiz',
                            'आज की क्विज़ के जवाब दें',
                          ),
                  ),
                ),
              ],
              if (mockRoles != null) ...[
                _heading(
                  context,
                  tr(context, 'Mock interview', 'मॉक इंटरव्यू'),
                ),
                for (final role
                    in (mockRoles['roles'] as List<dynamic>? ?? const [])
                        .whereType<Map<String, dynamic>>())
                  ModuleCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MockQuizScreen(role: role),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text('${role['name'] ?? ''}')),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
              ],
              if (packs == null &&
                  dailyQuiz == null &&
                  mockRoles == null &&
                  !data.packs.isOff)
                _notice(context, data.packs),
            ],
          );
        },
      ),
    );
  }

  Widget _notice(BuildContext context, LearningPart part) {
    final failure = part.failure;
    final text = failure?.code == 'NOT_ELIGIBLE'
        ? tr(
            context,
            'Interview prep opens once you are a registered student.',
            'इंटरव्यू तैयारी पंजीकृत छात्र बनने पर खुलती है।',
          )
        : failure?.code == 'NOT_LINKED'
        ? tr(
            context,
            'Link your account to your admission first.',
            'पहले अपना खाता अपने प्रवेश से जोड़ें।',
          )
        : failure == null
        ? ''
        : failureLine(failure, context.l10n);
    return ModuleCard(
      child: Row(
        children: [
          Expanded(child: Text(text)),
          TextButton(
            onPressed: () => setState(() => _future = _load()),
            child: Text(tr(context, 'Try again', 'फिर कोशिश करें')),
          ),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}
