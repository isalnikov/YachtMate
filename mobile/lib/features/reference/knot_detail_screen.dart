import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/reference/knot_entry.dart';
import '../../l10n/app_localizations.dart';

/// Пошаговое описание узла (офлайн).
class KnotDetailScreen extends ConsumerStatefulWidget {
  const KnotDetailScreen({super.key, required this.entry});

  final KnotEntry entry;

  @override
  ConsumerState<KnotDetailScreen> createState() => _KnotDetailScreenState();
}

class _KnotDetailScreenState extends ConsumerState<KnotDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_auditOpen());
    });
  }

  Future<void> _auditOpen() async {
    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M9',
          action: 'knot_open',
          contextJson: '{"knotId":"${widget.entry.id}"}',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final title = widget.entry.titleForLang(lang);
    final steps = widget.entry.stepsForLang(lang);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.knotStepsHeading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${i + 1}.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Expanded(child: Text(steps[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
