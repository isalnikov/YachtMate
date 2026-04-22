import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/disclaimer_gate.dart';
import '../../l10n/app_localizations.dart';

/// First-run legal disclaimer (Фаза 1.5). Acceptance is persisted + audited.
class DisclaimerScreen extends ConsumerWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.disclaimerTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.disclaimerP1, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text(l10n.disclaimerP2, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  await ref.read(disclaimerAcceptedProvider.notifier).accept();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l10n.disclaimerAccept),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
