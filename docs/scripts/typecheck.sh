#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  "tsconfig.json"
  "tsconfig.*.json"
)

expected="tsconfig.json, tsconfig.*.json"

shopt -s nullglob
found=()
for pattern in "${patterns[@]}"; do
  for path in "${root_dir}/${pattern}"; do
    if [ -f "${path}" ]; then
      found+=("${path#${root_dir}/}")
    fi
  done
done

if [ "${#found[@]}" -eq 0 ]; then
  echo "Typecheck skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "Typecheck config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Optional stub: update scripts/typecheck.sh to run the chosen tool."
exit 0
