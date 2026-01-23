# AGENTS.md (trimmed)

Make skills concise + specific. Sacrifice grammar for concision.

Purpose: guardrails for **skills / commands / hooks** across Codex/Claude/Gemini. Primary Codex. Model-agnostic.

This repo is the **canonical source** of product-engineering **skills, commands, hooks, templates** (custom + curated/vendor). Other repos **consume** this canon (link/import from here), they don’t rewrite it.

Canonical surface: **`.agents/`** (commands + skills + hooks).

Mechanism: **iannuttall/dotagents** is the default way to **sync/link this canonical `.agents/` folder into different runners/clients** (Codex, Claude, etc) and across machines.

Platform: **macOS/Linux/WSL only**. Shell scripts do not run natively on Windows.

When creating or updating skills, follow the **`skill-creator` skill** (it’s the reference implementation for how we write skills).

---

## Core principles

* Prefer **simple workflows + verification**, not clever automation.
* **No roles/modes** in v1. No sub-agent dependency; use `multi-agent-routing` (sub-agents if supported, else parallel/serial sessions).
* Commands are **runbooks**. Skills are reusable blocks.
* `.agents/` is source of truth; dotagents links it into clients.
* Code-touching work must include pnpm ladder + **GO/NO-GO**:

  * `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build`, `pnpm verify`
* Compounding is cross-cutting: capture learnings from any stage.

---

## Canonical structure (must hold)

Everything runnable lives under `.agents/`:

* `.agents/skills/<category>/<skill>/SKILL.md`
* `.agents/commands/<command>.md`
* `.agents/hooks/` optional (examples only in v1)

Repo also contains:

* `inspiration/<vendor>/` mirrors + `changelog/<vendor>.md` (Sync/Fork/Ignore)
* `scripts/` (refresh/generate/verify)
* `docs/templates/` (templates used by skills/commands)

---

## Skill rules (strict)

* `SKILL.md` required. Frontmatter: **name + description only**.
* Description = trigger/when-to-use. Body = imperative how-to. Examples > prose.
* Keep `<500 lines`. Use `scripts/`, `assets/`, `references/` (link references once).
* No extra per-skill docs (README/CHANGELOG). Move essentials to `references/` or drop.
* Every skill includes **Verify**. If code-touching: pnpm ladder + go/no-go.
* Use `skill-creator` whenever adding a new skill or repairing a messy one.

### Special utility skill: ask-questions-if-underspecified

* Must exist exactly as defined.
* **Never auto-run**. Only when explicitly invoked.

---

## Command rules (runbooks)

* File: `.agents/commands/<name>.md`
* Must include: purpose, inputs, outputs, steps (which skills), verification + go/no-go, usage examples.
* Workflow commands: `wf-explore`, `wf-shape`, `wf-develop`, `wf-review`, `wf-release`, `wf-ralph`
* Utility commands: short names eg. `verify`, `landpr`, `handoff`, `pickup`, `compound`
* Keep upstream names where useful (eg `test-browser` wrapper; naming vs `agent-browser` is open).

---

## Naming + taxonomy

* Skill name: lowercase/digits/hyphens, <64 chars, verb-noun; folder matches name.
* Single-level categories only. No deep nesting.
* Framework-specific: encode in folder name (react-, next-, cloudflare-).

Skills must live under exactly:

* `explore/` (problem/opportunity selection only)
* `shape/` (PRD, breadboards, spikes, deeper plan, JSON PRD)
* `develop/` (implement + verify loop)
* `review/` (review, browser QA, audits)
* `release/` (release checklist, changelog, post-release verify)
* `compound/` (compounding writer)
* `utilities/` (helpers + marketplace shelf)

---

## Compounding (v1)

* Can happen after Explore/Shape/Develop/Review/Release.
* Storage target: **project repo** `docs/learnings.md` (append-only).
* `compound` appends structured entry (stage + summary + root cause/fix/prevention + verification evidence if code-touching).
* `wf-release` runs `compound` by default for non-trivial work.
* Templates live here: `docs/templates/learnings.md`, `docs/templates/learning-entry.md`.

---

## Ralph (continuous coding)

* `wf-ralph` is opt-in.
* Must: ensure `.agents/tasks/prd-<slug>.json`, ask iterations (default **10**), loop `ralph build 1` N times, run `verify` and output go/no-go.
* Keep it modular, not a platform.

---

## Vendor / marketplace

* Vendors live in `inspiration/<vendor>/`. Decisions in `changelog/<vendor>.md` (Sync/Fork/Ignore/Unclassified).
* Enabled surface = what’s linked into `.agents/skills` and `.agents/commands`.
* Scripts:

  * `vendor_update.sh` (pull latest)
  * `vendor_sync.sh` (expose enabled items)
  * `agents_refresh.sh` (update + sync + regenerate cheatsheet + verify)
* External CLIs that should always be latest (eg Oracle):

  * `pnpm dlx <pkg>@latest …` (preferred), fallback `npx -y <pkg>@latest …`
  * wrap in `scripts/<tool>.sh`

---

## Hooks

Git hooks (templates shipped):

* `pre-commit`: staged lint/format + typecheck
* `pre-push`: tests (or targeted)
* CI: full `pnpm verify`

Rules:

* degrade gracefully if scripts missing; don’t run installs in hooks.
* Optional templates: `prepare-commit-msg`, `commit-msg`, `post-merge`.
* Client hooks: examples only under `.agents/hooks/` (not required v1).

---

## Creation workflow (v1)

1. Collect real examples.
2. Define inputs/outputs + verify first.
3. Create folder + SKILL.md (strict frontmatter).
4. Add scripts/assets/references only if they reduce repetition.
5. Run in real work and tighten.
   Tooling like init/package scripts stays TODO.

---

## Attribution

Credit upstream creator + repo for synced/forked content. Note methodology inspiration (eg Shape Up).
