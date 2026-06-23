import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers.dart';
import '../../core/sos_settings_controller.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../domain/distress/sos_emergency_type.dart';
import '../../domain/distress/sos_message_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_card.dart';
import 'widgets/sos_emergency_panel.dart';
import 'widgets/sos_timer_display.dart';
import 'widgets/sos_type_selector.dart';

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
  SosEmergencyType _emergencyType = SosEmergencyType.medical;
  double? _previewLat;
  double? _previewLon;
  bool _loadingPosition = false;
  DateTime? _activatedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(sosSettingsProvider);
      _vesselCtrl.text = s.vesselName;
      _smsCtrl.text = s.smsNumber;
      _rescueCtrl.text = s.regionRescueNumber;
      _refreshPreviewPosition();
    });
    _vesselCtrl.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _vesselCtrl.removeListener(_onFieldsChanged);
    _vesselCtrl.dispose();
    _smsCtrl.dispose();
    _rescueCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshPreviewPosition() async {
    if (_loadingPosition) return;
    setState(() => _loadingPosition = true);
    try {
      final pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _previewLat = pos.latitude;
          _previewLon = pos.longitude;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _previewLat ??= 0;
          _previewLon ??= 0;
        });
      }
    } finally {
      if (mounted) setState(() => _loadingPosition = false);
    }
  }

  Future<void> _persistFields() async {
    final n = ref.read(sosSettingsProvider.notifier);
    await n.setVesselName(_vesselCtrl.text);
    await n.setSmsNumber(_smsCtrl.text);
    await n.setRegionRescueNumber(_rescueCtrl.text);
  }

  String _previewMessage(SosSettings sos) {
    final lat = _previewLat ?? 0;
    final lon = _previewLon ?? 0;
    final utc = DateTime.now().toUtc();
    return SosMessageFormatter.build(
      lat: lat,
      lon: lon,
      utc: utc,
      vesselName: sos.vesselName.isEmpty ? _vesselCtrl.text : sos.vesselName,
      testMode: sos.testMode,
      emergencyType: _emergencyType,
    );
  }

  Future<void> _activate() async {
    await _persistFields();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final sos = ref.read(sosSettingsProvider);
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
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

    final lat = pos?.latitude ?? _previewLat ?? 0.0;
    final lon = pos?.longitude ?? _previewLon ?? 0.0;
    final activatedAt = DateTime.now().toUtc();
    final msg = SosMessageFormatter.build(
      lat: lat,
      lon: lon,
      utc: activatedAt,
      vesselName: sos.vesselName.isEmpty ? _vesselCtrl.text : sos.vesselName,
      testMode: sos.testMode,
      emergencyType: _emergencyType,
    );

    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'sos_activate',
          severity: 'critical',
          contextJson:
              '{"testMode":${sos.testMode},"hasFix":${pos != null},"type":"${_emergencyType.name}"}',
        );

    if (!mounted) return;

    setState(() {
      _activatedAt = activatedAt;
      _previewLat = lat;
      _previewLon = lon;
    });

    if (sos.testMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sosAfterTest)),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sosAfterLive)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sos = ref.watch(sosSettingsProvider);
    final notifier = ref.read(sosSettingsProvider.notifier);
    final colors = context.cwColors;
    final theme = Theme.of(context);
    final previewLat = _previewLat;
    final previewLon = _previewLon;
    final previewUtc = DateTime.now().toUtc();

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.sosBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: CwSpacing.m),
        SwitchListTile(
          title: Text(l10n.sosTestMode),
          value: sos.testMode,
          onChanged: notifier.setTestMode,
        ),
        SosTypeSelector(
          selected: _emergencyType,
          onSelected: (type) => setState(() => _emergencyType = type),
        ),
        const SizedBox(height: CwSpacing.m),
        CwCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sosMessagePreview,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: CwSpacing.s),
              if (_loadingPosition && previewLat == null)
                Text(
                  l10n.sosCoordsPending,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                  ),
                )
              else if (previewLat != null && previewLon != null)
                CwTypography.coords(context, previewLat, previewLon)
              else
                Text(
                  l10n.sosCoordsPending,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              const SizedBox(height: CwSpacing.xs),
              Text(
                'UTC ${previewUtc.toIso8601String().substring(0, 19)}Z',
                style: CwTypography.monoCoords(color: colors.textMuted),
              ),
              const SizedBox(height: CwSpacing.s),
              SelectableText(
                _previewMessage(sos),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: CwSpacing.m),
        ExpansionTile(
          title: Text(l10n.sosOpenSettings),
          children: [
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
          ],
        ),
        const SizedBox(height: CwSpacing.m),
        CheckboxListTile(
          value: _ack,
          onChanged: (v) => setState(() => _ack = v ?? false),
          title: Text(l10n.sosStep1),
        ),
        const SizedBox(height: CwSpacing.s),
        SosEmergencyPanel(
          enabled: _ack,
          onActivated: _activate,
        ),
        if (_activatedAt != null) SosTimerDisplay(activatedAt: _activatedAt!),
      ],
    );
  }
}
