---

name: landpr
description: This skill should be used when preparing a /landpr prompt/checklist to land a PR.
---

# /landpr

Input
- PR: `<pr-number>`

Do (end-to-end)
Goal: PR ends in GitHub state `MERGED` (never `CLOSED`). Use `gh pr merge` with `--rebase` or `--squash`.
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
8) Pick merge strategy (if unclear, ask):
   - Rebase: preserve commit history
   - Squash: single clean commit
9) Full gate (BEFORE commit):
   - `pnpm lint && pnpm build && pnpm test`
10) Commit via `committer` (include `#<pr-number>` + contributor in commit message):
   - `committer "fix: <summary> (#<pr-number>) (thanks @$contrib)" CHANGELOG.md <changed files>`
   - capture `land_sha=$(git rev-parse HEAD)`
11) Push updated PR branch (rebase => usually needs force):
   - `git push --force-with-lease`
12) Merge PR (must show MERGED on GitHub):
   - Rebase: `gh pr merge <pr-number> --rebase`
   - Squash: `gh pr merge <pr-number> --squash`
   - Never `gh pr close`
13) Sync `main` + push:
   - `git checkout main`
   - `git pull --ff-only`
   - `git push`
14) Comment on PR with what we did + SHAs + thanks:
   - `merge_sha=$(gh pr view <pr-number> --json mergeCommit --jq '.mergeCommit.oid')`
   - `gh pr comment <pr-number> --body "Landed via temp rebase onto main.\n\n- Gate: pnpm lint && pnpm build && pnpm test\n- Land commit: $land_sha\n- Merge commit: $merge_sha\n\nThanks @$contrib!"`
15) Verify PR state == `MERGED`:
   - `gh pr view <pr-number> --json state,mergedAt --jq '.state + \" @ \" + .mergedAt'`
16) Delete temp branch:
   - `git branch -D temp/landpr-<pr-number>`
