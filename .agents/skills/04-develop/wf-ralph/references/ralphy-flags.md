# Ralphy flags cheat sheet (wf-ralph)

This is a quick reference for the Ralphy CLI flags that matter in the wf-ralph workflow.

## Task sources

Pick one primary task source per run.

- `--json <file>`: JSON tasks (recommended for wf-ralph)
- `--prd <path>`: Markdown tasks (file or folder)
- `--yaml <file>`: YAML tasks
- `--github <owner/repo>`: GitHub issues as tasks
- `--github-label <label>`: filter GitHub issues by label
- `--sync-issue <num>`: sync PRD progress back to a GitHub issue

## Engine selection

- `--codex` (wf-ralph default)
- `--claude`
- `--opencode`
- `--cursor`
- `--qwen`
- `--droid`
- `--copilot`
- `--gemini`

Model override:

- `--model <name>`
- `--sonnet` (shortcut for `--claude --model sonnet`)

Pass engine-specific args through (anything after `--` is forwarded):

```bash
ralphy --copilot --prd PRD.md -- --allow-all-tools --allow-all-urls
```

## Core loop controls

- `--max-iterations <n>`: stop after completing N tasks
  - wf-ralph default is `1` (one task per iteration, run repeatedly)
- `--max-retries <n>`: retries per task (default is 3)
- `--retry-delay <seconds>`: delay between retries
- `--dry-run`: preview only
- `-v, --verbose`: debug output

## Quality and git behaviour

- `--no-tests`: skip tests
- `--no-lint`: skip lint
- `--fast`: skip tests + lint
- `--no-commit`: do not auto-commit

wf-ralph defaults:

- dev: keep tests/lint on, rely on `verify` skill after each iteration
- research: use `--fast`

## Browser automation

Ralphy browser automation is via agent-browser.

- `--browser`: force enable browser automation
- `--no-browser`: force disable

wf-ralph default: `--no-browser` and use `test-browser` skill instead.

## Branch + PR workflow

- `--branch-per-task`: one branch per task
- `--base-branch <name>`: base branch name
- `--create-pr`: create PRs
- `--draft-pr`: create draft PRs

wf-ralph default: run on current branch (closest to Ralph).

## Parallel execution

Use only when intentionally running multiple tasks at once.

- `--parallel`: enable parallel execution (default max 3 agents)
- `--max-parallel <n>`: set number of agents
- `--sandbox`: use sandbox mode instead of git worktrees
- `--no-merge`: skip auto-merge in parallel mode

wf-ralph default: parallel off.
