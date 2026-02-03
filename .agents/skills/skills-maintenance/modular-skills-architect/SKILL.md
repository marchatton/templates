---
name: modular-skills-architect
description: Map and refactor an agent context ecosystem: skills, commands/workflows, hooks, agent files, AGENTS.md templates, and docs. Output system map, module/dependency design, Register updates, and a concrete split/consolidate/rename/delete plan. Use when routing or ownership is messy.
---

# Modular Skills Architect

the modular-skills-architect must flow

Consistency across skills not required. Do not standardize structure unless asked.

## Canonical repo only (important)

Use this skill **only** in the canonical templates repo where agent instructions live (GitHub: `marchatton/templates`; local path may differ).

If you are running this from another repo:
- stop and switch to the canonical repo first, or you will refactor the wrong source of truth
- update this line to the correct canonical repo link/name for your org

## Provenance + control model (also important)

Not everything is truly "owned" by this repo. Treat each artefact (skill/command/hook/agent file/template) as one of:

1) **Forked (you hold master)**
- canonical source is your fork; you can change it here
- refactors can be implemented directly (still keep changes small)

2) **Synced / drifted**
- you have a local or downstream copy that differs from what "master" says
- treat as risky until reconciled
- refactor output must include a sync plan: real source of truth + how to converge

3) **External (called, not stored)**
- e.g. invoked via `npx <thing>` like `npx agent-skills`
- you do not edit it here; you can only:
  - wrap it (command wrapper)
  - document it (how/when)
  - pin versions
  - replace it with an owned implementation (only if justified)

This skill must surface provenance early, and every recommendation must state which bucket it touches and what that implies (direct change vs wrapper vs upstream work vs reconcile).

## Use when

- inherited messy skills/commands/workflows/AGENTS/docs and nobody can explain fit
- combining sources and need to consolidate + rationalise, keep it simple
- skills overlap, routing surprises, outputs inconsistent, glue logic in wrong place
- need concrete refactor plan (split/consolidate/rename/delete), not theory

## Avoid when

- only need one existing workflow (`wf-*`) and nothing structurally broken
- missing almost all inputs and cannot locate corpus (still proceed if partial, label assumptions)

## Inputs to ingest (treat all as one ecosystem)

For every artefact, capture:
- location (path or invocation)
- owner/source of truth
- provenance bucket: local / forked / synced / external
- upstream: repo + path when forked/synced

1) Skills corpus
- each skill purpose/scope
- tool requirements
- output conventions (templates, filenames, formatting)
- cross-skill references + shared patterns
- provenance for each skill (local/forked/synced/external)

2) Commands + workflows corpus
- all commands (including workflow commands `wf-*`)
- how commands are routed or invoked
- which workflows call which skills/commands
- naming, arguments, expected outputs, GO/NO-GO semantics
- implied orchestration logic and where it lives
- provenance for each command/workflow (local/forked/synced/external)

3) Hooks corpus
- hook inventory (even if examples only)
- trigger conditions + precedence
- conflicts (multiple hooks apply) and fallout
- what belongs in hooks vs commands vs skills
- provenance for hooks/templates (local/forked/synced/external)

4) Agent files + policy corpus
- agent configs, system prompts, routing logic, tool policies
- glue behavior outside individual skills
- provenance (local/forked/synced/external) and what is actually authoritative

