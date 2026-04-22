import 'dart:io' show Platform;

/// MapLibre GL Flutter supports Android / iOS / Web only (Linux desktop ≠ supported).
bool chartEngineSupported() => Platform.isAndroid || Platform.isIOS;
