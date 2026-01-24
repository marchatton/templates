# wf-review

## Purpose

Wrapper around native `/review` (Claude/Codex) with verification, optional fix loop, and risk checks.

## Inputs

- PRD and acceptance criteria.
- Code changes or PR diff.
- Relevant logs or test outputs.

## Outputs

- `docs/review/<slug>/review.md`
- Optional: `docs/review/<slug>/browser-qa.md`

## Steps

1. Define the work slug and gather context.
2. Run native `/review` command (Claude/Codex) to capture review findings.
3. Run `pnpm verify` in the target repo.
4. **If verify fails**, ask: "Run review-loop to fix bugs? (y/n)"
   - **Yes**: Run `review-loop` skill with default 10 iterations until clean or max reached.
   - **No**: Continue to summary with failures noted.
5. Optionally run `test-browser` (wraps `agent-browser`) and record results.
6. Write review summary and GO/NO-GO.

## Verification

- `pnpm verify`
- Optional: `test-browser`

## Go/No-Go

- GO if verify is green and no high-risk gaps remain.
- NO-GO if correctness, rollout, or security risks are unresolved.

## Usage

- Codex: `/prompts:wf-review <slug>`
- Claude: `/wf-review <slug>`
