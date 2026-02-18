#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETTINGS_FILE="$ROOT_DIR/scaffold/settings.json"
DOCS_PROFILES_FILE="$ROOT_DIR/docs/REPO-STRUCTURE.profiles.json"
STRUCTURE_DOC="$ROOT_DIR/docs/REPO-STRUCTURE.md"
TEMPLATES_DIR="$ROOT_DIR/docs/agentsmd"
DOC_TEMPLATES_DIR="$ROOT_DIR/docs/doc-templates"
DOC_SCRIPTS_DIR="$ROOT_DIR/docs/scripts"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/ci.yml"

TARGET_DIR=""
FORCE_OVERWRITE="${FORCE:-0}"
PROFILE=""
STACK=""
YES=0
DRY_RUN=0
DRY_RUN_EXPLICIT=0
APPLY=0
LIST_PROFILES=0

EXISTING_REPO_MODE=0
ALLOW_DIRTY=0

DOCS_OVERRIDE=""
SKILLS_OVERRIDE=""
AGENTS_OVERRIDE=""
SKILLS_PACK_OVERRIDE=""

DOCS_ENABLED=0
SKILLS_ENABLED=0
AGENTS_ENABLED=0
DOCS_PROFILE=""
AGENTS_PROFILE=""
SKILLS_PACK=""
DEFAULT_PROFILE="minimal"

usage() {
  cat >&2 <<'USAGE'
Usage:
  scripts/onboard_repo.sh /path/to/target-repo [options]

Core options:
  --profile <minimal|full>  Select scaffold profile (default from scaffold/settings.json)
  --stack <name>            Optional stack hint stored in scaffold state metadata
  --yes                     Skip interactive confirmations
  --dry-run                 Print plan only, do not write files
  --apply                   Execute writes (required for existing repos)
  --list-profiles           Print available profiles and exit

Surface overrides:
  --docs / --no-docs
  --skills / --no-skills
  --agents / --no-agents
  --skills-pack <core|extended>

Existing repo safety:
  --existing-repo           Confirm in-place onboarding for an existing git repo
  --allow-dirty             Allow apply with uncommitted changes

Other:
  -f, --force               Overwrite scaffold-managed files when they already exist
  -h, --help                Show help

Notes:
- Existing repos default to dry-run plan mode. Re-run with --apply after review.
- Existing repos must not apply from main/master/trunk.
USAGE
}

copy_file() {
  local src="$1"
  local dst="$2"
  local mode="${3:-default}"

  [[ -f "$src" ]] || return 0

  if [[ -f "$dst" ]]; then
    if [[ "$mode" == "protect" ]]; then
      return 0
    fi
    if [[ "$FORCE_OVERWRITE" -ne 1 ]]; then
      return 0
    fi
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy file: $src -> $dst"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp -f "$src" "$dst"
}

copy_tree() {
  local src="$1"
  local dst="$2"

  [[ -d "$src" ]] || return 0

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy tree: $src -> $dst"
    return 0
  fi

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

merge_managed_block() {
  local src="$1"
  local dst="$2"
  local label="$3"

  [[ -f "$src" ]] || return 0

  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -f "$dst" ]]; then
      echo "[dry-run] merge managed block ($label): $src -> $dst"
    else
      echo "[dry-run] copy managed file ($label): $src -> $dst"
    fi
    return 0
  fi

  if [[ ! -f "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -f "$src" "$dst"
    return 0
  fi

  if [[ "$FORCE_OVERWRITE" -eq 1 ]]; then
    cp -f "$src" "$dst"
    return 0
  fi

  python3 - "$src" "$dst" "$label" <<'PY'
from pathlib import Path
import re
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
label = sys.argv[3]

begin = f"<!-- agent-skills:begin {label} -->"
end = f"<!-- agent-skills:end {label} -->"
managed = src.read_text(encoding="utf-8").rstrip() + "\n"
block = f"{begin}\n{managed}{end}\n"

existing = dst.read_text(encoding="utf-8")
pattern = re.compile(re.escape(begin) + r"\n[\s\S]*?" + re.escape(end) + r"\n?", re.M)

if pattern.search(existing):
    merged = pattern.sub(block, existing, count=1)
else:
    tail = "" if existing.endswith("\n") else "\n"
    merged = f"{existing}{tail}\n{block}"

dst.write_text(merged.rstrip() + "\n", encoding="utf-8")
PY
}

ensure_python3() {
  if command -v python3 >/dev/null 2>&1; then
    return 0
  fi

  if ! command -v uv >/dev/null 2>&1; then
    echo "python3 not found and uv is not installed. Install uv or python3 manually." >&2
    exit 1
  fi

  echo "python3 not found; installing via uv..." >&2
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] uv python install 3.12"
    return 0
  fi
  uv python install 3.12
}

