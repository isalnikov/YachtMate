import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import 'mooring_providers.dart';

Future<void> showMooringDetailSheet({
  required BuildContext context,
  required MooringPlaceRow place,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _MooringDetailBody(place: place),
  );
}

class _MooringDetailBody extends ConsumerStatefulWidget {
  const _MooringDetailBody({required this.place});

  final MooringPlaceRow place;

  @override
  ConsumerState<_MooringDetailBody> createState() => _MooringDetailBodyState();
}

class _MooringDetailBodyState extends ConsumerState<_MooringDetailBody> {
  late final TextEditingController _comment;
  int _stars = 4;

  @override
  void initState() {
    super.initState();
    _comment = TextEditingController();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);
    await ref.read(mooringRepositoryProvider).queueReviewDraft(
          placeId: widget.place.id,
          stars: _stars,
          comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
        );

    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M6',
          action: 'mooring_review_queue',
          contextJson:
              '{"placeId":"${widget.place.id}","stars":$_stars}',
        );

    if (!mounted) return;
    Navigator.of(context).pop();
    messenger?.showSnackBar(SnackBar(content: Text(l10n.mooringReviewQueued)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = widget.place;
    final theme = Theme.of(context);
    Map<String, dynamic>? svc;
    if ((p.servicesJson ?? '').isNotEmpty) {
      try {
        final m = jsonDecode(p.servicesJson!) as Map<String, dynamic>;
        svc = m;
      } catch (_) {}
    }

    final kindLabel = p.kind == 'marina'
        ? l10n.mooringKindMarina
        : l10n.mooringKindAnchorage;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(p.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '$kindLabel · ${p.lat.toStringAsFixed(4)}°, ${p.lon.toStringAsFixed(4)}°',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if ((p.vhf ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('${l10n.mooringVhf}: ${p.vhf}'),
            ],
            if ((p.phone ?? '').isNotEmpty)
              Text('${l10n.mooringPhone}: ${p.phone}'),
            if ((p.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(p.notes!, style: theme.textTheme.bodyMedium),
            ],
            if (svc != null && svc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.mooringServices, style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                svc.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            Text(l10n.mooringReviewTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(l10n.mooringReviewStars),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _stars,
                  items: [
                    for (var i = 1; i <= 5; i++)
                      DropdownMenuItem(value: i, child: Text('$i')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _stars = v);
                  },
                ),
              ],
            ),
            TextField(
              controller: _comment,
              decoration: InputDecoration(
                labelText: l10n.mooringReviewComment,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.mooringGdprHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.mooringReviewSave),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.mooringDetailClose),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
