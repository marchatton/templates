#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(git node pnpm python3 bash)
missing=0

for cmd in "${required[@]}"; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Missing required command: ${cmd}"
    missing=1
  fi
done

if [ "${missing}" -ne 0 ]; then
  exit 1
fi

echo "Tooling checks: OK"

bash "${root_dir}/scripts/onboard_repo.sh" --list-profiles
bash "${root_dir}/scripts/verify_repo.sh"

echo "doctor OK"
