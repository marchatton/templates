#!/usr/bin/env bash
set -euo pipefail

# Scaffold a target repo using canonical templates from this repo.
# Usage: scripts/onboard_repo.sh /path/to/target-repo

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: scripts/onboard_repo.sh /path/to/target-repo" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target repo not found: $TARGET_DIR" >&2
  exit 1
fi

STRUCTURE_DOC="$ROOT_DIR/docs/REPO-STRUCTURE.md"
TEMPLATES_DIR="$ROOT_DIR/docs/agentsmd"
DOC_TEMPLATES_DIR="$ROOT_DIR/docs/doc-templates"
DOC_SCRIPTS_DIR="$ROOT_DIR/docs/scripts"

if [[ ! -f "$STRUCTURE_DOC" ]]; then
  echo "Missing structure doc: $STRUCTURE_DOC" >&2
  exit 1
fi

ensure_python3() {
  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
    return 0
  fi

  if ! command -v uv >/dev/null 2>&1; then
    echo "python3 not found and uv is not installed. Install uv or python3 manually." >&2
    exit 1
  fi

  echo "python3 not found; installing via uv..." >&2
  uv python install 3.12
  PYTHON_BIN="$(uv python find 3.12 | head -n 1)"
  if [[ -z "$PYTHON_BIN" ]]; then
    echo "uv python install failed or python path not found." >&2
    exit 1
  fi
}

is_placeholder_path() {
  local rel_path="$1"
  [[ "$rel_path" == *"<"* ]] && return 0
  [[ "$rel_path" == *"YYYY"* ]] && return 0
  return 1
}

add_gitkeep_to_empty_dirs() {
  local base_dir="$1"
  [[ -d "$base_dir" ]] || return 0
  while IFS= read -r -d '' dir; do
    if [[ -z "$(ls -A "$dir")" ]]; then
      : > "$dir/.gitkeep"
    fi
  done < <(find "$base_dir" -type d -print0)
}

ensure_gitignore() {
  local gitignore_path="$TARGET_DIR/.gitignore"
  local added=0

  if [[ ! -f "$gitignore_path" ]]; then
    cat > "$gitignore_path" <<'EOF'
# Onboarding defaults
/throwaway/
/packages/
EOF
    return 0
  fi

  if ! grep -Fxq "/throwaway/" "$gitignore_path"; then
    echo "/throwaway/" >> "$gitignore_path"
    added=1
  fi

  if ! grep -Fxq "/packages/" "$gitignore_path"; then
    echo "/packages/" >> "$gitignore_path"
    added=1
  fi

  if [[ "$added" -eq 1 ]]; then
    # Ensure trailing newline for clean diffs
    printf "\n" >> "$gitignore_path"
  fi
}

# Parse docs tree from REPO-STRUCTURE.md.
PYTHON_BIN="python3"
ensure_python3
DOC_PATHS=$("$PYTHON_BIN" - <<'PY' "$STRUCTURE_DOC"
import sys
from pathlib import Path

structure = Path(sys.argv[1]).read_text().splitlines()

paths = []
stack = []
started = False

for line in structure:
    raw = line.rstrip('\n')
    if not started:
        if raw.strip() == 'docs/':
            started = True
            stack = ['docs']
            paths.append('docs/')
        continue

    if not raw.startswith('  '):
        # stop when we leave the indented tree
        if raw.strip():
            break
        continue

    # strip comments
    content = raw.split('#', 1)[0].rstrip()
    if not content.strip():
        continue

    indent = len(content) - len(content.lstrip(' '))
    level = indent // 2
    name = content.strip()

    if name.startswith('('):
        continue

    is_dir = name.endswith('/')
    name = name[:-1] if is_dir else name

    stack = stack[:level]
    stack.append(name)
    path = '/'.join(stack) + ('/' if is_dir else '')
    paths.append(path)

    if not is_dir:
        stack.pop()

print("\n".join(paths))
PY
)

if [[ -z "$DOC_PATHS" ]]; then
  echo "No docs/ tree found in $STRUCTURE_DOC" >&2
  exit 1
fi

