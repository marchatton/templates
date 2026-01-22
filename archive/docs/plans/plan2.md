# PRD: canonical templates repo for LLM-assisted product engineering (Explore → Shape → Develop → Review → Release)

Owner: Marc
Status: Draft (ready for implementation)
Primary runner: Codex (model-agnostic core). Claude-compatible.
Package manager rule: **pnpm** for Node/TS workflows (no npm, no bun for repo scripts)
Canonical manager: **dotagents** (`.agents/` is the source of truth)

---

## Summary

Build one canonical templates repo that product engineers can use end-to-end with a tight verify loop:

* **Explore**: pick the right problems and opportunities (product strategy only)
* **Shape**: shape work for delivery (Shape Up-inspired: PRD, breadboards, spike plans)
* **Develop**: implement with verification-first loop (pnpm)
* **Review**: structured review and explicit go/no-go
* **Release**: ship checklist + post-release checks
* **Compound (cross-cutting)**: capture learnings from *any stage* into a single durable file in the **project repo**: `docs/learnings.md` (append-only in v1), made explicit via a `compound` command. `wf-release` invokes `compound` by default for non-trivial work.

This templates repo contains:

* **skills** (structured, reusable “how-to” bundles)
* **commands** (runbooks / slash commands)
* **hooks** (git hooks templates)
* **guardrails** (`AGENTS.md`)
* **cheatsheet** (`cheatsheet.md`, generated)

Upstream inspirations (non-npm) are mirrored under `inspiration/` (plain clones, gitignored) and tracked via your changelog files:

* `compound-engineering-plugin`
* `agent-scripts`

Oracle is treated as a "marketplace tool" with an always-latest execution wrapper (no vendoring), sourced from `steipete/oracle`.

---

## Problem

LLM-assisted coding is powerful but inconsistent:

* prompts and runbooks drift per repo and per person
* verification is easy to skip
* public skills exist but syncing and keeping them current is annoying
* compounding often happens late, so teams re-learn the same things

We want a boring, verifiable templates repo that:

* installs cleanly everywhere
* enforces a verify loop for code changes (pnpm ladder)
* supports public skills and tools without constant manual syncing
* makes compounding a habit, not a ceremony

---

## Goals

1. A complete workflow for product engineers
   Explore → Shape → Develop → Review → Release, plus cross-cutting compounding.

2. Verify-first, pnpm-first
   Anything touching code must include:

* `pnpm lint`
* `pnpm typecheck`
* `pnpm test`
* `pnpm build`
* `pnpm verify` (alias for the above)
  …and a go/no-go rule.

3. Marketplace-ready without constant manual syncing

* upstream repos mirrored under `inspiration/` (plain clones; npm tools use wrappers)
* “enabled” skills and commands exposed via symlinks into `.agents/` surface
* one command to update vendors and refresh the surface

4. Compounding is explicit and cross-cutting

* can happen after Explore, Shape, Develop, Review, or Release
* stored in a single file: `docs/learnings.md` in the **project repo**
* `wf-release` triggers it by default for non-trivial work

5. Ralph continuous coding is supported

* provide `wf-ralph` runbook
* always ask for iteration count (default 10)

6. No roles / lenses / modes in v1
   Removed. TODO later.

---

## Non-goals

* sub-agent orchestration runtimes
* worktrees as default
* stack-specific deep playbooks dominating v1
* fully automatic upstream merges without human triage (we automate surfacing, not decisions)

---

## Concepts (practical)

### Skill

A folder with `SKILL.md` that has YAML frontmatter with only:

* `name`
* `description`

Codex injects only the skill’s name/description/path unless the skill is explicitly invoked.

### Command (runbook)

A markdown runbook invoked as a slash command. In Codex, custom prompts are local to the Codex home and require explicit invocation. Codex also notes custom prompts are deprecated in favour of skills, but we still ship command runbooks for ergonomics and stability.

### Stage vs workflow

* **Stage**: Explore/Shape/Develop/Review/Release (organises skills and outputs)
* **Workflow**: a runbook command (`wf-*`) that orchestrates stage outputs and verification

