#!/usr/bin/env bash
# Check only Dart files changed since the common ancestor of two commits.
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: bash .github/scripts/check-format.sh BASE_REF [HEAD_REF]" >&2
  exit 2
fi

cd "$(git rev-parse --show-toplevel)"
base_commit=$(git rev-parse --verify --end-of-options "${1}^{commit}")
head_commit=$(git rev-parse --verify --end-of-options "${2:-HEAD}^{commit}")
common_commit=$(git merge-base "$base_commit" "$head_commit")

changed_files=$(mktemp)
trap 'rm -f "$changed_files"' EXIT
# A file keeps git errors observable; process substitution would hide its status.
git diff --name-only --diff-filter=ACMR -z "$common_commit" "$head_commit" \
  -- '*.dart' > "$changed_files"

files=()
while IFS= read -r -d '' path; do
  if [[ -f "$path" ]]; then
    files+=("$path")
  fi
done < "$changed_files"

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No changed Dart files to format."
  exit 0
fi

printf 'Checking formatting of %s changed Dart files.\n' "${#files[@]}"
dart format --output=none --set-exit-if-changed -- "${files[@]}"
