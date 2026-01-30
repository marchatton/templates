#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hooks_src="${root_dir}/.agents/hooks/git"

if [ ! -d "${hooks_src}" ]; then
  echo "No hooks templates found at ${hooks_src}"
  exit 1
fi

if [ ! -d "${root_dir}/.git" ]; then
  echo "No .git directory found. Skipping hook install."
  exit 0
fi

hooks_dst="${root_dir}/.git/hooks"
mkdir -p "${hooks_dst}"

installed=()
for hook in "${hooks_src}"/*; do
  name="$(basename "${hook}")"
  dest="${hooks_dst}/${name}"
  cp "${hook}" "${dest}"
  chmod +x "${dest}"
  installed+=("${name}")
done

echo "Installed hooks:"
printf "- %s\n" "${installed[@]}"
