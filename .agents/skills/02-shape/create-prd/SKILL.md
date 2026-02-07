---
name: create-prd
description: Draft PRD with scope, stories, acceptance criteria, verification. Use when shaping a new feature or spec.
---

# Create PRD

## Inputs
- Problem statement + target users
- Success metric
- Constraints, risks, dependencies

## Outputs
- PRD doc saved per `docs/AGENTS.md` in target repo.
- If a dossier/project needs multiple PRDs, create a `prds/` subfolder and store them there using an ordering prefix plus a short slug (kebab-case) in the filename (for example `prds/prd-1-auth-flow.md`, `prds/prd-2-audit-log.md`, ...).

## Steps
1. Ask 3-5 clarifying questions (answerable as 1A, 2B).
2. Use PRD template from `docs/AGENTS.md`.
3. Fill sections (short, explicit):
   - Overview + goals
   - Scope + non-goals
   - User stories (US-001...), one sprint-sized
   - Acceptance criteria per story + verification notes (tests/build, browser smoke for UI)
   - Functional requirements (FR-001...)
   - Risks + dependencies
   - Success metrics + open questions
4. Ensure criteria map to verification; split oversized stories.

## Verification
- Acceptance criteria testable; verification mapped.
- Stories small, priority ordered.
- Location matches `docs/AGENTS.md`.
- If there are multiple PRDs, they are stored in a dedicated subfolder (for example `prds/`) and each has a short slug in the filename.