5) AGENTS.md corpus (including templates)
- root `AGENTS.md` + scoped AGENTS (apps/web, docs/*, release, etc)
- templates (e.g. `docs/agentsmd/*`)
- source-of-truth rules + symlink expectations
- repeated guidance that should move into skills/commands (or vice versa)
- provenance (local/forked/synced/external) for any template sources

6) Document structure
- folder layout + naming conventions
- where truth lives (single source vs scattered)
- duplicated/overlapping docs (guides vs skills vs templates)
- templates + scaffolding sources

7) Optional constraints
- preferred module boundaries (tool, domain, workflow stage)
- constraints like avoid new tools, keep onboarding < 10 minutes
- target audience (novice vs expert operators)

If missing, make best-effort assumptions and record them under **11. Assumptions**.

## Outputs

Practical architecture + refactor plan using required headers (below). Not theory.

Also create or update the **Register** in the canonical repo:
- canonical location: `.agents/register.json`
- purpose: machine-readable inventory + tiering + provenance for skills (optional: commands/workflows/hooks/AGENTS templates)
- optional README ok, but derived from `register.json` (register is source of truth)

Dependency map output:
- list of `a -> b` edges
- render as mermaid diagram

## Register (required)

### File: `.agents/register.json` (source of truth)
Store metadata for ecosystem. Minimum: all skills. Recommended: include commands/workflows/hooks/AGENTS templates too.

### Tiers (max 3)
Default tiers unless user supplies a different scheme:
- `core`
- `leaf`
- `deprecated`

### Provenance / control model (required per entry)
- `provenance`: `local` | `forked` | `synced` | `external`
- `upstream`: `{ repo, path }` (only for `forked`/`synced`)

### Required fields (skills)
- `name`
- `tier`
- `purpose` (1 line)
- `useWhen` (short signal)
- `outputs` (array of paths or artefacts)
- `ownerModule` (from proposed module list)
- `location` (path or invocation)
- `provenance`
- `upstream` (only if `forked`/`synced`)
- `replaces` / `replacedBy` (optional, deprecated)

### Recommended fields (commands/workflows/hooks/AGENTS)
- commands/workflows: `name`, `purpose`, `calls`, `outputs`, `location`, `tier` (optional), provenance fields
- hooks: `name`, `trigger`, `precedence`, `location`, provenance fields
- AGENTS templates: `name`, `scope`, `location`, provenance fields

## Refactor need score (required)

Score how close the ecosystem is to needing a refactor and include it under **1. Current System Map**.

### Refactor Need Score (0-100)
Compute a single score using a simple rubric (best-effort, label assumptions):
- overlap/duplication across skills/commands/AGENTS/docs (0-25)
- unclear routing and conflict rules (skills vs commands vs hooks vs agent logic) (0-25)
- inconsistent naming/contracts (commands, hooks, outputs, GO/NO-GO) (0-20)
- glue logic misplaced (in skills vs agent files vs workflows vs AGENTS) (0-20)
- provenance drift and unclear source-of-truth (fork vs synced vs external ambiguity) (0-10)

Interpretation:
- 0-39: ok, refactor optional
- 40-69: should refactor soon
- 70-100: refactor now

## Workflow

1) Inventory + extract contracts (skills + commands + hooks + AGENTS + agent files + docs)
- list artefacts and where they live
- for each, capture provenance + upstream
- pull implicit contracts: naming, outputs, verification, routing rules, precedence
- identify overlaps, contradictions, glue logic, drift

2) Map the current system
- who routes what (workflow command -> agent logic -> skills -> outputs)
- where decisions made (agent prompt vs command docs vs skill text vs AGENTS)
- where contracts unclear/duplicated
- where source of truth ambiguous (local vs forked vs synced vs external)
- compute **Refactor Need Score (0-100)** with rubric above

3) Propose modular architecture
- few core modules + leaf modules
- define ownership + anti-scope

4) Define dependency rules
- allowed dependency direction (and forbidden)
- shared conventions layer only if needed (tiny)
- produce dependency map: `a -> b` edges + mermaid diagram

5) Refactor recommendations (concrete)
For each: what to change, why, expected benefit.
Also state: provenance bucket + how to execute (direct change vs wrapper vs upstream vs reconcile).
Must include:
- skills to split
- skills to consolidate
- skills/sections to delete
- commands/workflows to rename or merge
- hooks to merge or tighten
- glue logic moves (skills <-> agent files <-> workflows/commands <-> AGENTS)
- sync/drift fixes when something is "synced" but not actually canonical

6) DRY plan
- repeated patterns (3+ occurrences) across skills/commands/AGENTS/templates
- consolidate minimally
- justify repetition kept
- avoid DRY that forces coupling across local/forked/external boundaries

7) Harmonise commands + hooks
- consistent naming scheme (commands + workflows)
- hook precedence rules
- conflict resolution rules (clear owner + fallback behavior)
- minimal, predictable routing rules for workflow commands
- if external tools involved, define wrapper conventions + version pinning

8) Docs + file structure proposal
- folder structure for skills, commands, hooks, agent files, AGENTS templates, workflow docs
- where source of truth lives (esp local vs forked vs synced vs external)
- examples location
- lightweight versioning/deprecation

9) Minimal refactor steps
- ordered list of small, reversible changes
- include stop points where system already meaningfully improved
- quick win in first 2 steps
- prefer "index + clarify contracts + fix routing surprises" before big reorganisations

10) Register update
- create/update `.agents/register.json` in canonical repo
- every skill classified (max 3 tiers) + provenance + upstream (if forked/synced)
- mark deprecated with replacement + removal rule

11) Examples
- 2-3 example tasks showing routing (workflow command -> agent logic -> skill modules -> output)
- include at least one conflict case (multiple skills apply) and show resolution
- include at least one example involving an external-invoked tool (npx) and show wrapper/documentation behavior

## Required output headers

Use these headers exactly, in order:
1. Current System Map
2. Proposed Module List
3. Responsibilities and Anti-Responsibilities
4. Dependency Rules
5. Refactor Recommendations
6. Consolidation Opportunities (DRY)
7. Command and Hook Harmonisation
8. Document and File Structure Proposal
9. Refactor Plan (Minimal Steps)
10. Example Task Flows
11. Assumptions

Prefer bullets over paragraphs.

## Behaviour rules

- apply DRY/YAGNI/KISS; repeat only if clarity/coupling improves
- skills/commands/AGENTS are opinionated guidance, not rigid scripts
- prefer composition over inheritance, no deep hierarchies
- keep module count low until complexity forces it
- do not invent frameworks; shared/common layer must be tiny and justified
- if components conflict (skill vs workflow vs hook vs agent file vs AGENTS), resolve to reduce operator surprise + maintenance burden
- do not propose edits to external artefacts you do not control; use wrappers, docs, pinning, or replacement plans

## Boundary heuristics (defaults)

- split by workflow stage:
  - intake + routing
  - tool execution guidance
  - output formatting + file handling
  - quality checks + verification
- split by tool only when tool changes workflow materially (PDF vs slides vs spreadsheets)
- split by domain only if domain changes constraints (legal/medical/safety)

## Verification (quality bar)

Before finalising, confirm:
- no heavy overlap between modules
- shared rules centralized only if used 3+ places
- refactor plan includes quick win in first 2 steps
- command/hook naming consistent + predictable
- Register exists and every skill classified (max 3 tiers) with provenance + upstream (if forked/synced)
- new contributor can grok system in under 10 minutes