---

## Decision rule: skill vs command

Use a **skill** when:

* you want reusable behaviour with stable inputs/outputs and verification steps
* you want consistent artefact formats (PRD, breadboard, bug repro, review report)
* you want it available across clients via dotagents

Use a **command** when:

* you want a human-invoked runbook that chains skills
* you want “do X then verify then summarise GO/NO-GO”
* you want convenience entrypoints like `verify`, `landpr`, `compound`, `wf-release`

---

## Key decisions

### 1) Naming: Discover → Explore

We use **Explore** everywhere.

### 2) No `c-` prefix

Utility commands have short names. Workflow runbooks use `wf-` prefix.

### 3) dotagents is canonical

dotagents keeps `.agents/` as the source of truth and symlinks commands/skills/hooks into Codex and others.


### 4) Explore vs Shape boundary (hard rule)

* Explore: only opportunity selection and product strategy inputs (segmentation, positioning, roadmap, OST)
* Shape: PRD, breadboards, spike plans, deeper plan, JSON PRD

### 5) `test-browser` vs `agent-browser` naming is open

Upstream includes `agent-browser` (skill) and `test-browser` (command wrapper). In v1:

* keep skill: `utilities/agent-browser`
* keep command: `test-browser` (wrapper calling the skill)
* TODO later: decide which name to surface as primary

### 6) Compounding storage target (confirmed)

* Always append to **`docs/learnings.md` in the project repo** (append-only v1).

### 7) Ralph iterations

* `wf-ralph` always asks iteration count
* default is **10** if not specified

### 8) "Non-trivial" definition for wf-release → compound

Work is **non-trivial** if any of:
* code/schema/db touched
* user-facing behavior changed
* incident or bugfix

Rule of thumb: *"If you had to think about it, compound it."*

### 9) Verify behavior outside Node repos

If no `package.json` detected, `verify` prints **NO-GO with guidance**:
> "No pnpm detected. Define verification in project's docs/verify.md or pass `--skip-verify` with reason."

This keeps verify-first intact without blocking non-Node work indefinitely.

### 10) SKILL.md body structure

Body must include standardized headings for machine parsing:
* `## Inputs`
* `## Outputs`
* `## Verification`

YAML frontmatter stays minimal (name + description only). Headings enable cheatsheet generation.

### 11) Windows support

Document **macOS/Linux/WSL requirement**. Shell scripts won't run natively on Windows.

### 12) Command naming (confirmed)

No `c-` prefix. Utility commands use short names: `handoff.md`, `pickup.md`, `landpr.md`.
Changelogs updated to reflect this.

### 13) Workflow command mapping (confirmed)

PRD names are canonical. Upstream names map as follows:
* `wf-plan` → `wf-shape`
* `wf-work` → `wf-develop`
* `wf-compound` → `compound` (utility command, not workflow)

### 14) Vendor ingestion mechanism

Use **scripted clones** (not submodules or subtrees):
* `inspiration/` directories are plain cloned repos
* `.gitignore` excludes `inspiration/*/`
* `vendor_update.sh` clones missing repos (repo list in script) and pulls latest
* Fresh clone: run `./scripts/vendor_update.sh` to clone+pull vendors (document in README)

### 15) Symlinks in `.agents/` (confirmed)

Symlinks are allowed in `.agents/` for v1:
* `vendor_sync.sh` creates symlinks from `inspiration/` into `.agents/`
* Edits to synced content require forking first (copy to `.agents/`, remove symlink)

### 16) Enabled vendors config

Use **`.agents/vendors.json`** for explicit source→target mappings:
```json
{
  "agent-scripts": {
    "sync": [
      { "src": "skills/frontend-design", "dst": "skills/utilities/frontend-design" }
    ]
  },
  "compound-engineering-plugin": {
    "sync": [
      { "src": "plugins/compound-engineering/skills/agent-browser", "dst": "skills/utilities/agent-browser" }
    ]
  }
}
```
Changelogs remain human-readable (decisions); config is machine-readable (mappings).

