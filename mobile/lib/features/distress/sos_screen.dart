import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers.dart';
import '../../core/sos_settings_controller.dart';
import '../../domain/distress/sos_message_formatter.dart';
import '../../l10n/app_localizations.dart';

/// SOS / distress — двухшаговое подтверждение; тестовый режим без внешней отправки (Фаза 7.2).
class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  final _vesselCtrl = TextEditingController();
  final _smsCtrl = TextEditingController();
  final _rescueCtrl = TextEditingController();
  bool _ack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(sosSettingsProvider);
      _vesselCtrl.text = s.vesselName;
      _smsCtrl.text = s.smsNumber;
      _rescueCtrl.text = s.regionRescueNumber;
    });
  }

  @override
  void dispose() {
    _vesselCtrl.dispose();
    _smsCtrl.dispose();
    _rescueCtrl.dispose();
    super.dispose();
  }

  Future<void> _persistFields() async {
    final n = ref.read(sosSettingsProvider.notifier);
    await n.setVesselName(_vesselCtrl.text);
    await n.setSmsNumber(_smsCtrl.text);
    await n.setRegionRescueNumber(_rescueCtrl.text);
  }

  Future<void> _activate() async {
    await _persistFields();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final sos = ref.read(sosSettingsProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sosTitle),
        content: Text(sos.testMode ? l10n.sosAfterTest : l10n.sosNoNumber),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.logbookCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.sosHold),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition();
    } catch (_) {}

    final lat = pos?.latitude ?? 0.0;
    final lon = pos?.longitude ?? 0.0;
    final msg = SosMessageFormatter.build(
      lat: lat,
      lon: lon,
      utc: DateTime.now().toUtc(),
      vesselName: sos.vesselName.isEmpty ? _vesselCtrl.text : sos.vesselName,
      testMode: sos.testMode,
    );

    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'sos_activate',
          severity: 'critical',
          contextJson: '{"testMode":${sos.testMode},"hasFix":${pos != null}}',
        );

    if (!mounted) return;

    if (sos.testMode) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.sosAfterTest)));
      return;
    }

    final raw = sos.smsNumber.trim().replaceAll(RegExp(r'[^\d+]'), '');
    if (raw.replaceAll('+', '').isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.sosNoNumber),
          content: SelectableText(msg),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: msg));
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.sosMessageCopied)),
                  );
                }
              },
              child: Text(l10n.sosCopyMessage),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.logbookCancel),
            ),
          ],
        ),
      );
      return;
    }

    final smsUri = Uri.parse('sms:$raw?body=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.sosAfterLive)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sos = ref.watch(sosSettingsProvider);
    final notifier = ref.read(sosSettingsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.sosBody, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text(l10n.sosTestMode),
          value: sos.testMode,
          onChanged: notifier.setTestMode,
        ),
        TextField(
          controller: _vesselCtrl,
          decoration: InputDecoration(labelText: l10n.sosVesselName),
          onSubmitted: (_) => notifier.setVesselName(_vesselCtrl.text),
        ),
        TextField(
          controller: _smsCtrl,
          decoration: InputDecoration(labelText: l10n.sosSmsNumber),
          keyboardType: TextInputType.phone,
        ),
        TextField(
          controller: _rescueCtrl,
          decoration: InputDecoration(labelText: l10n.sosRegionRescue),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: _ack,
          onChanged: (v) => setState(() => _ack = v ?? false),
          title: Text(l10n.sosStep1),
        ),
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: _ack ? () => _activate() : null,
          child: Text(l10n.sosHold),
        ),
      ],
    );
  }
}
