---
name: c-landpr
description: Land a PR end-to-end (rebase temp branch, changelog, gate, merge).
argument-hint: <pr-number>
---

> **Attribution:** Ported from [agent-scripts](https://github.com/steipete/agent-scripts) by Peter Steinberger.

# /landpr

Input
- PR: `<pr-number>`

Do (end-to-end)
1) Repo clean: `git status`.
2) Identify PR meta (author + head branch):
   - `gh pr view <pr-number> --json number,title,author,headRefName,baseRefName --jq '{number,title,author:.author.login,head:.headRefName,base:.baseRefName}'`
   - `contrib=$(gh pr view <pr-number> --json author --jq .author.login)`
   - `head=$(gh pr view <pr-number> --json headRefName --jq .headRefName)`
3) Fast-forward base:
   - `git checkout main`
   - `git pull --ff-only`
4) Create temp base branch from `main`:
   - `git checkout -b temp/landpr-<pr-number>`
5) Check out PR branch locally:
   - `gh pr checkout <pr-number>`
6) Rebase PR branch onto temp base:
   - `git rebase temp/landpr-<pr-number>`
   - fix conflicts; keep history tidy
7) Fix + tests + changelog:
   - implement fixes + add/adjust tests
   - update `CHANGELOG.md` and mention `#<pr-number>` + `@$contrib`
8) Full gate (BEFORE commit):
   - `pnpm lint && pnpm build && pnpm test`
9) Commit via `committer` (include `#<pr-number>` + contributor in commit message):
   - `committer "fix: <summary> (#<pr-number>) (thanks @$contrib)" CHANGELOG.md <changed files>`
   - capture `land_sha=$(git rev-parse HEAD)`
10) Push updated PR branch (rebase => usually needs force):
    - `git push --force-with-lease`
11) Merge PR:
    - `gh pr merge <pr-number> --merge`
12) Sync `main` + push:
    - `git checkout main`
    - `git pull --ff-only`
    - `git push`
13) Comment on PR with what we did + SHAs + thanks:
    - `merge_sha=$(gh pr view <pr-number> --json mergeCommit --jq '.mergeCommit.oid')`
    - `gh pr comment <pr-number> --body "Landed via temp rebase onto main.\n\n- Gate: pnpm lint && pnpm build && pnpm test\n- Land commit: $land_sha\n- Merge commit: $merge_sha\n\nThanks @$contrib!"`
14) Verify PR state == `MERGED`:
    - `gh pr view <pr-number> --json state --jq .state`
15) Delete temp branch:
    - `git branch -D temp/landpr-<pr-number>`

## Invocation
- **Codex:** `/prompts:c-landpr`
- **Claude:** `/c-landpr`
