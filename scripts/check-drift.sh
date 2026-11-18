#!/usr/bin/env bash
# Compares the shared files of every template on the Nix baseline with github-project-template,
# the source of the convention. A template without flake.nix is not on the baseline, so it is skipped.
# The examples keep their own toolchain, so they are not checked.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="$ROOT/templates/github-project-template"

# Files that every template holds unchanged.
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
  docs/adr/0001-documentation-conventions.md
  docs/adr/_template.md
)

# A platform keeps its long form of ADR-0001. Its section of shared terms still matches the source.
PLATFORM=(nextjs-mvp-template sovereign-platform-template)
ADR_0001=docs/adr/0001-documentation-conventions.md

# Prints the section of shared terms of an ADR-0001: from its heading to the next heading.
shared_terms() {
  awk '/^### Shared terms$/ { on = 1 } on && /^##/ && !/^### Shared terms$/ { exit } on' "$1"
}

drift=0
checked=0
for repo in "$ROOT"/templates/*; do
  name="${repo#"$ROOT"/}"
  [[ "$repo" == "$SOURCE" || ! -f "$repo/flake.nix" ]] && continue
  platform=0
  for p in "${PLATFORM[@]}"; do [[ "$name" == "templates/$p" ]] && platform=1; done
  for f in "${SHARED[@]}"; do
    if [[ $platform -eq 1 && "$f" == "$ADR_0001" ]]; then
      if [[ "$(shared_terms "$SOURCE/$f")" != "$(shared_terms "$repo/$f")" ]]; then
        echo "$name: the shared terms of $f differ from github-project-template"
        drift=1
      fi
      continue
    fi
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
  echo "No drift. Templates checked against github-project-template: $checked."
fi
exit $drift
