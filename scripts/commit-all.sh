#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 \"commit message\""
  exit 1
fi

MSG="$1"
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "==> Committing in submodules..."
git -C "$ROOT" submodule foreach --recursive "
  if ! git diff --quiet || ! git diff --cached --quiet || [ -n \"\$(git ls-files --others --exclude-standard)\" ]; then
    git add -A
    git commit -m '$MSG'
    echo \"  committed: \$displaypath\"
  else
    echo \"  nothing to commit: \$displaypath\"
  fi
"

echo
echo "==> Committing in root repo..."
git -C "$ROOT" add -A
if ! git -C "$ROOT" diff --cached --quiet; then
  git -C "$ROOT" commit -m "$MSG"
  echo "  committed: root"
else
  echo "  nothing to commit: root"
fi

echo
echo "Done."
