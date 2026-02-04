---
name: wf-plan
description: This skill should only be used when the user uses the word workflow and asks to create a commit-ready, deep project plan from a shaped packet (brief, breadboard, risks, spikes) before development starts.
---

# wf-plan

## Purpose

Turn a shaped packet (from wf-shape) into a commit-ready plan.

Never implement. Never write production code. Only research and write the plan.

## When to use

- There is a shaped packet and the team is considering committing to build.
- The change has non-trivial blast radius (new flows, new data, external integrations, platform work).
- The work needs sequencing, rollout thinking, or multiple contributors.

## Inputs

A dossier folder path containing the shaped packet:
- `brief.md`
- `breadboard-pack.md`
- `risk-register.md`
- `spike-investigation.md` (if spikes were needed)

## Outputs

Write a single plan file inside the same dossier folder:
- `plan.md`

## Workflow

### 0) Ingest the shaped packet

- Read `brief.md` first.
- Read `breadboard-pack.md`, `risk-register.md`, and `spike-investigation.md`.
- If `brief.md` is missing and this is a larger feature, stop and route to the brief skill.

If any of the following are missing, stop and route back to wf-shape:
- perimeter (in vs out)
- at least one end-to-end key flow
- top risks treated (cut/patch/spike/out-of-bounds)

### 1) Create the plan skeleton

- Create `plan.md` using `references/plan-template.md`.
- Link back to the shaping artefacts.
- Date the plan (current year is 2026).

### 2) Local research (always)

Goal: match the repo’s patterns and avoid re-solving known problems.

- Find repo conventions (templates, naming, docs guidance).
- Search for similar implementations.
- Search institutional learnings (`docs/learnings.md`, `docs/solutions/`, etc).
- Capture exact file paths and concrete notes.

Write findings into `plan.md` under **Research & references**.

### 3) External research decision (conditional)

Decide whether to do external research.

Always do external research for:
- security/auth
- payments
- data privacy/compliance
- external APIs/integrations
- migrations/backfills with real data risk

Also do external research when:
- the repo has no clear precedent
- the approach feels foggy

If external research is done:
- prefer primary sources (official docs, standards)
- capture links + key takeaways in `plan.md`

### 4) Plan the build (deep)

Fill `plan.md` so it is build-ready.

Hard requirements:
- Scope: in/out (copy the perimeter from the brief).
- Key flows: reference breadboard, then specify acceptance criteria.
- Technical approach: map to breadboard parts.
- Sequencing: phases with explicit stop points.
- Verification plan: what proves each acceptance criterion.
- Rollout/rollback plan.
- Observability plan (metrics/logs/alerts).
- Dependencies + prerequisites.
- Risks + mitigations (pull from risk register; update if needed).

### 5) Spec hardening (gap pass)

Run a structured gap pass and patch the plan:
- edge cases and boundaries
- failure modes
- concurrency/race conditions (if relevant)
- performance constraints
- security threats (if relevant)
- data integrity/migrations (if relevant)

Update acceptance criteria and verification steps based on gaps.

### 6) Plan review passes (pre-commit)

Use `references/plan-review-checklist.md`.

Do the passes, then integrate fixes into `plan.md` (do not leave review notes dangling):
- Simplicity
- Risk
- Ops / release
- Data integrity
- Security & privacy
- UX / product

Then run the final mandatory pass:
- Invoke the `oracle` skill as a challenge pass on the whole plan.
- Apply oracle findings (or explicitly mark as out-of-bounds with rationale).

### 7) Commit gate

End `plan.md` with a commit decision.

**GO** only if:
- acceptance criteria are measurable
- verification steps exist per criterion
- sequencing is explicit
- rollout/rollback is explicit
- no P1 unknowns remain (or they are explicitly cut/out-of-bounds)

If NO-GO:
- state what must happen next (usually targeted wf-shape spike/breadboard update)

### 8) Handoff

If GO:
- proceed to wf-develop (tight verify loop) or wf-ralph (high-iteration loop)
- treat `plan.md` as the canonical build input

## Verification

- `plan.md` is complete and internally consistent.
- Plan includes acceptance criteria + verification + rollout.
- Research references include concrete file paths and links.
- Oracle pass completed and integrated.

## Go/No-Go

- GO if the plan can be built without re-discovering the shape.
- NO-GO if the plan depends on “we’ll figure it out during implementation”.
