---
name: create-json-prd
description: Convert PRD to JSON PRD for tooling. Use when tools require json-prd.
---

# Create JSON PRD

## Inputs
- PRD doc
- Optional: breadboard, spike plan, deepen plan

## Outputs
- JSON PRD saved alongside the PRD markdown with the matching basename (per `docs/04-projects/AGENTS.md`):
  - `prd.md` -> `prd.json`
  - `prd-overall.md` -> `prd-overall.json`
  - `prds/.../prd.md` -> `prds/.../prd.json`

## Steps
1. Read PRD; extract project, branch name, description, user stories.
2. For each story: id (US-001), title, description, acceptanceCriteria[], priority int.
3. Add optional fields if helpful: `passes` (false), `notes` (empty).
4. Save the JSON next to the PRD markdown with the matching basename:
   - `prd.md` -> `prd.json`
   - `prd-overall.md` -> `prd-overall.json`
   - Slice PRDs: `prds/<slice_id>_<slug>/prd.md` -> `prds/<slice_id>_<slug>/prd.json`
5. Validate against repo schema (find `json-prd.schema.json` in docs templates); fix gaps or NO-GO.

## Verification
- JSON validates against schema.
- All PRD acceptance criteria captured.