### 17) Non-Node verification

For repos without `package.json`, use **`docs/verify.md`**:
* Contains fenced `bash` blocks with verification commands
* `verify` command extracts and runs them
* If missing: NO-GO with guidance to create it or pass `--skip-verify "reason"`

### 18) Merge conflict policy for learnings

When `docs/learnings.md` conflicts:
* Keep both entries
* Order by timestamp (newest at bottom of stage section)
* Never rewrite history

### 19) `landpr` behavior (confirmed)

```
landpr
├── Stage changed files (unless `--staged-only`)
├── Check working tree clean (fail if unstaged/untracked remain)
├── Run `verify`
│   ├── GO → continue
│   └── NO-GO → refuse unless `--force "reason"` (reason is logged)
├── Generate commit message (conventional format, override with `--message`)
├── Commit
├── Push to current branch
└── Print summary + PR URL hint if on feature branch
```
Fails fast on detached HEAD.

---

## Repo architecture

### Canonical templates repo structure

```txt
templates/
  AGENTS.md
  cheatsheet.md                         # generated

  .agents/
    AGENTS.md                           # canonical tool guardrails

    commands/
      # workflow runbooks
      wf-explore.md
      wf-shape.md
      wf-develop.md
      wf-review.md
      wf-release.md
      wf-ralph.md

      # utility runbooks (some synced from agent-scripts)
      verify.md
      landpr.md                          # synced (agent-scripts)
      handoff.md                         # synced (agent-scripts)
      pickup.md                          # synced (agent-scripts)
      compound.md
      oracle.md                          # optional wrapper command

      # imported from compound-engineering-plugin (exhaustive list)
      triage.md
      plan-review.md
      deepen-plan.md
      report-bug.md
      reproduce-bug.md
      resolve-parallel.md
      resolve-pr-parallel.md
      resolve-todo-parallel.md
      agent-native-audit.md
      changelog.md
      generate-command.md
      create-agent-skill.md
      heal-skill.md
      test-browser.md                    # wrapper around utilities/agent-browser

    skills/
      explore/
        opportunity-solution-tree/
        customer-segmentation/           # placeholder v1
        positioning/                     # placeholder v1
        roadmap/                         # placeholder v1
        pricing-packaging/               # placeholder v1 (optional)

      shape/
        create-prd/
        breadboard/
        spike-plan/
        deepen-plan/
        prd-review/
        create-json-prd/                 # optional inputs: breadboard/spike/plan

      develop/
        work-execute/
        reproduce-bug/
        report-bug/
        resolve-todos/
        resolve-pr-feedback/

      review/
        pr-review/
        agent-native-architecture/
        browser-qa/                      # uses utilities/agent-browser

      release/
        release-checklist/
        changelog-draft/
        post-release-verify/

      compound/
        compound-docs/                   # appends to docs/learnings.md in project repo

      utilities/
        ask-questions-if-underspecified/
        agent-browser/
        oracle/
        file-todos/
        markdown-converter/
        frontend-design/
        openai-image-gen/
        gemini-imagegen/
        nano-banana-pro/
        video-transcript-downloader/
        every-style-editor/
        skill-creator/
        create-agent-skills/
        create-cli/                      # added
        docs-list/                       # added (wraps docs-list.ts concept)
        trash/                           # added (wraps trash.ts concept)

    ralph/
      config.sh                          # defaults, editable per user/project
      prompts/                           # optional prompt templates

    hooks/
      README.md                          # optional Claude/Factory hook examples

  hooks/
    git/
      pre-commit
      pre-push
      prepare-commit-msg                 # optional
      commit-msg                         # optional
      post-merge                         # optional

  scripts/
    verify_repo.sh
    generate_cheatsheet.ts
    vendor_update.sh                     # clones/pulls vendor sources
    vendor_sync.sh                       # exposes enabled vendor items into .agents surface
    agents_refresh.sh                    # update + sync + regenerate + verify
    install_git_hooks.sh
    install_codex_skills_copy.sh         # fallback if symlink loading regresses

  docs/
    templates/
      prd.md
      breadboard.md
      spike-plan.md
      pack.md
      learnings.md                       # template header for project repos
      learning-entry.md                  # entry format template
      json-prd.schema.json
      release-checklist.md
    guides/
      oracle.md
      ralph.md

  inspiration/
    compound-engineering-plugin/         # plain clone, gitignored; pull latest on refresh
    agent-scripts/                       # plain clone, gitignored; pull latest on refresh
    # note: oracle is NOT vendored here — it's an npm package (@steipete/oracle)

  changelog/
    compound-engineering-plugin.md
    agent-scripts.md

  package.json
  pnpm-lock.yaml
```

