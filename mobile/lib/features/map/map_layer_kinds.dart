/// Navionics-style map overlay selection (UI state; tile wiring is later).
enum MapOverlayKind {
  none,
  satellite,
  reliefShading,
  sonar,
}

/// Chart palette / style selection (night mode links to step-26).
enum ChartStyleKind {
  standard,
  paper,
  simple,
  night,
}

extension MapOverlayKindStorage on MapOverlayKind {
  String get storageKey => name;

  static MapOverlayKind fromStorage(String? value) {
    return MapOverlayKind.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MapOverlayKind.none,
    );
  }
}

extension ChartStyleKindStorage on ChartStyleKind {
  String get storageKey => name;

  static ChartStyleKind fromStorage(String? value) {
    return ChartStyleKind.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChartStyleKind.standard,
    );
  }
}
