import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_empty_state.dart';
import 'track_recording_controller.dart';
import 'widgets/track_stats_card.dart';

/// Управление записью трека (Фаза 7.3).
class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final rec = ref.watch(trackRecordingProvider);
    final ptsAsync = ref.watch(activeTrackPointsProvider);
    final tripAsync = ref.watch(activeTrackTripProvider);

    final pointCount = ptsAsync.maybeWhen(
      data: (pts) => pts.length,
      orElse: () => 0,
    );
    final startedAtMs = tripAsync.maybeWhen(
      data: (trip) => trip?.startedAtMs,
      orElse: () => null,
    );

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TrackStatsCard(
            isRecording: rec.isRecording,
            pointCount: pointCount,
            startedAtMs: rec.isRecording ? startedAtMs : null,
          ),
          const SizedBox(height: CwSpacing.m),
          Row(
            children: [
              Expanded(
                child: CwButton(
                  label: l10n.trackStart,
                  variant: CwButtonVariant.primary,
                  icon: Icons.play_arrow_rounded,
                  onPressed: rec.isRecording
                      ? null
                      : () => ref.read(trackRecordingProvider.notifier).start(),
                ),
              ),
              const SizedBox(width: CwSpacing.s + 4),
              Expanded(
                child: CwButton(
                  label: l10n.trackStop,
                  variant: CwButtonVariant.danger,
                  icon: Icons.stop_rounded,
                  onPressed: !rec.isRecording
                      ? null
                      : () => ref.read(trackRecordingProvider.notifier).stop(),
                ),
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.l),
          Text(
            l10n.trackTitle,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.s),
          Expanded(
            child: FutureBuilder(
              future: ref.read(trackRepositoryProvider).tripsNewestFirst(),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snap.data!;
                if (trips.isEmpty) {
                  return Center(
                    child: CwEmptyState(
                      icon: Icons.route_outlined,
                      title: l10n.trackEmptyTrips,
                      message: l10n.trackEmptyTripsMessage,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (c, i) {
                    final t = trips[i];
                    return ListTile(
                      dense: true,
                      title: Text(t.id.substring(0, 8)),
                      subtitle: Text(
                        '${DateTime.fromMillisecondsSinceEpoch(t.startedAtMs)} '
                        '${t.endedAtMs != null ? "→ ${DateTime.fromMillisecondsSinceEpoch(t.endedAtMs!)}" : "(open)"}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
