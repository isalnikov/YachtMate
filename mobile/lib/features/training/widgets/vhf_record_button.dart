import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Floating record button with pulse glow while recording.
class VhfRecordButton extends StatefulWidget {
  const VhfRecordButton({
    super.key,
    required this.recording,
    required this.onPressed,
  });

  final bool recording;
  final VoidCallback onPressed;

  @override
  State<VhfRecordButton> createState() => _VhfRecordButtonState();
}

class _VhfRecordButtonState extends State<VhfRecordButton>
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
  void didUpdateWidget(covariant VhfRecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.recording && !reduceMotion) {
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
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final label = widget.recording ? l10n.vhfRecordStop : l10n.vhfRecordStart;
    final icon = widget.recording ? Icons.stop_rounded : Icons.mic;
    final fabColor = widget.recording ? colors.danger : colors.accentTeal;

    return Semantics(
      button: true,
      label: label,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final glow = widget.recording && !reduceMotion
              ? 0.3 + _pulse.value * 0.4
              : 0.0;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: glow > 0
                  ? [
                      BoxShadow(
                        color: colors.danger.withValues(alpha: glow),
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: FloatingActionButton.large(
              heroTag: 'vhf_record_fab',
              backgroundColor: fabColor,
              foregroundColor: colors.textPrimary,
              onPressed: widget.onPressed,
              tooltip: label,
              child: Icon(icon, size: 32),
            ),
          );
        },
      ),
    );
  }
}