### Why `docs/` exists in the templates repo

Because this repo defines the artefact formats and templates that your commands/skills create in project repos:

* PRD, breadboard, spike plan, pack templates
* learnings templates and entry format
* JSON PRD schema
* release checklist template
* guides for Oracle and Ralph

Project repos get the outputs:

* `docs/explore/<slug>/...`, `docs/shape/<slug>/...`, etc
* `docs/learnings.md` (append-only)

---

## Installation and invocation

### dotagents (primary)

dotagents keeps `.agents/` as the canonical source and symlinks commands/skills/hooks into the client homes.

### Codex symlink fallback (if needed)

Codex docs say symlinked skills are supported.
But since symlink loading has had issues, v1 includes `scripts/install_codex_skills_copy.sh` as a fallback if you hit the bug.

### Invocation (Codex)

* workflow and utility commands: invoked as slash commands once installed (dotagents links them into the correct Codex home path).
* skills: appear in Codex skills list and can be invoked explicitly when needed.

---

## Oracle (marketplace tool, always latest)

You asked: “best approach to load Oracle so it always uses latest”.

### What Oracle provides

Oracle is a CLI workflow that can bundle context files and run with different backends. It documents running via `npx -y @steipete/oracle` and notes Node 22+.

### v1 design: wrapper-only skill, run the CLI as latest

We separate **skill instructions** from **executable**:

1. Keep the Oracle skill local (no vendor repo)

* `.agents/skills/utilities/oracle` lives in this repo (no symlink)
* optional: `.agents/commands/oracle.md` wrapper command

2. Always run the CLI as latest
   Preferred:

* `pnpm dlx @steipete/oracle@latest <args>`
  Fallback:
* `npx -y @steipete/oracle@latest <args>`

3. Wrapper script used by the oracle skill and optional oracle command
   Add `scripts/oracle.sh` in this templates repo that:

* warns if Node < 22
* runs `pnpm dlx @steipete/oracle@latest …`
* supports a no-keys "copy/paste" flow (Oracle supports rendering and copy)

Result:

* oracle skill is maintained locally (no vendor sync)
* execution always uses latest via `@latest`
* no global install drift

---

## Ralph (continuous coding)

We support iannuttall/ralph as the canonical “Ralph loop”.

Ralph design facts we align with:

* state persists in `.ralph/`
* PRD JSON default output lives under `.agents/tasks/`
* templates can be installed into `.agents/ralph/`
* one iteration is `ralph build 1`
* runner is configurable via `AGENT_CMD` in `.agents/ralph/config.sh`

---

## Inventory (exhaustive from your changelogs)

### Commands (canonical surface)

Workflow commands (ours):

* `wf-explore`
* `wf-shape`
* `wf-develop`
* `wf-review`
* `wf-release`
* `wf-ralph`

Utility commands (ours):

* `verify`
* `compound`
* `oracle` (optional wrapper command)

Imported from compound-engineering-plugin (exhaustive list from your changelog):

* `triage`
* `plan-review`
* `deepen-plan`
* `report-bug`
* `reproduce-bug`
* `resolve-parallel`
* `resolve-pr-parallel`
* `resolve-todo-parallel`
* `agent-native-audit`
* `changelog`
* `generate-command`
* `create-agent-skill`
* `heal-skill`
* `test-browser`

