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
- Preferred tracking: `prd.md` and `prd.json` (especially `prd.json`)

## Outputs (dossier)

Create/update a dossier folder:
- `docs/04-projects/<lane>/<id>_<slug>/`

Files:
- `brief.md` (1–2 pager)
- `prd.md`
- `prd.json` (recommended; created via `create-json-prd`)
- `breadboard-pack.md`
- `risk-register.md`
- `spike-investigation.md` (optional; single file)

## Steps

0) Pickup (recommended if resuming / new thread)
- Invoke `pickup` if repo/dossier context is not fresh.

1) Start a dossier
- Choose `id_<slug>` (prefer `0001_<short>`).
- Choose a lane under `docs/04-projects/`.
- Create dossier + stub files.

2) Write the 1–2 pager brief
- Write `brief.md`.
- Hard requirements:
  - goals + non-goals
  - in-scope/out-of-scope perimeter
  - top risks + unknowns
  - open questions
  - GO/NO-GO placeholder

3) PRD (source of truth for “done”)
- Create/update `prd.md` in the dossier.
- Capture user stories and measurable acceptance criteria.
- If acceptance criteria are missing, write explicit TODOs rather than vibes.

4) Breadboard
- Invoke breadboarding skill.
- Save as `breadboard-pack.md` (places/affordances/connections + parts list + rabbit holes + fit check).

5) Risk register
- Write `risk-register.md`.
- For every top risk choose: Cut / Patch / Spike / Out-of-bounds.

6) Spike investigation (only for Spike items)
- Invoke spike-investigation skill for each Spike.
- Record results in `spike-investigation.md`.

7) Oracle pass (mandatory per spike)
- After each spike section, invoke `oracle` skill.
- Append oracle notes and apply cuts/patches if needed.

8) JSON PRD (recommended)
- Run `create-json-prd` so agents/tools can execute acceptance criteria.
- Ensure it validates against the repo schema (NO-GO if invalid).

9) Synthesis + perimeter lock
- Update `brief.md` and `prd.md` to reflect the final perimeter, cuts, and risk treatments.
- Ensure breadboard is buildable as parts.

10) Shaping decision
- GO only if biggest risks are proved, cut, or out-of-bounds.

11) Handoff (pick wf-plan vs wf-develop explicitly)
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
