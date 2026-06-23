import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/logbook_repository.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_button_sizes.dart';
import '../../../widgets/cw_card.dart';

CwBadgeVariant logbookCategoryBadgeVariant(String category) {
  return switch (category) {
    LogbookEntryCategories.fuel => CwBadgeVariant.danger,
    LogbookEntryCategories.maintenance => CwBadgeVariant.info,
    LogbookEntryCategories.watch => CwBadgeVariant.safe,
    _ => CwBadgeVariant.info,
  };
}

/// Logbook list row: category badge, title, timestamp, optional body.
class LogbookEntryCard extends StatelessWidget {
  const LogbookEntryCard({
    super.key,
    required this.entry,
    required this.categoryLabel,
    required this.showDelete,
    required this.onDelete,
  });

  final LogbookEntryRow entry;
  final String categoryLabel;
  final bool showDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final payload = LogbookPayload.parse(entry.payloadJson);
    final titleText = (payload.title ?? '').trim();
    final when = DateFormat.yMMMd().add_Hm().format(
      DateTime.fromMillisecondsSinceEpoch(entry.t),
    );
    final body = (payload.body ?? '').trim();

    return CwCard(
      margin: const EdgeInsets.only(bottom: CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CwBadge(
                label: categoryLabel,
                variant: logbookCategoryBadgeVariant(entry.category),
              ),
              const Spacer(),
              Text(
                when,
                style: CwTypography.caption(color: colors.textMuted),
              ),
              if (showDelete) ...[
                const SizedBox(width: CwSpacing.xs),
                CwIconButton(
                  icon: Icons.delete_outline,
                  variant: CwButtonVariant.tertiary,
                  size: CwButtonSize.sm,
                  semanticLabel: 'Delete',
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
          const SizedBox(height: CwSpacing.s),
          Text(
            titleText.isNotEmpty ? titleText : categoryLabel,
            style: CwTypography.h2(color: colors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.xs),
            Text(
              body,
              style: CwTypography.body(color: colors.textMuted),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class LogbookPayload {
  LogbookPayload({this.title, this.body});

  final String? title;
  final String? body;

  static LogbookPayload parse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return LogbookPayload(
          title: decoded['title']?.toString(),
          body: decoded['body']?.toString(),
        );
      }
    } catch (_) {}
    return LogbookPayload();
  }
}
