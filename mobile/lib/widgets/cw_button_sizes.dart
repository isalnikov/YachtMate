/// Touch-target sizes for Captain Wrongel buttons (design-system-spec §4).
enum CwButtonSize {
  /// Compact controls — 36dp min height.
  sm(36, 12, 18),

  /// Default touch target — 44dp min height.
  md(44, 16, 20),

  /// Glove mode touch target — 52dp min height.
  lg(52, 20, 24),

  /// Extra-large actions — 56dp min height.
  xl(56, 24, 28);

  const CwButtonSize(this.minHeight, this.horizontalPadding, this.iconSize);

  final double minHeight;
  final double horizontalPadding;
  final double iconSize;

  /// Returns [lg] when [gloveMode] is on, otherwise [md].
  static CwButtonSize fromGloveMode(bool gloveMode) =>
      gloveMode ? lg : md;
}

/// Circular FAB diameters (Navionics-style map controls, step-09).
enum CwFabSize {
  sm(48, 22),
  lg(56, 26);

  const CwFabSize(this.diameter, this.iconSize);

  final double diameter;
  final double iconSize;

  static CwFabSize fromGloveMode(bool gloveMode) => gloveMode ? lg : sm;
}
