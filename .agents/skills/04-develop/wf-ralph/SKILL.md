---
name: wf-ralph
description: This skill should be used when running a Ralph-style, one-task-per-iteration loop using Ralphy under the hood, with simple modes (dev, research, e2e, review), Codex-by-default, and dossier-local prd.json discovery.
license: MIT
---

# wf-ralph

## Purpose

Run a “Ralph-style loop runner” using Ralphy.

- Keep the mental model: **one task per iteration**, frequent verification, small changes.
- Default engine: **Codex** (`ralphy --codex`).
- Default task source: dossier-local **Ralphy JSON** (`--json <path>`).
- Default browser behaviour: **off** (`--no-browser`) and rely on `test-browser` skill for UI checks.

## When to use

Use this skill when any of the following is true:

- A “run Ralph loop” workflow is needed, but the underlying runner should be **Ralphy**.
- A repeatable, copy-paste command template is needed for `dev | research | e2e | review`.
- A dossier-local `prd.json` must be found from an `@slug` or a relative dossier path.

## Minimum questions

If any of these are missing, ask only these questions first (reply format at the end).

1) **Mode**?
- a) **dev** (default)
- b) research
- c) e2e
- d) review

2) **PRD location**?
- a) **Use `./prd.json` if present** (default)
- b) `@slug` (search under `docs/04-projects/**`)
- c) relative path to dossier folder or `prd.json`

3) **Branch workflow**?
- a) **Run on current branch** (default, closest to Ralph)
- b) `--branch-per-task` (one branch per task)

4) If 3b, PR behaviour?
- a) **No PRs** (default)
- b) `--create-pr`
- c) `--draft-pr`

Reply shorthand:

- `defaults` (accept all defaults)
- or `1b 2c docs/04-projects/... 3a` etc

## Discovery

### Determine repo root

- Prefer: `git rev-parse --show-toplevel`
- Fallback: current working directory

### Locate dossier `prd.json` without brittle paths

Locate the PRD JSON using this order:

1) If current working directory contains `prd.json`, use it.
2) Else, accept either:
   - an `@slug` (dossier folder name contains the slug), or
   - a relative dossier path, or
   - a relative path to a `prd.json`
   Then search under `docs/04-projects/**`.

Optional helper (bundled): `scripts/find_prd_json.sh`

- `scripts/find_prd_json.sh` prints the resolved `prd.json` path.
- Prefer invoking it from repo root:

```bash
./scripts/find_prd_json.sh @bulk-invite-members
./scripts/find_prd_json.sh docs/04-projects/02-features/0007_bulk-invite-members
```

## Ralphy commands

### Defaults that match the Ralph vibe

- Run **one task per invocation** via `--max-iterations 1`.
- Repeat the command N times manually (or via a wrapper script) to avoid context rot.
- Keep `--parallel` off by default.
- Keep auto browser automation off (`--no-browser`) and use `test-browser` skill instead.

### Dev mode

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser
```

Behavioural requirements:

- Keep changes small and focused (one concern per iteration).
- Respect repo conventions (pnpm workspaces, TypeScript preference).
- For code changes: always use the `verify` skill and report commands + results.
- For UI/user-flow changes: use `test-browser` skill for smoke verification and basic a11y spot-check.

Optional debug/safety flags (add only when needed):

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser --max-retries 3 --retry-delay 10 --verbose
ralphy --codex --json "<PRD_JSON>" --dry-run
ralphy --codex --json "<PRD_JSON>" --no-commit
```

### Research mode

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --fast --no-browser
```

Behavioural requirements:

- Treat “done” as a concrete artefact (memo, plan, decision record) written into the dossier.
- Prefer writing under the dossier folder (for example: `docs/04-projects/.../<dossier>/research/…`).
- Avoid modifying product code unless a task explicitly asks.

### E2E mode

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser
```

Behavioural requirements:

- Do not use Ralphy’s `--browser` / agent-browser flow in this mode.
- Require tasks to call the `test-browser` skill and capture evidence.
- Write evidence artefacts to a dossier-local artefacts folder (recommendation):
  - `<dossier>/artifacts/e2e/` (screenshots, notes, logs)

Test suite status:

- If an automated E2E runner does not exist yet, treat it as a placeholder task.
- Still produce proof via `test-browser` screenshots and a short run log.

### Review mode

Default behaviour:

- Do not run Ralphy unless explicitly asked.
- Summarise changes (diff-level), key risks, and verification status.
- Write review notes into the dossier (for example: `<dossier>/reviews/<date>-review.md`).

## Ralphy config guardrails

### Initialise project config

Create `.ralphy/config.yaml` if missing:

```bash
ralphy --init
```

### Recommend rules

Add rules that reduce agent freelancing:

- “Prefer TypeScript for new code unless the repo already uses something else.”
- “Follow repo conventions and patterns in AGENTS.md.”
- “Keep changes small; avoid drive-by refactors.”
- “Do not edit PRD files (`prd.json`, PRD markdown) unless explicitly asked.”

Add via CLI when helpful:

```bash
ralphy --add-rule "Prefer TypeScript for new code"
ralphy --add-rule "Do not edit PRD files unless asked"
```

### Recommend boundaries.never_touch

Avoid brittle paths. Use globs and repo-relative patterns.

Recommended starting point:

```yaml
boundaries:
  never_touch:
    - ".ralphy/**"
    - ".ralphy-worktrees/**"
    - ".ralphy-sandboxes/**"
    - "**/*.lock"
    - "**/node_modules/**"
    - "**/dist/**"
    - "**/build/**"
    - "**/coverage/**"
```

If the workflow needs dependency changes, remove or narrow the lockfile patterns intentionally.

## PRD JSON format and acceptance criteria

### What Ralphy expects

Use the Ralphy JSON task shape as the source of truth:

```json
{
  "tasks": [
    {
      "title": "US-001: short task title",
      "completed": false,
      "parallel_group": 1,
      "description": "Optional details"
    }
  ]
}
```

- Titles must be unique.
- Only rely on `tasks[].title`, `tasks[].completed`, `tasks[].parallel_group`, `tasks[].description`.
- Extra metadata keys may be present, but do not depend on them being preserved.

### Add acceptance criteria safely

Store acceptance criteria inside `tasks[].description` so the file remains Ralphy-compatible.

Recommended description structure:

- Context (what and why)
- Acceptance criteria (bullets)
- Verification (commands to run, plus `test-browser` instructions when relevant)
- Evidence paths (where screenshots/logs/docs will land)

Example (valid JSON, uses `\n` newlines):

```json
{
  "tasks": [
    {
      "title": "US-002: Display priority indicator on task cards",
      "completed": false,
      "parallel_group": 1,
      "description": "Context:\nShow priority on each task card so users can scan urgency quickly.\n\nAcceptance criteria:\n- Each task card shows a priority badge: high, medium, low\n- Badge is visible without hover\n- Typecheck passes\n\nVerification:\n- Run verify skill (lint/test/build as appropriate)\n- Use test-browser skill to confirm the badge renders and is readable\n\nEvidence:\n- Save screenshot to <dossier>/artifacts/e2e/priority-badge.png\n"
    }
  ]
}
```

## Output format when running this skill

When this skill is invoked in a chat/thread:

1) Ask the minimum questions if anything is missing (mode, PRD path/slug, branch workflow).
2) Print copy-paste-ready command lines for the chosen mode.
3) List expected evidence artefacts and where they will be written.
4) End with a suggestion to run `pickup` at the start (new thread) and `handoff` at the end (before switching threads).