is_placeholder_path() {
  local rel_path="$1"
  [[ "$rel_path" == *"<"* ]] && return 0
  [[ "$rel_path" == *"YYYY"* ]] && return 0
  return 1
}

load_settings() {
  [[ -f "$SETTINGS_FILE" ]] || {
    echo "Missing scaffold settings file: $SETTINGS_FILE" >&2
    exit 1
  }

  eval "$(python3 - "$SETTINGS_FILE" <<'PY'
import json
import shlex
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
def q(s: str) -> str:
    return shlex.quote(str(s))

default_profile = settings.get("defaultProfile", "minimal")
profile_names = " ".join(settings.get("profiles", {}).keys())
print("DEFAULT_PROFILE=" + q(default_profile))
print("PROFILES=" + q(profile_names))
PY
)"

  if [[ -z "$PROFILE" ]]; then
    PROFILE="$DEFAULT_PROFILE"
  fi

  eval "$(python3 - "$SETTINGS_FILE" "$PROFILE" <<'PY'
import json
import shlex
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
profile = sys.argv[2]
profiles = settings.get("profiles", {})

if profile not in profiles:
    print("PROFILE_FOUND=0")
    sys.exit(0)

p = profiles[profile]
surfaces = p.get("surfaces", {})

def b(v):
    return "1" if bool(v) else "0"

def q(s: str) -> str:
    return shlex.quote(str(s))

print("PROFILE_FOUND=1")
print("PROFILE_DOCS=" + b(surfaces.get("docs", True)))
print("PROFILE_SKILLS=" + b(surfaces.get("skills", True)))
print("PROFILE_AGENTS=" + b(surfaces.get("agents", True)))
print("PROFILE_DOCS_PROFILE=" + q(p.get("docsProfile", profile)))
print("PROFILE_AGENTS_PROFILE=" + q(p.get("agentsProfile", profile)))
print("PROFILE_SKILLS_PACK=" + q(p.get("skillsPack", "core")))
PY
)"

  if [[ "$PROFILE_FOUND" -ne 1 ]]; then
    echo "Unknown profile: $PROFILE" >&2
    echo "Available profiles: $PROFILES" >&2
    exit 1
  fi

  DOCS_ENABLED="$PROFILE_DOCS"
  SKILLS_ENABLED="$PROFILE_SKILLS"
  AGENTS_ENABLED="$PROFILE_AGENTS"

  DOCS_PROFILE="$PROFILE_DOCS_PROFILE"
  AGENTS_PROFILE="$PROFILE_AGENTS_PROFILE"
  SKILLS_PACK="$PROFILE_SKILLS_PACK"

  if [[ -n "$DOCS_OVERRIDE" ]]; then DOCS_ENABLED="$DOCS_OVERRIDE"; fi
  if [[ -n "$SKILLS_OVERRIDE" ]]; then SKILLS_ENABLED="$SKILLS_OVERRIDE"; fi
  if [[ -n "$AGENTS_OVERRIDE" ]]; then AGENTS_ENABLED="$AGENTS_OVERRIDE"; fi
  if [[ -n "$SKILLS_PACK_OVERRIDE" ]]; then SKILLS_PACK="$SKILLS_PACK_OVERRIDE"; fi
}

list_profiles() {
  [[ -f "$SETTINGS_FILE" ]] || {
    echo "Missing scaffold settings file: $SETTINGS_FILE" >&2
    exit 1
  }

  python3 - "$SETTINGS_FILE" <<'PY'
import json
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
profiles = settings.get("profiles", {})
print("Profiles:")
for name, cfg in profiles.items():
    surfaces = cfg.get("surfaces", {})
    docs = "on" if surfaces.get("docs", True) else "off"
    skills = "on" if surfaces.get("skills", True) else "off"
    agents = "on" if surfaces.get("agents", True) else "off"
    print(f"- {name}: docs={docs}, skills={skills}, agents={agents}, skillsPack={cfg.get('skillsPack', 'core')}")
PY
}

