import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';

/// Clears Campus's cookies from the web view (student_app #2, item 10). The
/// page never gets the app's token; the Campus session lives only in the web
/// view's cookie store, and it goes on sign-out and when the gate closes.
Future<void> clearCampusCookies() =>
    WebViewCookieManager().clearCookies();

/// Campus inside the Jobs tab (student_app #2, item 9). The one-minute
/// hand-off link is loaded as the top-level page and is never stored, logged
/// or shown (its fragment is a token). Links to any other host, and `tel:`,
/// `mailto:`, WhatsApp, Meet and unknown schemes, open outside the app.
class CampusWebView extends StatefulWidget {
  const CampusWebView({super.key, required this.url});

  final Uri? url;

  @override
  State<CampusWebView> createState() => _CampusWebViewState();
}

class _CampusWebViewState extends State<CampusWebView> {
  late final WebViewController? _controller;
  bool _loading = true;
  bool _failed = false;
  String? _allowedHost;

  @override
  void initState() {
    super.initState();
    final url = widget.url;
    if (url == null) return;
    _allowedHost = url.host.toLowerCase();
    late final WebViewController controller;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(context.palette.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _onNavigation,
          onPageStarted: (_) {
            if (mounted) setState(() { _loading = true; _failed = false; });
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
            // window.open and target="_blank" would otherwise do nothing in
            // this web view. Send the link to the app, which keeps the same
            // site inside the web view and hands anything else to the phone.
            unawaited(controller.runJavaScript(_openLinkBridge));
          },
          onWebResourceError: (error) {
            // A sub-resource failing does not blank the page.
            if (error.isForMainFrame ?? false) {
              if (mounted) setState(() { _loading = false; _failed = true; });
            }
          },
        ),
      );
    _controller = controller;
    unawaited(
      controller.addJavaScriptChannel(
        _openLinkChannel,
        onMessageReceived: (message) => _openFromPage(message.message),
      ),
    );
    unawaited(_allowFileUpload(controller));
    // The load is fired after the first frame so the widget is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.loadRequest(url);
      }
    });
  }

  /// Campus's résumé upload opens the phone's file picker (student_app #2,
  /// item 9). Android's WebView asks the host app to show it; without this,
  /// a file input does nothing.
  Future<void> _allowFileUpload(WebViewController controller) async {
    final platform = controller.platform;
    if (platform is! AndroidWebViewController) return;
    await platform.setOnShowFileSelector((params) async {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: params.mode == FileSelectorMode.openMultiple,
        type: FileType.any,
      );
      return (result?.files ?? const [])
          .map((file) => file.path)
          .whereType<String>()
          .toList();
    });
  }

  static const _openLinkChannel = 'RvmOpenLink';

  /// Installed after every page load. It is idempotent per document, so a
  /// page that replaces `window.open` after us is caught again.
  static const _openLinkBridge = '''
(function () {
  if (window.__rvmOpenLinkInstalled) return;
  window.__rvmOpenLinkInstalled = true;
  window.open = function (url) {
    try { window.$_openLinkChannel.postMessage(String(url)); } catch (_) {}
    return null;
  };
  document.addEventListener('click', function (event) {
    var link = event.target && event.target.closest
      ? event.target.closest('a[target="_blank"]')
      : null;
    if (link && link.href) {
      event.preventDefault();
      try { window.$_openLinkChannel.postMessage(String(link.href)); } catch (_) {}
    }
  }, true);
})();
''';

  /// A link the page tried to open in a new window. The same site stays in
  /// the web view; everything else opens outside, like the navigation rule.
  void _openFromPage(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    final scheme = uri.scheme.toLowerCase();
    if ((scheme == 'http' || scheme == 'https') &&
        _sameSite(uri.host.toLowerCase()) &&
        !_looksLikeDownload(uri)) {
      final controller = _controller;
      if (controller != null) {
        unawaited(controller.loadRequest(uri));
        return;
      }
    }
    unawaited(_openOutside(uri));
  }

  NavigationDecision _onNavigation(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.prevent;
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    if ((scheme == 'http' || scheme == 'https')) {
      // A download opens outside the app, where Android's downloader handles
      // it: the web view has no download UI of its own.
      if (_looksLikeDownload(uri)) {
        _openOutside(uri);
        return NavigationDecision.prevent;
      }
      if (_sameSite(host)) return NavigationDecision.navigate;
    }
    _openOutside(uri);
    return NavigationDecision.prevent;
  }

  /// True for the hand-off host and its subdomains (Campus stays on
  /// `jobs.rvmcad.org`, but a redirect to `www.` or another subdomain of the
  /// same site must not leave the app).
  bool _sameSite(String host) {
    final allowed = _allowedHost;
    if (allowed == null) return false;
    return host == allowed ||
        host.endsWith('.$allowed') ||
        allowed.endsWith('.$host');
  }

  /// A file the web view cannot show, opened by the phone instead.
  static bool _looksLikeDownload(Uri uri) {
    final path = uri.path.toLowerCase();
    const extensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.zip',
      '.csv',
      '.txt',
      '.png',
      '.jpg',
      '.jpeg',
    ];
    if (extensions.any(path.endsWith)) return true;
    final query = uri.query.toLowerCase();
    return query.contains('download=') || query.contains('attachment=');
  }

  Future<void> _openOutside(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // A link nothing can open is simply not opened; the page stays.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final controller = _controller;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || controller == null) return;
        if (await controller.canGoBack()) {
          await controller.goBack();
          return;
        }
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tabJobs),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (controller != null && await controller.canGoBack()) {
                await controller.goBack();
                return;
              }
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ),
        body: controller == null
            ? const StudentEmptyState(
                icon: Icons.link_off_rounded,
                title: 'Jobs',
              )
            : Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (_loading) const LinearProgressIndicator(minHeight: 2),
                  if (_failed)
                    ColoredBox(
                      color: context.palette.surface,
                      child: StudentEmptyState(
                        icon: Icons.cloud_off_rounded,
                        title: l10n.jobsWebError,
                        action: OutlinedButton(
                          onPressed: () {
                            final url = widget.url;
                            if (url != null) controller.loadRequest(url);
                          },
                          child: Text(l10n.retry),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // Never add the URL: its fragment is a one-use token.
    properties.add(FlagProperty('loading', value: _loading, ifTrue: 'loading'));
  }
}
