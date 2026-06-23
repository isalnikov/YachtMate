import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../domain/reference/medical_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_card.dart';

CwBadgeVariant medicalCategoryBadgeVariant(String category) {
  return switch (category) {
    'critical' => CwBadgeVariant.danger,
    _ => CwBadgeVariant.info,
  };
}

String medicalCategoryLabel(AppLocalizations l10n, String category) {
  return switch (category) {
    'critical' => l10n.sosTypeMedical,
    'environment' => 'Environment',
    _ => category.isEmpty
        ? category
        : '${category[0].toUpperCase()}${category.substring(1)}',
  };
}

/// Glossary term panel: title, category badge, and educational body text.
class MedicalTermCard extends StatelessWidget {
  const MedicalTermCard({
    super.key,
    required this.entry,
    required this.lang,
  });

  final MedicalEntry entry;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = entry.titleFor(lang);
    final body = entry.bodyFor(lang);

    return CwCard(
      key: Key('medical_term_${entry.id}'),
      margin: const EdgeInsets.only(bottom: CwSpacing.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: CwSpacing.m),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.s),
          CwBadge(
            label: medicalCategoryLabel(l10n, entry.category),
            variant: medicalCategoryBadgeVariant(entry.category),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.s),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