load_docs_paths() {
  local profile_name="$1"

  if [[ "$profile_name" == "full" ]]; then
    [[ -f "$STRUCTURE_DOC" ]] || {
      echo "Missing structure doc: $STRUCTURE_DOC" >&2
      exit 1
    }

    python3 - <<'PY' "$STRUCTURE_DOC"
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
        if raw.strip():
            break
        continue

    content = raw.split('#', 1)[0].rstrip()
    if not content.strip():
        continue

    indent = len(content) - len(content.lstrip(' '))
    if indent_unit is None:
        indent_unit = indent
        if indent_unit <= 0:
            continue

    if indent_unit <= 0 or indent % indent_unit != 0:
        raise SystemExit('Docs tree indentation must be consistent.')

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

print('\n'.join(paths))
PY
    return
  fi

  [[ -f "$DOCS_PROFILES_FILE" ]] || {
    echo "Missing docs profile metadata: $DOCS_PROFILES_FILE" >&2
    exit 1
  }

  python3 - "$DOCS_PROFILES_FILE" "$profile_name" <<'PY'
import json
import sys

meta = json.load(open(sys.argv[1], encoding="utf-8"))
profile = sys.argv[2]
profiles = meta.get("profiles", {})
if profile not in profiles:
    raise SystemExit(f"Unknown docs profile: {profile}")

paths = profiles[profile].get("paths", [])
print("\n".join(paths))
PY
}

agent_templates_for_profile() {
  local profile_name="$1"
  python3 - "$SETTINGS_FILE" "$profile_name" <<'PY'
import json
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
profiles = settings.get("agentsProfiles", {})
profile = sys.argv[2]
if profile not in profiles:
    raise SystemExit(f"Unknown agents profile: {profile}")
print("\n".join(profiles[profile]))
PY
}

skills_pack_dirs() {
  local pack_name="$1"
  python3 - "$SETTINGS_FILE" "$pack_name" <<'PY'
import json
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
packs = settings.get("skillsPacks", {})
pack = sys.argv[2]
if pack not in packs:
    raise SystemExit(f"Unknown skills pack: {pack}")
entry = packs[pack]
mode = entry.get("copyMode", "directories")
print(f"MODE={mode}")
for item in entry.get("directories", []):
    print(item)
PY
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
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] create .gitignore at $gitignore_path"
      return 0
    fi
    printf "%s\n" "${desired_lines[@]}" > "$gitignore_path"
    return 0
  fi

  local added=0
  local line=""
  for line in "${desired_lines[@]}"; do
    if [[ -z "$line" ]]; then
      continue
    fi
    if ! grep -Fxq -- "$line" "$gitignore_path"; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[dry-run] append to .gitignore: $line"
      else
        printf "%s\n" "$line" >> "$gitignore_path"
      fi
      added=1
    fi
  done

  if [[ "$added" -eq 1 && "$DRY_RUN" -ne 1 ]]; then
    printf "\n" >> "$gitignore_path"
  fi
}

apply_docs_tree() {
  local docs_paths="$1"

  while IFS= read -r rel_path; do
    [[ -z "$rel_path" ]] && continue

    if [[ "$rel_path" == */ ]]; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[dry-run] mkdir -p $TARGET_DIR/$rel_path"
      else
        mkdir -p "$TARGET_DIR/$rel_path"
      fi
      if [[ "$rel_path" != "docs/" ]]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
          echo "[dry-run] touch $TARGET_DIR/$rel_path/.gitkeep"
        else
          : > "$TARGET_DIR/$rel_path/.gitkeep"
        fi
      fi
      continue
    fi

    if is_placeholder_path "$rel_path"; then
      continue
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] ensure file $TARGET_DIR/$rel_path"
      continue
    fi

    mkdir -p "$(dirname "$TARGET_DIR/$rel_path")"
    if [[ ! -f "$TARGET_DIR/$rel_path" ]]; then
      : > "$TARGET_DIR/$rel_path"
    fi
  done <<< "$docs_paths"
}

write_generated_docs_structure() {
  local docs_paths="$1"
  local out="$TARGET_DIR/docs/REPO-STRUCTURE.generated.md"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] write generated docs structure: $out"
    return 0
  fi

  mkdir -p "$(dirname "$out")"

  {
    echo "# Generated Docs Structure"
    echo
    echo "- Profile: $PROFILE"
    echo "- Docs profile: $DOCS_PROFILE"
    echo "- Stack: ${STACK:-unspecified}"
    echo "- Generated by: scripts/onboard_repo.sh"
    echo
    while IFS= read -r rel_path; do
      [[ -z "$rel_path" ]] && continue
      echo "- \`$rel_path\`"
    done <<< "$docs_paths"
  } > "$out"
}

