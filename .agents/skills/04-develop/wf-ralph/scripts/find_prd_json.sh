#!/usr/bin/env bash
set -euo pipefail

# find_prd_json.sh
#
# Resolve a dossier-local prd.json without hardcoding absolute paths.
#
# Resolution order:
#  1) If ./prd.json exists in the current working directory, return it.
#  2) If an arg is provided:
#     - If it is a file path to prd.json, return it.
#     - If it is a directory containing prd.json, return it.
#     - If it is @slug or slug, search under <repo-root>/docs/04-projects/** for prd.json within a dossier folder matching the slug.
#  3) Otherwise, walk up parent dirs looking for prd.json.
#
# If multiple matches are found for a slug search, print all matches and exit non-zero.

arg="${1-}"

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

abs_path() {
  local p="$1"
  if [[ -d "$p" ]]; then
    (cd "$p" && pwd)
  else
    (cd "$(dirname "$p")" && printf "%s/%s" "$(pwd)" "$(basename "$p")")
  fi
}

# 1) Current dir
if [[ -f "./prd.json" ]]; then
  abs_path "./prd.json"
  exit 0
fi

# 2) Arg path handling
if [[ -n "$arg" ]]; then
  # File path
  if [[ -f "$arg" && "$(basename "$arg")" == "prd.json" ]]; then
    abs_path "$arg"
    exit 0
  fi

  # Directory path
  if [[ -d "$arg" && -f "$arg/prd.json" ]]; then
    abs_path "$arg/prd.json"
    exit 0
  fi

  # Slug search
  slug="$arg"
  slug="${slug#@}"

  root="$(repo_root)"
  base="$root/docs/04-projects"
  if [[ -d "$base" ]]; then
    # Match either exact dossier folder suffix "_<slug>" or any path component containing the slug.
    mapfile -t matches < <(find "$base" -type f -name prd.json \( -path "*_${slug}/*" -o -path "*${slug}*" \) 2>/dev/null | sort)

    if (( ${#matches[@]} == 1 )); then
      abs_path "${matches[0]}"
      exit 0
    fi

    if (( ${#matches[@]} > 1 )); then
      echo "Multiple prd.json matches for slug '${slug}':" >&2
      for m in "${matches[@]}"; do
        echo "- $m" >&2
      done
      echo "Pass a more specific relative path, or rename dossier slugs to be unique." >&2
      exit 2
    fi
  fi

  echo "No prd.json found for slug '${slug}'." >&2
  exit 1
fi

# 3) Walk up parents
here="$(pwd)"
while [[ "$here" != "/" ]]; do
  if [[ -f "$here/prd.json" ]]; then
    abs_path "$here/prd.json"
    exit 0
  fi
  here="$(dirname "$here")"
done

echo "No prd.json found. Run from within a dossier folder, or pass @slug or a relative dossier path." >&2
exit 1
