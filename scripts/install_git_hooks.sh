#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hooks_path=".agents/hooks/git"
hooks_src="${root_dir}/${hooks_path}"

if [ ! -d "${hooks_src}" ]; then
  echo "No hooks templates found at ${hooks_src}"
  exit 1
fi

if [ ! -d "${root_dir}/.git" ]; then
  echo "No .git directory found. Skipping hook install."
  exit 0
fi

git -C "${root_dir}" config core.hooksPath "${hooks_path}"
chmod +x "${hooks_src}/"* 2>/dev/null || true

echo "Configured git hooks:"
echo "- core.hooksPath = ${hooks_path}"
echo "- hooks dir = ${hooks_src}"
echo "Hooks:"
ls -1 "${hooks_src}" | sed 's/^/- /'
