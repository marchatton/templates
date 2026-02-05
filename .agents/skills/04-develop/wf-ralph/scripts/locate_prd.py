#!/usr/bin/env python3
"""Locate a dossier-local prd.json without hardcoding absolute paths.

Search order:

1) Explicit --path (file or dossier folder)
2) CWD contains prd.json
3) Walk up from CWD to git repo root, looking for prd.json
4) If --slug provided, search under docs/04-projects/** for matching dossier folder and prd.json
5) Fallback: search repo for prd.json excluding common junk directories

Prints the resolved path to stdout.
Exits non-zero if nothing is found.

Examples:

  python scripts/locate_prd.py
  python scripts/locate_prd.py --slug bulk-invite-members
  python scripts/locate_prd.py --path docs/04-projects/02-features/0007_bulk-invite-members/prd.json
  python scripts/locate_prd.py --path docs/04-projects/02-features/0007_bulk-invite-members/

"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path
from typing import Iterable, Optional


EXCLUDE_DIR_NAMES = {
    ".git",
    "node_modules",
    ".ralphy",
    ".ralphy-worktrees",
    ".ralphy-sandboxes",
    ".pnpm-store",
    ".yarn",
    ".cache",
}

EXCLUDE_PATH_PARTS = {
    "docs/99-archive",
}


def _git_repo_root(start: Path) -> Optional[Path]:
    try:
        out = subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=str(start),
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        return Path(out)
    except Exception:
        return None


def _walk_up(start: Path, stop_at: Path) -> Iterable[Path]:
    cur = start.resolve()
    stop = stop_at.resolve()
    while True:
        yield cur
        if cur == stop:
            break
        if cur.parent == cur:
            break
        cur = cur.parent


def _candidate_prd_in_dir(d: Path) -> Optional[Path]:
    p = d / "prd.json"
    return p if p.is_file() else None


def _looks_excluded(path: Path) -> bool:
    s = str(path.as_posix())
    for part in EXCLUDE_PATH_PARTS:
        if part in s:
            return True
    return False


def _find_in_docs_projects(repo_root: Path, slug: str) -> Optional[Path]:
    docs_root = repo_root / "docs" / "04-projects"
    if not docs_root.is_dir():
        return None

    slug = slug.strip()
    if slug.startswith("@"):
        slug = slug[1:]
    if not slug:
        return None

    matches: list[Path] = []
    # Match any folder name containing the slug.
    for d in docs_root.rglob("*"):
        if not d.is_dir():
            continue
        name = d.name.lower()
        if slug.lower() not in name:
            continue
        prd = d / "prd.json"
        if prd.is_file():
            matches.append(prd)

    if not matches:
        return None

    # Prefer the most recently modified prd.json
    matches.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return matches[0]


def _find_repo_wide(repo_root: Path) -> Optional[Path]:
    candidates: list[Path] = []
    for root, dirs, files in os.walk(repo_root):
        # Prune excluded dirs
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIR_NAMES]
        if "prd.json" in files:
            p = Path(root) / "prd.json"
            if _looks_excluded(p):
                continue
            candidates.append(p)

    if not candidates:
        return None

    candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return candidates[0]


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--path", help="Path to prd.json OR dossier folder", default=None)
    parser.add_argument("--slug", help="Dossier slug (optionally prefixed with @)", default=None)
    args = parser.parse_args(argv)

    cwd = Path.cwd()
    repo_root = _git_repo_root(cwd) or cwd

    # 1) Explicit path
    if args.path:
        p = Path(args.path)
        if not p.is_absolute():
            p = (cwd / p).resolve()
        if p.is_file() and p.name == "prd.json":
            print(str(p))
            return 0
        if p.is_dir():
            prd = _candidate_prd_in_dir(p)
            if prd:
                print(str(prd.resolve()))
                return 0
        # If a file path was given but isn't prd.json, try its parent
        if p.is_file():
            prd = _candidate_prd_in_dir(p.parent)
            if prd:
                print(str(prd.resolve()))
                return 0

    # 2) CWD contains prd.json
    prd = _candidate_prd_in_dir(cwd)
    if prd:
        print(str(prd.resolve()))
        return 0

    # 3) Walk up to repo root
    for d in _walk_up(cwd, repo_root):
        prd = _candidate_prd_in_dir(d)
        if prd:
            print(str(prd.resolve()))
            return 0

    # 4) Search docs/04-projects by slug
    if args.slug:
        prd = _find_in_docs_projects(repo_root, args.slug)
        if prd:
            print(str(prd.resolve()))
            return 0

    # 5) Repo-wide fallback
    prd = _find_repo_wide(repo_root)
    if prd:
        print(str(prd.resolve()))
        return 0

    print("ERROR: could not locate prd.json (try --path or --slug)", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
