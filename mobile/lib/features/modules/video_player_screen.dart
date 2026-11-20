import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

import '../../core/api/student_api.dart';
import '../../core/security/secure_screen.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';

/// A protected recording (#9 items 5–8, #85). The server creates the play
/// session and a view is counted only on its side. RVM's own stream plays in
/// an ordinary player with a moving watermark and no download, share, cast or
/// picture-in-picture control; the VdoCipher player stays as the fallback the
/// server can switch back to.
class VideoPlaybackScreen extends StatefulWidget {
  const VideoPlaybackScreen({super.key, required this.video});

  final Map<String, dynamic> video;

  @override
  State<VideoPlaybackScreen> createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  Map<String, dynamic>? _session;
  VdoPlayerController? _vdo;
  VideoPlayerController? _video;
  Timer? _beat;
  Timer? _watermark;
  DateTime? _lastBeat;
  int _furthest = 0;
  int _corner = 0;
  bool _starting = true;
  bool _stopped = false;
  String? _message;

  String get _videoId => '${widget.video['id'] ?? ''}';
  bool get _isSelf => '${_session?['provider'] ?? 'vdocipher'}' == 'self';

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  @override
  void dispose() {
    _beat?.cancel();
    _watermark?.cancel();
    _video?.removeListener(_onVideoChanged);
    unawaited(_video?.dispose());
    final sessionId = '${_session?['session_id'] ?? ''}';
    if (sessionId.isNotEmpty) {
      unawaited(
        getIt<StudentApi>()
            .postJson('/v1/playback/sessions/$sessionId/end', {})
            .catchError((_) => <String, dynamic>{}),
      );
    }
    try {
      _vdo?.pause();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _start() async {
    if (_videoId.isEmpty) {
      setState(() {
        _starting = false;
        _message = tr(
          context,
          'This video is not available.',
          'यह वीडियो उपलब्ध नहीं है।',
        );
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
      if ('${session['provider'] ?? 'vdocipher'}' == 'self') {
        await _startSelf(session);
      }
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      setState(() {
        _starting = false;
        _message = failureLine(failure, context.l10n);
      });
    }
  }

  /// RVM's own stream (#85): a signed URL from the server, read like any
  /// HTTP video. It carries no Authorization header and is never cached.
  Future<void> _startSelf(Map<String, dynamic> session) async {
    final raw = '${session['stream_url'] ?? ''}';
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) {
      setState(() {
        _message = tr(
          context,
          'The video could not play. Try again.',
          'वीडियो नहीं चल सका। फिर कोशिश करें।',
        );
      });
      return;
    }
    final controller = VideoPlayerController.networkUrl(
      uri,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );
    _video = controller;
    controller.addListener(_onVideoChanged);
    try {
      await controller.initialize();
      if (!mounted) return;
      await controller.play();
      if (!mounted) return;
      setState(() {});
      _startHeartbeat();
      _startWatermark();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message = tr(
          context,
          'The video could not play. Try again.',
          'वीडियो नहीं चल सका। फिर कोशिश करें।',
        );
      });
    }
  }

  void _onVideoChanged() {
    final value = _video?.value;
    if (value == null || !mounted) return;
    if (value.hasError && !_stopped) {
      _stopped = true;
      _beat?.cancel();
      _watermark?.cancel();
      setState(() {
        _message = value.errorDescription?.contains('410') == true
            ? tr(
                context,
                'This playback has ended. Open the video again.',
                'यह प्लेबैक खत्म हो गया। वीडियो फिर खोलें।',
              )
            : tr(
                context,
                'The video could not play. Try again.',
                'वीडियो नहीं चल सका। फिर कोशिश करें।',
              );
      });
    }
  }

  void _onVdoCreated(VdoPlayerController controller) {
    _vdo = controller;
    _startHeartbeat();
  }

  void _startHeartbeat() {
    final seconds = (_session?['heartbeat_seconds'] as num?)?.toInt() ?? 15;
    _beat?.cancel();
    _beat = Timer.periodic(
      Duration(seconds: seconds),
      (_) => unawaited(_sendBeat()),
    );
  }

  /// The watermark the server set: the student's name and the last four
  /// digits of the phone. It moves between the corners every four seconds.
  void _startWatermark() {
    if (('${_session?['watermark_text'] ?? ''}').trim().isEmpty) return;
    _watermark?.cancel();
    _watermark = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() => _corner = (_corner + 1) % 4);
    });
  }

  Alignment get _watermarkAlignment => switch (_corner) {
    0 => Alignment.topLeft,
    1 => Alignment.topRight,
    2 => Alignment.bottomRight,
    _ => Alignment.bottomLeft,
  };

  Future<int> _positionSeconds() async {
    final video = _video;
    if (video != null) return video.value.position.inSeconds;
    try {
      return (await _vdo?.getPosition())?.inSeconds ?? _furthest;
    } catch (_) {
      return _furthest;
    }
  }

  Future<void> _pauseAll() async {
    try {
      await _video?.pause();
    } catch (_) {}
    try {
      await _vdo?.pause();
    } catch (_) {}
  }

  Future<void> _sendBeat() async {
    final sessionId = '${_session?['session_id'] ?? ''}';
    if (sessionId.isEmpty || _stopped) return;
    final position = await _positionSeconds();
    if (position > _furthest) _furthest = position;
    final now = DateTime.now();
    final elapsed = _lastBeat == null
        ? 0
        : now.difference(_lastBeat!).inSeconds;
    _lastBeat = now;
    try {
      final reply = await getIt<StudentApi>().postJson(
        '/v1/playback/sessions/$sessionId/heartbeat',
        {'position_s': _furthest, 'elapsed_s': elapsed < 0 ? 0 : elapsed},
      );
      if (reply['stop'] == true) {
        _stopped = true;
        _beat?.cancel();
        _watermark?.cancel();
        await _pauseAll();
        if (!mounted) return;
        setState(() {
          _message = switch ('${reply['reason'] ?? ''}') {
            'revoked' => tr(
              context,
              'This video was stopped by your centre.',
              'यह वीडियो आपके सेंटर ने रोक दिया।',
            ),
            'replaced' => tr(
              context,
              'This video was opened on another phone.',
              'यह वीडियो दूसरे फ़ोन पर खुल गया।',
            ),
            _ => tr(
              context,
              'This video was closed. Open it again to continue.',
              'यह वीडियो बंद हो गया। जारी रखने के लिए फिर खोलें।',
            ),
          };
        });
      }
    } on Failure catch (failure) {
      // 410 SESSION_ENDED means the server has ended this playback: the
      // stream URL is now a 410 too, so stop and say so.
      if (failure.statusCode == 410 || failure.code == 'SESSION_ENDED') {
        _stopped = true;
        _beat?.cancel();
        _watermark?.cancel();
        await _pauseAll();
        if (!mounted) return;
        setState(() {
          _message = tr(
            context,
            'This playback has ended. Open the video again.',
            'यह प्लेबैक खत्म हो गया। वीडियो फिर खोलें।',
          );
        });
      }
    } catch (_) {
      // A dropped beat must not close the player; the next one tries again.
    }
  }

  Future<void> _toggle() async {
    if (_stopped) return;
    final video = _video;
    if (video != null) {
      if (video.value.isPlaying) {
        await video.pause();
      } else {
        await video.play();
      }
      if (mounted) setState(() {});
      return;
    }
    // The VdoCipher player owns its controls; a tap on our page does nothing.
  }

  @override
  Widget build(BuildContext context) {
    final watermark = '${_session?['watermark_text'] ?? ''}'.trim();
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
                        tr(
                          context,
                          'Continuing the same view.',
                          'वही व्यू जारी है।',
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  if (_isSelf)
                    _selfPlayer(watermark)
                  else
                    VdoPlayer(
                      embedInfo: EmbedInfo.streaming(
                        otp: '${_session?['otp'] ?? ''}',
                        playbackInfo: '${_session?['playback_info'] ?? ''}',
                        embedInfoOptions: const EmbedInfoOptions(
                          autoplay: true,
                          allowAdbDebugging: false,
                        ),
                      ),
                      onPlayerCreated: _onVdoCreated,
                      onFullscreenChange: (_) {},
                      onError: (error) {
                        if (!mounted) return;
                        setState(() {
                          _message = tr(
                            context,
                            'The video could not play. Try again.',
                            'वीडियो नहीं चल सका। फिर कोशिश करें।',
                          );
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
                    tr(
                      context,
                      'A view is used once 5% has played. Do not leave the app.',
                      '5% चलने पर एक व्यू लग जाता है। ऐप न छोड़ें।',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _selfPlayer(String watermark) {
    final controller = _video;
    if (controller == null || !controller.value.isInitialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final value = controller.value;
    return AspectRatio(
      aspectRatio: value.aspectRatio <= 0 ? 16 / 9 : value.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,
            child: VideoPlayer(controller),
          ),
          if (!value.isPlaying)
            IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  size: 64,
                  color: context.palette.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          if (watermark.isNotEmpty)
            IgnorePointer(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 700),
                alignment: _watermarkAlignment,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    watermark,
                    style: TextStyle(
                      color: context.palette.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: context.palette.navyDeep.withValues(
                            alpha: 0.54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The confirm sheet before a counted play (#9 item 4), and the "one more
/// view" request when the server refuses (#9 item 9).
Future<bool> confirmCountedPlay(
  BuildContext context,
  Map<String, dynamic> video,
) async {
  final views = (video['views_left'] as num?)?.toInt() ?? 0;
  final locked = video['locked_reason'];
  if (views <= 0 || locked != null) {
    final reason = switch (locked) {
      'FEE_PENDING' => tr(
        context,
        'Clear your fees to watch this.',
        'इसे देखने के लिए फीस चुकाएँ।',
      ),
      'NOT_YOUR_COURSE' => tr(
        context,
        'This video is for another course.',
        'यह वीडियो दूसरे कोर्स का है।',
      ),
      'ACCESS_ENDED' => tr(
        context,
        'Your access to this video has ended.',
        'इस वीडियो तक पहुँच खत्म हो गई।',
      ),
      'NO_VIEWS_LEFT' => tr(
        context,
        'No views are left for this video.',
        'इस वीडियो के व्यू खत्म हो गए।',
      ),
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
            child: Text(
              tr(context, 'Ask for one more view', 'एक और व्यू माँगें'),
            ),
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
            SnackBar(
              content: Text(
                tr(context, 'Asked your centre.', 'सेंटर से कह दिया।'),
              ),
            ),
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
