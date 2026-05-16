#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "==> Pushing submodules..."
git -C "$ROOT" submodule foreach --recursive "
  git push
  echo \"  pushed: \$displaypath\"
"

echo
echo "==> Pushing root repo..."
git -C "$ROOT" push
echo "  pushed: root"

echo
echo "Done."
