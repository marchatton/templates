#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  ".eslintrc"
  ".eslintrc.*"
  "eslint.config.*"
  ".stylelintrc"
  ".stylelintrc.*"
  "stylelint.config.*"
  ".markdownlint.*"
  ".markdownlint-cli2.*"
)

expected=".eslintrc*, eslint.config.*, .stylelintrc*, stylelint.config.*, .markdownlint*, .markdownlint-cli2.*"

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
  echo "Lint skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "Lint config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Update scripts/lint.sh to run the chosen tool."
exit 1
