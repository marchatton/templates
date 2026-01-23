## Inventory (reusable bits) + gaps

What you already have in-repo:

* Guardrails draft in `AGENTS.md` (clear constraints, taxonomy, attribution rules). (`AGENTS.md`)
* Inspiration mirrors:

  * Compound engineering plugin, full component set (commands, agents, skills). (`inspiration/compound-engineering-plugin/...`)
  * Agent-scripts repo (handoff/pickup/landpr docs, committer script, guardrails). (`inspiration/agent-scripts/...`)
* Sync tracking scaffolding in `changelog/compound-engineering-plugin.md` and `changelog/agent-scripts.md` (already the right “Fork/Sync/Ignore/Unclassified” shape). (`changelog/compound-engineering-plugin.md`, `changelog/agent-scripts.md`)
* Brainstorm dump with target areas + links. (`Ideation/brainstorming.md`)

Immediate gaps / mismatches to resolve early:

* `AGENTS.md` references `scripts/init_skill.py` + `scripts/package_skill.py` but those scripts do not appear in the diff you shared. Either implement or delete that workflow. (`AGENTS.md`)
* Compound plugin workflow commands are sub-agent heavy (`Task ... in parallel`) and assume Claude tooling like AskUserQuestion and backgrounding with `&`. That’s not Codex-first compatible as-is. (`inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/workflows/plan.md`, `.../review.md`, `.../compound.md`)
* Worktrees are promoted upstream, but your constraints say avoid worktrees by default. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../skills/git-worktree/`, `.../commands/workflows/work.md`)
* Tooling drift: upstream uses npm/bun in places; you want pnpm everywhere. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../skills/agent-browser/`, `inspiration/agent-scripts/README.md`)

Net: you’re set up well for “mirror upstream, then curate thin templates”. You’re not set up yet for “ship a minimal, Codex-first template pack” until you cut out sub-agent assumptions + align on install/usage patterns.

---

## Oracle critique of your approach

What’s strong (keep):

* Good separation of concerns: “mirror upstream in `inspiration/` + track sync in `changelog/`” is the right long-term maintenance move. (`AGENTS.md`, `changelog/*.md`)
* Progressive disclosure rule (`scripts/`, `references/`, `assets/`) is a real quality guardrail, and it scales. (`AGENTS.md`)
* You’re explicitly optimising for product engineers end-to-end (problem → ship → promo), not generic “AI productivity”. That’s the right lens. (`AGENTS.md`, `Ideation/brainstorming.md`)

What will bite you (fix now, not later):

