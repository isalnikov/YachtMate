import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../domain/astro/suncalc_port.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_section_header.dart';
import 'widgets/compass_dial.dart';

/// Компас + приблизительные восход/закат (F09).
class CompassAstroScreen extends ConsumerStatefulWidget {
  const CompassAstroScreen({super.key});

  @override
  ConsumerState<CompassAstroScreen> createState() => _CompassAstroScreenState();
}

class _CompassAstroScreenState extends ConsumerState<CompassAstroScreen> {
  Position? _pos;

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((p) {
      if (mounted) setState(() => _pos = p);
    }).catchError((_) {});
  }

  bool get _compassSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    final solar = _solarForPosition(_pos);

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(
          l10n.compassDisclaimer,
          style: CwTypography.caption(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.l),
        if (!_compassSupported)
          Text(l10n.compassUnavailablePlatform)
        else
          _CompassHeadingSection(l10n: l10n),
        const SizedBox(height: CwSpacing.l),
        CwSectionHeader(label: l10n.astroSectionTitle),
        if (_pos == null)
          Text(
            l10n.astroNeedGps,
            style: CwTypography.body(color: colors.textPrimary),
          )
        else if (solar != null) ...[
          _SunTimesRow(
            sunriseLabel: l10n.astroSunrise,
            sunsetLabel: l10n.astroSunset,
            sunriseUtc: solar.sunriseUtc,
            sunsetUtc: solar.sunsetUtc,
          ),
          const SizedBox(height: CwSpacing.s),
          Text(
            ref.watch(localeControllerProvider).languageCode == 'ru'
                ? 'Часовой пояс устройства; формулы приблизительные.'
                : 'Device timezone; approximate formulas.',
            style: CwTypography.caption(color: colors.textMuted),
          ),
        ],
      ],
    );
  }

  SunRiseSetUtc? _solarForPosition(Position? position) {
    final p = position;
    if (p == null) return null;
    final now = DateTime.now();
    return approximateSunriseSunsetUtc(
      latDeg: p.latitude,
      lonDeg: p.longitude,
      whenUtc: DateTime.utc(now.year, now.month, now.day, 12),
    );
  }
}

class _CompassHeadingSection extends StatelessWidget {
  const _CompassHeadingSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final stream = FlutterCompass.events;

    if (stream == null) {
      return Column(
        children: [
          const CompassDial(),
          const SizedBox(height: CwSpacing.s),
          Text(
            l10n.compassUnavailablePlatform,
            textAlign: TextAlign.center,
            style: CwTypography.body(color: colors.textPrimary),
          ),
        ],
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: stream,
      builder: (context, snap) {
        final heading = snap.data?.heading;
        return Column(
          children: [
            CompassDial(headingDeg: heading),
            const SizedBox(height: CwSpacing.s),
            Text(
              l10n.compassHeadingLabel,
              textAlign: TextAlign.center,
              style: CwTypography.caption(color: colors.textMuted),
            ),
          ],
        );
      },
    );
  }
}

class _SunTimesRow extends StatelessWidget {
  const _SunTimesRow({
    required this.sunriseLabel,
    required this.sunsetLabel,
    required this.sunriseUtc,
    required this.sunsetUtc,
  });

  final String sunriseLabel;
  final String sunsetLabel;
  final DateTime sunriseUtc;
  final DateTime sunsetUtc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SunTimeCard(
            key: const Key('compass_sunrise_card'),
            icon: Icons.wb_sunny_outlined,
            label: sunriseLabel,
            timeLocal: _fmtLocal(sunriseUtc),
          ),
        ),
        const SizedBox(width: CwSpacing.s),
        Expanded(
          child: _SunTimeCard(
            key: const Key('compass_sunset_card'),
            icon: Icons.nights_stay_outlined,
            label: sunsetLabel,
            timeLocal: _fmtLocal(sunsetUtc),
          ),
        ),
      ],
    );
  }

  static String _fmtLocal(DateTime utc) {
    final local = utc.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _SunTimeCard extends StatelessWidget {
  const _SunTimeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.timeLocal,
  });

  final IconData icon;
  final String label;
  final String timeLocal;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accentOrange, size: 22),
          const SizedBox(height: CwSpacing.s),
          Text(
            label,
            style: CwTypography.caption(color: colors.textMuted),
          ),
          const SizedBox(height: CwSpacing.xs),
          Text(
            timeLocal,
            style: CwTypography.h2(color: colors.accentTeal),
          ),
        ],
      ),
    );
  }
}
