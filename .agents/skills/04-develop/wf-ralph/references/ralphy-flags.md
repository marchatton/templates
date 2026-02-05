# Ralphy flags reference

Keep this as a quick lookup when writing copy/paste command lines.

## Task sources

- `--prd PATH`  
  Use a markdown task file (or folder). Default is `PRD.md` if present.

- `--yaml FILE`  
  Use a YAML task file.

- `--json FILE`  
  Use a JSON task file.

- `--github OWNER/REPO`  
  Use GitHub Issues as tasks.

- `--github-label TAG`  
  Filter GitHub issues by label.

- `--sync-issue N`  
  Sync PRD progress to GitHub issue `#N` after each task.

## Engines

- Default engine: Claude Code
- Select engine:
  - `--codex` (default for wf-ralph)
  - `--opencode`
  - `--cursor`
  - `--qwen`
  - `--droid`
  - `--copilot`
  - `--gemini`

## Model selection

- `--model NAME`  
  Override the engine’s default model.

- `--sonnet`  
  Shortcut for `--claude --model sonnet` (Claude only).

## Loop and retries

- `--max-iterations N`  
  Stop after N tasks (0 = unlimited).  
  wf-ralph default: `1` per outer-loop pass.

- `--max-retries N`  
  Retries per task (default: 3).

- `--retry-delay N`  
  Seconds between retries.

- `--dry-run`  
  Preview only (no changes).

- `-v, --verbose`  
  Debug output.

## Quality gates

- `--no-tests`  
  Skip tests.

- `--no-lint`  
  Skip lint.

- `--fast`  
  Skip both tests and lint.

- `--no-commit`  
  Do not auto-commit.

## Branch and PR workflow

- `--branch-per-task`  
  Create a branch per task.

- `--base-branch NAME`  
  Base branch for branching/merging.

- `--create-pr`  
  Create PRs (mainly useful with `--branch-per-task` or parallel mode).

- `--draft-pr`  
  Create draft PRs.

## Parallel execution

- `--parallel`  
  Run multiple agents in parallel (default: 3).

- `--max-parallel N`  
  Set number of parallel agents.

- `--sandbox`  
  Use lightweight sandboxes instead of git worktrees (faster for large dependency trees).

- `--no-merge`  
  Skip auto-merge in parallel mode.

## Browser automation

- `--browser`  
  Enable agent-browser automation.

- `--no-browser`  
  Disable agent-browser automation.

wf-ralph default is `--no-browser` because UI evidence is produced via `test-browser` skill instead.

## Project config

- `--init`  
  Create `.ralphy/config.yaml` with auto-detected settings.

- `--config`  
  Show config.

- `--add-rule "rule"`  
  Append a rule into `.ralphy/config.yaml`.

## Engine-specific arguments

Pass extra args to the underlying engine CLI after `--`.

Example pattern:

```bash
ralphy --copilot --prd PRD.md -- --allow-all-tools --allow-all-urls
```
