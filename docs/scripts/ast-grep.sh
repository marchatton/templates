#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  "sgconfig.yml"
  "sgconfig.yaml"
  ".sgconfig.yml"
  ".sgconfig.yaml"
)

expected="sgconfig.yml, sgconfig.yaml, .sgconfig.yml, .sgconfig.yaml, .ast-grep/"

shopt -s nullglob
found=()
for pattern in "${patterns[@]}"; do
  for path in "${root_dir}/${pattern}"; do
    if [ -f "${path}" ]; then
      found+=("${path#${root_dir}/}")
    fi
  done
done

if [ -d "${root_dir}/.ast-grep" ]; then
  found+=(".ast-grep/")
fi

if [ "${#found[@]}" -eq 0 ]; then
  echo "ast-grep skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "ast-grep config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Optional stub: update scripts/ast-grep.sh to run the chosen tool."
exit 0
