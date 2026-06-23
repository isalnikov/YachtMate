import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_button.dart';
import '../mooring_providers.dart';

/// Offline review draft form for a mooring place (preserved from step-18 scope).
class MooringReviewSection extends ConsumerStatefulWidget {
  const MooringReviewSection({
    super.key,
    required this.placeId,
    this.onQueued,
  });

  final String placeId;
  final VoidCallback? onQueued;

  @override
  ConsumerState<MooringReviewSection> createState() =>
      _MooringReviewSectionState();
}

class _MooringReviewSectionState extends ConsumerState<MooringReviewSection> {
  late final TextEditingController _comment;
  int _stars = 4;
  bool _busy = false;

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
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);

    try {
      await ref.read(mooringRepositoryProvider).queueReviewDraft(
            placeId: widget.placeId,
            stars: _stars,
            comment:
                _comment.text.trim().isEmpty ? null : _comment.text.trim(),
          );

      await ref.read(auditRepositoryProvider).record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M6',
            action: 'mooring_review_queue',
            contextJson:
                '{"placeId":"${widget.placeId}","stars":$_stars}',
          );

      ref.invalidate(mooringPendingReviewsProvider);

      if (!mounted) return;
      widget.onQueued?.call();
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.mooringReviewQueued)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.mooringReviewTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(l10n.mooringReviewStars),
            const SizedBox(width: 12),
            DropdownButton<int>(
              key: const Key('mooring_review_stars'),
              value: _stars,
              items: [
                for (var i = 1; i <= 5; i++)
                  DropdownMenuItem(value: i, child: Text('$i')),
              ],
              onChanged: _busy
                  ? null
                  : (v) {
                      if (v != null) setState(() => _stars = v);
                    },
            ),
          ],
        ),
        TextField(
          key: const Key('mooring_review_comment'),
          controller: _comment,
          enabled: !_busy,
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
        CwButton(
          key: const Key('mooring_review_save'),
          label: l10n.mooringReviewSave,
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}
