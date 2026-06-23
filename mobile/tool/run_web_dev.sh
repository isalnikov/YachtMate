#!/usr/bin/env bash
# Serve CanvasKit/sqlite wasm from the build output instead of the Flutter CDN.
# Avoids "Incorrect response MIME type" / HTML error pages when the CDN is blocked.
set -euo pipefail
cd "$(dirname "$0")/.."
exec flutter run -d chrome --no-web-resources-cdn "$@"
