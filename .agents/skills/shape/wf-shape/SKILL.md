---
name: wf-shape
description: This skill should only be used when the user uses the word workflow and asks to shape a project (produce a PRD and supporting artefacts).
---

# wf-shape

## Purpose

Produce a PRD and optional supporting artefacts that are ready for implementation.

## Inputs

- Opportunity brief or problem statement.
- Constraints, dependencies, and risks.
- Discovery insights (interviews, data, market) if any.

## Outputs

- Docs artefacts saved per `docs/AGENTS.md` in the target repo (PRD required; optional supporting docs per skills).
- Required for tooling: `.agents/tasks/prd-<slug>.json`

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering).
2. Run skill `create-prd` and fill acceptance criteria + verification plan.
3. Add breadboard and spike plan if needed.
4. Run `deepen-plan` when sequencing is complex.
5. Run skill `create-json-prd` to generate JSON PRD (include optional artefacts if present).

## Verification

- Acceptance criteria are testable and mapped to verification steps.

## Go/No-Go

- GO if success criteria and verification plan are explicit.
- NO-GO if success criteria or verification plan is missing.
