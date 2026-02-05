---
name: wf-ralph
description: This skill should be used when orchestrating a Ralph-style iterative loop using Ralphy (Codex default) across dev, research, e2e, and review modes, with guardrails, verification, and handoff/pickup notes.
license: Internal
---

# wf-ralph

## Purpose

Run a simple, repeatable “Ralph-style” loop on top of Ralphy.

- Prefer one small task per iteration.
- Keep each iteration as a fresh process (default: run `--max-iterations 1` in a repeat loop).
- Persist progress in dossier-local `prd.json` (Ralphy JSON tasks) and in git.
- Default to the Codex engine (`--codex`).
- Use `verify` for code changes.
- Use `test-browser` for UI smoke evidence (default: pass `--no-browser` to Ralphy).
- Use `/pickup` at the start when context is cold; use `/handoff` when switching threads.

## Repo conventions to respect

Follow repo principles and defaults:

- Prefer TypeScript for new code unless the repo clearly uses something else.
- Use pnpm workspaces conventions:
  - Monorepo/shared scope: `pnpm -r lint`, `pnpm -r test`, `pnpm -r build`
  - Single package/app: `pnpm -F <pkg> lint`, `pnpm -F <pkg> test`, `pnpm -F <pkg> build`
- Avoid duplication (DRY). Do not paste the same knowledge across many files.
- Keep changes small and focused (one concern per iteration).

## When to use

Use when asked to:

- “Run wf-ralph for N iterations”
- “Work through this dossier PRD”
- “Do dev vs research vs e2e in a controlled loop”
- “Keep it simple, don’t do parallel chaos”

Do not use to write the PRD itself. Create/refresh PRDs separately, then point this skill at the dossier `prd.json`.

## Inputs and defaults

Clarify and then lock in:

- **Mode**: `dev | research | e2e | review` (default: `dev`)
- **PRD JSON**: dossier-local `prd.json` (default: locate closest `prd.json`)
- **Iterations**: number of outer-loop passes (default: `5`)
- **Engine**: default `--codex`
- **Base branch**: default `main`
- **Git workflow**: default single branch per dossier (no `--branch-per-task`)
- **Browser automation**: default `--no-browser` (because evidence is via `test-browser`)
- **Parallel execution**: default OFF (no `--parallel`)

## Ask the minimum questions if missing

If the request is underspecified, ask 1 to 5 questions and pause.

Use this fast-path format:

```text
1) Mode?
a) dev (default)
b) research
c) e2e
d) review

2) Which PRD?
a) Use closest prd.json from current folder upwards (default)
b) Provide path: <path>
c) Provide dossier slug: @<slug>

3) Iterations?
a) 5 (default)
b) 1
c) other: <N>

4) Base branch?
a) main (default)
b) other: <branch>

5) Workflow?
a) Single branch per dossier (default)
b) Branch-per-task + PRs (opt-in)
c) Parallel (opt-in, higher risk)

Reply with: defaults (or e.g. 1a 2c 3a 4a 5a)
```

Then restate the choices in 1 to 2 sentences and proceed.

## Locate repo root and PRD JSON

### Determine repo root

Prefer:

- `git rev-parse --show-toplevel`

Fallback:

- current working directory

### Locate the dossier PRD JSON

Use this priority order:

1. If the user provided an explicit file path, use it.
2. If the current working directory contains `prd.json`, use it.
3. Walk up parent directories until repo root, looking for `prd.json`.
4. If given an `@slug`, search under `docs/04-projects/**/` for a dossier folder whose name contains the slug, then use its `prd.json`.
5. If still not found, search the repo for `prd.json` (exclude `.git/`, `node_modules/`, `docs/99-archive/`, `.ralphy-worktrees/`, `.ralphy-sandboxes/`).

Optional helper: run the bundled script `scripts/locate_prd.py` (it prints the best guess path). If scripts cannot be executed, follow the same logic manually.

## Ralphy mapping (flags to know)

Task source flags:

- Primary: `--json <path>`
- Alternates: `--prd <file|folder>`, `--yaml <file>`, `--github <owner/repo>`

Core loop flags:

- `--max-iterations N` (wf-ralph defaults to `1` per outer-loop pass)
- `--max-retries N`
- `--retry-delay N`
- `--dry-run`
- `-v, --verbose`

Quality flags:

- `--no-tests`, `--no-lint`, `--fast`
- `--no-commit`

Browser flags:

- Default in wf-ralph: `--no-browser` (because UI verification uses `test-browser`)
- Ralphy also supports: `--browser` (opt-in)

Branch workflow flags (opt-in):

- `--branch-per-task`
- `--base-branch <name>`
- `--create-pr`, `--draft-pr`
- `--no-merge` (mainly for parallel mode)

Parallel flags (opt-in, higher risk):

- `--parallel`
- `--max-parallel N`
- `--sandbox`

For a fuller reference, read `references/ralphy-flags.md`.

## PRD JSON conventions (Ralphy-compatible)

