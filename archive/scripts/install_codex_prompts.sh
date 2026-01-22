#!/usr/bin/env bash
# Install commands to ~/.codex/prompts/ for Codex
# Run from templates repo root: ./scripts/install_codex_prompts.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_ROOT/commands"
DEST_DIR="$HOME/.codex/prompts"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: commands/ directory not found at $SOURCE_DIR"
  exit 1
fi

mkdir -p "$DEST_DIR"

echo "Installing commands to $DEST_DIR..."

changed=0
for file in "$SOURCE_DIR"/*.md; do
  [ -e "$file" ] || continue
  filename=$(basename "$file")
  
  if [ -f "$DEST_DIR/$filename" ]; then
    if ! diff -q "$file" "$DEST_DIR/$filename" > /dev/null 2>&1; then
      cp "$file" "$DEST_DIR/$filename"
      echo "  Updated: $filename"
      ((changed++)) || true
    fi
  else
    cp "$file" "$DEST_DIR/$filename"
    echo "  Added: $filename"
    ((changed++)) || true
  fi
done

if [ $changed -eq 0 ]; then
  echo "No changes needed - all commands up to date."
else
  echo "Installed $changed command(s) to $DEST_DIR"
fi

echo ""
echo "Invoke commands in Codex with: /prompts:<command-name>"
echo "Example: /prompts:wf-plan"
