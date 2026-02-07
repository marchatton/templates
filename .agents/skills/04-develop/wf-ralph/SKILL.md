---
name: wf-ralph
description: Run a Ralph-style, one-story-per-iteration loop using the Ralph CLI (dev, research, e2e, review), Codex-by-default, and dossier-local PRD JSON discovery.
license: MIT
---

# wf-ralph

## Purpose

Run a "Ralph loop" using the `ralph` CLI.

- Keep the mental model: **one story per iteration**, frequent verification, small changes.
- Default agent: **Codex** (YOLO) unless you override `--agent`.
- Default task source: dossier-local **Ralph PRD JSON** (`prd.json` or `prd-<slug>.json`).
- Browser testing: **YES for UI stories** (default skill: `$dev-browser`).

## When to use

Use this skill when any of the following is true:

- You want copy-paste-ready `ralph` commands for `dev | research | e2e | review | prd-gen`.
- You have (or want) a dossier-local Ralph PRD JSON and need to run one iteration at a time.
- You have an `@slug` and need to locate the PRD JSON under `docs/04-projects/**`.

## Minimum questions

If any of these are missing, ask only these questions first (reply format at the end).

1) **Mode**?
- a) **dev** (default)
- b) research
- c) e2e
- d) review
- e) prd-gen

2) **PRD location**?
- a) **Use `./prd.json` if present** (default)
- b) pick from `./prd-*.json`
- c) `@slug` (search under `docs/04-projects/**`)
- d) explicit path to PRD JSON

3) **Commit behavior**?
- a) **Commit** (default)
- b) `--no-commit`

Reply shorthand:

- `defaults` (accept all defaults)
- or `1c 2c @bulk-invite-members 3b` etc

## Discovery

### Determine repo root (required)

Run `ralph` from the repo root so `.ralph/` state/logs land in the right place:

```bash
cd "$(git rev-parse --show-toplevel)"
```

### Locate dossier PRD JSON (avoid brittle paths)

Ralph auto-discovery only scans `.agents/tasks/*.json`. For dossier-local PRDs, pass `--prd` explicitly.

Resolution order:

1) If the current working directory contains `prd.json`, use it.
2) Else if it contains `prd-*.json`:
- if exactly one match, use it
- if multiple matches, ask which to use
3) Else accept either:
- an `@slug` (dossier folder name contains the slug), or
- a relative path to a dossier folder, or
- an explicit path to a PRD JSON file

```bash
# Find PRDs and filter by slug
find docs/04-projects -type f \( -name 'prd.json' -o -name 'prd-*.json' \) | rg '<slug>'

# Example
find docs/04-projects -type f \( -name 'prd.json' -o -name 'prd-*.json' \) | rg 'bulk-invite-members'
```

If you don't have `rg`, run the `find ...` and inspect the results.

## Ralph commands

### Defaults that match the Ralph vibe

- Run **one story per invocation**: `ralph build 1`.
- Repeat the command N times manually (or via a wrapper script) to avoid context rot.
- Prefer explicit `--prd <file>` for dossier-local PRDs.

### Dev mode

```bash
ralph build 1 --agent=codex --prd "<PRD_JSON>"
```

Behavioural requirements:

- Keep changes small and focused (one concern per iteration).
- Respect repo conventions (pnpm workspaces, TypeScript preference).
- For code changes: always use the `verify` skill and report commands + results.
- For UI/user-flow changes: browser verification is required (default: `$dev-browser`).

### No-commit (dry run style)

```bash
ralph build 1 --agent=codex --prd "<PRD_JSON>" --no-commit
```

### Research mode

Behavioural requirements:

- Treat “done” as a concrete artefact (memo, plan, decision record) written into the dossier.
- Prefer writing under the dossier folder (for example: `docs/04-projects/.../<dossier>/research/…`).
- Avoid modifying product code unless a task explicitly asks.

Recommendation:
- default to `--no-commit` if you're exploring
- enable commits once the story is clearly correct

### E2E mode

Behavioural requirements:

- Require browser verification for UI stories.
- Default browser verification skill: `$dev-browser`.
- Optional/alternate quick smoke: `$test-browser`.
- Write evidence artefacts to a dossier-local artefacts folder (recommendation):
  - `<dossier>/artifacts/e2e/` (screenshots, notes, logs)

Test suite status:

- If an automated E2E runner does not exist yet, treat it as a placeholder task.
- Still produce proof via `test-browser` screenshots and a short run log.

### Review mode

Use `ralph review` (do not run `ralph build` unless explicitly asked).

```bash
ralph review
ralph review --scope staged
ralph review --scope range --range main..HEAD
```

### PRD generation mode (optional)

Generate a new PRD JSON into `.agents/tasks/`:

```bash
ralph prd --agent=codex
```

Override output path:

```bash
ralph prd --agent=codex --out .agents/tasks/prd-<short>.json "<feature description>"
```

## PRD JSON notes

Ralph PRD JSON uses top-level `qualityGates[]` and `stories[]`.

- Ralph updates story `status` automatically (`open` -> `in_progress` -> `done`). Avoid editing story statuses manually.
- Optional fields like `stories[].passes` and `stories[].notes` are supported for downstream workflows, but Ralph does not set them.

## Output format when running this skill

When this skill is invoked in a chat/thread:

1) Ask the minimum questions if anything is missing (mode, PRD path/slug, commit behavior).
2) Print copy-paste-ready command lines for the chosen mode.
3) List expected evidence artefacts and where they will be written.
4) End with a suggestion to run `pickup` at the start (new thread) and `handoff` at the end (before switching threads).
