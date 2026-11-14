import 'package:flutter/widgets.dart';

import 'secure_window.dart';

/// Marks [child] as a screen that must not be captured (student_app #8,
/// item 1): screenshots, screen recordings and the app-switcher preview come
/// out black while it is on screen. The child is drawn unchanged.
///
/// It holds the window's guard ([SecureWindow]) only while its screen can be
/// seen:
///  * from its first frame, and through its own push and pop transitions;
///  * under a dialog or a bottom sheet, which leave the screen visible;
///  * not once an opaque route covers it, and again when that route is
///    popped (the Navigator turns [TickerMode] off for a route nobody can
///    see);
///  * not while its go_router shell tab is not the selected one (go_router
///    turns [TickerMode] off for those branches too);
///  * not while [visible] is false, which is how a tab in a container that
///    keeps every tab built (a `TabBarView`, a plain `IndexedStack`) says it
///    is not the selected one;
///  * not after it leaves the tree.
///
/// Guards are counted, so a marked screen pushed over a marked tab, or two
/// marked screens crossing in a transition, never drop the guard in between,
/// and a screen that is not marked never turns it on.
class SecureScreen extends StatefulWidget {
  const SecureScreen({
    super.key,
    required this.child,
    this.visible = true,
    this.window,
  });

  final Widget child;

  /// False while this screen is built but not shown.
  final bool visible;

  /// The window to guard; [SecureWindow.instance] unless a test passes one.
  final SecureWindow? window;

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  /// The window this screen holds the guard on, or null while it holds none.
  SecureWindow? _held;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant SecureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _hold(null);
    super.dispose();
  }

  /// Reading [TickerMode] also rebuilds this screen when it changes.
  void _sync() => _hold(
    widget.visible && TickerMode.of(context)
        ? (widget.window ?? SecureWindow.instance)
        : null,
  );

  void _hold(SecureWindow? window) {
    if (identical(window, _held)) return;
    _held?.release();
    _held = window;
    window?.acquire();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
