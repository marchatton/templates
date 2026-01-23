#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  "vite.config.*"
  "webpack.config.*"
  "rollup.config.*"
  "parcel.config.*"
  ".parcelrc"
  "esbuild.config.*"
  "tsup.config.*"
  "next.config.*"
  "nuxt.config.*"
  "astro.config.*"
  "svelte.config.*"
  "gulpfile.*"
  "turbo.json"
  "nx.json"
)

expected="vite.config.*, webpack.config.*, rollup.config.*, parcel.config.*, .parcelrc, esbuild.config.*, tsup.config.*, next.config.*, nuxt.config.*, astro.config.*, svelte.config.*, gulpfile.*, turbo.json, nx.json"

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
  echo "Build skipped: no config found."
  echo "Expected one of: ${expected}"
  exit 0
fi

echo "Build config detected but no runner wired:"
printf -- "- %s\n" "${found[@]}"
echo "Update scripts/build.sh to run the chosen tool."
exit 1
