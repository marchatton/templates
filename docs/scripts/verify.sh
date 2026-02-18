#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "${root_dir}/scripts/lint.sh"
bash "${root_dir}/scripts/test.sh"
bash "${root_dir}/scripts/build.sh"

echo "Verify OK."
