#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
register_file="${root_dir}/.agents/register.json"

usage() {
  cat <<'USAGE'
Usage:
  scripts/skills_diff.sh --list
  scripts/skills_diff.sh --all
  scripts/skills_diff.sh <skill-name>

Notes:
- Diffs local skills against inspiration sources from .agents/register.json.
- Directories use recursive diff; files use unified diff.
USAGE
}

list_entries() {
  python3 - "${register_file}" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fh:
    data = json.load(fh)

entries = []
for skill in data.get("entries", {}).get("skills", []):
    upstream = skill.get("upstream") or {}
    repo = upstream.get("repo")
    src = upstream.get("path")
    name = skill.get("name")
    dst = skill.get("location")
    if not repo or not src or not name or not dst:
        continue
    if not dst.startswith(".agents/skills/"):
        continue
    entries.append((name, repo, src, dst))

for name, repo, src, dst in entries:
    print(f"{name}\t{repo}\t{src}\t{dst}")
PY
}

mode="all"
skill=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all)
      mode="all"
      ;;
    --list)
      mode="list"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [ -n "${skill}" ]; then
        usage
        exit 1
      fi
      skill="$1"
      mode="one"
      ;;
  esac
  shift
done

if [ "${mode}" = "list" ]; then
  list_entries | cut -f1 | sort -u
  exit 0
fi

found=0

while IFS=$'\t' read -r name repo src dst; do
  if [ "${mode}" = "one" ] && [ "${name}" != "${skill}" ]; then
    continue
  fi
  found=1
  if [[ "${repo}" == *"/"* ]]; then
    echo "Skip ${name}: upstream ${repo} not in inspiration/ (use scripts/npx_skills_refresh.sh)." >&2
    continue
  fi
  src_root="${root_dir}/inspiration/${repo}"
  if [ ! -d "${src_root}" ]; then
    echo "Missing upstream repo: ${src_root} (run scripts/vendor_update.sh)." >&2
    continue
  fi
  src_path="${src_root}/${src}"
  dst_path="${root_dir}/${dst}"

  if [ ! -e "${src_path}" ]; then
    echo "Missing source: ${src_path}" >&2
    continue
  fi
  if [ -d "${src_path}" ]; then
    if [[ "${dst_path}" == *.md ]]; then
      dst_dir="$(dirname "${dst_path}")"
    else
      dst_dir="${dst_path}"
    fi
    if [ ! -d "${dst_dir}" ]; then
      echo "Missing local: ${dst_dir}" >&2
      continue
    fi
    echo "==> ${name}"
    diff -ru -x .DS_Store "${src_path}" "${dst_dir}" || true
  else
    if [ -d "${dst_path}" ]; then
      dst_file="${dst_path}/SKILL.md"
    else
      dst_file="${dst_path}"
    fi
    if [ ! -f "${dst_file}" ]; then
      echo "Missing local: ${dst_file}" >&2
      continue
    fi
    echo "==> ${name}"
    diff -u "${src_path}" "${dst_file}" || true
  fi

done < <(list_entries)

if [ "${mode}" = "one" ] && [ "${found}" -eq 0 ]; then
  echo "Skill not found: ${skill}" >&2
  exit 1
fi