Synced from agent-scripts (exhaustive list from your changelog):

* `handoff`
* `pickup`
* `landpr`

### Skills (canonical surface)

Explore:

* `opportunity-solution-tree`
* `customer-segmentation` (placeholder)
* `positioning` (placeholder)
* `roadmap` (placeholder)
* `pricing-packaging` (optional placeholder)

Shape:

* `create-prd`
* `breadboard`
* `spike-plan`
* `deepen-plan`
* `prd-review`
* `create-json-prd` (required input: PRD; optional inputs: breadboard/spike/plan)

Develop:

* `work-execute`
* `reproduce-bug`
* `report-bug`
* `resolve-todos`
* `resolve-pr-feedback`

Review:

* `pr-review`
* `agent-native-architecture`
* `browser-qa` (uses utilities/agent-browser)

Release:

* `release-checklist`
* `changelog-draft`
* `post-release-verify`

Compound:

* `compound-docs` (appends to project repo `docs/learnings.md`)

Utilities (exhaustive list from changelogs + your additions):
From agent-scripts:

* `frontend-design`
* `markdown-converter`
* `nano-banana-pro`
* `openai-image-gen`
* `oracle` (ignored from vendor; replaced by local wrapper)
* `video-transcript-downloader`

From compound-engineering-plugin:

* `agent-browser`
* `create-agent-skills`
* `every-style-editor`
* `file-todos`
* `gemini-imagegen`
* `skill-creator`

Your additions:

* `ask-questions-if-underspecified` (explicit invoke only, exact content)
* `create-cli`
* `docs-list` (wrap docs-list.ts concept)
* `trash` (wrap trash.ts concept)

Explicit ignore/skip:

* ignore `docs/subagent.md`
* skip `nanobanana` unless proven distinct from nano-banana-pro

---

## Core loop runbooks (commands) and outputs

### `wf-explore`

Outputs in project repo:

* `docs/explore/<slug>/opportunity-solution-tree.md`
* optional: segmentation/positioning/roadmap docs (placeholders)

Go/no-go:

* GO if we can name: target user, target metric, riskiest assumption, next experiment
* NO-GO if it’s just a list and no next bet

### `wf-shape`

Outputs in project repo:

* `docs/shape/<slug>/prd.md`
* `docs/shape/<slug>/breadboard.md`
* `docs/shape/<slug>/spike-plan.md` (if needed)
* `docs/shape/<slug>/plan.md` (deepen-plan)
* `docs/shape/<slug>/prd.json` (optional human mirror)
* `.agents/tasks/prd-<slug>.json` (canonical JSON PRD for tooling)

Rule:

* JSON PRD requires PRD
* breadboard/spike/plan are optional inputs but if they exist, `create-json-prd` must incorporate them

Go/no-go:

* GO if acceptance criteria are testable and mapped to verification steps
* NO-GO if success criteria or verification plan is missing

### `wf-develop`

Outputs in project repo:

* code changes
* `docs/dev/<slug>/dev-log.md` (what changed + how verified + go/no-go)

Verification commands (pnpm):

* `pnpm lint`
* `pnpm typecheck`
* `pnpm test`
* `pnpm build`
* `pnpm verify`

Go/no-go:

* GO if ladder is green and acceptance criteria met
* NO-GO if any command fails or behaviour cannot be demonstrated

### `wf-review`

Outputs in project repo:

* `docs/review/<slug>/review.md`
* optional: `docs/review/<slug>/browser-qa.md`

Verification:

* `pnpm verify`
* optionally `test-browser` (wrapper calling `agent-browser`)

Go/no-go:

* GO if checks green and no high-risk gaps remain
* NO-GO if there’s any unresolved correctness/rollout risk

### `wf-release`

Outputs in project repo:

* `docs/release/<slug>/release.md` (rollout, rollback, monitors)
* `docs/release/<slug>/changelog.md`
* optional `docs/release/<slug>/post-release.md`

Verification:

