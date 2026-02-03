---
name: spike
description: This skill should be used when shaping work and needing to de-risk rabbit holes (technical unknowns, design gaps, interdependencies) by running timeboxed spikes, documenting proof, and updating the shaped concept with patches, cuts, and out-of-bounds so the work stays thin-tailed within the appetite.
---

# Spiking

## Purpose

Turn uncertainty into proof fast.

Based on Shape Up and Ryan Singer's work.

Use spikes to answer “can this be done within the appetite?” with something more concrete than opinions: a small experiment, a thin slice, or a short code sketch that demonstrates the wiring.

Spikes are not mini-projects. They exist to remove a tail of risk.

## When to use

- A shaped concept looks plausible but contains **rabbit holes** (unknowns that could explode the schedule).
- There are technical assumptions that need verification.
- There is a misunderstood dependency or integration boundary.
- A team would otherwise be asked to resolve a hard decision under deadline.

## Inputs to request or infer

- Appetite / timebox for shaping and for the eventual build.
- The current concept (breadboard, parts list, fit check).
- The specific risk or question.
- The environment constraints (stack, access, deployment rules).

## Workflow

### 1) Identify rabbit holes

Slow down and review the concept critically.

- Walk through the main use case in slow motion.
- Look for gaps where “something” is assumed to happen.
- Question each element:
  - require new technical work?
  - depend on a system that isn’t well understood?
  - assume a design solution exists?
  - hide a hard product/UX decision?

Capture each rabbit hole in a risk list.

Use `references/templates/risk-register-template.md`.

### 2) Choose the mitigation move

For each rabbit hole, choose one primary action:

- **Patch the hole**: dictate a compromise/trade-off that removes uncertainty.
- **Declare out of bounds**: explicitly say what will *not* be supported.
- **Cut back**: drop non-essential flavour that adds tail risk.
- **Spike**: run an experiment to prove a “straight shot” exists.

Write the decision and why.

### 3) Define the spike

Specify the spike with tight edges:

- Question: one sentence.
- Success criteria: what proof looks like.
- Timebox: a hard cap.
- Scope: smallest possible slice.
- Artefacts: what to keep (notes, tiny code snippet, diagrams), what to throw away.

Use `references/templates/spike-plan-template.md`.

### 4) Execute the spike

Keep it narrow.

Typical spike shapes:

- **Wiring spike**: show that A -> B -> C can be wired together (UI event, state, service call, render).
- **Integration spike**: prove a third-party/system boundary behaves as assumed.
- **Performance spike**: prove a query, indexing strategy, or paging approach meets the rough bar.
- **State spike**: prove state can be persisted/restored (URL, storage, back button) without brittle hacks.

Capture only what is needed to communicate the result:

- Minimal reproduction steps.
- Key code snippets or pseudocode.
- Constraints discovered.
- Red flags (tangles, hidden dependencies, unexpected side-effects).

### 5) Conclude: straight shot, tangle, or fog

Classify the outcome:

- **Straight shot**: few moving parts, clear stopping points.
- **Tangle**: touches many parts, cascading changes, likely scope blow-up.
- **Fog**: cannot see the end yet; needs more discovery or a different approach.

Then decide:

- proceed with current concept (and record the proof)
- revise the concept (patch/cut/out-of-bounds)
- drop the concept and explore a different one

### 6) Update the shaped work

Immediately fold the results back into the artefacts so nobody has to remember context later.

- Update breadboard/wiring diagram to match reality.
- Update parts list (add/remove parts based on the proof).
- Update fit check (convert ⚠️ unknowns to ✅/❌ or reframe requirements).
- Add a “Rabbit holes” section that includes the spike outcome and the patch.

### 7) Produce a spike report

Write a tight report that can be pasted into the pitch.

Use `references/templates/spike-report-template.md`.

## Quality bar

- Timebox honoured.
- Proof beats opinions.
- Output is legible to someone joining later.
- Spike reduces risk *or* triggers a scope cut.

## Bundled resources

- `references/shapeup-risks-rabbit-holes-notes.md` — summary of Shape Up Ch 5 concepts.
- `references/templates/*` — spike plan/report and risk/rabbit-hole templates.
- `references/examples/sample-spike.md` — example spike write-up.