Ralphy’s JSON task source expects:

- top-level `tasks: []`
- each task has at least:
  - `title` (unique)
  - `completed` (boolean)
- optional:
  - `parallel_group` (number)
  - `description` (string)

Keep titles unique. Prefer prefixing with a stable id (example: `US-001 …`).

### Allow extra metadata, but do not depend on it

It is OK to add extra keys (example: `project`, `branchName`, `description`, `userStories`) as long as `tasks` exists and contains everything Ralphy needs.

Important: Ralphy may rewrite the file as it updates completion. Assume extra keys might be dropped. Keep must-have information inside `tasks[].description`.

Use the bundled template in `assets/prd-json-templates/prd.json`.

## Prepare Ralphy project config guardrails

If `.ralphy/config.yaml` is missing, initialise it:

- `ralphy --init`

Then inspect it:

- `ralphy --config`

Add rules as needed (examples):

- `ralphy --add-rule "Follow AGENTS.md and existing repo conventions"`
- `ralphy --add-rule "Prefer TypeScript for new code unless this repo uses something else"`
- `ralphy --add-rule "Keep changes small and focused; avoid refactors unless explicitly requested"`
- `ralphy --add-rule "Do not modify PRD files except completion updates"`

Recommended config patterns (use globs, avoid brittle absolute paths):

- `boundaries.never_touch`:
  - `**/node_modules/**`
  - `**/*.lock`
  - `docs/99-archive/**`
  - `.ralphy/**`
  - `.ralphy-worktrees/**`
  - `.ralphy-sandboxes/**`

Keep mode-specific constraints in task descriptions (example: research tasks say “docs-only”).

## Default git workflow (single branch per dossier)

Default is one branch for the whole dossier.

- Prefer base branch: `main`
- Determine target branch:
  - If `prd.json` includes a top-level `branchName`, use it.
  - Else derive from the dossier slug (example: `ralph/<slug>`).

Switch/create:

- `git checkout main`
- `git checkout -b <branch>` (or `git checkout <branch>` if it already exists)

Avoid `--branch-per-task` unless explicitly requested.

## Run the Ralph-style loop (outer loop)

Default rhythm:

- Run Ralphy for **one task only**: `--max-iterations 1`
- Repeat N times (default N = 5)

Always print copy/paste commands.

### Mode: dev (default)

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser
```

Defaults:

- Tests and lint ON (do not pass `--fast`, `--no-tests`, or `--no-lint`)
- Auto-commit ON (do not pass `--no-commit`)
- Parallel OFF

After each iteration:

- Invoke `verify` skill and report commands + results
- If blocked, return **NO-GO** plus the smallest unblock
- If UI/user-flow changed:
  - Use `test-browser` for a smoke run
  - Do a basic a11y spot-check (keyboard nav, focus, labels)
  - Capture evidence into the dossier (example: `<dossier>/artifacts/e2e/`)

### Mode: research

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --fast --no-browser --no-commit
```

Defaults:

- Prefer docs artefacts inside the dossier (example: `research/`, `notes/`, `decisions/`)
- Do not change product code unless the task explicitly asks for it
- Do not run tests/lint by default (`--fast`)

After each iteration:

- Confirm artefact files exist and read coherently
- Summarise findings and next steps
- Use `verify` only if code was changed (and call out why code was changed)

### Mode: e2e

Command template:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser
```

Defaults:

- Evidence-first. Do not rely on agent-browser.
- Use `test-browser` skill for smoke verification.
- Save screenshots/logs under the dossier, for example:
  - `<dossier>/artifacts/e2e/…`

Notes:

- Automated e2e suite is not built yet. Treat it as a placeholder:
  - If a task asks for automated e2e, either add the smallest repeatable smoke harness that fits the repo, or write a clear TODO + plan (do not pretend it exists).

After each iteration:

- Run `verify` skill if code changed
- Run `test-browser` when UI/user-flow changed, and capture evidence

### Mode: review

Default behaviour is not “do more coding”, it is “tighten, verify, and summarise”.

Prefer:

- Summarise diffs and risks
- Run `verify` and report results
- Write review notes into the dossier (or a local-only handoff note if appropriate)

Run Ralphy in review only if there are explicit review tasks in `prd.json` (and keep it constrained), for example:

```bash
ralphy --codex --json "<PRD_JSON>" --max-iterations 1 --no-browser --no-commit
```

## Handoff and pickup integration

If starting work in a fresh thread, run `/pickup` first.

If switching threads (or finishing a session), run `/handoff` at the end so the next thread can resume quickly.

## Output format (in chat)

When using this skill, output in this order:

1. Resolved repo root and resolved PRD JSON path
2. Chosen mode, engine, iterations, base branch, and workflow
3. Copy/paste Ralphy command(s) for the next iteration
4. What will be produced (files + evidence paths)
5. After-action checklist for this iteration (verify, test-browser, notes)
6. Suggest running `/handoff` if switching threads
