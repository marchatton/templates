#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
register_file="${root_dir}/.agents/register.json"

usage() {
  cat <<'USAGE'
Usage:
  scripts/skills_copy.sh --all [--force]
  scripts/skills_copy.sh <skill-name> [--force]

Notes:
- Copies skill content from inspiration sources defined in .agents/register.json.
- Does not delete extra local files; use --force to overwrite matching files.
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

force=0
mode=""
skill=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all)
      mode="all"
      ;;
    --force)
      force=1
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

if [ -z "${mode}" ]; then
  usage
  exit 1
fi

copied=0

while IFS=$'\t' read -r name repo src dst; do
  if [ "${mode}" = "one" ] && [ "${name}" != "${skill}" ]; then
    continue
  fi
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

  if [ -e "${dst_path}" ] && [ "${force}" -eq 0 ]; then
    echo "Skip ${name}: ${dst_path} exists (use --force to overwrite)."
    continue
  fi

  if [ -d "${src_path}" ]; then
    if [[ "${dst_path}" == *.md ]]; then
      dst_dir="$(dirname "${dst_path}")"
    else
      dst_dir="${dst_path}"
    fi
    if [ -e "${dst_dir}" ] && [ "${force}" -eq 0 ]; then
      echo "Skip ${name}: ${dst_dir} exists (use --force to overwrite)."
      continue
    fi
    mkdir -p "${dst_dir}"
    cp -R "${src_path}/." "${dst_dir}/"
  else
    if [ -d "${dst_path}" ]; then
      dst_file="${dst_path}/SKILL.md"
    else
      dst_file="${dst_path}"
    fi
    if [ -e "${dst_file}" ] && [ "${force}" -eq 0 ]; then
      echo "Skip ${name}: ${dst_file} exists (use --force to overwrite)."
      continue
    fi
    mkdir -p "$(dirname "${dst_file}")"
    cp "${src_path}" "${dst_file}"
  fi

  copied=$((copied + 1))
  echo "Copied ${name}"

done < <(list_entries)

if [ "${mode}" = "one" ] && [ "${copied}" -eq 0 ]; then
  echo "Skill not found: ${skill}" >&2
  exit 1
fi
