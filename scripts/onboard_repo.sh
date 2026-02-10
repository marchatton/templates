#!/usr/bin/env bash
set -euo pipefail

# Scaffold a target repo using canonical templates from this repo.
# Usage: scripts/onboard_repo.sh /path/to/target-repo [--force]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR=""
FORCE_OVERWRITE="${FORCE:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      FORCE_OVERWRITE=1
      shift
      ;;
    -h|--help)
      echo "Usage: scripts/onboard_repo.sh /path/to/target-repo [--force]" >&2
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      echo "Usage: scripts/onboard_repo.sh /path/to/target-repo [--force]" >&2
      exit 1
      ;;
    *)
      if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$1"
        shift
      else
        echo "Usage: scripts/onboard_repo.sh /path/to/target-repo [--force]" >&2
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: scripts/onboard_repo.sh /path/to/target-repo [--force]" >&2
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
CI_WORKFLOW="$ROOT_DIR/.github/workflows/ci.yml"

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

ensure_gitignore() {
  local gitignore_path="$TARGET_DIR/.gitignore"
  local -a desired_lines=(
    "# Local-only scratch"
    "/throwaway/"
    "docs/97-throwaway/"
    "docs/04-projects/**/throwaway/"
    "**.firecrawl/"
    "**.parallel/"
    "**.probe/"
    ""
    "# Onboarding defaults"
    "/node_modules/"
    "**/node_modules/"
    ""
    "# Build outputs"
    ".next/"
    "**/.next/"
    "dist/"
    "**/dist/"
    "coverage/"
    "*.tsbuildinfo"
    ""
    "# Env files (never commit secrets)"
    ".env"
    ".env.*"
    "!.env.example"
    "!.env.template"
    ""
    "# Local-only scratch"
    "tmp/fixture-seed/"
    "tmp/object-store/"
    ""
    "# Ralph agent run artefacts"
    ".ralph"
    "/.ralph/"
    "/.ralph.bad*/"
    ""
    "# macOS"
    ".DS_Store"
    "**/.DS_Store"
  )

  if [[ ! -f "$gitignore_path" ]]; then
    printf "%s\n" "${desired_lines[@]}" > "$gitignore_path"
    return 0
  fi

  local added=0
  local line=""
  for line in "${desired_lines[@]}"; do
    # Avoid injecting blank lines into existing gitignores; keep them for the new-file case above.
    if [[ -z "$line" ]]; then
      continue
    fi
    if ! grep -Fxq -- "$line" "$gitignore_path"; then
      printf "%s\n" "$line" >> "$gitignore_path"
      added=1
    fi
  done

  if [[ "$added" -eq 1 ]]; then
    # Ensure trailing newline for clean diffs
    printf "\n" >> "$gitignore_path"
  fi
}

copy_file() {
  local src="$1"
  local dst="$2"
  local mode="${3:-default}"

  [[ -f "$src" ]] || return 0
  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]]; then
    if [[ "$mode" == "protect" ]]; then
      return 0
    fi
    if [[ "$FORCE_OVERWRITE" -ne 1 ]]; then
      return 0
    fi
  fi

  cp -f "$src" "$dst"
}

