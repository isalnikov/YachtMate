import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';

/// Point count, elapsed duration, and recording pulse for the active session.
class TrackStatsCard extends StatefulWidget {
  const TrackStatsCard({
    super.key,
    required this.isRecording,
    required this.pointCount,
    this.startedAtMs,
  });

  final bool isRecording;
  final int pointCount;
  final int? startedAtMs;

  @override
  State<TrackStatsCard> createState() => _TrackStatsCardState();
}

class _TrackStatsCardState extends State<TrackStatsCard> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant TrackStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTimer();
  }

  void _syncTimer() {
    if (widget.isRecording) {
      _tick ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else {
      _tick?.cancel();
      _tick = null;
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Duration? get _duration {
    final startedAtMs = widget.startedAtMs;
    if (!widget.isRecording || startedAtMs == null) return null;
    final elapsed = DateTime.now().millisecondsSinceEpoch - startedAtMs;
    return Duration(milliseconds: elapsed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final statusLabel =
        widget.isRecording ? l10n.trackRecordingActive : l10n.trackIdle;

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _RecordingPulseIndicator(active: widget.isRecording),
              const SizedBox(width: CwSpacing.s),
              Expanded(
                child: Text(
                  statusLabel,
                  style: CwTypography.h2(color: colors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.m),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: l10n.trackStatsPoints,
                  value: '${widget.pointCount}',
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.trackStatsDuration,
                  value: _formatDuration(_duration),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration? duration) {
    if (duration == null) return '—';
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _RecordingPulseIndicator extends StatefulWidget {
  const _RecordingPulseIndicator({required this.active});

  final bool active;

  @override
  State<_RecordingPulseIndicator> createState() =>
      _RecordingPulseIndicatorState();
}

class _RecordingPulseIndicatorState extends State<_RecordingPulseIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant _RecordingPulseIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.active && !reduceMotion) {
      if (!_pulse.isAnimating) {
        _pulse.repeat(reverse: true);
      }
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final dotColor =
        widget.active ? colors.danger : colors.textMuted.withValues(alpha: 0.5);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = widget.active && !reduceMotion
            ? 0.35 + _pulse.value * 0.45
            : 0.0;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor.withValues(alpha: widget.active ? 0.9 : 1),
            boxShadow: glow > 0
                ? [
                    BoxShadow(
                      color: colors.danger.withValues(alpha: glow),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CwTypography.caption(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.xs),
        Text(
          value,
          style: CwTypography.h2(color: colors.accentTeal),
        ),
      ],
    );
  }
}
