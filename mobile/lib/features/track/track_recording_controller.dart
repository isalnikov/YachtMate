import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/energy_profile_controller.dart';
import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/track_repository.dart';

class TrackRecordingState {
  const TrackRecordingState({this.isRecording = false, this.tripId});

  final bool isRecording;
  final String? tripId;
}

class TrackRecordingNotifier extends StateNotifier<TrackRecordingState> {
  TrackRecordingNotifier(this._ref) : super(const TrackRecordingState()) {
    _ref.listen<EnergyProfile>(energyProfileProvider, (prev, next) {
      if (state.isRecording) {
        _restartTimer();
      }
    });
  }

  final Ref _ref;
  Timer? _timer;

  TrackRepository get _repo => _ref.read(trackRepositoryProvider);

  Duration get _interval =>
      _ref.read(energyProfileProvider).trackSamplingInterval;

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      unawaited(_tick());
    });
  }

  Future<void> start() async {
    if (state.isRecording) return;
    final id = await _repo.startTrip();
    state = TrackRecordingState(isRecording: true, tripId: id);
    _restartTimer();
    await _tick();
    _ref.invalidate(activeTrackPointsProvider);
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    final id = state.tripId;
    if (id != null) {
      await _repo.endTrip(id);
    }
    state = const TrackRecordingState();
    _ref.invalidate(activeTrackPointsProvider);
  }

  void cancelTimerOnly() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    final id = state.tripId;
    if (id == null) return;
    try {
      final p = await Geolocator.getCurrentPosition();
      await _repo.appendPoint(
        tripId: id,
        lat: p.latitude,
        lon: p.longitude,
        sog: p.speed,
        cog: p.heading.isNaN ? null : p.heading,
      );
      _ref.invalidate(activeTrackPointsProvider);
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final trackRecordingProvider =
    StateNotifierProvider<TrackRecordingNotifier, TrackRecordingState>((ref) {
      final n = TrackRecordingNotifier(ref);
      ref.onDispose(n.cancelTimerOnly);
      return n;
    });

/// Точки активной записи (пусто, если не пишем).
final activeTrackPointsProvider =
    FutureProvider.autoDispose<List<TrackPointRow>>((ref) async {
      final id = ref.watch(trackRecordingProvider.select((s) => s.tripId));
      if (id == null) return const [];
      return ref.read(trackRepositoryProvider).pointsForTrip(id);
    });

/// Активный рейс (для длительности сессии на экране трека).
final activeTrackTripProvider =
    FutureProvider.autoDispose<TrackTripRow?>((ref) async {
      final id = ref.watch(trackRecordingProvider.select((s) => s.tripId));
      if (id == null) return null;
      return ref.read(trackRepositoryProvider).tripById(id);
    });
