# wf-explore

## Purpose

Define the opportunity and next experiment before shaping.

## Inputs

- Problem context and target users.
- Current metrics or qualitative signals.
- Constraints and known risks.

## Outputs

- `docs/00-strategy/<slug>_opportunity-solution-tree.md`
- Optional: `docs/00-strategy/<slug>_customer-segmentation.md`
- Optional: `docs/00-strategy/<slug>_positioning.md`
- Optional: `docs/00-strategy/<slug>_roadmap.md`
- Optional: `docs/00-strategy/<slug>_pricing-packaging.md`

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering).
2. Run skill `opportunity-solution-tree` to capture problems, opportunities, and experiments.
3. Add optional segmentation/positioning/roadmap/pricing docs if needed.
4. Summarize the next experiment and expected learning.

## Verification

- Target user, target metric, riskiest assumption, and next experiment are explicit.

## Go/No-Go

- GO if the opportunity is scoped and the next bet is clear.
- NO-GO if it is a list without a testable next step.
