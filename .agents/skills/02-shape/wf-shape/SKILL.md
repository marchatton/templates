---
name: wf-shape
description: This skill should only be used when the user uses the word workflow and asks to shape a project from messy inputs into a de-risked, de-scoped shaped packet (brief, breadboard, risks, spikes) ready for wf-plan, with handoff/pickup boundaries to avoid context rot.
---

# wf-shape

## Purpose

Turn messy inputs into a shaped packet that is ready for commit-ready planning (wf-plan) or, for small/low-risk work, ready to go straight into wf-develop driven by `prd.json`.

Optimise for:
- picking the problems/opportunities that create high user and/or business value
- de-scope (draw the perimeter)
- risks understood (rabbit holes surfaced + treated)
- concrete artefacts (brief + breadboard + spikes)
- PRD spine that agents can actually execute against

## Inputs

- Raw notes, feature idea, bug report, links
- Constraints + appetite/timebox
- Any existing artefacts (designs, metrics, incidents)

## Outputs (dossier)

Create/update a dossier folder:
- `docs/04-projects/<lane>/<id>_<slug>/`

Files:
- `brief.md` (1–2 pager)
- `breadboard-pack.md`
- `risk-register.md`
- `spike-investigation.md` (optional; single file)
- `prd.md` (can be one or many)
- `prd.json` (recommended; created via `create-json-prd`) (can be one or many)

## Steps

0) Pickup (recommended if resuming / new thread)
- Understand where we are in the process.
- If new, start at step 1.
- Otherwise start at the relevant step (usually step 8), but first ensure previous steps have been completed.

1) Start a dossier (if not created already)
- Choose `id_<slug>` (prefer `0001_<short>`).
- Choose a lane under `docs/04-projects/`.
- Create dossier + stub files.

2) Write the 1–2 pager brief
- Inputs should come from the user by invoking `ask-questions-if-underspecified` and/or using relevant context.
- Write `brief.md`.
- Hard requirements:
  - goals + non-goals
  - in-scope/out-of-scope perimeter
  - top risks + unknowns
  - open questions
  - GO/NO-GO placeholder

3) Breadboard
- Invoke breadboarding skill.
- Save as `breadboard-pack.md` (places/affordances/connections + parts list + rabbit holes + fit check).

4) Risk register
- Write `risk-register.md`.
- For every top risk choose: Cut / Patch / Spike / Out-of-bounds.

5) Spike investigation (only for Spike items)
- Invoke spike-investigation skill for each Spike.
- Record results in `spike-investigation.md`.

6) Oracle bundle (mandatory)
- Invoke `oracle` once to create an oracle bundle for the dossier so later oracle passes have clean, repeatable context.
- Bundle inputs should include (at minimum):
  - dossier `brief.md`
  - dossier `breadboard-pack.md`
  - dossier `spike-investigation.md` 
  - dossier `risk-register.md`
  - any raw notes/links that materially affect scope
  - any existing artefacts (designs, metrics, incidents) that materially affect decisions

7) Midpoint handoff (mandatory, before PRD creation)
- Invoke `handoff` skill as a context checkpoint (this is separate from the final handoff).
- Include:
  - dossier path
  - current brief status + perimeter draft (in/out)
  - all context from dossier files
  - oracle bundle created: y/n + what was included
  - next step: PRD creation

8) Pickup on context
- User manually links to the midpoint handoff file and oracle findings and invokes the `pickup` skill.

9) Review oracle pass and make updates to:
- `brief.md`
- `breadboard-pack.md`
- `spike-investigation.md` (when present)
- `risk-register.md`

Also consider making updates to relevant `docs/03-architecture` documents where required.

10) PRD (source of truth for “done”)
- Use the `create-prd` skill to create one or many `prd.md` in the dossier.
- If acceptance criteria are missing, write explicit TODOs rather than vibes.

11) JSON PRD (recommended)
- Run `create-json-prd` skill so agents/tools can execute acceptance criteria.
- Each `prd.md` should have a corresponding `prd.json`.
- Ensure it validates against the repo schema (NO-GO if invalid).

12) Synthesis + perimeter lock
- Update `brief.md`, `prd.md`s and `prd.json`s to reflect the final perimeter, cuts, and risk treatments.
- Ensure breadboard is buildable as parts.

13) Shaping decision
- GO only if biggest risks are proved, cut, or out-of-bounds.

14) Handoff (pick wf-plan vs wf-develop explicitly)
- Invoke `handoff` and include:
  - dossier path
  - perimeter (in/out)
  - biggest risks + spike outcomes
  - PRD status (`prd.json` validated? y/n)
  - **Plan needed: yes/no + why**
- Recommended paths:
  - If Plan needed = yes → wf-plan
  - If Plan needed = no → wf-develop using `prd.json`
- Recommend starting the next step in a fresh thread:
  - `/new` then `pickup` then run wf-plan or wf-develop with the dossier path

## Verification

- brief has perimeter + testable outcomes
- risk register has a mitigation for each top risk
- PRD exists with acceptance criteria
- `prd.json` validates (when created)

## Go/No-Go

- GO if a stranger can explain what will be built and what won’t from brief + PRD + breadboard.
- NO-GO if core mechanics are still foggy.
