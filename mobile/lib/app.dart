import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/disclaimer_gate.dart';
import 'core/providers.dart';
import 'core/theme/cw_theme.dart';
import 'features/legal/disclaimer_screen.dart';
import 'features/shell/shell_screen.dart';
import 'l10n/app_localizations.dart';

class CaptainWrongelApp extends ConsumerStatefulWidget {
  const CaptainWrongelApp({super.key});

  @override
  ConsumerState<CaptainWrongelApp> createState() => _CaptainWrongelAppState();
}

class _CaptainWrongelAppState extends ConsumerState<CaptainWrongelApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapAudit());
  }

  Future<void> _bootstrapAudit() async {
    final audit = ref.read(auditRepositoryProvider);
    final session = ref.read(sessionIdProvider);
    final log = ref.read(rootLoggerProvider);
    try {
      await audit.record(
        sessionId: session,
        module: 'core',
        action: 'app_launch',
        contextJson: '{"phase":0}',
      );
      log.info('Bootstrap audit written', {'sessionId': session});
    } catch (e, st) {
      log.warning('Bootstrap audit failed', {
        'error': '$e',
        'sessionId': session,
      });
      FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, silent: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    final disclaimerOk = ref.watch(disclaimerAcceptedProvider);
    final accessibility = ref.watch(accessibilityPreferencesProvider);

    final baseTheme = accessibility.highContrast
        ? CwTheme.materialHighContrast()
        : CwTheme.material();

    final glove = accessibility.gloveMode;
    final scaled = accessibility.textScale;

    final tunedTheme = glove
        ? baseTheme.copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(52, 52),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                minimumSize: const Size(52, 52),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.all(14),
              ),
            ),
          )
        : baseTheme;

    return MaterialApp(
      key: ValueKey(disclaimerOk),
      title: 'Captain Wrongel',
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Captain Wrongel',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: tunedTheme,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scaled)),
          child: child,
        );
      },
      home: disclaimerOk ? const ShellScreen() : const DisclaimerScreen(),
    );
  }
}