* must run `pnpm verify`

Default behaviour:

* if non-trivial change, invoke `compound` and append to `docs/learnings.md`

Go/no-go:

* GO if verify is green + rollback plan exists + monitors listed
* NO-GO otherwise

### `wf-ralph`

Behaviour:

1. Ensure JSON PRD exists at `.agents/tasks/prd-<slug>.json`
2. Ask: “How many iterations?”

   * default: 10 if not specified
3. Run N iterations safely:

   * loop `ralph build 1` N times (v1 default)
4. After iterations, run `verify` (pnpm ladder) and write go/no-go summary

Outputs:

* `.agents/tasks/prd-<slug>.json`
* `.ralph/` state/logs (Ralph)
* optional: `docs/dev/<slug>/ralph-log.md` (summary per iteration)

---

## Compounding (cross-cutting, v1)

### Storage target

* Always append to `docs/learnings.md` in the **project repo** (append-only v1).

### `compound` command (explicit)

Inputs:

* stage: explore/shape/develop/review/release/other
* title
* context links (PR, issue, relevant doc paths)
* what changed (optional)
* verification evidence (required if code-touching)

Output:

* append an entry under the relevant stage heading in `docs/learnings.md`

Entry format (append-only):

* date stamp
* stage
* summary
* what happened
* root cause
* fix
* prevention
* verification (commands + results, if code-touching)
* links (PR, issues, dashboards, docs)

Template source:

* templates repo provides `docs/templates/learnings.md` and `docs/templates/learning-entry.md`
* project repo stores the actual `docs/learnings.md`

### `wf-release` default behaviour

After release checklist and changelog:

* if non-trivial, run `compound` and append to `docs/learnings.md`

---

## Verification and go/no-go standard

### pnpm ladder

* `pnpm lint`
* `pnpm typecheck`
* `pnpm test`
* `pnpm build`
* `pnpm verify`

### `verify` command

* runs ladder with sensible fallbacks if scripts are missing
* prints:

  * what ran
  * what failed
  * GO or NO-GO summary

### `landpr` command

* runs `verify`
* if GO: commit and push
* if NO-GO: refuses to commit unless explicitly instructed and records that decision

---

## Hooks

Goal: enforce quality without killing velocity.

### Git hooks (v1 default)

Recommended split:

* pre-commit: staged lint/format + typecheck
* pre-push: tests
* CI: full `pnpm verify`

Shipped templates:

* `pre-commit`
* `pre-push`
  Optional templates (off by default):
* `prepare-commit-msg` (integrate committer)
* `commit-msg`
* `post-merge` (lockfile reminder)

### Optional client hooks (future)

Keep examples under `.agents/hooks/` only. Do not require.

---

## Skill format constraints (must hold)

* skill folder: `.agents/skills/<category>/<skill>/`
* must contain `SKILL.md`
* YAML frontmatter: **name + description only**
* body:

  * imperative steps
  * examples > prose
  * include verification steps
  * keep under 500 LOC
* supporting folders allowed:

  * `scripts/`
  * `assets/`
  * `references/`

### Included skill: ask-questions-if-underspecified

Must be included exactly as you provided, and must never be invoked automatically (only explicitly invoked).

---

## Cheatsheet (generated)

`cheatsheet.md` must list:

* commands with 1-line purpose + verification notes
* skills grouped by category with 1-line purpose
* hooks with 1-line purpose
* default pnpm ladder
* key output paths (`docs/explore`, `docs/shape`, `docs/dev`, `docs/review`, `docs/release`, `docs/learnings.md`, `.agents/tasks`, `.ralph/`)

Generated by:

* `scripts/generate_cheatsheet.ts` scanning:

  * `.agents/commands/*.md`
  * `.agents/skills/**/SKILL.md`

---

## Marketplace: vendors, "always latest", and refresh flow

### Vendor model

Vendors are Git repos in `inspiration/` (plain clones, gitignored). We track decisions in `changelog/` (Sync vs Fork vs Ignore).

