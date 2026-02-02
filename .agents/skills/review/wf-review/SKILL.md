---
name: wf-review
description: This skill should only be used when the user uses the word workflow and asks to run a review workflow (multi-pass review, todos, verification).
---

# wf-review

## Purpose

Single-agent exhaustive review: start with native `/review`, then multi-angle passes, mandatory file-todos, verification, GO/NO-GO.

## Inputs

- Review target: PR number/URL, branch name, file path, or current branch.
- PRD + acceptance criteria.
- Code changes/PR diff.
- Relevant logs or test outputs.

## Outputs

- Review summary + severity breakdown.
- Todo files for all findings (file-todos skill).
- Verification results + GO/NO-GO.
- Optional browser QA notes.

## Steps

1. Define work slug (prefer `0001_<short>`), gather context, and ensure correct branch.
   - PR number/URL: use `gh pr view --json` to capture title/body/files.
   - If not on target branch, ask before checkout/worktree.
2. Run native `/review` (Claude/Codex) for baseline findings.
3. Run review passes (single-agent, sequential; no sub-agents):
   - security-sentinel, performance-oracle, architecture-strategist, data-integrity-guardian, agent-native-reviewer, pattern-recognition-specialist.
   - Language reviewer if relevant (e.g. kieran-typescript-reviewer, kieran-python-reviewer).
   - Simplification pass: code-simplicity-reviewer.
   - If migrations/backfills: add data-migration-expert + deployment-verification-agent.
4. Deep-dive phases (single-agent):
   - Stakeholders: developer, ops, end user, security, business.
   - Scenarios: invalid inputs, boundaries, concurrency, scale, timeouts, resource exhaustion, data corruption, security attacks.
5. Synthesize findings: de-dupe, categorize, severity (P1/P2/P3), effort (S/M/L).
6. Create todos (mandatory): use `file-todos` skill for **all** findings.
   - Store in the active dossier folder (e.g. `docs/04-projects/<lane>/<id>_<slug>/todos/`).
   - Periodic reviews: store under `docs/05-reviews-audits/<slug>/todos/`.
7. Run the verify skill in the target repo.
8. **If verify fails**, ask: "Fix failures now? (y/n)"
   - **Yes**: Ask max iterations (default 10). Loop: pick top failure, fix, re-run targeted check, then re-run verify skill until clean or max reached.
   - **No**: Continue to summary with failures noted.
9. If UI/user-flow changed, run `test-browser` and record results.
10. Write review summary and GO/NO-GO.

## Verification

- Verify skill
- Optional: `test-browser` (UI/user-flow changes)

## Go/No-Go

- GO if verify is green and no high-risk gaps remain.
- NO-GO if correctness, rollout, or security risks are unresolved.
