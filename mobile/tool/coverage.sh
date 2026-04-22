#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter test --coverage
echo "--- coverage --"
if command -v lcov >/dev/null 2>&1; then
  lcov --summary coverage/lcov.info
else
  echo "Install lcov for summary (optional)."
fi