* **You’re about to over-import.** Compound plugin is huge; if you “port everything” you’ll end up maintaining a second plugin. Start with 4 workflow commands + 3 utilities, then expand only when you feel friction. (`inspiration/compound-engineering-plugin/plugins/compound-engineering/README.md`)
* **Sub-agent flows are the wrong default.** They read clever, but they’re brittle across runners. Codex-first means “single agent, multi-pass, evidence-first”. Keep sub-agent support as an optional accelerator. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`, `.../review.md`, `.../compound.md`)
* **Worktree reliance conflicts with your own rule.** Make worktrees an opt-in “when parallel branches truly matter”, not a baked-in step. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../commands/workflows/work.md`)
* **Your commands will sprawl unless you enforce a hard “lean” bar.** SKILL.md has the <500 lines rule, but your commands need the same spirit or people won’t run them. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`)

Best path: “thin curated layer” over inspirations, not a forked clone.

---

## Major decisions (pros/cons/risks/alternatives)

### 1) AGENTS.md: pointer-style vs full local

You currently went “full local” in `AGENTS.md`. (`AGENTS.md`) Agent-scripts pushes “pointer-style”. (`inspiration/agent-scripts/README.md`, `inspiration/agent-scripts/AGENTS.MD`)

Recommendation: **hybrid**
Top of `AGENTS.md`:

* One optional pointer line (only if present on machine)
* Then your repo-local rules (your constraints)

Pros:

* Self-contained for anyone cloning this templates repo
* Still benefits from shared guardrails if you install agent-scripts locally

Cons:

* Slight duplication
* Requires discipline to avoid copying huge shared blocks

Risk:

* Two sources of truth diverge

Alternative:

* Pure pointer style (leanest), but breaks portability and onboarding unless everyone has the pointer target.

### 2) “Copy upstream skills” vs “link upstream skills”

Recommendation: **mirror upstream in `inspiration/`, then create thin wrappers in your taxonomy**.

Pros:

* Your templates stay consistent with your constraints (pnpm, verification steps, no worktrees)
* You can still diff/sync upstream cleanly via `changelog/<repo>.md`

Cons:

* You’ll write wrappers that feel “duplicative”

Risk:

* If wrappers become full rewrites, you’re back to maintaining a fork

Alternative:

* Link-only (low effort) but you lose consistency and you’ll keep tripping on incompatible instructions.

### 3) Commands format (single canonical file per command)

Recommendation: **one command name, one file, with Codex + Claude examples in the same doc** (as you intend). Keep Claude-only bits clearly fenced.

Pros:

* One mental model
* Prevents drift between “Codex version” and “Claude version”

Cons:

* Slightly longer docs

Risk:

* If Claude-only content is not clearly tagged, Codex runs will break

Alternative:

* Separate `commands/codex/...` and `commands/claude/...` (cleaner execution), but guaranteed drift.

### 4) Sub-agents

Recommendation: **default: no sub-agents**. Add an optional “If your runner supports parallel sub-agents” appendix.

Pros:

* Works everywhere
* Less brittle
* Easier to debug

Cons:

* Slower on huge reviews

Risk:

* People re-introduce multi-agent sprawl because it feels powerful

Alternative:

* Keep 2–3 high-ROI sub-agents only (security/perf/copy), but only if Codex actually supports them in your setup.

---

## Codex-compatible replacements for sub-agent flows

Pattern: **single-agent, multi-pass**. Same outcome as “parallel agents”, but deterministic and runner-agnostic.

### Replace “parallel research agents” in `/workflows:plan`

Upstream: `repo-research-analyst`, `best-practices-researcher`, `framework-docs-researcher` in parallel. (`inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`)

Codex-first replacement:

1. Pass 1: repo facts only

* scan: `ls`, `rg`, read `README/CONTRIBUTING/CLAUDE` if present, find existing patterns
* output: “Local Evidence” section with file paths

2. Pass 2: external facts only

* web/docs references (no coding)
* output: “External References” list

3. Pass 3: synthesise into plan

* acceptance criteria, risks, rollout, verification commands

Optional accelerator (Claude-only):

* “Run these three prompts as separate sub-agent tasks” block, clearly tagged.

### Replace multi-agent `/workflows:review`

Upstream: 10–15 reviewer agents. (`inspiration/compound-engineering-plugin/.../commands/workflows/review.md`)

Codex-first replacement: “review lanes” in a single doc, each with a checklist + evidence:

* Correctness (edge cases, error handling)
* Security (authz, injection, secrets, logging)
* Data integrity (migrations, backfills)
* Performance (hot paths, N+1, caching)
* DX + maintainability (naming, structure, tests)
* Ops (deploy safety, flags, monitoring)
* UX (states, empty/loading/error)

Output: one structured review + TODO file(s). If you keep file-based todos, keep it as a utility skill or command, not a dependency on sub-agents. (Upstream uses `file-todos` heavily.) (`inspiration/compound-engineering-plugin/.../skills/file-todos/`, `.../commands/workflows/review.md`)

### Replace `/workflows:compound` parallel doc generation

Upstream: 6–7 subagents. (`inspiration/compound-engineering-plugin/.../commands/workflows/compound.md`)

Codex-first replacement:

* single template: Symptom → Root cause → Fix → Verify → Prevention → Links
* one-pass capture while context is fresh
* optional: “Oracle second opinion” step (send doc to another model) as an **optional** utility, not required.

---

## Minimal template structure (Codex-first, taxonomy-aligned, low nesting)

This is the smallest structure that still supports your constraints + future growth:

```txt
.
├─ AGENTS.md
├─ changelog/
│  ├─ compound-engineering-plugin.md
│  └─ agent-scripts.md
├─ inspiration/
│  ├─ compound-engineering-plugin/...
│  └─ agent-scripts/...
├─ docs/
│  ├─ plans/
│  │  └─ plan.md
│  └─ cheatsheet.md
├─ scripts/
│  ├─ install-commands.sh
│  ├─ install-hooks.sh
│  └─ build-cheatsheet.ts
├─ commands/
│  ├─ workflows/
│  │  ├─ plan.md
│  │  ├─ work.md
│  │  ├─ review.md
│  │  └─ compound.md
│  └─ utils/
│     ├─ handoff.md
│     ├─ pickup.md
│     └─ landpr.md
├─ hooks/
│  ├─ git/
│  │  └─ pre-commit.sample
│  └─ claude-only/
│     └─ postToolUse-format.json
└─ skills/
   ├─ framing/
   ├─ shaping/
   ├─ development/
   ├─ packaging-promotion/
   └─ utilities/
