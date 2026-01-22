#!/usr/bin/env bash
# Install git hooks templates
# Run from target repo root: /path/to/templates/scripts/install_git_hooks.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_ROOT/hooks/git"
DEST_DIR=".git/hooks"

if [ ! -d ".git" ]; then
  echo "Error: Not in a git repository root (no .git/ directory found)"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: hooks/git/ directory not found at $SOURCE_DIR"
  exit 1
fi

mkdir -p "$DEST_DIR"

echo "Installing git hooks to $DEST_DIR..."

installed=0
for file in "$SOURCE_DIR"/*.sample; do
  [ -e "$file" ] || continue
  filename=$(basename "$file")
  hookname="${filename%.sample}"
  
  # Copy and rename (remove .sample)
  cp "$file" "$DEST_DIR/$hookname"
  chmod +x "$DEST_DIR/$hookname"
  echo "  Installed: $hookname"
  ((installed++)) || true
done

if [ $installed -eq 0 ]; then
  echo "No hook templates found in $SOURCE_DIR"
else
  echo ""
  echo "Installed $installed hook(s) to $DEST_DIR"
  echo ""
  echo "Note: Hooks are templates - edit to enable checks."
  echo "Hooks run pnpm scripts only if package.json exists and script is defined."
fi
