import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'theme/student_theme.dart';
import 'theme/student_tokens.dart';
import 'widgets/states.dart';

/// What a build that must not start shows instead of the app: a prod build
/// made without the Student API address, or a dart-define the app does not
/// understand (see `StudentEnv.resolve`). No request is made.
class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: StudentTheme.light(),
      builder: (context, child) => Theme(
        data: StudentTheme.forLanguageCode(
          Localizations.localeOf(context).languageCode,
        ),
        child: child!,
      ),
      home: const _ConfigErrorScreen(),
    );
  }
}

class _ConfigErrorScreen extends StatelessWidget {
  const _ConfigErrorScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ScrollableCenter(
          child: Padding(
            padding: const EdgeInsets.all(RvmSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.build_circle_outlined,
                    size: 44,
                    color: StudentColors.danger,
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Text(
                    l10n.configErrorTitle,
                    textAlign: TextAlign.center,
                    style: text.titleLarge,
                  ),
                  const SizedBox(height: RvmSpacing.sm),
                  Text(
                    l10n.configErrorBody,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(color: StudentColors.fg2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
