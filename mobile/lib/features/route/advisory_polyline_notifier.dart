import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Линия advisory на карте: список (lat, lon) или null.
class AdvisoryPolylineNotifier extends StateNotifier<List<(double, double)>?> {
  AdvisoryPolylineNotifier() : super(null);

  void setPolyline(List<(double, double)>? pts) => state = pts;
}

final advisoryPolylineProvider =
    StateNotifierProvider<AdvisoryPolylineNotifier, List<(double, double)>?>(
      (ref) => AdvisoryPolylineNotifier(),
    );
