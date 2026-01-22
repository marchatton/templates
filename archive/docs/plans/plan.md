# Templates repo PRD: Codex-first product engineering templates (problem → ship → promo)

Owner: Marc  
Status: Draft (ready for implementation)  
Repo: `/Users/marc/Code/personal-projects/templates`  
Primary runner: Codex (model-agnostic core). Claude-specific parts allowed, clearly tagged `CLAUDE_ONLY`.

## Summary
Build a canonical templates repo that product engineers can use to go end-to-end:
**explore → shape → plan → work → review → release → compound**, with utilities that work across the loop.

This repo will contain:
- **skills** (structured, reusable “how-to” bundles)
- **commands** (slash commands / prompts)
- **hooks** (shared git hooks; Claude-only hooks optional)
- **guardrails** (`AGENTS.md`)
- **cheatsheet** (`cheatsheet.md`)

We will also mirror upstream inspirations into `inspiration/` (Compound Engineering + agent-skills/agent-scripts) and track what we keep vs fork vs ignore under `changelog/`. The scope is to **triage 100% of items from those repos; port only items that can be made compliant quickly; keep the rest in `inspiration/` and mark Ignore with rationale**.

## Explore is product strategy and experimentation
Explore is where we:
- pick the right problems and opportunities (product strategy, segmentation, positioning inputs)
- run experiments and discovery (prototypes, user tests, quick validation)
- reduce risk before shaping and shipping

Explore is de-prioritised initially in terms of depth, but it is explicitly part of the workflow and taxonomy.

## Goals
1) Provide a complete workflow for product engineers:
   - **Explore**: strategy, opportunity identification, experiments
   - **Shape**: PRDs/specs, architecture, breadboarding/user journeys
   - **Plan**: execution plan, sequencing, verification, scope cuts
   - **Work**: implement, test, iterate, keep quality high
   - **Review**: structured review lanes, TODO capture, fix loop
   - **Release**: deploy/ops checks + positioning/packaging
   - **Compound**: capture solved problems and reusable learnings
   - **Utilities**: handoff/rehydrate, land PRs, ask-user-question pattern, oracle, etc

2) Codex-first and model-agnostic:
   - Everything must work without Claude-only primitives.
   - Claude-specific enhancements are allowed but must be tagged `CLAUDE_ONLY` and never required.

3) Lean + verifiable:
   - Skills: `SKILL.md` YAML frontmatter has **name + description only**; body is imperative how-to; examples > prose; include verification steps; keep file <500 LOC. (AGENTS.md)
   - Commands and hooks include usage examples and verification steps. (AGENTS.md)
   - Use pnpm for Node/TS workflows. (AGENTS.md)

4) Maintainability:
   - Mirror upstream repos in `inspiration/`.
   - Track decisions under `changelog/<repo>.md` using Fork/Sync/Ignore/Unclassified.
   - Make monthly manual sync realistic (diff, triage, copy, adapt, verify).

## Non-goals
- Agents SDK orchestration (explicitly removed for now).
- Worktrees as a default (avoid; optional appendix only if ever).
- Rails-first defaults (TS-first; keep stack-specific content but clearly tagged).
- “Exploration-heavy” skills becoming the bulk of v1 (we still port everything, but Explore usage is not the main path day-to-day yet).

## Canonical repo sources (what we are porting)
This repo already mirrors inspirations under `inspiration/`. We will port from:
- `inspiration/compound-engineering-plugin/` (Compound Engineering plugin)
- `inspiration/agent-scripts/` (guardrails + scripts + skills + slash commands)

We treat these as upstream sources. We will port their content into our canonical structure, then adjust it to fit our constraints.

We also track both inspirations under `changelog/` with Fork/Sync/Ignore/Unclassified:
- `changelog/compound-engineering-plugin.md`
- `changelog/agent-scripts.md` (this is the “agent-skills/agent-scripts” source tracker)

