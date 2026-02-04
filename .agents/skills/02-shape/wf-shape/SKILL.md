---
name: wf-shape
description: This skill should only be used when the user uses the word workflow and asks to shape a project from messy inputs into a de-risked, de-scoped shaped packet (brief, breadboard, risks, spikes) ready for wf-plan.
---

# wf-shape

## Purpose

Turn messy inputs into a shaped packet that is ready to be turned into a commit-ready plan.

Optimise for:
- De-scope (draw the perimeter)
- Risks understood (rabbit holes surfaced + treated)
- Concrete artefacts (brief + breadboard + spikes)

## When to use

- Problem/solution is messy, ambiguous, or contested.
- Perimeter is not yet drawn (what’s in vs out).
- Key flow is unclear (UX + data + ops interplay).
- There are high-risk unknowns that need proof (auth, payments, privacy, migrations, external APIs, unfamiliar architecture).

## Inputs

- Raw notes, feature idea, bug report, screenshots, links.
- Constraints: appetite/timebox, team, platforms, compliance.
- Any existing artefacts (designs, prior plans, incidents, metrics).

## Outputs

Create/update a single dossier folder and write these artefacts:

**Dossier folder (default):**
- `docs/04-projects/<lane>/<id>_<slug>/`

**Files:**
- `brief.md` (1–2 pager)
- `breadboard-pack.md`
- `risk-register.md`
- `spike-investigation.md` (optional; single file)

If the repo structure differs, locate the canonical project dossier location and follow it.

## Workflow

Start with the brief. Do not breadboard without it.

### 0) Start a dossier

- Choose `id_<slug>` (prefer `0001_<short>` for ordering).
- Choose a `<lane>`.
  - If unsure, list existing lanes under `docs/04-projects/` and pick the best match.
- Create the dossier folder.
- Create empty files (or stubs) for the outputs above.

### 1) Write the 1–2 pager brief

- Draft `brief.md` using `../breadboarding/references/templates/brief-template.md`.
- Keep it short; link out instead of bloating the brief.

Hard requirements inside `brief.md`:
- Problem alignment: why this matters, evidence.
- Goals (prioritised) and non-goals (explicit).
- De-scope / cuts (what is out, with reasons).
- A perimeter statement (what we are building).
- Top risks + unknowns (max 10).
- Open questions (max 10).
- “Shaping decision” placeholder (GO/NO-GO).

### 2) Breadboard the solution

- Invoke the breadboarding skill.
- Save the output as `breadboard-pack.md`.

Hard requirements in `breadboard-pack.md`:
- Places / surfaces.
- Affordances.
- Connections (wiring).
- Data contracts (inputs/outputs).
- Parts list (BOM).
- Out-of-bounds list.
- Rabbit holes list.
- Fit check: what is still foggy.

### 3) Build the risk register

- Create/update `risk-register.md` using `references/risk-register-template.md`.
- Pull risks from:
  - the brief (unknowns)
  - the breadboard (rabbit holes / fit check)

For each risk/unknown, choose one mitigation move:
- **Cut** (remove from scope)
- **Patch** (a simplifying assumption or constraint)
- **Spike** (proof required)
- **Out-of-bounds** (explicitly not handled)

### 4) Spike the rabbit holes (only when needed)

- For each risk marked **Spike**, invoke the `spike` skill.
- Record all spike outputs inside `spike-investigation.md`.
  - Use `references/spike-section-template.md` as the per-spike skeleton.

Hard requirements per spike section:
- The question to prove.
- The approach to get proof.
- The result.
- The decision (straight shot / tangle / fog).
- The consequence (what changes in scope or approach).
- Evidence links (docs paths, file paths, external refs).

Do not build production code in spikes. Treat spikes as proof gathering.

### 5) Run oracle on every spike (mandatory)

- After each spike section, invoke the `oracle` skill as a challenge pass.
- Append an “Oracle notes” subsection under that spike:
  - what was missed
  - hidden dependencies
  - failure modes
  - what would prove this is wrong

If oracle flags a major trap:
- Cut scope, patch the approach, mark out-of-bounds, or schedule a follow-up spike.
- Do not ignore the oracle output.

### 6) Synthesis + de-scope lock

- Update `brief.md` so it matches reality:
  - Perimeter now crisp.
  - Cuts are explicit.
  - Risks have treatments (cut/patch/spike/out-of-bounds).
  - Links to breadboard + risk register + spikes.

- Ensure the breadboard is buildable as parts and connections, not just vibes.

### 7) Shaping decision

Write the decision at the bottom of `brief.md`:
- **GO** if perimeter is drawn and the biggest risks are either proved, cut, or explicitly out-of-bounds.
- **NO-GO** if core mechanics are still foggy or the plan depends on “we’ll figure it out later”.

If GO, hand off to wf-plan with the dossier path.

## Verification

- `brief.md` has goals/non-goals + de-scope + perimeter + open questions.
- `breadboard-pack.md` includes places/affordances/connections + parts list.
- `risk-register.md` has a chosen mitigation for every top risk.
- `spike-investigation.md` exists when needed, and every spike has oracle notes.

## Go/No-Go

- GO if a stranger can read the brief + breadboard and explain what will be built and what won’t.
- NO-GO if the perimeter is still porous or the riskiest bits are still opinion.
