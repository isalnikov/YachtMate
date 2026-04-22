import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'track_recording_controller.dart';

/// Управление записью трека (Фаза 7.3).
class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rec = ref.watch(trackRecordingProvider);
    final ptsAsync = ref.watch(activeTrackPointsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            rec.isRecording ? l10n.trackRecordingActive : l10n.trackIdle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ptsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (pts) => Text(l10n.trackPoints(pts.length)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: rec.isRecording
                      ? null
                      : () => ref.read(trackRecordingProvider.notifier).start(),
                  child: Text(l10n.trackStart),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: !rec.isRecording
                      ? null
                      : () => ref.read(trackRecordingProvider.notifier).stop(),
                  child: Text(l10n.trackStop),
                ),
              ),
            ],
          ),
          const Divider(height: 40),
          Text(l10n.trackTitle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder(
              future: ref.read(trackRepositoryProvider).tripsNewestFirst(),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snap.data!;
                if (trips.isEmpty) {
                  return Text(l10n.trackIdle);
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
