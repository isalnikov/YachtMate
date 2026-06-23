import 'dart:async';

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';

/// Elapsed timer shown after SOS activation.
class SosTimerDisplay extends StatefulWidget {
  const SosTimerDisplay({
    super.key,
    required this.activatedAt,
  });

  final DateTime activatedAt;

  @override
  State<SosTimerDisplay> createState() => _SosTimerDisplayState();
}

class _SosTimerDisplayState extends State<SosTimerDisplay> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void didUpdateWidget(covariant SosTimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activatedAt != widget.activatedAt) {
      _tick();
    }
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      _elapsed = DateTime.now().difference(widget.activatedAt);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:$m:$s';
    }
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final theme = Theme.of(context);

    return CwCard(
      margin: const EdgeInsets.only(top: CwSpacing.m),
      padding: const EdgeInsets.symmetric(
        horizontal: CwSpacing.m,
        vertical: CwSpacing.s + 4,
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: colors.danger, size: 22),
          const SizedBox(width: CwSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sosTimerActive,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${l10n.sosTimerElapsed}: ${_format(_elapsed)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _format(_elapsed),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