```

Notes tied to your constraints:

* Command filenames avoid `:` (macOS); command *names* can still be `workflows:plan` via YAML frontmatter. (Upstream does this.) (`inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`)
* Skills live under taxonomy folders but the leaf folder still matches the skill name. (`AGENTS.md`)
* Claude-only hooks live in `hooks/claude-only/` so you never accidentally apply them in Codex contexts. (`AGENTS.md`)

---

## Incompatibilities + fragile sequences to avoid

High-risk to port “as-is”:

* Anything that requires sub-agents (`Task ... in parallel`) as a hard dependency. Make optional. (`inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`, `.../review.md`, `.../compound.md`)
* AskUserQuestion / interactive menu tooling. Replace with a plain “Next options:” list. (`inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`)
* Backgrounding with `&` (runner-specific). Remove. (`inspiration/compound-engineering-plugin/.../commands/workflows/plan.md`)
* Worktree-first flows. Keep as optional appendix. (`AGENTS.md`, `inspiration/compound-engineering-plugin/.../commands/workflows/work.md`)
* npm/bun instructions. Rewrite to pnpm equivalents or “project-local dev dependency”. (`AGENTS.md`, `inspiration/agent-scripts/README.md`, `inspiration/compound-engineering-plugin/.../README.md`)
* Language/framework-specific reviewers (Rails-only etc) in the default path. Keep as optional “if stack matches” sections. (`changelog/compound-engineering-plugin.md` Ignore list already flags many.) (`changelog/compound-engineering-plugin.md`)

---

## Draft `docs/plans/plan.md` (paste-ready)

```md
# Plan: Codex-first product engineering templates (problem → ship → promo)

## Summary
Build a minimal, Codex-first template repo of skills, slash commands, hooks, and agent guardrails for product engineers. Use compound engineering as the core workflow (plan → work → review → compound), but remove runner-specific and sub-agent-only assumptions. Keep Claude-specific content, tagged clearly.

## Goal
- Provide a reusable template set in this repo that can be copied into projects.
- Prioritise end-to-end delivery (problem → ship → promo).
- Keep skills lean: SKILL.md with YAML frontmatter (name + description only), imperative how-to, examples > prose, include verification steps.
- Keep inspirations mirrored in `inspiration/` and track sync decisions in `changelog/<repo>.md`.

## Approach
1) Curate, do not clone.
   - Mirror upstream repos in `inspiration/` (already present).
   - Build thin wrappers in `commands/` + `skills/` aligned to our constraints.
2) Codex-first execution model.
   - Default: single-agent, multi-pass checklists.
   - Optional: Claude-only accelerators (sub-agents, hooks), clearly tagged.
3) Progressive disclosure everywhere.
   - Repeatable code in `scripts/`.
   - Long docs in `references/` (skill-local).
   - Templates in `assets/` (skill-local).

## Key decisions
- AGENTS.md style:
  - Use hybrid: optional pointer to shared guardrails if installed, plus repo-local rules.
