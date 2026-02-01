#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

errors=0

required_skill_dirs=(
  "${root_dir}/.agents/skills/explore"
  "${root_dir}/.agents/skills/shape"
  "${root_dir}/.agents/skills/develop"
  "${root_dir}/.agents/skills/review"
  "${root_dir}/.agents/skills/release"
  "${root_dir}/.agents/skills/compound"
  "${root_dir}/.agents/skills/skills-maintenance"
  "${root_dir}/.agents/skills/utilities"
)

for dir in "${required_skill_dirs[@]}"; do
  if [ ! -d "${dir}" ]; then
    echo "Missing skill category: ${dir}"
    errors=1
  fi
done

required_commands=(
  ".agents/commands/workflows/wf-explore.md"
  ".agents/commands/workflows/wf-shape.md"
  ".agents/commands/workflows/wf-develop.md"
  ".agents/commands/workflows/wf-review.md"
  ".agents/commands/workflows/wf-release.md"
  ".agents/commands/workflows/wf-ralph.md"
  ".agents/commands/utilities/compound.md"
)

for cmd in "${required_commands[@]}"; do
  if [ ! -f "${root_dir}/${cmd}" ]; then
    echo "Missing command: ${cmd}"
    errors=1
  fi
done

required_templates=(
  "${root_dir}/docs/templates/learnings.md"
)

for file in "${required_templates[@]}"; do
  if [ ! -f "${file}" ]; then
    echo "Missing template: ${file}"
    errors=1
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for frontmatter checks"
  errors=1
else
  if ! python3 - "${root_dir}/.agents/skills" <<'PY'
import os
import sys

skills_root = sys.argv[1]
errors = 0
names = {}

for base, dirs, files in os.walk(skills_root, followlinks=True):
    if "SKILL.md" not in files:
        continue
    path = os.path.join(base, "SKILL.md")
    with open(path, "r", encoding="utf-8") as fh:
        content = fh.read()

    if not content.startswith("---"):
        print(f"Missing frontmatter: {path}")
        errors += 1
        continue

    parts = content.split("---", 2)
    if len(parts) < 3:
        print(f"Malformed frontmatter: {path}")
        errors += 1
        continue

    frontmatter = parts[1].strip().splitlines()
    keys = {}
    for line in frontmatter:
        if not line.strip() or line.strip().startswith("#"):
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip()
        keys[key] = value

    if "name" not in keys or "description" not in keys:
        print(f"Missing name/description in frontmatter: {path}")
        errors += 1
        continue

    extra = [k for k in keys.keys() if k not in {"name", "description", "license"}]
    if extra:
        print(f"Extra frontmatter keys in {path}: {', '.join(extra)}")
        errors += 1

    name = keys["name"]
    if name in names:
        print(f"Duplicate skill name: {name} ({path}, {names[name]})")
        errors += 1
    else:
        names[name] = path

if errors:
    sys.exit(1)
PY
  then
    errors=1
  fi
fi

echo "Manual smoke steps:"
echo "- ./scripts/vendor_update.sh"
echo "- ./scripts/npx_skills_refresh.sh"
echo "- node --experimental-strip-types ./scripts/generate_cheatsheet.ts"
echo "- ./scripts/verify_repo.sh"

echo "- Run a wf-* command end-to-end and confirm outputs."

if [ "${errors}" -ne 0 ]; then
  exit 1
fi

echo "verify_repo OK."
