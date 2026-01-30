# wf-shape

## Purpose

Produce a PRD and optional supporting artefacts that are ready for implementation.

## Inputs

- Opportunity brief or problem statement.
- Constraints, dependencies, and risks.
- Existing Explore artefacts (if any).

## Outputs

- `docs/05-prds/<slug>.md`
- Optional: `docs/05-prds/<slug>_breadboard.md`
- Optional: `docs/05-prds/<slug>_spike-plan.md`
- Optional: `docs/05-prds/<slug>_plan.md`
- Optional: `docs/05-prds/<slug>.json`
- Required for tooling: `.agents/tasks/prd-<slug>.json`

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering).
2. Run skill `create-prd` and fill acceptance criteria + verification plan.
3. Add breadboard and spike plan if needed.
4. Run `deepen-plan` when sequencing is complex.
5. Generate JSON PRD from the PRD (include optional artefacts if present).

## Verification

- Acceptance criteria are testable and mapped to verification steps.

## Go/No-Go

- GO if success criteria and verification plan are explicit.
- NO-GO if success criteria or verification plan is missing.