# Build directories and placeholder files.
while IFS= read -r rel_path; do
  [[ -z "$rel_path" ]] && continue
  if [[ "$rel_path" == */ ]]; then
    mkdir -p "$TARGET_DIR/$rel_path"
  else
    if is_placeholder_path "$rel_path"; then
      continue
    fi
    mkdir -p "$(dirname "$TARGET_DIR/$rel_path")"
    if [[ ! -f "$TARGET_DIR/$rel_path" ]]; then
      : > "$TARGET_DIR/$rel_path"
    fi
  fi
done <<< "$DOC_PATHS"

# Copy AGENTS templates into target repo.
mkdir -p "$TARGET_DIR/docs"
cp -f "$TEMPLATES_DIR/AGENTS.root.md" "$TARGET_DIR/AGENTS.md"
cp -f "$TEMPLATES_DIR/AGENTS.docs.md" "$TARGET_DIR/docs/AGENTS.md"

mkdir -p "$TARGET_DIR/apps/web"
cp -f "$TEMPLATES_DIR/AGENTS.web-apps.md" "$TARGET_DIR/apps/web/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/02-guidelines"
cp -f "$TEMPLATES_DIR/AGENTS.guidelines.md" "$TARGET_DIR/docs/02-guidelines/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/03-architecture"
cp -f "$TEMPLATES_DIR/AGENTS.architecture.md" "$TARGET_DIR/docs/03-architecture/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/04-projects"
cp -f "$TEMPLATES_DIR/AGENTS.delivery.md" "$TARGET_DIR/docs/04-projects/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/06-release"
if [[ -f "$TEMPLATES_DIR/AGENTS.release.md" ]]; then
  cp -f "$TEMPLATES_DIR/AGENTS.release.md" "$TARGET_DIR/docs/06-release/AGENTS.md"
fi

# Copy canonical agent surface.
if [[ -d "$ROOT_DIR/.agents" ]]; then
  mkdir -p "$TARGET_DIR/.agents"
  cp -R "$ROOT_DIR/.agents/." "$TARGET_DIR/.agents/"
fi

# Copy repo-level scripts.
if [[ -d "$DOC_SCRIPTS_DIR" ]]; then
  mkdir -p "$TARGET_DIR/scripts"
  cp -R "$DOC_SCRIPTS_DIR/." "$TARGET_DIR/scripts/"
  chmod +x "$TARGET_DIR/scripts/"* 2>/dev/null || true
fi

# Copy templates for docs content.
if [[ -f "$DOC_TEMPLATES_DIR/learnings.md" ]]; then
  cp -f "$DOC_TEMPLATES_DIR/learnings.md" "$TARGET_DIR/docs/learnings.md"
fi

if [[ -d "$DOC_TEMPLATES_DIR" ]]; then
  mkdir -p "$TARGET_DIR/docs/04-projects/_templates"
  cp -f "$DOC_TEMPLATES_DIR/prd.md" "$TARGET_DIR/docs/04-projects/_templates/prd.md" 2>/dev/null || true
  cp -f "$DOC_TEMPLATES_DIR/breadboard.md" "$TARGET_DIR/docs/04-projects/_templates/breadboard.md" 2>/dev/null || true
  cp -f "$DOC_TEMPLATES_DIR/spike-plan.md" "$TARGET_DIR/docs/04-projects/_templates/spike-plan.md" 2>/dev/null || true
  cp -f "$DOC_TEMPLATES_DIR/pack.md" "$TARGET_DIR/docs/04-projects/_templates/pack.md" 2>/dev/null || true
  cp -f "$DOC_TEMPLATES_DIR/release-checklist.md" "$TARGET_DIR/docs/04-projects/_templates/release-checklist.md" 2>/dev/null || true
  cp -f "$DOC_TEMPLATES_DIR/json-prd.schema.json" "$TARGET_DIR/docs/04-projects/_templates/json-prd.schema.json" 2>/dev/null || true
fi

add_gitkeep_to_empty_dirs "$TARGET_DIR/docs"
ensure_gitignore

echo "Onboarding scaffold complete: $TARGET_DIR"
echo "Optional: run npx @iannuttall/dotagents in the target repo to link .agents into other tools."
