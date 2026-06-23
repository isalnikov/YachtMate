import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../mooring_service_labels.dart';

const kMooringDetailServiceKeys = ['water', 'electricity', 'wifi'];

Map<String, dynamic>? parseMooringServicesJson(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final m = jsonDecode(raw);
    if (m is Map<String, dynamic>) return m;
  } catch (_) {}
  return null;
}

bool mooringServiceAvailable(Map<String, dynamic>? services, String key) {
  if (services == null) return false;
  final value = services[key];
  if (value is bool) return value;
  return value != null;
}

/// Water / electricity / Wi‑Fi availability chips for the detail sheet.
class MooringServiceChips extends StatelessWidget {
  const MooringServiceChips({
    super.key,
    required this.place,
  });

  final MooringPlaceRow place;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final services = parseMooringServicesJson(place.servicesJson);

    return Wrap(
      spacing: CwSpacing.xs,
      runSpacing: CwSpacing.xs,
      children: [
        for (final key in kMooringDetailServiceKeys)
          _ServiceChip(
            key: Key('mooring_service_$key'),
            label: mooringServiceKeyLabel(l10n, key),
            icon: _iconFor(key),
            available: mooringServiceAvailable(services, key),
            colors: colors,
          ),
      ],
    );
  }

  IconData _iconFor(String key) {
    return switch (key) {
      'water' => Icons.water_drop_outlined,
      'electricity' => Icons.electric_bolt_outlined,
      'wifi' => Icons.wifi_outlined,
      _ => Icons.check_circle_outline,
    };
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    super.key,
    required this.label,
    required this.icon,
    required this.available,
    required this.colors,
  });

  final String label;
  final IconData icon;
  final bool available;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final fg = available ? colors.accentTeal : colors.textMuted;
    final bg = available
        ? colors.accentTeal.withValues(alpha: 0.12)
        : colors.deckBlue.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CwRadius.full),
        border: Border.all(
          color: available
              ? colors.accentTeal.withValues(alpha: 0.35)
              : colors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 4),
          Text(label, style: CwTypography.caption(color: fg)),
        ],
      ),
    );
  }
}
