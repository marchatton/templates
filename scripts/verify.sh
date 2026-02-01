#!/usr/bin/env bash
set -euo pipefail

pnpm -s lint
pnpm -s test
pnpm -s build

echo "Verify OK."
