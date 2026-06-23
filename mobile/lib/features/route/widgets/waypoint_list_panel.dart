import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';
import '../../../widgets/cw_empty_state.dart';

/// Reorderable waypoint list with swipe-to-delete.
class WaypointListPanel extends StatelessWidget {
  const WaypointListPanel({
    super.key,
    required this.waypoints,
    required this.onReorder,
    required this.onDelete,
  });

  final List<RouteWaypointRow> waypoints;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.routeWaypointListTitle,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.m),
          if (waypoints.isEmpty)
            CwEmptyState(
              icon: Icons.place_outlined,
              title: l10n.routeWaypointEmpty,
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: waypoints.length,
              onReorder: onReorder,
              itemBuilder: (context, index) {
                final wp = waypoints[index];
                final label = wp.name?.isNotEmpty == true
                    ? wp.name!
                    : l10n.routeWaypointDefaultName(index + 1);

                return Dismissible(
                  key: ValueKey(wp.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: CwSpacing.m),
                    color: colors.danger.withValues(alpha: 0.85),
                    child: Icon(Icons.delete_outline, color: colors.textPrimary),
                  ),
                  onDismissed: (_) => onDelete(index),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.drag_handle, color: colors.textMuted),
                      title: Text(
                        label,
                        style: CwTypography.body(color: colors.textPrimary),
                      ),
                      subtitle: Text(
                        '${wp.lat.toStringAsFixed(4)}°, ${wp.lon.toStringAsFixed(4)}°',
                        style: CwTypography.caption(color: colors.textMuted),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
