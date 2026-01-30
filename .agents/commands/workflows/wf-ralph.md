# wf-ralph

## Purpose

Run a continuous coding loop with Ralph and finish with verification.

## Inputs

- `.agents/tasks/prd-<slug>.json` (required).
- Iteration count (default 10).

## Outputs

- `.agents/tasks/prd-<slug>.json`
- `.ralph/` state and logs
- Optional: `docs/06-delivery/<slug>_ralph-log.md`

## Steps

1. Ensure `.agents/tasks/prd-<slug>.json` exists (prefer `0001_<short>` slug).
2. Ask for iteration count (default 10).
3. Loop `ralph build 1` for N iterations.
4. Run `verify` and record GO/NO-GO.

## Verification

- `verify` (pnpm ladder)

## Go/No-Go

- GO if verify is green and acceptance criteria are met.
- NO-GO if any verification fails.
