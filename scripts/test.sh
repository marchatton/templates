#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  "vitest.config.*"
  "jest.config.*"
  "playwright.config.*"
  "cypress.config.*"
  "ava.config.*"
  ".mocharc.*"
  "mocha.opts"
  "karma.conf.*"
)

expected="vitest.config.*, jest.config.*, playwright.config.*, cypress.config.*, ava.config.*, .mocharc.*, mocha.opts, karma.conf.*"

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
  echo "Tests skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "Test config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Update scripts/test.sh to run the chosen tool."
exit 1
