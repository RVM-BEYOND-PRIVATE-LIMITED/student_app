import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';

/// The server's device refusal (#8, item 4): a plain reason and the centre's
/// number. The app's own hints never decide this; the server's verdict does.
class DeviceRefusedScreen extends StatefulWidget {
  const DeviceRefusedScreen({super.key, this.reason});
  final String? reason;

  @override
  State<DeviceRefusedScreen> createState() => _DeviceRefusedScreenState();
}

class _DeviceRefusedScreenState extends State<DeviceRefusedScreen> {
  late final Future<List<Branch>> _branches = getIt<StudentApi>().branches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'This phone cannot open videos', 'यह फ़ोन वीडियो नहीं खोल सकता'))),
      body: FutureBuilder<List<Branch>>(
        future: _branches,
        builder: (context, snapshot) {
          final branches = snapshot.data ?? const <Branch>[];
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              Icon(Icons.phonelink_erase_rounded, size: 44, color: context.palette.warning),
              const SizedBox(height: RvmSpacing.md),
              Text(widget.reason ?? tr(context, 'Your phone did not pass the security check. Use your registered phone, or ask your centre.', 'आपका फ़ोन सुरक्षा जाँच में सफल नहीं हुआ। अपना पंजीकृत फ़ोन इस्तेमाल करें या सेंटर से पूछें।')),
              const SizedBox(height: RvmSpacing.lg),
              for (final branch in branches)
                if (branch.phoneUri != null)
                  ListTile(
                    leading: const Icon(Icons.call_rounded),
                    title: Text(branch.name),
                    subtitle: Text(branch.callNumber ?? ''),
                    onTap: () => launchUrl(branch.phoneUri!),
                  ),
            ],
          );
        },
      ),
    );
  }
}
