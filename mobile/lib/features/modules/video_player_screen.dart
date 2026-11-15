import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

import '../../core/api/student_api.dart';
import '../../core/security/secure_screen.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';

/// A protected recording (#9 items 5–8). The server creates the play session
/// and a view is counted only on its side; this screen starts the session,
/// passes the one-time values to the VdoCipher player and reports the
/// position at the interval the server sets.
class VideoPlaybackScreen extends StatefulWidget {
  const VideoPlaybackScreen({super.key, required this.video});

  final Map<String, dynamic> video;

  @override
  State<VideoPlaybackScreen> createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  Map<String, dynamic>? _session;
  VdoPlayerController? _controller;
  Timer? _beat;
  DateTime? _lastBeat;
  int _furthest = 0;
  bool _starting = true;
  bool _stopped = false;
  String? _message;

  String get _videoId => '${widget.video['id'] ?? ''}';

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  @override
  void dispose() {
    _beat?.cancel();
    final sessionId = '${_session?['session_id'] ?? ''}';
    if (sessionId.isNotEmpty) {
      unawaited(
        getIt<StudentApi>()
            .postJson('/v1/playback/sessions/$sessionId/end', {})
            .catchError((_) => <String, dynamic>{}),
      );
    }
    try {
      _controller?.pause();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _start() async {
    if (_videoId.isEmpty) {
      setState(() {
        _starting = false;
        _message = tr(context, 'This video is not available.', 'यह वीडियो उपलब्ध नहीं है।');
      });
      return;
    }
    try {
      final session = await getIt<StudentApi>().postJson(
        '/v1/playback/sessions',
        {'video_id': _videoId},
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _starting = false;
        _lastBeat = DateTime.now();
      });
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      setState(() {
        _starting = false;
        _message = failureLine(failure, context.l10n);
      });
    }
  }

  void _onPlayerCreated(VdoPlayerController controller) {
    _controller = controller;
    final seconds = (_session?['heartbeat_seconds'] as num?)?.toInt() ?? 15;
    _beat?.cancel();
    _beat = Timer.periodic(Duration(seconds: seconds), (_) => unawaited(_sendBeat()));
  }

  Future<void> _sendBeat() async {
    final sessionId = '${_session?['session_id'] ?? ''}';
    if (sessionId.isEmpty || _stopped) return;
    int position;
    try {
      position = (await _controller?.getPosition())?.inSeconds ?? _furthest;
    } catch (_) {
      position = _furthest;
    }
    if (position > _furthest) _furthest = position;
    final now = DateTime.now();
    final elapsed = _lastBeat == null ? 0 : now.difference(_lastBeat!).inSeconds;
    _lastBeat = now;
    try {
      final reply = await getIt<StudentApi>().postJson(
        '/v1/playback/sessions/$sessionId/heartbeat',
        {'position_s': _furthest, 'elapsed_s': elapsed < 0 ? 0 : elapsed},
      );
      if (reply['stop'] == true) {
        _stopped = true;
        _beat?.cancel();
        try {
          await _controller?.pause();
        } catch (_) {}
        if (!mounted) return;
        setState(() {
          _message = switch ('${reply['reason'] ?? ''}') {
            'revoked' => tr(context, 'This video was stopped by your centre.',
                'यह वीडियो आपके सेंटर ने रोक दिया।'),
            'replaced' => tr(context, 'This video was opened on another phone.',
                'यह वीडियो दूसरे फ़ोन पर खुल गया।'),
            _ => tr(context, 'This video was closed. Open it again to continue.',
                'यह वीडियो बंद हो गया। जारी रखने के लिए फिर खोलें।'),
          };
        });
      }
    } catch (_) {
      // A dropped beat must not close the player; the next one tries again.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecureScreen(
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.video['title'] ?? ''}')),
        body: _starting
            ? const Center(child: CircularProgressIndicator())
            : _message != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(RvmSpacing.lg),
                  child: Text(_message!, textAlign: TextAlign.center),
                ),
              )
            : Column(
                children: [
                  if (_session?['resumed'] == true)
                    Container(
                      width: double.infinity,
                      color: context.palette.surface2,
                      padding: const EdgeInsets.all(RvmSpacing.sm),
                      child: Text(
                        tr(context, 'Continuing the same view.', 'वही व्यू जारी है।'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  VdoPlayer(
                    embedInfo: EmbedInfo.streaming(
                      otp: '${_session?['otp'] ?? ''}',
                      playbackInfo: '${_session?['playback_info'] ?? ''}',
                      embedInfoOptions: const EmbedInfoOptions(
                        autoplay: true,
                        allowAdbDebugging: false,
                      ),
                    ),
                    onPlayerCreated: _onPlayerCreated,
                    onFullscreenChange: (_) {},
                    onError: (error) {
                      if (!mounted) return;
                      setState(() {
                        _message = tr(context, 'The video could not play. Try again.',
                            'वीडियो नहीं चल सका। फिर कोशिश करें।');
                      });
                    },
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Text(
                    '${tr(context, 'Views left', 'बचे व्यू')}: ${_session?['views_left'] ?? 0}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: RvmSpacing.sm),
                  Text(
                    tr(context, 'A view is used once 5% has played. Do not leave the app.',
                        '5% चलने पर एक व्यू लग जाता है। ऐप न छोड़ें।'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }
}

/// The confirm sheet before a counted play (#9 item 4), and the "one more
/// view" request when the server refuses (#9 item 9).
Future<bool> confirmCountedPlay(BuildContext context, Map<String, dynamic> video) async {
  final views = (video['views_left'] as num?)?.toInt() ?? 0;
  final locked = video['locked_reason'];
  if (views <= 0 || locked != null) {
    final reason = switch (locked) {
      'FEE_PENDING' => tr(context, 'Clear your fees to watch this.', 'इसे देखने के लिए फीस चुकाएँ।'),
      'NOT_YOUR_COURSE' => tr(context, 'This video is for another course.',
          'यह वीडियो दूसरे कोर्स का है।'),
      'ACCESS_ENDED' => tr(context, 'Your access to this video has ended.',
          'इस वीडियो तक पहुँच खत्म हो गई।'),
      'NO_VIEWS_LEFT' => tr(context, 'No views are left for this video.',
          'इस वीडियो के व्यू खत्म हो गए।'),
      _ => tr(context, 'This video is locked.', 'यह वीडियो लॉक है।'),
    };
    final ask = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'Video locked', 'वीडियो लॉक')),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'Close', 'बंद')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'Ask for one more view', 'एक और व्यू माँगें')),
          ),
        ],
      ),
    );
    if (ask == true) {
      try {
        await getIt<StudentApi>().postJson(
          '/v1/videos/${video['id']}/extra-view-requests',
          {'reason': 'I need one more view.'},
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr(context, 'Asked your centre.', 'सेंटर से कह दिया।'))),
          );
        }
      } catch (error) {
        if (!context.mounted) return false;
        final failure = error is Failure ? error : const UnknownFailure();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureLine(failure, context.l10n))),
        );
      }
    }
    return false;
  }
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(tr(context, 'Play this video?', 'यह वीडियो चलाएँ?')),
          content: Text(
            '${tr(context, 'This play uses one view.', 'इस बार एक व्यू लगेगा।')} '
            '${tr(context, 'Views left', 'बचे व्यू')}: $views',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tr(context, 'Cancel', 'रद्द')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'Play', 'चलाएँ')),
            ),
          ],
        ),
      ) ??
      false;
}
