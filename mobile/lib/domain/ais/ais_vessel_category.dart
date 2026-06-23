/// Demo vessel category for AIS filters (derived from MMSI when static data absent).
enum AisVesselCategory {
  cargo,
  tanker,
  pleasure,
}

/// Deterministic demo mapping from MMSI to filter category.
AisVesselCategory aisCategoryFromMmsi(int mmsi) {
  return switch (mmsi % 3) {
    0 => AisVesselCategory.cargo,
    1 => AisVesselCategory.tanker,
    _ => AisVesselCategory.pleasure,
  };
}

String aisDemoVesselName(int mmsi) => 'Vessel ${mmsi % 100000}';
