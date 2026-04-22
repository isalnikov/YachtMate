import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/providers.dart';
import '../../domain/astro/suncalc_port.dart';
import '../../l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;

    final unsupported = kIsWeb ||
        !(defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);

    SunRiseSetUtc? solar;
    final p = _pos;
    if (p != null) {
      final noonUtc = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        12,
      );
      solar = approximateSunriseSunsetUtc(
        latDeg: p.latitude,
        lonDeg: p.longitude,
        whenUtc: noonUtc,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.compassDisclaimer, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 24),
        if (unsupported)
          Text(l10n.compassUnavailablePlatform)
        else
          StreamBuilder<CompassEvent>(
            stream: FlutterCompass.events,
            builder: (ctx, snap) {
              final heading = snap.data?.heading;
              final deg = heading == null ? '—' : '${heading.toStringAsFixed(0)}°';
              return Column(
                children: [
                  Text(
                    deg,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(l10n.compassHeadingLabel),
                ],
              );
            },
          ),
        const Divider(height: 40),
        Text(l10n.astroSectionTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (p == null)
          Text(l10n.astroNeedGps)
        else if (solar != null) ...[
          Text(
            '${l10n.astroSunrise}: ${_fmtLocal(solar.sunriseUtc)}',
          ),
          Text(
            '${l10n.astroSunset}: ${_fmtLocal(solar.sunsetUtc)}',
          ),
          Text(
            lang == 'ru'
                ? 'Часовой пояс устройства; формулы приблизительные.'
                : 'Device timezone; approximate formulas.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  String _fmtLocal(DateTime utc) =>
      '${utc.toLocal().hour.toString().padLeft(2, '0')}:'
      '${utc.toLocal().minute.toString().padLeft(2, '0')}';
}
