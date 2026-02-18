#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

errors=0

required_skill_dirs=(
  "${root_dir}/.agents/skills/00-utilities"
  "${root_dir}/.agents/skills/01-research-brainstorm"
  "${root_dir}/.agents/skills/02-shape"
  "${root_dir}/.agents/skills/03-plan"
  "${root_dir}/.agents/skills/04-develop"
  "${root_dir}/.agents/skills/05-review"
  "${root_dir}/.agents/skills/06-release"
  "${root_dir}/.agents/skills/07-compound"
  "${root_dir}/.agents/skills/10-audit"
  "${root_dir}/.agents/skills/98-skill-maintenance"
  "${root_dir}/.agents/skills/99-archive"
)

for dir in "${required_skill_dirs[@]}"; do
  if [ ! -d "${dir}" ]; then
    echo "Missing skill category: ${dir}"
    errors=1
  fi
done

required_workflow_skills=(
  ".agents/skills/02-shape/wf-shape/SKILL.md"
  ".agents/skills/03-plan/wf-plan/SKILL.md"
  ".agents/skills/04-develop/wf-develop/SKILL.md"
  ".agents/skills/04-develop/wf-ralph/SKILL.md"
  ".agents/skills/05-review/wf-review/SKILL.md"
  ".agents/skills/06-release/wf-release/SKILL.md"
)

for skill in "${required_workflow_skills[@]}"; do
  if [ ! -f "${root_dir}/${skill}" ]; then
    echo "Missing workflow skill: ${skill}"
    errors=1
  fi
done

required_templates=(
  "${root_dir}/docs/doc-templates/learnings.md"
  "${root_dir}/docs/doc-templates/docs-readme.md"
  "${root_dir}/docs/doc-templates/architecture-high-level-design.md"
  "${root_dir}/docs/doc-templates/release-changelog.md"
  "${root_dir}/docs/doc-templates/projects-readme.md"
  "${root_dir}/docs/doc-templates/dossier-starter.md"
  "${root_dir}/docs/REPO-STRUCTURE.profiles.json"
  "${root_dir}/scaffold/settings.json"
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

echo "- Run a wf-* skill end-to-end and confirm outputs."

if [ "${errors}" -ne 0 ]; then
  exit 1
fi

echo "verify_repo OK."