- Workflow commands:
  - Keep the 4-command loop: workflows:plan / workflows:work / workflows:review / workflows:compound.
  - Add 3 utilities: handoff / pickup / landpr.
- Sub-agents:
  - Not required. Allow as optional appendix only.
- Worktrees:
  - Avoid by default. Optional appendix for teams that want it.
- Package manager:
  - pnpm only. No npm/bun in templates.

## Tasks and sub tasks

### 1) Inventory repo + inspirations
- [ ] List what exists today in: `inspiration/compound-engineering-plugin/` and `inspiration/agent-scripts/`.
- [ ] For each upstream item we might use, record: keep as mirror only vs wrap as template.
- [ ] Identify missing primitives: install scripts, cheatsheet, minimal hooks.

### 2) Oracle critique + execution plan
- [ ] Lock the “curate thin wrappers” strategy.
- [ ] Decide AGENTS.md hybrid format and apply it.
- [ ] Decide command file conventions (one file per command, Codex + Claude examples inside).

### 3) Adapt compound-engineering workflow (Codex-first)
- [ ] Create `commands/workflows/{plan,work,review,compound}.md`.
- [ ] Replace sub-agent steps with single-agent multi-pass lanes.
- [ ] Tag Claude-only sections explicitly (hooks, sub-agents, any runner-specific tools).
- [ ] Remove worktree-first flows; keep as optional appendix.
- [ ] Add verification steps to every command (example terminal commands).

### 4) Agent-scripts utilities integration
- [ ] Port `/handoff` and `/pickup` from inspiration docs into `commands/utils/` (keep content lean).
- [ ] Port `/landpr` but switch gate commands to pnpm and make repo-agnostic (placeholders).
- [ ] Add `scripts/committer` equivalent (either copy from inspiration or wrap it) and document usage.

### 5) Design template layout (taxonomy + workflow)
- [ ] Create directories: `skills/{framing,shaping,development,packaging-promotion,utilities}/`.
- [ ] Add 1 exemplar skill per category (only the minimum to prove the pattern).
  - Framing: clarify problem + constraints + success metric.
  - Shaping: write plan/PRD + spec-flow checklist.
  - Development: implement-plan + verify loop.
  - Packaging + promotion: PR description + changelog + announcement draft.
  - Utilities: file-todos (optional) + oracle handoff (optional).
- [ ] Ensure each SKILL.md meets constraints (frontmatter fields, imperative, examples, verification).

### 6) Implement cheatsheet
- [ ] Create `docs/cheatsheet.md` listing:
  - Commands: name + 1-line purpose
  - Skills: name + 1-line purpose
  - Hooks: what they do + how to enable/disable
- [ ] Add `scripts/build-cheatsheet.ts` to regenerate from folder metadata (optional but preferred).

### 7) Update changelog/<repo>.md
- [ ] For compound-engineering-plugin: keep Fork/Sync/Ignore/Unclassified accurate as wrappers are created.
- [ ] For agent-scripts: same.
- [ ] Add short rationale when moving items out of Unclassified.

### 8) Summarise changes + verification commands
- [ ] Add `docs/plans/verification.md` or put verification section at end of this plan:
  - `pnpm -v`
  - `pnpm lint` (if repo has lint)
  - `pnpm test` (if repo has tests)
  - `pnpm run cheatsheet:build` (if implemented)
  - Manual: open a command file and run through its “Verify” steps in a sample project.

## Done definition
- Commands exist for the core workflow + utilities, each with examples + verification.
- At least 5 exemplar skills exist (1 per taxonomy category), each compliant with SKILL.md rules.
- Cheatsheet is accurate and easy to scan.
- Inspiration mirrors remain untouched except for syncing; wrappers contain attribution.
- Changelog files reflect reality (Fork/Sync/Ignore/Unclassified kept current).
```

If you want a single “north star” constraint to enforce: **thin wrappers only**. Anything that starts looking like “port the plugin” is a trap door back into endless maintenance.
