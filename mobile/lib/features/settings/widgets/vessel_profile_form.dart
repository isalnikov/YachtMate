import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/vessel_prefs.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_text_field.dart';

/// Vessel name, LOA, draft, and hull type (step-27).
class VesselProfileForm extends ConsumerStatefulWidget {
  const VesselProfileForm({super.key});

  @override
  ConsumerState<VesselProfileForm> createState() => _VesselProfileFormState();
}

class _VesselProfileFormState extends ConsumerState<VesselProfileForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _loaCtrl;
  late final TextEditingController _draftCtrl;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(vesselPrefsProvider);
    _nameCtrl = TextEditingController(text: profile.name);
    _loaCtrl = TextEditingController(
      text: _formatLength(profile.loaM, profile.units),
    );
    _draftCtrl = TextEditingController(
      text: _formatLength(profile.draftM, profile.units),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _loaCtrl.dispose();
    _draftCtrl.dispose();
    super.dispose();
  }

  String _formatLength(double meters, UnitSystem units) {
    final v = units.lengthFromMeters(meters);
    return units == UnitSystem.metric
        ? v.toStringAsFixed(1)
        : v.toStringAsFixed(0);
  }

  double? _parseLength(String text, UnitSystem units) {
    final raw = double.tryParse(text.replaceAll(',', '.'));
    if (raw == null || raw <= 0) return null;
    return units.lengthToMeters(raw);
  }

  void _syncLengthFields(VesselProfile profile) {
    final loa = _formatLength(profile.loaM, profile.units);
    final draft = _formatLength(profile.draftM, profile.units);
    if (_loaCtrl.text != loa) _loaCtrl.text = loa;
    if (_draftCtrl.text != draft) _draftCtrl.text = draft;
  }

  String _typeLabel(VesselType type, AppLocalizations l10n) => switch (type) {
    VesselType.sailing => l10n.settingsVesselTypeSailing,
    VesselType.motor => l10n.settingsVesselTypeMotor,
    VesselType.catamaran => l10n.settingsVesselTypeCatamaran,
    VesselType.other => l10n.settingsVesselTypeOther,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(vesselPrefsProvider);
    final unit = profile.units.lengthUnitLabel;

    ref.listen<VesselProfile>(vesselPrefsProvider, (prev, next) {
      if (prev?.units != next.units) {
        _syncLengthFields(next);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CwTextField(
          controller: _nameCtrl,
          label: l10n.settingsVesselName,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => unawaited(
            ref.read(vesselPrefsProvider.notifier).setName(_nameCtrl.text.trim()),
          ),
          onChanged: (v) => unawaited(
            ref.read(vesselPrefsProvider.notifier).setName(v.trim()),
          ),
        ),
        const SizedBox(height: 12),
        CwTextField(
          controller: _loaCtrl,
          label: l10n.settingsVesselLoa(unit),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          onSubmitted: (_) {
            final m = _parseLength(_loaCtrl.text, profile.units);
            if (m != null) {
              unawaited(ref.read(vesselPrefsProvider.notifier).setLoaM(m));
            }
          },
          onChanged: (v) {
            final m = _parseLength(v, profile.units);
            if (m != null) {
              unawaited(ref.read(vesselPrefsProvider.notifier).setLoaM(m));
            }
          },
        ),
        const SizedBox(height: 12),
        CwTextField(
          controller: _draftCtrl,
          label: l10n.settingsVesselDraft(unit),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          onSubmitted: (_) {
            final m = _parseLength(_draftCtrl.text, profile.units);
            if (m != null) {
              unawaited(ref.read(vesselPrefsProvider.notifier).setDraftM(m));
            }
          },
          onChanged: (v) {
            final m = _parseLength(v, profile.units);
            if (m != null) {
              unawaited(ref.read(vesselPrefsProvider.notifier).setDraftM(m));
            }
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<VesselType>(
          value: profile.type,
          decoration: CwTextField.decoration(
            context,
            label: l10n.settingsVesselType,
          ),
          dropdownColor: Theme.of(context).colorScheme.surface,
          items: VesselType.values
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(_typeLabel(t, l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (t) {
            if (t != null) {
              unawaited(ref.read(vesselPrefsProvider.notifier).setType(t));
            }
          },
        ),
      ],
    );
  }
}