apply_docs_templates() {
  local docs_readme_template="$DOC_TEMPLATES_DIR/docs-readme.md"
  local arch_template="$DOC_TEMPLATES_DIR/architecture-high-level-design.md"
  local release_template="$DOC_TEMPLATES_DIR/release-changelog.md"
  local projects_template="$DOC_TEMPLATES_DIR/projects-readme.md"
  local dossier_template="$DOC_TEMPLATES_DIR/dossier-starter.md"

  copy_file "$DOC_TEMPLATES_DIR/learnings.md" "$TARGET_DIR/docs/learnings.md" "protect"

  if [[ "$EXISTING_REPO_MODE" -eq 1 ]]; then
    merge_managed_block "$docs_readme_template" "$TARGET_DIR/docs/README.md" "docs-readme"
  else
    copy_file "$docs_readme_template" "$TARGET_DIR/docs/README.md" "protect"
  fi

  copy_file "$arch_template" "$TARGET_DIR/docs/03-architecture/high-level-design.md" "protect"
  copy_file "$release_template" "$TARGET_DIR/docs/06-release/CHANGELOG.md" "protect"
  copy_file "$projects_template" "$TARGET_DIR/docs/04-projects/README.md" "protect"
  copy_file "$dossier_template" "$TARGET_DIR/docs/04-projects/_templates/dossier-starter.md" "protect"
}

apply_agent_templates() {
  local agent_keys
  agent_keys="$(agent_templates_for_profile "$AGENTS_PROFILE")"

  local key=""
  local src=""
  local dst=""

  while IFS= read -r key; do
    [[ -z "$key" ]] && continue

    case "$key" in
      AGENTS.root)
        src="$TEMPLATES_DIR/AGENTS.root.md"
        dst="$TARGET_DIR/AGENTS.md"
        ;;
      AGENTS.docs)
        src="$TEMPLATES_DIR/AGENTS.docs.md"
        dst="$TARGET_DIR/docs/AGENTS.md"
        ;;
      AGENTS.web-apps)
        src="$TEMPLATES_DIR/AGENTS.web-apps.md"
        dst="$TARGET_DIR/apps/web/AGENTS.md"
        ;;
      AGENTS.guidelines)
        src="$TEMPLATES_DIR/AGENTS.guidelines.md"
        dst="$TARGET_DIR/docs/02-guidelines/AGENTS.md"
        ;;
      AGENTS.architecture)
        src="$TEMPLATES_DIR/AGENTS.architecture.md"
        dst="$TARGET_DIR/docs/03-architecture/AGENTS.md"
        ;;
      AGENTS.delivery)
        src="$TEMPLATES_DIR/AGENTS.delivery.md"
        dst="$TARGET_DIR/docs/04-projects/AGENTS.md"
        ;;
      AGENTS.release)
        src="$TEMPLATES_DIR/AGENTS.release.md"
        dst="$TARGET_DIR/docs/06-release/AGENTS.md"
        ;;
      *)
        echo "Unknown agent template key: $key" >&2
        exit 1
        ;;
    esac

    if [[ "$EXISTING_REPO_MODE" -eq 1 ]]; then
      merge_managed_block "$src" "$dst" "$key"
    else
      copy_file "$src" "$dst"
    fi
  done <<< "$agent_keys"
}

apply_skills_pack() {
  local mode_and_dirs
  mode_and_dirs="$(skills_pack_dirs "$SKILLS_PACK")"

  local mode_line
  mode_line="$(printf "%s\n" "$mode_and_dirs" | head -n 1)"
  local mode="${mode_line#MODE=}"

  copy_file "$ROOT_DIR/.agents/register.json" "$TARGET_DIR/.agents/register.json"
  copy_tree "$ROOT_DIR/.agents/commands" "$TARGET_DIR/.agents/commands"
  copy_tree "$ROOT_DIR/.agents/hooks" "$TARGET_DIR/.agents/hooks"

  if [[ "$mode" == "all" ]]; then
    copy_tree "$ROOT_DIR/.agents/skills" "$TARGET_DIR/.agents/skills"
  else
    local path=""
    while IFS= read -r path; do
      [[ -z "$path" || "$path" == MODE=* ]] && continue
      copy_tree "$ROOT_DIR/$path" "$TARGET_DIR/$path"
    done <<< "$mode_and_dirs"
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] filter .agents/register.json to copied skills"
    return 0
  fi

  python3 - "$TARGET_DIR/.agents/register.json" <<'PY'
