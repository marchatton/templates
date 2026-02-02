---
name: wf-develop
description: This skill should only be used when the user uses the word workflow and asks to develop or implement changes with a verification-first loop.
---

# wf-develop

## Purpose

Implement changes with a verification-first loop.

## Inputs

- Approved PRD and acceptance criteria.
- Target repo and branch.
- Known risks and dependencies.

## Outputs

- Code changes.
- Docs artefacts saved per `docs/AGENTS.md` in the target repo (dev log summary + verification + GO/NO-GO).

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering) and open the target repo.
2. Implement changes with tight, verifiable increments.
3. Run the verify skill (pnpm ladder).
4. Write a dev log with summary, verification, and GO/NO-GO.

## Verification

- Verify skill (pnpm ladder).

## Go/No-Go

- GO if ladder is green and acceptance criteria met.
- NO-GO if any command fails or behavior cannot be demonstrated.
