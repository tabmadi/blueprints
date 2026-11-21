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
  .config/renovate.json
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
  .github/workflows/renovate.yml
  LICENSE
  docs/adr/0001-documentation-conventions.md
  docs/adr/0100-toolchain.md
  docs/adr/0101-source-control-and-ci.md
  docs/adr/0102-dependency-updates.md
  docs/adr/0103-tasks.md
  docs/adr/0104-formatters-and-linters.md
  docs/adr/0105-editor.md
  docs/adr/_template.md
)

# A platform keeps its long form of ADR-0001. Its section of shared terms still matches the source.
PLATFORM=(nextjs-mvp-template sovereign-platform-template)
ADR_0001=docs/adr/0001-documentation-conventions.md
# A platform can add its own package rules and custom managers to the Renovate config, such as a hold on a major
# that its stack cannot take yet. Without those additions, the file still matches the source.
RENOVATE=.github/renovate.json
# A template can add its own lines after the shared lines of .gitattributes, such as a Linguist rule for a file that
# only its stack generates.
GITATTRIBUTES=.gitattributes
# Sovereign runs Renovate for GitHub and Forgejo, with its own groups, per its ADR-0117.
OWN_RENOVATE_RUN=(.config/renovate.json .github/workflows/renovate.yml)

# Prints a Renovate config without the package rules that the source does not have, and without custom managers.
renovate_shared() {
  jq -S --slurpfile src "$SOURCE/$RENOVATE" \
    '.packageRules |= map(select(. as $r | $src[0].packageRules | index([$r]))) | del(.customManagers)' "$1"
}

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
    if [[ "$name" == "templates/sovereign-platform-template" && " ${OWN_RENOVATE_RUN[*]} " == *" $f "* ]]; then
      [[ -f "$repo/$f" ]] || { echo "$name: $f is missing"; drift=1; }
      continue
    fi
    if [[ $platform -eq 1 && "$f" == "$ADR_0001" ]]; then
      if [[ "$(shared_terms "$SOURCE/$f")" != "$(shared_terms "$repo/$f")" ]]; then
        echo "$name: the shared terms of $f differ from github-project-template"
        drift=1
      fi
      continue
    fi
    if [[ $platform -eq 1 && "$f" == "$RENOVATE" && -f "$repo/$f" ]]; then
      if [[ "$(renovate_shared "$SOURCE/$f")" != "$(renovate_shared "$repo/$f")" ]]; then
        echo "$name: $f, without its own package rules, differs from github-project-template"
        drift=1
      fi
      continue
    fi
    if [[ "$f" == "$GITATTRIBUTES" && -f "$repo/$f" ]]; then
      if [[ "$(head -n "$(wc -l <"$SOURCE/$f")" "$repo/$f")" != "$(cat "$SOURCE/$f")" ]]; then
        echo "$name: $f does not start with the lines of github-project-template"
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