## Workflow (do not skip explore)
Canonical loop:
1) Explore (ongoing work, core product)
2) Shape (product + design + engineering)
3) Plan (execution plan + verification)
4) Work (design engineering + backend engineering)
5) Review (QA)
6) Release (dev ops and QA)
7) Compound (all roles)
8) Repeat

Note: steps 1-2 often run separately; steps 3-7 run in a loop.

Utilities can be used at any point.

## Information architecture (single-level taxonomy)
Skills MUST be grouped exactly under:

skills/
  explore/              # product strategy, experimentation, discovery
  shape/                # PRDs, architecture, breadboarding, user journeys
  work/                 # implementation + verify loops
  review/               # review lanes, QA, fix loops
  release/              # deploy/ops checks + positioning/packaging
  compound/             # capture solved problems + learnings
  utilities/            # handoff/rehydrate, oracle, ask-user, helpers

Plan is a workflow step; there is no `skills/plan/` category. Plan skills live under shape/work.

Single-level *category* hierarchy means:
- no nested category dirs (no `delivery/build/...`)
- we may introduce a second level later for frameworks if necessary, but we will not do it now

Framework-specific skills (React/Next/Cloudflare/etc) in v1:
- encode framework in the skill folder name, keep taxonomy flat, e.g.
  - `skills/work/react-component-patterns/`
  - `skills/review/react-performance-audit/`
  - `skills/release/cloudflare-workers-deploy-checklist/`

## Skill format constraints (must hold after porting)
From `AGENTS.md`:
- Each skill lives in `skills/<category>/<skill-name>/`.
- Skill must include `SKILL.md`:
  - YAML frontmatter: **name + description only**
  - body: imperative how-to
  - examples > prose
  - include verification steps
  - keep <500 LOC
- Progressive disclosure inside the skill folder:
  - `scripts/` repeatable code
  - `references/` docs (link once from SKILL.md)
  - `assets/` templates

No extra docs inside skills (no README/CHANGELOG per-skill). If upstream skill has extras, move essential material into `references/` or drop it.

## “Thin curated layer” over inspirations (what that means now, given full port scope)
We are porting everything from inspirations, but we still keep separation:

- `inspiration/<repo>/...` remains the upstream mirror for diffing.
- Canonical runnable templates live in:
  - `skills/` (restructured + corrected to our spec)
  - `commands/` (our canonical command set, even if based on upstream)
  - `scripts/`, `hooks/`, `cheatsheet.md`, `AGENTS.md`

So yes, we will have “local versions” that are the ones used day-to-day.
Upstream mirror stays as the source for monthly manual sync. We do not aim for automatic syncing because we expect improvements and local edits.

## Commands: naming + how to keep “same commands” across Codex and Claude
We maintain ONE canonical command file per command in-repo under `commands/`.

### Prefix rules
- Workflow commands: `wf-<name>`  
  Example: `wf-explore`, `wf-shape`, `wf-plan`, `wf-work`, `wf-review`, `wf-release`, `wf-compound`

- Utility commands: `c-<name>`  
  Example: `c-handoff`, `c-pickup`, `c-landpr`, `c-ask`, `c-oracle`

Shorthand in prose: `WF <name>` (eg WF plan). Filenames stay `wf-<name>`.

Where a runner already provides a standard built-in command that we like (eg `/review`), we explicitly say “use built-in /review” as a step, and we keep our wrapper focused on the extra structure and outputs we want.

### Installation and invocation (important nuance)
- Canonical source is `commands/`. Do not edit `.claude/commands/` or `~/.codex/prompts/`; they are generated by install scripts. Add `.claude/commands/` to `.gitignore`.
- Codex custom commands live in `~/.codex/prompts/` (not repo-shared by default), so we install there via a script.
- Claude custom commands live in `.claude/commands/` (repo-local), so we install there via a script too.

