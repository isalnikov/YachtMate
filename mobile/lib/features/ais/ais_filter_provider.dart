import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/ais/ais_vessel_category.dart';

/// Active vessel-type filter; `null` shows all categories.
enum AisFilterSelection {
  all,
  cargo,
  tanker,
  pleasure,
}

extension AisFilterSelectionX on AisFilterSelection {
  bool matches(AisVesselCategory category) => switch (this) {
        AisFilterSelection.all => true,
        AisFilterSelection.cargo =>
          category == AisVesselCategory.cargo,
        AisFilterSelection.tanker =>
          category == AisVesselCategory.tanker,
        AisFilterSelection.pleasure =>
          category == AisVesselCategory.pleasure,
      };
}

final aisFilterProvider = StateProvider<AisFilterSelection>(
  (ref) => AisFilterSelection.all,
);
