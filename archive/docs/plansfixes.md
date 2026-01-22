# Plan: Codex-only fixes

Scope: Codex only. Claude later in `docs/plans/plan.md`.

## Issues + decisions

1) Issue: Codex commands include Claude-only constructs (Task/subagents, AskUserQuestion, worktrees, figma-design-sync, imgup). Priority: P1. Options: A) remove and replace with Codex-friendly steps B) keep + tag CLAUDE_ONLY C) leave as-is. Selected: A.

2) Issue: Output paths mismatch contract (`plans/`, `todos/`, wrong template path). Priority: P1. Options: A) change contract to match commands B) update commands+skills to `docs/` paths C) allow both. Selected: B.

3) Issue: Baseline workflow commands are stubs (wf-explore, wf-shape, wf-release) and miss required inputs/outputs/examples/verification. Priority: P1. Options: A) implement minimal complete workflows now B) drop from baseline C) keep TODOs. Selected: A.

4) Issue: Skill packaging violations (name/folder mismatch, >500 LOC, nonstandard dirs, schema at root, file-todos path). Priority: P2. Options: A) fix in place, move content to references/assets, trim SKILL.md B) move to inspiration only C) split into new skills. Selected: A.

5) Issue: pnpm-only rule violated (npm installs, package-lock). Priority: P2. Options: A) convert to pnpm, remove npm lock B) mark npm-only C) ignore. Selected: A.

6) Issue: Cheatsheet/verify do not enforce lintable bullet structure. Priority: P2. Options: A) add required bullet lists + update verify.sh checks B) change requirement C) leave manual. Selected: A.

## Order
- P1: items 1-3
- P2: items 4-6