We keep the SAME command filenames for both runners by installing the same `commands/*.md` into both locations.

Invocation differences are runner reality:
- Claude: `/<name>`
- Codex: `/prompts:<name>`

We do not fight this. We make it boring, consistent, and documented in `cheatsheet.md`.

### Command content requirements (every command)
Every command file must include:
- What it does
- Inputs
- Outputs (files created/updated)
- Examples for Codex and Claude (in one file)
- Verification steps

Claude-only features must be tagged `CLAUDE_ONLY`.

### Baseline command set (required)
- `wf-explore`, `wf-shape`, `wf-plan`, `wf-work`, `wf-review`, `wf-release`, `wf-compound`
- `c-handoff`, `c-pickup`, `c-landpr`

**Note:** `wf-explore`, `wf-shape`, and `wf-release` are **net-new** (not ported from upstream). v1 scope:
- `wf-explore`: produce 1-page opportunity brief + experiment list (no deep tooling)
- `wf-shape`: produce PRD/spec + journey + architecture sketch
- `wf-release`: produce release checklist + comms snippet (no video automation)

`scripts/verify.sh` must assert these filenames exist in `commands/`.

## Workflow artifact contract (canonical paths for target repos)

These paths are conventions for **target repos** that use the templates (not this templates repo itself). Commands document these paths in their outputs.

| Artifact | Path | Created by |
|----------|------|------------|
| **Plan** | `docs/plans/<type>-<slug>.md` | `wf-plan` |
| **Todos** | `docs/todos/{id}-{status}-{priority}-{desc}.md` | `wf-review` (file-todos skill) |
| **Solution doc** | `docs/solutions/<category>/<slug>.md` | `wf-compound` |

### Plan file naming
- Use conventional commit prefix + descriptive slug
- Examples: `docs/plans/feat-user-auth.md`, `docs/plans/fix-cart-race.md`, `docs/plans/refactor-api-client.md`

### Todo file naming
- `{id}-{status}-{priority}-{description}.md`
- **ID format**: sequential numeric (`001`, `002`, ...) for single-lane; timestamp-based (`20260116-153012`) for parallel lanes to avoid collisions
- Status: `pending` → `ready` → `complete`
- Priority: `p1` (critical), `p2` (important), `p3` (nice-to-have)
- Example: `001-pending-p1-path-traversal.md` or `20260116-153012-pending-p1-path-traversal.md`

### Solution doc categories
Auto-detected from problem type:
- `build-errors/`, `test-failures/`, `runtime-errors/`, `performance-issues/`
- `database-issues/`, `security-issues/`, `ui-bugs/`, `integration-issues/`, `logic-errors/`

## Avoiding context rot: default to handoff + rehydrate (not fork)
We do NOT make "forking threads" the default parallelism pattern.

Default pattern:
1) The **plan file** serves as the context bundle (no separate pack file).
2) Run one or more review lanes as fresh sessions reading the plan.
3) Each lane writes todos to `docs/todos/`.
4) Main session synthesizes and continues.

For parallel lanes in practice:
- **Multiple sessions (default)**: Open 2–4 terminal tabs, run `c-pickup` with plan path, run lane, write todos.
- **Codex Cloud (optional)**: Use cloud tasks for parallel execution (not required).

## Compounding: does it follow the plugin?
Yes in philosophy and outcome:
- capture solved problems while context is fresh
- store structured solution docs
- make future work easier

We will port the plugin’s compounding concepts, but implement them with:
- plan file as context bundle
- lane outputs as files
- optional parallel execution
- no mandatory sub-agents

## Required repo artefacts
### 1) Guardrails
- `AGENTS.md` is canonical and must reflect:
  - taxonomy (new categories)
  - pnpm rule
  - no worktrees default
  - skill spec constraints
  - attribution + inspiration rules
  - cheatsheet requirement

