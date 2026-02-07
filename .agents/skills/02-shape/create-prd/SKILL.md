---
name: create-prd
description: Draft PRD with scope, stories, acceptance criteria, verification. Use when shaping a new feature or spec.
---

# Create PRD

## Quick Start
1. Copy the template: `assets/prd-template.md`
2. Fill it out in the target dossier:
   - Single-PRD dossier: `prd.md`
   - Multi-PRD dossier:
     - Overall / spine PRD at the dossier root: `prd-overall.md`
     - Slice PRDs under `prds/`: `prds/<slice_id>_<slug>/prd.md`

   Notes:
   - Lowest-level PRD filenames are always `prd.md` (no `prd-slice-*` filenames).
   - Use a short kebab-case slug like `auth-token-rotation` or `invoice-pdf-export`.
3. Pull all details from shaping inputs into the PRD so it’s implementable without extra context (no information loss)

## PRD Slicing Rubric (Reusable)

### Rules of thumb (thin PRDs)
- One PRD should deliver **one user-visible affordance** (or one backend capability with a **measurable, observable effect**), not a whole workflow.
- Each PRD must have **measurable acceptance criteria** tied to at least one **replayable verification pack** (fixture data, synthetic dataset, scripted scenario, etc.).
- Keep PRDs **vertical-ish**: UI + a thin API/data change where needed, but avoid building platform layers unless they **directly unblock the next slice**.
- If a PRD introduces a new failure mode, it must also introduce the **UX to surface it** (no silent failures).
- Prefer **scaffold then replace**: ship a deterministic baseline behind stable contracts first, then swap in ML/OCR/retrieval/LLM (or other complex components) behind the same interface.

### Examples (good slices)
- "UI affordance X triggers state Y, persists, and is visible after refresh."
- "API returns payload + stable checksum/hash so clients can detect mismatches."
- "Verifier rejects records on checksum mismatch and surfaces a user-visible error state."
- "Parser extracts a single structured list into a table with row-level provenance."

### Examples (bad slices)
- "Build ingestion + parsing + retrieval + drafting + verification + export" (too many risks bundled).
- "Implement an autonomous multi-agent copilot" (non-deterministic + typically too broad for a single slice).
- "Add full template/customisation system" (platform work without proving the core loop).

### Red flags a PRD is too fat
- Touches 3+ major subsystems/components in one go.
- Needs more than 1-2 new schemas or widespread data model churn.
- Acceptance criteria can't be tested against a pack/fixture/script.
- Contains multiple hard unknowns at once (new parsing + matching + verification together).

### Minimum PRD structure (every PRD)
The minimum structure is defined by `assets/prd-template.md` and must include:
- Introduction/Overview (problem + goal)
- Goals
- User stories
- Functional requirements (numbered)
- Non-goals (out of scope)
- Success metrics
- Open questions

Additionally, every PRD must include:
- Acceptance criteria + verification plan (pack/fixture/script)
- Failure states + user-visible UX (no silent failures)
- Metrics/logging (at least 1 signal)
- Rollback/disable path (feature flag or safe default)
- A lightweight "Sources" section pointing to shaping inputs (brief/breadboard/spike/risk-register)

## Inputs
One or more of the following:
- Problem statement + target users
- Success metric
- Constraints, risks, dependencies
- Any existing verification packs/fixtures/scripts (or willingness to create a minimal one)

## No Context Loss (Requirement)
If any of the following shaping files exist, no information should be lost from them:
- `brief.md`
- `breadboard-pack.md`
- `spike-investigation.md`
- `risk-register.md`

Guidance:
- Prefer integrating shaping details directly into the PRD sections (requirements, risks, constraints, UX, verification).
- Add a short "Sources" section with links/paths to the shaping files you used.
- If a detail does not fit cleanly into a PRD section, add it to the appendix as notes or key excerpts. Avoid dumping large verbatim blocks by default.
- Each PRD must be implementable without needing additional context outside the PRD.

Try find this information:
- `brief.md`
- `breadboard-pack.md`
- `spike-investigation.md` 
- `risk-register.md`

Where unclear, use the `ask-questions-if-underspecified` skill.

## Outputs
- Single-PRD dossier: `prd.md` in the dossier root.
- Multi-PRD dossier:
  - Overall / spine PRD in the dossier root as `prd-overall.md`.
  - Slice PRDs under `prds/<slice_id>_<slug>/prd.md`.

## Steps
1. Ask 3-5 clarifying questions (answerable as 1A, 2B) that force a thin slice:
   - What is the single user-visible affordance (or single observable backend capability)?
   - What is the primary observable effect (what changes, where can we see it)?
   - What pack/fixture/script will we use to verify acceptance criteria?
   - What new failure modes does this introduce, and how should UX surface them?
   - What is the rollback/disable path (flag/default-off/fallback)?
2. Run the slicing rubric:
   - If the scope triggers a red flag, propose a split into PRD-1/PRD-2/... and proceed with the smallest slice that unblocks the next.
3. Use the PRD template at `assets/prd-template.md`.
4. Fill sections (short, explicit; keep the template headings):
   - Introduction/Overview + goals
   - In scope + non-goals (out of scope)
   - User stories (US-001...), one sprint-sized
   - Functional requirements (FR-001...)
   - Acceptance criteria + verification plan per story (measurable; tied to a pack/fixture/script)
   - Failure states and UX (no silent failures)
   - Metrics/logging + rollback/disable path
   - Risks + dependencies
   - Success metrics + open questions
   - Sources: link to shaping inputs used
   - Appendix (optional): shaping notes / key excerpts when needed (see "No Context Loss")
5. Ensure criteria map to verification; split oversized stories. If generating multiple PRDs:
   - Create the overall/spine PRD at the dossier root as `prd-overall.md`.
   - Create each slice PRD under `prds/<slice_id>_<slug>/prd.md` (one folder per slice).

   Each PRD must be independently implementable and must not lose shaping input information.

## Verification
- PRD delivers one affordance / one observable capability.
- Acceptance criteria measurable, testable, and tied to at least one pack/fixture/script.
- Acceptance criteria mapped to verification (tests/build/smoke/scripts).
- Failure modes surfaced in UX (no silent failures).
- At least 1 metric/log signal is specified.
- Rollback/disable path is explicit (flag or safe default).
- Stories small, priority ordered.
- Location matches `docs/AGENTS.md`.
- If there are multiple PRDs for a dossier:
  - the overall/spine PRD is `prd-overall.md` in the dossier root
  - each slice lives under `prds/<slice_id>_<slug>/prd.md` (folder-per-slice; lowest-level PRD filename is always `prd.md`)
- Sources section links to shaping inputs used.
- No information is lost from shaping inputs (details are integrated into the PRD or captured in the appendix).
