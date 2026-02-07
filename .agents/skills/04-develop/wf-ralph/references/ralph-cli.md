# Ralph CLI cheat sheet (wf-ralph)

This is a quick reference for the `ralph` CLI commands and flags that matter in the wf-ralph workflow.

## Core commands

- `ralph prd`: generate a PRD JSON using the `$prd` skill
- `ralph build 1`: run one iteration (one story) from a PRD JSON
- `ralph review`: run a code review using the agent's `/review` command
- `ralph overview`: write a tiny overview Markdown file next to the PRD JSON

## Common flags

Agent selection:
- `--agent=codex|claude|droid|opencode`

PRD paths:
- `--prd <path>`: explicitly point at a PRD JSON file
  - Recommended for dossier-local PRDs (Ralph auto-discovery only scans `.agents/tasks/*.json` when `--prd` is omitted)
- `--out <path|dir>`: set output path for `ralph prd`
- `--progress <path>`: override the progress log path (advanced)

Git behavior:
- `--no-commit`: run without committing changes

Review scope:
- `--scope staged`: review only staged changes
- `--scope range --range main..HEAD`: review a commit range

## Examples

Run one iteration against a dossier PRD JSON:

```bash
cd "$(git rev-parse --show-toplevel)"
ralph build 1 --agent=codex --prd "docs/04-projects/.../prd.json"
```

Generate a PRD JSON into `.agents/tasks/`:

```bash
ralph prd --agent=codex
```

Generate a PRD JSON with an explicit output path:

```bash
ralph prd --agent=codex --out .agents/tasks/prd-api.json "Add an API key auth middleware"
```