### 2) Cheatsheet
- `cheatsheet.md` (repo root) lists:
  - Commands (`wf-*`, `c-*`) with 1-line purpose
  - Skills (grouped by category) with 1-line purpose
  - Hooks (git shared + Claude-only) with 1-line purpose
  - Common verification commands

**Lintable structure (required for `verify.sh`):**
- Must contain headings: `## Commands`, `## Skills`, `## Hooks`
- Under `## Commands`: one bullet per `commands/*.md` filename
- Under `## Skills`: one bullet per `skills/<cat>/<skill>/` path

### 3) Docs
- `docs/plans/plan.md` (this file)
- `docs/solutions/` structure for compounded learnings
- optional: `docs/packs/` and `reviews/` created by commands/skills as outputs

### 4) Scripts
- `scripts/install_codex_prompts.sh` (copy/sync `commands/*.md` → `~/.codex/prompts/`)
- `scripts/install_claude_commands.sh` (copy/sync `commands/*.md` → `.claude/commands/` optionally)
- `scripts/install_git_hooks.sh` (copy hook templates into `.git/hooks/` or instruct)
- `scripts/verify.sh` (structure + frontmatter checks, prints next steps)
- NOTE/TODO only: `scripts/init_skill.py` is not implemented in this scope (keep as TODO note only).

### 5) Hooks
- Shared: `hooks/git/` (pre-commit, pre-push), pnpm-based.
- Optional: `hooks/claude-only/` for Claude hooks configs, tagged `CLAUDE_ONLY`.

## Scope change (important): port everything from inspirations
Unlike a minimal “v1 set”, the scope here is:
- port over the complete inspirations we have mirrored (Compound Engineering plugin + agent-scripts)
- then normalise and reconcile them to fit:
  - taxonomy
  - pnpm
  - no worktrees default
  - skill format constraints
  - commands naming and installation

This includes:
- all upstream skills that are useful
- all upstream commands (mapped into wf-* or c-* or documented as “use built-in”)
- relevant scripts (eg committer)
- relevant docs where they are not “extra docs for skills” (docs can exist at repo root or `docs/`)

Exception:
- Compound Engineering plugin agents stay in `inspiration/` only; mark Ignore in changelog.

If an upstream item is not usable (eg deeply Rails-only), it still gets triaged in changelog and either:
- ported as STACK_SPECIFIC and clearly labelled, or
- ignored with rationale

## Acceptance criteria
A coding agent should be able to implement this PRD and validate:

- Skills taxonomy exists exactly:
  - `skills/{explore,shape,work,review,release,compound,utilities}/`
- All ported skills have `SKILL.md` that meets our frontmatter constraint:
  - name + description only
- All ported commands exist in `commands/` and are installable into:
  - `~/.codex/prompts/`
  - `.claude/commands/` (optional)
- Command naming is consistent:
  - `wf-*` are workflow commands
  - `c-*` are utility commands
- Cheatsheet exists and matches the command/skill inventory.
- `changelog/compound-engineering-plugin.md` and `changelog/agent-scripts.md` are updated to reflect reality after porting, with clear Fork/Sync/Ignore/Unclassified decisions.
- `scripts/verify.sh` passes and prints the manual smoke steps.
- Manual smoke:
  - run `wf-plan` in Codex and confirm it creates a plan file in `docs/plans/`.

## Tasks and sub tasks (detailed implementation plan)

### 0) Update docs and guardrails to reflect new taxonomy and full-port scope
0.1 Update `AGENTS.md`
- Replace old taxonomy list with:
  - Explore, Shape, Work, Review, Release, Compound, Utilities
- Add rule: skills taxonomy is single-level categories exactly as above.
- Add rule: skill folder naming encodes framework (react-, next-, cloudflare-) instead of adding a second level.
- Keep pnpm rule and “no worktrees by default”.
- Ensure “examples + verification” is required for skills/commands/hooks.

