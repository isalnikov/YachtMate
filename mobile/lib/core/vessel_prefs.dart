import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Vessel hull category for CPA and marina requests.
enum VesselType {
  sailing,
  motor,
  catamaran,
  other;

  static VesselType decode(String? raw) => switch (raw) {
    'motor' => VesselType.motor,
    'catamaran' => VesselType.catamaran,
    'other' => VesselType.other,
    _ => VesselType.sailing,
  };

  String get encoded => switch (this) {
    VesselType.sailing => 'sailing',
    VesselType.motor => 'motor',
    VesselType.catamaran => 'catamaran',
    VesselType.other => 'other',
  };
}

enum UnitSystem {
  metric,
  imperial;

  static UnitSystem decode(String? raw) =>
      raw == 'imperial' ? UnitSystem.imperial : UnitSystem.metric;

  String get encoded => switch (this) {
    UnitSystem.metric => 'metric',
    UnitSystem.imperial => 'imperial',
  };

  static const metersPerFoot = 0.3048;

  double lengthFromMeters(double meters) => switch (this) {
    UnitSystem.metric => meters,
    UnitSystem.imperial => meters / metersPerFoot,
  };

  double lengthToMeters(double value) => switch (this) {
    UnitSystem.metric => value,
    UnitSystem.imperial => value * metersPerFoot,
  };

  String get lengthUnitLabel => switch (this) {
    UnitSystem.metric => 'm',
    UnitSystem.imperial => 'ft',
  };
}

/// Persisted vessel profile used by settings and route depth checks (step-27).
class VesselProfile {
  const VesselProfile({
    required this.name,
    required this.loaM,
    required this.draftM,
    required this.type,
    required this.units,
  });

  final String name;
  final double loaM;
  final double draftM;
  final VesselType type;
  final UnitSystem units;

  VesselProfile copyWith({
    String? name,
    double? loaM,
    double? draftM,
    VesselType? type,
    UnitSystem? units,
  }) {
    return VesselProfile(
      name: name ?? this.name,
      loaM: loaM ?? this.loaM,
      draftM: draftM ?? this.draftM,
      type: type ?? this.type,
      units: units ?? this.units,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is VesselProfile &&
      other.name == name &&
      other.loaM == loaM &&
      other.draftM == draftM &&
      other.type == type &&
      other.units == units;

  @override
  int get hashCode => Object.hash(name, loaM, draftM, type, units);
}

class VesselPrefsController extends StateNotifier<VesselProfile> {
  VesselPrefsController(this._prefs, this._audit, this._sessionId)
    : super(_initial(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const nameKey = 'vessel_name';
  static const loaKey = 'vessel_loa_m';
  static const draftKey = 'vessel_draft_m';
  static const typeKey = 'vessel_type';
  static const unitsKey = 'vessel_units';

  /// Legacy draft key from ship routing prefs (step-05).
  static const legacyDraftKey = 'ship_draft_m';

  static VesselProfile _initial(SharedPreferences prefs) {
    return VesselProfile(
      name: prefs.getString(nameKey) ?? '',
      loaM: prefs.getDouble(loaKey) ?? 12.0,
      draftM: prefs.getDouble(draftKey) ??
          prefs.getDouble(legacyDraftKey) ??
          2.5,
      type: VesselType.decode(prefs.getString(typeKey)),
      units: UnitSystem.decode(prefs.getString(unitsKey)),
    );
  }

  Future<void> setName(String value) async {
    if (value == state.name) return;
    await _prefs.setString(nameKey, value);
    state = state.copyWith(name: value);
    await _auditVessel('vessel_name');
  }

  Future<void> setLoaM(double meters) async {
    if (meters <= 0 || meters == state.loaM) return;
    await _prefs.setDouble(loaKey, meters);
    state = state.copyWith(loaM: meters);
    await _auditVessel('vessel_loa');
  }

  Future<void> setDraftM(double meters) async {
    if (meters <= 0 || meters == state.draftM) return;
    await _prefs.setDouble(draftKey, meters);
    await _prefs.setDouble(legacyDraftKey, meters);
    state = state.copyWith(draftM: meters);
    await _auditVessel('vessel_draft');
  }

  Future<void> setType(VesselType type) async {
    if (type == state.type) return;
    await _prefs.setString(typeKey, type.encoded);
    state = state.copyWith(type: type);
    await _auditVessel('vessel_type');
  }

  Future<void> setUnits(UnitSystem units) async {
    if (units == state.units) return;
    await _prefs.setString(unitsKey, units.encoded);
    state = state.copyWith(units: units);
    await _auditVessel('vessel_units');
  }

  Future<void> _auditVessel(String action) async {
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: action,
      contextJson:
          '{"draftM":${state.draftM},"loaM":${state.loaM},"type":"${state.type.encoded}"}',
    );
  }
}
