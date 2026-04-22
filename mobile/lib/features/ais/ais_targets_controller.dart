import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/ais/ais_target.dart';
import '../../domain/ais/aivdm_position_report.dart';

class AisTargetsController extends StateNotifier<Map<int, AisTarget>> {
  AisTargetsController() : super(const {});

  void upsertFromReport(AisPositionReport r) {
    state = {
      ...state,
      r.mmsi: AisTarget(
        mmsi: r.mmsi,
        latitudeDeg: r.latitudeDeg,
        longitudeDeg: r.longitudeDeg,
        sogKnots: r.sogKnots,
        cogDegrees: r.cogDegrees,
        updatedAtUtc: DateTime.now().toUtc(),
      ),
    };
  }

  void clear() => state = const {};
}