0.2 Update `docs/plans/plan.md`
- Ensure Explore definition (product strategy, experimentation) appears near top (done).
- Ensure workflow includes Explore + Plan + Work naming (done).
- Ensure scope explicitly says “port everything from inspirations” (done).

0.3 (Optional) Update `Ideation/brainstorming.md`
- Reorganise headings into:
  - Explore, Shape, Work, Review, Release, Compound, Utilities
- Keep all links, just move them under the new headings.

### 1) Create/normalise repo structure
1.1 Create directories
- `skills/{explore,shape,work,review,release,compound,utilities}/`
- `commands/`
- `hooks/git/`
- `hooks/claude-only/` (optional)
- `scripts/`
- `docs/solutions/` (can start empty)

1.2 Flatten any previous nested taxonomy dirs
- If existing skills were under other categories, move them into the new ones.

### 2) Port everything from `inspiration/compound-engineering-plugin`
2.1 Port skills
Source:
- `inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/*`

Destination:
- map each upstream skill into one of:
  - `skills/shape/`
  - `skills/work/`
  - `skills/review/`
  - `skills/release/`
  - `skills/compound/`
  - `skills/utilities/`
  - (rare) `skills/explore/`

Rules:
- Preserve upstream skill folder name unless it clashes.
- Convert SKILL.md frontmatter to `name` + `description` only.
- Move any extra docs into `references/` or drop if redundant.
- Replace npm/bun instructions with pnpm where relevant.
- Remove worktree requirements or mark as OPTIONAL.
- Add attribution block (creator/inspiration + link) inside SKILL.md body.

2.2 Port commands
Source:
- `inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/**`

Destination:
- `commands/` (single-level)

Mapping:
- workflows:
  - `workflows:plan` → `wf-plan`
  - `workflows:work` → `wf-work`
  - `workflows:review` → `wf-review`
  - `workflows:compound` → `wf-compound`
- other plugin commands:
  - triage, resolve_todo_parallel, feature-video, changelog, etc:
    - if utility: `c-<name>`
    - if release-ish: `wf-release` step or `c-release-*`

Rules:
- Commands must include Codex + Claude usage examples in one file.
- Replace Task/sub-agent instructions with pack-driven lanes (default).
- Tag any remaining Claude-only steps as `CLAUDE_ONLY`.
- Replace backgrounding `&` patterns with “run in another session” or “Codex Cloud optional”.
- Remove worktree-first flow (appendix only, OPTIONAL).

2.3 Do not port agents (keep in inspiration)
Source:
- `inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/**`

Decision:
- Keep agents in `inspiration/` only.
- Mark as Ignore in `changelog/compound-engineering-plugin.md`.

### 3) Port everything from `inspiration/agent-scripts`
3.1 Port slash commands
Source:
- `inspiration/agent-scripts/docs/slash-commands/*`

Destination:
- `commands/c-handoff.md`
- `commands/c-pickup.md`
- `commands/c-landpr.md`
- plus any others you want (acceptpr, raise, etc) mapped to `c-*`

Rules:
- Replace gate commands with pnpm where it is a Node repo.
- Remove worktree assumptions.
- Keep verification steps.
- Keep attribution.

3.2 Port scripts
Source:
- `inspiration/agent-scripts/scripts/committer`

Destination:
- `scripts/committer` (or keep identical name and document)
- Document usage in `commands/c-landpr.md` and cheatsheet.

3.3 Port skills
Source:
- `inspiration/agent-scripts/skills/*`

Destination:
- map into `skills/<category>/...` using same rules as above (frontmatter constraint, pnpm, verification, attribution).

### 4) Reconcile overlaps and naming collisions
4.1 Deduplicate skill names
- If both repos have `frontend-design`, decide:
  - keep one canonical skill
  - keep the other as a reference in inspiration only, or rename with prefix

4.2 Standardise naming conventions
- skill folder names: lowercase, digits, hyphens, verb-led where possible.
- framework skills: prefix with framework (`react-`, `next-`, `cloudflare-`).