import json
from pathlib import Path
import sys

register_path = Path(sys.argv[1])
if not register_path.exists():
    raise SystemExit(0)

register = json.loads(register_path.read_text(encoding="utf-8"))
entries = register.get("entries", {})
skills = entries.get("skills", [])

filtered = []
for skill in skills:
    location = skill.get("location")
    if not location:
        continue
    target = register_path.parent.parent / location
    if target.exists():
        filtered.append(skill)

entries["skills"] = filtered
register["entries"] = entries
register_path.write_text(json.dumps(register, indent=2) + "\n", encoding="utf-8")
PY
}

configure_git_hooks() {
  if [[ "$SKILLS_ENABLED" -ne 1 ]]; then
    return 0
  fi

  if ! git -C "$TARGET_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] git -C $TARGET_DIR config core.hooksPath .agents/hooks/git"
    return 0
  fi

  git -C "$TARGET_DIR" config core.hooksPath ".agents/hooks/git"
  chmod +x "$TARGET_DIR/.agents/hooks/git/"* 2>/dev/null || true
}

write_scaffold_state() {
  local state_file="$TARGET_DIR/.agent-skills.scaffold.json"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] write scaffold state: $state_file"
    return 0
  fi

  python3 - "$state_file" <<'PY'
import json
from datetime import datetime, UTC
import os
import sys

state_file = sys.argv[1]
state = {
    "generatedAt": datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "profile": os.environ.get("PROFILE"),
    "stack": os.environ.get("STACK") or None,
    "surfaces": {
        "docs": os.environ.get("DOCS_ENABLED") == "1",
        "skills": os.environ.get("SKILLS_ENABLED") == "1",
        "agents": os.environ.get("AGENTS_ENABLED") == "1",
    },
    "docsProfile": os.environ.get("DOCS_PROFILE"),
    "agentsProfile": os.environ.get("AGENTS_PROFILE"),
    "skillsPack": os.environ.get("SKILLS_PACK"),
}
with open(state_file, "w", encoding="utf-8") as fh:
    json.dump(state, fh, indent=2)
    fh.write("\n")
PY
}

print_plan() {
  echo "Scaffold plan"
  echo "- target: $TARGET_DIR"
  echo "- profile: $PROFILE"
  echo "- stack: ${STACK:-unspecified}"
  echo "- surfaces: docs=$DOCS_ENABLED, skills=$SKILLS_ENABLED, agents=$AGENTS_ENABLED"
  echo "- docs profile: $DOCS_PROFILE"
  echo "- agents profile: $AGENTS_PROFILE"
  echo "- skills pack: $SKILLS_PACK"
  echo "- existing repo mode: $EXISTING_REPO_MODE"
  echo "- dry-run: $DRY_RUN"
}

is_existing_repo_with_history() {
  local target="$1"

  if ! git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
    return 1
  fi

  if ! git -C "$target" rev-parse --verify HEAD >/dev/null 2>&1; then
    return 1
  fi

  return 0
}