copy_tree() {
  local src="$1"
  local dst="$2"

  [[ -d "$src" ]] || return 0
  mkdir -p "$dst"

  if command -v rsync >/dev/null 2>&1; then
    if [[ "$FORCE_OVERWRITE" -eq 1 ]]; then
      rsync -a "$src/" "$dst/"
    else
      rsync -a --ignore-existing "$src/" "$dst/"
    fi
    return 0
  fi

  if [[ "$FORCE_OVERWRITE" -eq 1 ]]; then
    cp -R "$src/." "$dst/"
    return 0
  fi

  while IFS= read -r -d '' file; do
    local rel="${file#$src/}"
    local out="$dst/$rel"
    if [[ ! -e "$out" ]]; then
      mkdir -p "$(dirname "$out")"
      cp -p "$file" "$out"
    fi
  done < <(find "$src" -type f -print0)
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
indent_unit = None

for line in structure:
    raw = line.rstrip('\n')
    if not started:
        if raw.strip() == 'docs/':
            started = True
            stack = ['docs']
            paths.append('docs/')
        continue

    if not raw.startswith(' '):
        # stop when we leave the indented tree
        if raw.strip():
            break
        continue

    # strip comments
    content = raw.split('#', 1)[0].rstrip()
    if not content.strip():
        continue

    indent = len(content) - len(content.lstrip(' '))
    if indent_unit is None:
        indent_unit = indent
        if indent_unit <= 0:
            continue
    if indent_unit <= 0 or indent % indent_unit != 0:
        raise SystemExit("Docs tree indentation must be consistent.")
    level = indent // indent_unit
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
    if [[ "$rel_path" != "docs/" ]]; then
      : > "$TARGET_DIR/$rel_path/.gitkeep"
    fi
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

ensure_gitignore

# Ensure repo-shape directories exist.
mkdir -p "$TARGET_DIR/apps" "$TARGET_DIR/packages" "$TARGET_DIR/tmp" "$TARGET_DIR/throwaway"
if ! grep -Fxq "/packages/" "$TARGET_DIR/.gitignore"; then
  if [[ ! -f "$TARGET_DIR/packages/.gitkeep" ]]; then
    : > "$TARGET_DIR/packages/.gitkeep"
  fi
fi
if [[ ! -f "$TARGET_DIR/tmp/.gitkeep" ]]; then
  : > "$TARGET_DIR/tmp/.gitkeep"
fi

# Copy AGENTS templates into target repo.
mkdir -p "$TARGET_DIR/docs"
copy_file "$TEMPLATES_DIR/AGENTS.root.md" "$TARGET_DIR/AGENTS.md"
copy_file "$TEMPLATES_DIR/AGENTS.docs.md" "$TARGET_DIR/docs/AGENTS.md"

mkdir -p "$TARGET_DIR/apps/web"
copy_file "$TEMPLATES_DIR/AGENTS.web-apps.md" "$TARGET_DIR/apps/web/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/02-guidelines"
copy_file "$TEMPLATES_DIR/AGENTS.guidelines.md" "$TARGET_DIR/docs/02-guidelines/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/03-architecture"
copy_file "$TEMPLATES_DIR/AGENTS.architecture.md" "$TARGET_DIR/docs/03-architecture/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/04-projects"
copy_file "$TEMPLATES_DIR/AGENTS.delivery.md" "$TARGET_DIR/docs/04-projects/AGENTS.md"

mkdir -p "$TARGET_DIR/docs/06-release"
if [[ -f "$TEMPLATES_DIR/AGENTS.release.md" ]]; then
  copy_file "$TEMPLATES_DIR/AGENTS.release.md" "$TARGET_DIR/docs/06-release/AGENTS.md"
fi

# Copy canonical agent surface.
copy_tree "$ROOT_DIR/.agents" "$TARGET_DIR/.agents"

# Copy repo-level scripts.
if [[ -d "$DOC_SCRIPTS_DIR" ]]; then
  copy_tree "$DOC_SCRIPTS_DIR" "$TARGET_DIR/scripts"
  chmod +x "$TARGET_DIR/scripts/"* 2>/dev/null || true
fi

# Copy GitHub Actions CI workflow (Node/pnpm default).
if [[ -f "$CI_WORKFLOW" ]]; then
  copy_file "$CI_WORKFLOW" "$TARGET_DIR/.github/workflows/ci.yml"
fi

# Enable tracked git hooks if this is a git repo.
if git -C "$TARGET_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$TARGET_DIR" config core.hooksPath ".agents/hooks/git"
  chmod +x "$TARGET_DIR/.agents/hooks/git/"* 2>/dev/null || true
fi

# Copy templates for docs content.
copy_file "$DOC_TEMPLATES_DIR/learnings.md" "$TARGET_DIR/docs/learnings.md" "protect"

if [[ -d "$DOC_TEMPLATES_DIR" ]]; then
  mkdir -p "$TARGET_DIR/docs/04-projects/_templates"
  copy_file "$DOC_TEMPLATES_DIR/prd.md" "$TARGET_DIR/docs/04-projects/_templates/prd.md"
  copy_file "$DOC_TEMPLATES_DIR/breadboard.md" "$TARGET_DIR/docs/04-projects/_templates/breadboard.md"
  copy_file "$DOC_TEMPLATES_DIR/spike-plan.md" "$TARGET_DIR/docs/04-projects/_templates/spike-plan.md"
  copy_file "$DOC_TEMPLATES_DIR/pack.md" "$TARGET_DIR/docs/04-projects/_templates/pack.md"
  copy_file "$DOC_TEMPLATES_DIR/release-checklist.md" "$TARGET_DIR/docs/04-projects/_templates/release-checklist.md"
  copy_file "$DOC_TEMPLATES_DIR/json-prd.schema.json" "$TARGET_DIR/docs/04-projects/_templates/json-prd.schema.json"
fi

echo "Onboarding scaffold complete: $TARGET_DIR"
echo "Optional: run npx @iannuttall/dotagents in the target repo to link .agents into other tools."