* **Sync**: pull latest from upstream on refresh, symlink into `.agents/*` surface
* **Fork**: copy into `.agents/*` and edit, we maintain
* **Ignore**: not exposed

### Vendor categories

| Type | Example | How to consume |
|------|---------|----------------|
| **npm package** | `@steipete/oracle` | Thin wrapper skill, `pnpm dlx @pkg@latest` — no vendoring |
| **Synced content** | `agent-browser`, `skill-creator` | Vendor in `inspiration/`, pull latest on refresh, symlink |
| **Fork content** | One-off customizations | Copy into `.agents/`, we maintain |

### Refresh flow (manually triggered)

* `scripts/vendor_update.sh` — clones missing repos and pulls latest main for all `inspiration/` repos
* `scripts/vendor_sync.sh` — symlinks enabled items into `.agents/` surface
* `scripts/agents_refresh.sh` — runs update + sync + cheatsheet + verify

Human reviews changes (git diff) before committing. No automatic merges.

### npm package wrappers (always @latest)

For tools distributed as npm packages, we don't vendor content. Instead:

* Create a thin wrapper skill that invokes the CLI
* Always use `pnpm dlx @pkg@latest` (fallback `npx -y @pkg@latest`)

Current npm packages:
* `@steipete/oracle` — wrapper in `skills/utilities/oracle/`

---

## Implementation plan

### Phase 0: guardrails + templates

* write `AGENTS.md` with:

  * taxonomy
  * pnpm rule
  * no subagents
  * skill constraints
  * verify-first requirement
  * compounding rules (append to docs/learnings.md)
* add `docs/templates/*` including learnings templates and JSON schema
* add `docs/guides/oracle.md` and `docs/guides/ralph.md`

### Phase 1: structure + generator tooling

* create `.agents/commands` and `.agents/skills/*`
* implement `scripts/generate_cheatsheet.ts`
* implement `scripts/verify_repo.sh`:

  * validates taxonomy
  * validates frontmatter constraints
  * validates required commands exist
  * validates unique skill names
  * validates learnings templates exist

### Phase 2: port content (exhaustive)

* implement workflow runbooks: `wf-explore`, `wf-shape`, `wf-develop`, `wf-review`, `wf-release`, `wf-ralph`
* implement utility runbooks: `verify`, `compound`, `oracle` (wrapper)
* sync utility runbooks from agent-scripts: `handoff`, `pickup`, `landpr`
* port all commands and skills listed in the changelog excerpts into canonical surface
* add utilities: create-cli, docs-list, trash
* include ask-questions-if-underspecified exactly as given

### Phase 3: marketplace refresh

* add `inspiration/*` (plain clones, gitignored)
* implement `vendor_update.sh`, `vendor_sync.sh`, `agents_refresh.sh`
* wire `scripts/oracle.sh` (wrapper-only)

### Phase 4: hooks

* implement git hook templates and `scripts/install_git_hooks.sh`
* ensure hooks degrade gracefully in non-node repos (print guidance, don’t brick)

---

## Acceptance criteria

1. Structure exists

* `.agents/commands`, `.agents/skills/{explore,shape,develop,review,release,compound,utilities}`

2. Skill frontmatter rule holds

* name + description only (no extra fields)

3. Exhaustive inventory present

* all commands/skills from both changelog excerpts exist
* create-cli, docs-list, trash included
* nanobanana skipped unless proven distinct
* docs/subagent ignored

4. dotagents works as canonical

* `.agents` is source of truth and links are created

5. Oracle “always latest” works

* oracle skill exists and uses `pnpm dlx @steipete/oracle@latest …` with Node 22 warning

6. Compounding works in project repos

* `compound` appends to `docs/learnings.md`
* `wf-release` invokes `compound` by default for non-trivial work

7. Ralph runbook behaviour correct

* `wf-ralph` asks iterations, default 10
* respects `.agents/tasks` and `.ralph/` conventions

8. Repo verification passes

* `scripts/verify_repo.sh` passes and prints manual smoke steps (including how to refresh vendors)

---
