import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// 120dp SOS hold button with pulsing animation (respects reduceMotion).
class SosEmergencyPanel extends StatefulWidget {
  const SosEmergencyPanel({
    super.key,
    required this.enabled,
    required this.onActivated,
  });

  final bool enabled;
  final VoidCallback onActivated;

  static const holdDuration = Duration(seconds: 2);
  static const buttonSize = 120.0;

  @override
  State<SosEmergencyPanel> createState() => _SosEmergencyPanelState();
}

class _SosEmergencyPanelState extends State<SosEmergencyPanel>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _holdTimer;
  int _holdTicks = 0;
  double _holdProgress = 0;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant SosEmergencyPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) {
      _cancelHold();
    }
    _syncPulse();
  }

  void _syncPulse() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.enabled && !reduceMotion) {
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
    _holdTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdTicks = 0;
    if (_holdProgress != 0) {
      setState(() => _holdProgress = 0);
    }
  }

  void _startHold() {
    if (!widget.enabled) return;
    _holdTicks = 0;
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      _holdTicks++;
      final progress = (_holdTicks * 50 /
              SosEmergencyPanel.holdDuration.inMilliseconds)
          .clamp(0.0, 1.0);
      setState(() => _holdProgress = progress);
      if (progress >= 1.0) {
        _holdTimer?.cancel();
        _holdTimer = null;
        _holdTicks = 0;
        setState(() => _holdProgress = 0);
        widget.onActivated();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      children: [
        Text(
          l10n.sosStep2,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.m),
        Semantics(
          button: true,
          enabled: widget.enabled,
          label: l10n.sosHold,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: widget.enabled ? (_) => _startHold() : null,
            onTapUp: widget.enabled ? (_) => _cancelHold() : null,
            onTapCancel: widget.enabled ? () => _cancelHold() : null,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final glow = widget.enabled && !reduceMotion
                    ? 0.25 + _pulse.value * 0.35
                    : 0.0;
                return Container(
                  width: SosEmergencyPanel.buttonSize + 24,
                  height: SosEmergencyPanel.buttonSize + 24,
                  alignment: Alignment.center,
                  decoration: widget.enabled
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.danger.withValues(alpha: glow),
                              blurRadius: 18,
                              spreadRadius: 4,
                            ),
                          ],
                        )
                      : null,
                  child: child,
                );
              },
              child: SizedBox(
                width: SosEmergencyPanel.buttonSize,
                height: SosEmergencyPanel.buttonSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_holdProgress > 0)
                      SizedBox(
                        width: SosEmergencyPanel.buttonSize,
                        height: SosEmergencyPanel.buttonSize,
                        child: CircularProgressIndicator(
                          value: _holdProgress,
                          strokeWidth: 4,
                          color: colors.textPrimary,
                          backgroundColor:
                              colors.danger.withValues(alpha: 0.35),
                        ),
                      ),
                    Material(
                      color: widget.enabled
                          ? colors.danger
                          : colors.danger.withValues(alpha: 0.35),
                      shape: const CircleBorder(),
                      elevation: widget.enabled ? 4 : 0,
                      child: SizedBox(
                        width: SosEmergencyPanel.buttonSize,
                        height: SosEmergencyPanel.buttonSize,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(CwSpacing.s),
                            child: Text(
                              l10n.sosHold,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}