import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ais_demo_controller.dart';

final aisDemoProvider = StateNotifierProvider<AisDemoController, bool>(
  (ref) => AisDemoController(ref),
);
