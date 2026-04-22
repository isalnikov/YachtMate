import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers.dart';

/// Роль и «корабль» по инвайт-коду (локально, Фаза 7.6).
enum CrewRole { captain, crew }

class CrewState {
  const CrewState({required this.role, this.shipId, this.inviteCode});

  final CrewRole role;
  final String? shipId;
  final String? inviteCode;

  bool get canCaptainActions => role == CrewRole.captain;
}

class CrewController extends StateNotifier<CrewState> {
  CrewController(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static const _kRole = 'crew_role';
  static const _kShip = 'crew_ship_id';
  static const _kInv = 'crew_invite_display';

  static CrewState _read(SharedPreferences p) {
    final r = p.getString(_kRole) ?? 'captain';
    return CrewState(
      role: r == 'crew' ? CrewRole.crew : CrewRole.captain,
      shipId: p.getString(_kShip),
      inviteCode: p.getString(_kInv),
    );
  }

  Future<void> createShipAndInvite() async {
    final code = _randomInvite();
    final shipId = sha256
        .convert(utf8.encode('ship::$code'))
        .toString()
        .substring(0, 20);
    await _prefs.setString(_kRole, 'captain');
    await _prefs.setString(_kShip, shipId);
    await _prefs.setString(_kInv, code);
    state = CrewState(role: CrewRole.captain, shipId: shipId, inviteCode: code);
  }

  Future<void> joinShip(String enteredCode) async {
    final trimmed = enteredCode.trim().toUpperCase();
    final shipId = sha256
        .convert(utf8.encode('ship::$trimmed'))
        .toString()
        .substring(0, 20);
    await _prefs.setString(_kRole, 'crew');
    await _prefs.setString(_kShip, shipId);
    await _prefs.setString(_kInv, trimmed);
    state = CrewState(role: CrewRole.crew, shipId: shipId, inviteCode: trimmed);
  }

  Future<void> leaveShip() async {
    await _prefs.remove(_kShip);
    await _prefs.remove(_kInv);
    await _prefs.setString(_kRole, 'captain');
    state = const CrewState(role: CrewRole.captain);
  }

  static String _randomInvite() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }
}

final crewControllerProvider = StateNotifierProvider<CrewController, CrewState>(
  (ref) => CrewController(ref.watch(sharedPreferencesProvider)),
);