preflight_existing_repo() {
  local target="$1"
  local current_branch=""
  local protected_branch=""

  if ! is_existing_repo_with_history "$target"; then
    return 0
  fi

  if [[ "$EXISTING_REPO_MODE" -ne 1 ]]; then
    echo "Existing git repo detected at: $target" >&2
    echo "Create an onboarding branch, then rerun with --existing-repo." >&2
    echo "Example:" >&2
    echo "  git -C \"$target\" switch -c chore/agent-skills-onboarding" >&2
    echo "  $ROOT_DIR/scripts/onboard_repo.sh \"$target\" --existing-repo --dry-run" >&2
    exit 1
  fi

  if [[ "$APPLY" -ne 1 && "$DRY_RUN_EXPLICIT" -ne 1 ]]; then
    DRY_RUN=1
  fi

  current_branch="$(git -C "$target" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  for protected_branch in main master trunk; do
    if [[ "$current_branch" == "$protected_branch" ]]; then
      echo "Refusing to onboard existing repo on '$current_branch'." >&2
      echo "Create and switch to a dedicated onboarding branch first:" >&2
      echo "  git -C \"$target\" switch -c chore/agent-skills-onboarding" >&2
      exit 1
    fi
  done

  if [[ "$DRY_RUN" -ne 1 && "$ALLOW_DIRTY" -ne 1 ]]; then
    if [[ -n "$(git -C "$target" status --porcelain)" ]]; then
      echo "Working tree is not clean in: $target" >&2
      echo "Commit or stash changes, then rerun." >&2
      echo "If you intentionally want to proceed on a dirty tree, use --allow-dirty." >&2
      exit 1
    fi
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      FORCE_OVERWRITE=1
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --stack)
      STACK="${2:-}"
      shift 2
      ;;
    --yes)
      YES=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      DRY_RUN_EXPLICIT=1
      shift
      ;;
    --apply)
      APPLY=1
      DRY_RUN=0
      shift
      ;;
    --list-profiles)
      LIST_PROFILES=1
      shift
      ;;
    --docs)
      DOCS_OVERRIDE=1
      shift
      ;;
    --no-docs)
      DOCS_OVERRIDE=0
      shift
      ;;
    --skills)
      SKILLS_OVERRIDE=1
      shift
      ;;
    --no-skills)
      SKILLS_OVERRIDE=0
      shift
      ;;
    --agents)
      AGENTS_OVERRIDE=1
      shift
      ;;
    --no-agents)
      AGENTS_OVERRIDE=0
      shift
      ;;
    --skills-pack)
      SKILLS_PACK_OVERRIDE="${2:-}"
      shift 2
      ;;
    --existing-repo)
      EXISTING_REPO_MODE=1
      shift
      ;;
    --allow-dirty)
      ALLOW_DIRTY=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$1"
        shift
      else
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ "$LIST_PROFILES" -eq 1 ]]; then
  list_profiles
  exit 0
fi

if [[ -z "$TARGET_DIR" ]]; then
  usage
  exit 1
fi

load_settings
ensure_python3

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] mkdir -p $TARGET_DIR"
  else
    mkdir -p "$TARGET_DIR"
  fi
fi

preflight_existing_repo "$TARGET_DIR"
print_plan

if [[ "$DRY_RUN" -eq 1 ]]; then
  if [[ "$DOCS_ENABLED" -eq 1 ]]; then
    echo "Planned docs paths (first 12):"
    load_docs_paths "$DOCS_PROFILE" | head -n 12 | sed 's/^/- /'
  fi

  if [[ "$EXISTING_REPO_MODE" -eq 1 && "$APPLY" -ne 1 ]]; then
    echo
    echo "Dry-run complete. Apply with:"
    echo "  $ROOT_DIR/scripts/onboard_repo.sh \"$TARGET_DIR\" --existing-repo --apply --profile $PROFILE"
  fi
  exit 0
fi

ensure_gitignore
mkdir -p "$TARGET_DIR/apps" "$TARGET_DIR/packages" "$TARGET_DIR/tmp" "$TARGET_DIR/throwaway"

if [[ ! -f "$TARGET_DIR/tmp/.gitkeep" ]]; then
  : > "$TARGET_DIR/tmp/.gitkeep"
fi
if [[ ! -f "$TARGET_DIR/packages/.gitkeep" ]]; then
  : > "$TARGET_DIR/packages/.gitkeep"
fi

if [[ "$DOCS_ENABLED" -eq 1 ]]; then
  DOC_PATHS="$(load_docs_paths "$DOCS_PROFILE")"
  if [[ -z "$DOC_PATHS" ]]; then
    echo "No docs paths resolved for docs profile: $DOCS_PROFILE" >&2
    exit 1
  fi

  apply_docs_tree "$DOC_PATHS"
  apply_docs_templates
  write_generated_docs_structure "$DOC_PATHS"
fi

if [[ "$AGENTS_ENABLED" -eq 1 ]]; then
  apply_agent_templates
fi

if [[ "$SKILLS_ENABLED" -eq 1 ]]; then
  apply_skills_pack
fi

if [[ -d "$DOC_SCRIPTS_DIR" ]]; then
  copy_tree "$DOC_SCRIPTS_DIR" "$TARGET_DIR/scripts"
  chmod +x "$TARGET_DIR/scripts/"* 2>/dev/null || true
fi

if [[ -f "$CI_WORKFLOW" ]]; then
  copy_file "$CI_WORKFLOW" "$TARGET_DIR/.github/workflows/ci.yml"
fi

configure_git_hooks
write_scaffold_state

echo "Onboarding scaffold complete: $TARGET_DIR"
echo "Optional: run npx @iannuttall/dotagents in the target repo to link .agents into other tools."
