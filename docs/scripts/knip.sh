#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  "knip.json"
  ".knip.json"
  "knip.jsonc"
  ".knip.jsonc"
  "knip.config.js"
  "knip.config.cjs"
  "knip.config.mjs"
  "knip.config.ts"
  "knip.config.mts"
  "knip.config.cts"
)

expected="knip.json, .knip.json, knip.jsonc, .knip.jsonc, knip.config.{js,cjs,mjs,ts,mts,cts}, package.json#knip"

shopt -s nullglob
found=()
for pattern in "${patterns[@]}"; do
  for path in "${root_dir}/${pattern}"; do
    if [ -f "${path}" ]; then
      found+=("${path#${root_dir}/}")
    fi
  done
done

if command -v node >/dev/null 2>&1; then
  if node -e "const pkg=require('./package.json'); process.exit(pkg.knip ? 0 : 1)" 2>/dev/null; then
    found+=("package.json#knip")
  fi
fi

if [ "${#found[@]}" -eq 0 ]; then
  echo "Knip skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "Knip config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Optional stub: update scripts/knip.sh to run the chosen tool."
exit 0
