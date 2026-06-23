import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/reference/knot_entry.dart';
import '../../l10n/app_localizations.dart';
import 'knot_favorites_preferences.dart';
import 'widgets/knot_step_list.dart';

/// Пошаговое описание узла с избранным (офлайн).
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
    final favorites = ref.watch(knotFavoritesProvider);
    final isFavorite = favorites.contains(widget.entry.id);
    final title = widget.entry.titleForLang(lang);
    final steps = widget.entry.stepsForLang(lang);
    final useCase = widget.entry.useCaseForLang(lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: isFavorite
                ? l10n.knotRemoveFavorite
                : l10n.knotAddFavorite,
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () {
              unawaited(
                ref
                    .read(knotFavoritesProvider.notifier)
                    .toggle(widget.entry.id),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(CwSpacing.m),
        children: [
          Icon(
            Icons.link,
            size: 72,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: CwSpacing.m),
          if (useCase.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: CwSpacing.l),
              child: Text(
                useCase,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          KnotStepList(
            heading: l10n.knotStepsHeading,
            steps: steps,
          ),
        ],
      ),
    );
  }
}
