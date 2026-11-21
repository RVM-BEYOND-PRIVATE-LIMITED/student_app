import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// student_app #85: the protected player has no way to take the video out of
/// the app, and it plays RVM's own stream.
void main() {
  test('the player has no download, share, cast or picture-in-picture control', () {
    final source = File(
      'lib/features/modules/video_player_screen.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'Icons.download',
      'Icons.file_download',
      'Icons.share',
      'Icons.cast',
      'Icons.picture_in_picture',
      'SharePlus',
      'share_plus',
      'launchUrl',
    ]) {
      expect(source, isNot(contains(forbidden)), reason: forbidden);
    }

    expect(source, contains('stream_url'));
    expect(source, contains('watermark_text'));
    expect(source, contains('VideoPlayer('));
  });
}
