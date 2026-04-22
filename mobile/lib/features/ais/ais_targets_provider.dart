import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/ais/ais_target.dart';
import 'ais_targets_controller.dart';

final aisTargetsProvider =
    StateNotifierProvider<AisTargetsController, Map<int, AisTarget>>(
      (ref) => AisTargetsController(),
    );
