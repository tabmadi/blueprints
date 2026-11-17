#!/usr/bin/env bash
# Compares the shared files of every blueprint on the Nix baseline with github-project-template,
# the source of the convention. A blueprint without flake.nix is not on the baseline, so it is skipped.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="$ROOT/templates/github-project-template"

# Files that every blueprint holds unchanged.
SHARED=(
  .config/cog.toml
  .config/dprint.json
  .config/gitleaks.toml
  .config/rumdl.toml
  .envrc
  .gitattributes
  .github/CODE_OF_CONDUCT.md
  .github/ISSUE_TEMPLATE/bug_report.yml
  .github/ISSUE_TEMPLATE/documentation_improvement.yml
  .github/ISSUE_TEMPLATE/feature_request.yml
  .github/PULL_REQUEST_TEMPLATE.md
  .github/SECURITY.md
  .github/renovate.json
  .github/workflows/check.yml
  LICENSE
)

# Files that every blueprint with ADRs holds unchanged. An example has no ADRs.
SHARED_ADR=(
  docs/adr/0001-documentation-conventions.md
  docs/adr/_template.md
)

drift=0
checked=0
for repo in "$ROOT"/templates/* "$ROOT"/examples/*; do
  name="${repo#"$ROOT"/}"
  [[ "$repo" == "$SOURCE" || ! -f "$repo/flake.nix" ]] && continue
  files=("${SHARED[@]}")
  [[ "$name" == templates/* ]] && files+=("${SHARED_ADR[@]}")
  for f in "${files[@]}"; do
    if [[ ! -f "$repo/$f" ]]; then
      echo "$name: $f is missing"
      drift=1
    elif ! cmp -s "$SOURCE/$f" "$repo/$f"; then
      echo "$name: $f differs from github-project-template"
      drift=1
    fi
  done
  checked=$((checked + 1))
done

if [[ $drift -eq 0 ]]; then
  echo "No drift. Blueprints checked against github-project-template: $checked."
fi
exit $drift
