import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Centralized user-facing errors (step 58).
enum CwErrorKind {
  network,
  gpsDenied,
  gpsUnavailable,
  vaultDecrypt,
  routingFailed,
  generic,
}

extension CwErrorCatalog on CwErrorKind {
  String message(AppLocalizations l10n) => switch (this) {
        CwErrorKind.network => l10n.errorNetwork,
        CwErrorKind.gpsDenied => l10n.errorGpsDenied,
        CwErrorKind.gpsUnavailable => l10n.errorGpsUnavailable,
        CwErrorKind.vaultDecrypt => l10n.errorVaultDecrypt,
        CwErrorKind.routingFailed => l10n.errorRoutingFailed,
        CwErrorKind.generic => l10n.errorGeneric,
      };
}

void showCwErrorSnackBar(
  BuildContext context,
  CwErrorKind kind,
) {
  final l10n = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(kind.message(l10n))),
  );
}
