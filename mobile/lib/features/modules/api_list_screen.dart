import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';

/// A small list screen over one JSON list in the Student API contract. It
/// shares the transport, the palette, the error copy and the request id with
/// every other screen. Modules add their own item cards and actions.
class ApiListScreen extends StatefulWidget {
  const ApiListScreen({
    super.key,
    required this.title,
    required this.path,
    required this.listKey,
    required this.emptyText,
    required this.itemBuilder,
    this.header,
    this.refreshPath,
  });

  final String title;
  final String path;
  final String listKey;
  final String emptyText;
  final Widget Function(BuildContext, Map<String, dynamic>) itemBuilder;
  final Widget? header;
  final String? refreshPath;

  @override
  State<ApiListScreen> createState() => _ApiListScreenState();
}

class _ApiListScreenState extends State<ApiListScreen> {
  late Future<Map<String, dynamic>> _future = _load();

  Future<Map<String, dynamic>> _load() => getIt<StudentApi>().getJson(widget.path);

  void _reload() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
          final items = (json[widget.listKey] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList();
          return RefreshIndicator(
            onRefresh: () async {
              _reload();
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.all(RvmSpacing.lg),
              children: [
                if (widget.header != null) ...[
                  widget.header!,
                  const SizedBox(height: RvmSpacing.md),
                ],
                if (items.isEmpty)
                  StudentEmptyState(
                    icon: Icons.inbox_outlined,
                    title: widget.emptyText,
                  )
                else
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: RvmSpacing.sm + 2),
                      child: widget.itemBuilder(context, item),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The card every module list uses.
class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RvmSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(RvmRadii.md),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

String money(int paise) {
  final rupees = paise / 100;
  return '₹${rupees.toStringAsFixed(rupees == rupees.roundToDouble() ? 0 : 2)}';
}

String? textOf(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value == null ? null : '$value';
}

String dateText(String? iso) {
  if (iso == null) return '';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return iso;
  return '${parsed.day.toString().padLeft(2, '0')}/'
      '${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
}