4.3 Attribution for ported content
After the YAML frontmatter (which contains only `name` and `description`), include attribution:

```markdown
---
name: skill-name
description: This skill should be used when...
---

> **Attribution:** Ported from [compound-engineering](https://github.com/kieranklaassen/compound-engineering-plugin) by Kieran Klaassen.

# Skill Title
...
```

4.4 Deduplicate command names
- If both repos define the same command, pick one canonical file.
- Rename or drop the other; record the decision in `changelog/`.

### 5) Implement install scripts (Codex + Claude + hooks)
5.1 `scripts/install_codex_prompts.sh`
- Copy/sync `commands/*.md` → `~/.codex/prompts/`
- Flat directory only.
- Print what changed.

5.2 `scripts/install_claude_commands.sh`
- Copy/sync `commands/*.md` → `.claude/commands/` (create if missing)
- Print what changed.

5.3 `scripts/install_git_hooks.sh`
- Install `hooks/git/*` into `.git/hooks/` and chmod +x.
- Print what was installed.

### 6) Hooks (ultra-minimal, template-based)
6.1 Shared git hooks in `hooks/git/`
- Ship as **templates only**: `pre-commit.sample`, `pre-push.sample`
- Install script copies to `.git/hooks/` but prints: "edit to enable checks"
- Hooks run `pnpm -s <script>` **only if** `package.json` exists **and** script exists; otherwise silent (no output)
- Never brick repos or produce noisy errors

6.2 Claude-only hooks (optional)
- Keep under `hooks/claude-only/`
- Must be tagged `CLAUDE_ONLY` and never required.

### 7) Cheatsheet
7.1 Create/refresh `cheatsheet.md` at repo root
Must include:
- Commands list (wf-* + c-*) with 1-line description
- Skills list grouped by category (entire ported set, not minimal)
- Hooks list
- Verification commands patterns

### 8) Changelog triage (first pass after full port)
8.1 Update `changelog/compound-engineering-plugin.md`
- Ensure every upstream item you port or reference is classified:
  - Sync: copied mostly verbatim into canonical
  - Fork: copied but modified to fit constraints
  - Ignore: not adopted, with short rationale
  - Unclassified: empty after triage

8.2 Update `changelog/agent-scripts.md`
- Same treatment after porting.

### 9) Verification
9.1 Implement `scripts/verify.sh`
Checks:
- required directory structure exists
- each skill folder has `SKILL.md`
- each `SKILL.md` frontmatter has name+description only
- baseline command set exists in `commands/`
- cheatsheet exists and references categories
- no network; no workflows run

9.2 Manual smoke test steps printed by `scripts/verify.sh`
- Run install scripts:
  - `./scripts/install_codex_prompts.sh`
  - `./scripts/install_claude_commands.sh` (optional)
  - `./scripts/install_git_hooks.sh`
- Run a workflow command in Codex:
  - `wf-plan` on a tiny feature, confirm a plan file is created and includes verification
- Run review artefact flow:
  - generate pack → run one lane via fresh session using `c-pickup` → merge summary

## Notes / open questions (non-blocking)
- `scripts/init_skill.py` and `scripts/package_skill.py` are referenced in `AGENTS.md`. Keep as TODO notes only for now, do not block porting.
- Worktrees are avoided by default. If an upstream item relies on worktrees, port it as OPTIONAL or rewrite it.
- Explore is part of the workflow, but we will not prioritise deep exploration tooling until the rest of the loop feels solid.

## Claude later (deferred)
- Re-add Claude invocation examples and `.claude/commands` install docs; update cheatsheet.
- Restore Claude-only flows: Task/subagents, AskUserQuestion, optional worktrees, figma-design-sync, imgup.
- Tag CLAUDE_ONLY sections across commands/skills; isolate in references where needed.
