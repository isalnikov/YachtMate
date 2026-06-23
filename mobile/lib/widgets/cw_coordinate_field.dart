import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_typography.dart';
import 'cw_text_field.dart';

/// Parses and formats nautical coordinates as D°M.mmm' hemisphere.
abstract final class CwCoordinateDms {
  static final RegExp _pattern = RegExp(
    r"^\s*(\d+(?:\.\d+)?)\s*°\s*"
    r"(?:(\d+(?:\.\d+)?)\s*['′]"
  r'(?:(\d+(?:\.\d+)?)\s*["])?'
    r")?\s*"
    r"([NSEW])\s*",
    caseSensitive: false,
  );

  /// Parses a single-axis coordinate string to decimal degrees, or `null` if invalid.
  static double? parse(String input, {required bool isLatitude}) {
    final trimmed = input.trim();
    final match = _pattern.firstMatch(trimmed);
    if (match == null || match.end != trimmed.length) return null;

    final degrees = double.tryParse(match.group(1)!);
    if (degrees == null) return null;

    final minutes = double.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = double.tryParse(match.group(3) ?? '0') ?? 0;
    final hemisphere = match.group(4)!.toUpperCase();

    final validHemispheres = isLatitude ? {'N', 'S'} : {'E', 'W'};
    if (!validHemispheres.contains(hemisphere)) return null;

    final absolute = degrees + minutes / 60 + seconds / 3600;
    final max = isLatitude ? 90.0 : 180.0;
    if (absolute > max) return null;

    return hemisphere == 'S' || hemisphere == 'W' ? -absolute : absolute;
  }

  /// Formats [value] as D°M.mmm' with the appropriate hemisphere letter.
  static String format(double value, {required bool isLatitude}) {
    final pos = isLatitude ? 'N' : 'E';
    final neg = isLatitude ? 'S' : 'W';
    final padDegrees = isLatitude ? 2 : 3;
    final hemisphere = value >= 0 ? pos : neg;
    final absolute = value.abs();
    final degrees = absolute.floor();
    final minutes = (absolute - degrees) * 60;
    final degreesText = degrees.toString().padLeft(padDegrees, '0');
    final minutesText = minutes.toStringAsFixed(3).padLeft(6, '0');
    return '$degreesText°$minutesText\' $hemisphere';
  }

  /// Parses latitude and longitude strings into a [LatLng], or `null` if either is invalid.
  static LatLng? parseLatLng({required String lat, required String lon}) {
    final latitude = parse(lat, isLatitude: true);
    final longitude = parse(lon, isLatitude: false);
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude, longitude);
  }
}

/// Coordinate text field with DMS parse/format and mono tabular styling.
class CwCoordinateField extends StatefulWidget {
  const CwCoordinateField({
    super.key,
    required this.isLatitude,
    this.controller,
    this.label,
    this.errorText,
    this.onChanged,
    this.onValidCoordinate,
  });

  final bool isLatitude;
  final TextEditingController? controller;
  final String? label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<double?>? onValidCoordinate;

  @override
  State<CwCoordinateField> createState() => _CwCoordinateFieldState();
}

class _CwCoordinateFieldState extends State<CwCoordinateField> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    widget.onValidCoordinate?.call(
      CwCoordinateDms.parse(value, isLatitude: widget.isLatitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    return CwTextField(
      controller: _controller,
      label: widget.label,
      errorText: widget.errorText,
      onChanged: _handleChanged,
      style: CwTypography.monoCoords(color: colors.textPrimary),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      semanticLabel: widget.label,
    );
  }
}
