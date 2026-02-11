---
name: breadboarding
description: This skill should be used when shaping a software change and needing to breadboard the solution at the right level of abstraction (places, affordances, connections), including mapping an existing system via UI + code affordances, producing a wiring diagram, a parts/BOM plan, a fit check, and (when relevant) an extract-vs-duplicate analysis.
---

# Breadboarding

## Purpose

Produce a Shape Up style breadboard that is concrete enough to guide a build, without collapsing into pixel-perfect UI spec or a full-code hairball.

Based on Shape Up and Ryan Singer's work.

Treat **affordances** as the simplifying primitive.

- **UI affordances**: things a user can do (type, click, scroll) or see (states/messages) that matter to the flow.
- **Code affordances**: things the system can do (call a function, observe an observable, write/read state, navigate) that cause the UI affordances to change.

Use those to build a lightweight model of the current system and the proposed change.

## When to use

- Reach the “rough out the elements” stage and need to turn an idea into buildable parts.
- Shape a change to a **pre-existing system** and need to understand what the system actually does today.
- Compare a new concept against an existing feature and decide whether to **duplicate vs extract** shared logic.
- Pick up a shaping effort after a gap and need a fast re-orientation: current state, chosen approach, and what’s still unsolved.

## Inputs to request or infer

Prefer working with whatever exists. If inputs are missing, use `ask-questions-if-underspecified` skill

- Appetite / timebox and any hard boundaries.
- Problem statement and success definition.
- Brief (problem, goals, in/out scope). If missing, pause and draft a brief first.
- Requirements list (or a rough list of must-haves).
- Entry point(s): where the user starts, how they discover the feature.
- Existing system context: routes/screens, key components, services, data stores.
- Any comparable feature(s) to analyse for reuse.

## Workflow

### 1) Establish the “right level of abstraction”

- Avoid full wireframes and visual design.
- Prefer **words** and **connections** over pictures.
- Focus on “what’s connected to what” (topology) and “what changes state”.

Use the breadboard primitives:

- **Places**: screens/pages/modals/menus that can be navigated to.
- **Affordances**: actions and information at a place (buttons, fields, copy, empty/loading states).
- **Connection lines**: how an affordance moves between places or triggers work.

### 2) Breadboard the user flow

- Start at the entry place.
- List the minimum affordances needed to serve the use case.
- Draw (describe) connection lines for navigation and “cause/effect” transitions.

Stop when the flow answers these shaping questions:

- Where in the current system does the new thing fit?
- How does a user get to it?
- What are the key components/interactions?
- Where does it take the user next?

### 3) Inventory UI affordances

Create a numbered list (recommended prefix **U**):

For each UI affordance, record:

- **ID**: U1, U2…
- **Component / place**: where it lives
- **Affordance**: “search input”, “loading spinner”, “no results message”, etc
- **Control**: type/click/scroll/render/iterate
- **Wires out**: what it triggers (calls, navigation, messages)
- **Reads** (optional): what state/data it depends on

Keep UI affordances at the interaction level, not implementation detail.

### 4) Inventory code affordances

Create a numbered list (recommended prefix **N**):

For each code affordance, record:

- **ID**: N1, N2…
- **Component/service**: where it lives
- **Affordance**: function, observable subscription, store write/read
- **Control**: call/observe/write/read
- **Wires out**: what it calls, writes, triggers, or returns

Interpretation rule:

- If it’s something that can be “operated” from a whole-system POV to make something happen, it’s an affordance.

### 5) Build a wiring diagram from affordances

Convert the inventories into a simple directed graph using `beautiful-mermaid` skill.

- Nodes: places, UI affordances, code affordances, external services, browser events.
- Edges:
  - **Solid** for “wires out”: calls, triggers, writes
  - **Dashed** for “returns/reads”: return values, store reads

Keep it legible:

