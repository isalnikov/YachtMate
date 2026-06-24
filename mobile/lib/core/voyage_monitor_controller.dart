import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// SafeTrx-style voyage monitoring state (step 50).
class VoyageMonitorState {
  const VoyageMonitorState({
    this.active = false,
    this.contactName = '',
    this.contactPhone = '',
    this.intervalMinutes = 60,
    this.nextCheckInDueMs,
    this.startedAtMs,
  });

  final bool active;
  final String contactName;
  final String contactPhone;
  final int intervalMinutes;
  final int? nextCheckInDueMs;
  final int? startedAtMs;

  bool get isOverdue {
    if (!active || nextCheckInDueMs == null) return false;
    return DateTime.now().millisecondsSinceEpoch > nextCheckInDueMs!;
  }

  Duration? timeUntilDue() {
    final due = nextCheckInDueMs;
    if (due == null) return null;
    final diff = due - DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: diff < 0 ? 0 : diff);
  }

  VoyageMonitorState copyWith({
    bool? active,
    String? contactName,
    String? contactPhone,
    int? intervalMinutes,
    int? nextCheckInDueMs,
    int? startedAtMs,
    bool clearSchedule = false,
  }) {
    return VoyageMonitorState(
      active: active ?? this.active,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      nextCheckInDueMs:
          clearSchedule ? null : (nextCheckInDueMs ?? this.nextCheckInDueMs),
      startedAtMs: clearSchedule ? null : (startedAtMs ?? this.startedAtMs),
    );
  }
}

class VoyageMonitorController extends StateNotifier<VoyageMonitorState> {
  VoyageMonitorController(this._prefs, this._audit, this._sessionId)
      : super(_load(_prefs)) {
    if (state.active) _startTicker();
  }

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const activeKey = 'voyageMonitorActive';
  static const nameKey = 'voyageMonitorContactName';
  static const phoneKey = 'voyageMonitorContactPhone';
  static const intervalKey = 'voyageMonitorIntervalMin';
  static const nextDueKey = 'voyageMonitorNextDueMs';
  static const startedKey = 'voyageMonitorStartedAtMs';

  Timer? _ticker;

  static VoyageMonitorState _load(SharedPreferences p) {
    return VoyageMonitorState(
      active: p.getBool(activeKey) ?? false,
      contactName: p.getString(nameKey) ?? '',
      contactPhone: p.getString(phoneKey) ?? '',
      intervalMinutes: p.getInt(intervalKey) ?? 60,
      nextCheckInDueMs: p.getInt(nextDueKey),
      startedAtMs: p.getInt(startedKey),
    );
  }

  Future<void> setContactName(String v) async {
    await _prefs.setString(nameKey, v.trim());
    state = state.copyWith(contactName: v.trim());
  }

  Future<void> setContactPhone(String v) async {
    await _prefs.setString(phoneKey, v.trim());
    state = state.copyWith(contactPhone: v.trim());
  }

  Future<void> setIntervalMinutes(int minutes) async {
    await _prefs.setInt(intervalKey, minutes);
    state = state.copyWith(intervalMinutes: minutes);
  }

  Future<void> start() async {
    final now = DateTime.now();
    final due = now.add(Duration(minutes: state.intervalMinutes));
    await _prefs.setBool(activeKey, true);
    await _prefs.setInt(startedKey, now.millisecondsSinceEpoch);
    await _prefs.setInt(nextDueKey, due.millisecondsSinceEpoch);
    state = state.copyWith(
      active: true,
      nextCheckInDueMs: due.millisecondsSinceEpoch,
      startedAtMs: now.millisecondsSinceEpoch,
    );
    _startTicker();
    await _audit.record(
      sessionId: _sessionId,
      module: 'M12',
      action: 'voyage_monitor_start',
      contextJson:
          '{"intervalMin":${state.intervalMinutes},"contact":"${state.contactName}"}',
    );
  }

  Future<void> stop() async {
    await _prefs.setBool(activeKey, false);
    await _prefs.remove(nextDueKey);
    await _prefs.remove(startedKey);
    _ticker?.cancel();
    state = state.copyWith(active: false, clearSchedule: true);
    await _audit.record(
      sessionId: _sessionId,
      module: 'M12',
      action: 'voyage_monitor_stop',
      contextJson: '{}',
    );
  }

  Future<void> checkInOk() async {
    if (!state.active) return;
    final due = DateTime.now().add(Duration(minutes: state.intervalMinutes));
    await _prefs.setInt(nextDueKey, due.millisecondsSinceEpoch);
    state = state.copyWith(nextCheckInDueMs: due.millisecondsSinceEpoch);
    await _audit.record(
      sessionId: _sessionId,
      module: 'M12',
      action: 'voyage_monitor_ok',
      contextJson: '{"nextDueMs":${due.millisecondsSinceEpoch}}',
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.active) return;
      state = state.copyWith(nextCheckInDueMs: state.nextCheckInDueMs);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