- Draw only the parts touched by the change.
- Collapse deep internals into a single node when they aren’t central to the shaped behaviour.
- If it becomes a hairball, split into sub-diagrams per place or per flow.

Required output format (both, not either/or):

1) **Source code**: include Mermaid source in a fenced ```mermaid block in the Markdown artefact.
2) **Static render**: generate and save a rendered diagram asset (SVG preferred) via `beautiful-mermaid`, and embed it in the Markdown artefact.
3) **Fallback**: also generate a terminal-safe ASCII/Unicode render (`.txt`) when practical.

Naming convention (recommended):

- `<doc-base>-wiring.svg`
- `<doc-base>-wiring.txt`

Place static assets adjacent to the breadboard Markdown file so links stay portable.
Use template `references/templates/wiring-diagram-mermaid-template.md`.

### 6) Produce a parts list (BOM)

Write a numbered parts list (recommended prefix **F** for “shape/feature parts”):

- Each part is a buildable chunk with a clear mechanism.
- Include deletes/migrations explicitly (e.g., “remove letters from widget-grid”).

For each part:

- Name the part
- Summarise the mechanism in 1–2 lines
- Call out notable trade-offs (scope cuts, simplifications)

Use `references/templates/parts-bom-template.md`.

### 7) Fit check: requirements × concept

Create a simple table:

- Rows: requirements (R0…)
- Columns:
  - requirement statement
  - status (core goal / must-have / nice-to-have / out / undecided)
  - fit with current concept (✅/❌/⚠️)

Then:

- Call out the **unsolved** requirement(s) as explicit shaping questions.
- Identify the decision needed (product/UX judgement vs technical unknown vs policy).

Use `references/templates/fit-check-template.md`.

### 8) Duplicate vs extract analysis (when overlap exists)

When a new change overlaps an existing feature, decide reuse via an **affordances overlap** rather than vibes.

Steps:

- Identify the comparable feature (existing) and the new concept.
- List shared affordances and divergent affordances.
- Compare requirements that drive divergence (URL shape, guards, state model, pagination mode, etc).
- Estimate the real code coupling cost vs the amount of duplication avoided.

Produce:

- A “Keep Shared vs Duplicate” table
- A recommendation (default bias: duplicate feature-level orchestration; extract infrastructure-level types/utilities)
- 3–5 concrete reasons, with emphasis on:
  - **divergent requirements**
  - **lines of code vs coupling cost**

Use `references/templates/extract-vs-duplicate-template.md`.

### 9) Package the breadboard as a single artefact

Output a “Breadboard Pack” as Markdown:

- Current State (what exists today)
- Proposed Breadboard (places, affordances, connections)
- UI Affordances table
- Code Affordances table
- Wiring diagram:
  - embedded static image link (`.svg`)
  - Mermaid code block (source of truth)
  - optional `.txt` fallback path
- Parts/BOM
- Fit check + unsolved questions
- Rabbit holes / out-of-bounds / cuts
- Optional: extract vs duplicate analysis

Use `references/templates/breadboard-pack-template.md`.

## Quality bar

- Stay rough, but solved: enough detail to unblock building, not enough to constrain visual design.
- Keep a consistent numbering scheme (U*, N*, R*, F*).
- Make every edge in the wiring diagram traceable back to an affordance row.
- Ensure diagram portability: a reader without Mermaid support must still see the static diagram.
- Prefer small, explicit trade-offs over implied complexity.

## Bundled resources

- `references/shapeup-breadboarding-notes.md` — summary of Shape Up breadboarding concepts.
- `references/templates/*` — reusable templates for breadboard pack, tables, diagrams, fit checks.
- `references/templates/brief-template.md` — brief template used by the brief skill.
- `references/examples/letter-search-example.md` — an end-to-end example using UI+code affordances.
- `scripts/render_mermaid_from_edges.py` — optional helper: JSON edge list -> Mermaid code (render via `beautiful-mermaid`)
