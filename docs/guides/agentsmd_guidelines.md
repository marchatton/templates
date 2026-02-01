# guidelines.md
Good AGENTS.md is small, true, and scoped. It helps an editing agent produce a better AGENTS.md (and companion docs) without bloating instructions or baking in stale repo trivia.

## Goal
Refactor (or create) an AGENTS.md that:
- Loads on every request without wasting tokens
- Stays accurate over time
- Improves agent behaviour by giving the *minimum universal context* 
- Uses progressive disclosure so detailed rules load only when needed

## Non-goals
AGENTS.md is **not**:
- A style guide dump
- A linter replacement
- A full onboarding handbook
- A place to document file paths that move weekly
- A running log of “agent did X once so add a rule forever”

## What good looks like
A strong setup usually has:
1. **Minimal root AGENTS.md** (universally relevant, always true)
2. **Task/domain docs** referenced from root (TypeScript, testing, API conventions, release process)
3. **Optional nested AGENTS.md** in subdirectories (monorepos/packages) for local scope
4. **Deterministic tooling** (lint/format/test hooks) doing enforcement, not the prompt

## Core principles

### 1) Less (instructions) is more
Every token in root AGENTS.md is paid on every request. So default to deleting or moving content out.
- Prefer a *few* high-signal instructions over lots of “nice to have” rules.
- If a rule is only relevant sometimes, it does not belong in root.

### 2) Universally applicable only in root
Root AGENTS.md should only contain things that are:
- Required for almost every task, and
- Stable over time, and
- Hard for the agent to infer reliably from the repo

If it fails any of those, it belongs elsewhere.

### 3) Progressive disclosure
Put detail in separate docs and link to them.
- Root should point the agent to “where to look” rather than “everything to remember”.
- Organise docs so agents can traverse a clear tree.

### 4) Avoid staleness (stale context poisons output)
Stale instructions mislead agents because they are treated as ground truth.
- Avoid documenting file paths and exact file locations unless they are genuinely stable.
- Prefer describing concepts and capabilities over structure.

### 5) Don’t make the agent do a linter’s job
Style and formatting rules are best enforced deterministically.
- Use formatters/linters and CI checks.
- Use hooks or commands to run checks and fix issues.
- Keep style guidance out of root unless it’s genuinely universal *and* cannot be enforced.

### 6) No auto-generated bloat
Never accept auto-generated AGENTS.md content as-is.
Generated files optimise for “cover everything” which is the opposite of good.

## Root AGENTS.md: the recommended minimum
Aim for something close to this, unless your repo genuinely needs more.

Must-haves:
- **One-sentence project description** (sets intent and scope)
- **Package manager** (if not npm) and workspace tooling
- **How to verify changes** (build/lint/test commands) when non-standard

Nice-to-haves (only if truly universal and stable):
- A short note on required runtimes (eg Node version) *if not obvious*
- A short note on release constraints (eg “never publish from local machine”)
- A pointer list to the progressive disclosure docs

Hard limit mindset:
- If root feels like a handbook, it’s already too big.

## Progressive disclosure doc tree: recommended structure
Keep docs discoverable, named plainly, and scoped by domain.

  Example:
  - `docs/`
    - `BUILD.md` (build, lint, common scripts, CI notes)
    - `TESTING.md` (test runner, how to run unit/integration/e2e)
    - `TYPESCRIPT.md` (TS conventions that aren’t enforced automatically)
    - `API_CONVENTIONS.md` (API patterns, error model, pagination, auth model)
    - `RELEASING.md` (versioning, changelog, cut release steps)
    - `ARCHITECTURE.md` (high-level design, stable concepts, boundaries)
    - `SECURITY.md` (safe handling rules, secrets, logging constraints)

Rules:
- Each doc should answer “When should I read this?” at the top.
- Prefer references to authoritative sources over copied snippets.
- Avoid long code blocks that will rot. If you must include examples, keep them tiny.

## Monorepos: scoping rules
Monorepos benefit from layered instructions.

- **Root AGENTS.md**
  - Monorepo purpose
  - How packages relate
  - Shared tooling (workspace, scripts)
  - Pointers to package-level AGENTS.md

- **Package-level AGENTS.md**
  - Package purpose and local constraints
  - Links to package-specific docs (or shared docs)

Warning:
- All AGENTS.md content merges into context. So keep each layer short.

## What to remove (anti-patterns)
Delete or move anything that’s:
- **Redundant**: the agent already knows (eg “write clean code”)
- **Vague**: cannot be acted on (eg “be thoughtful”)
- **Opinion-heavy** and not consistently enforced by the team
- **Contradictory** with other instructions
- **Overly specific** in ways that drift (file paths, directory maps)
- **Lint-y**: “always use const”, “never use var” (enforce via tooling or keep in a language doc at most)

## How to rewrite instructions so they actually work
Bad instruction styles:
- Absolute, broad, context-free (“Always do X”)
- Shouting emphasis (ALL CAPS)
- Lists of micro-style rules
- “Hotfix rules” stacked over time

Better:
- Short, scoped, and outcome-based
- “Prefer…” and “In this repo…” with a clear reason
- Pointing to the right doc instead of embedding detail
- Making verification steps explicit

Good phrasing patterns:
- “This repo is …”
- “Use … for dependency management.”
- “Before finalising, run …”
- “For <domain> conventions, see …”
- “If unsure, search for existing patterns in …”

## Editing workflow (what the AI should do)
When refactoring an AGENTS.md, follow this process:

1) **Extract everything into a list**
- Split by instruction/claim, not by paragraph.

2) **Find contradictions**
- Identify conflicts and present them as choices:
  - Option A: …
  - Option B: …
- Prefer removing both if neither is essential.

3) **Classify each item**
For each instruction, decide:
- Root AGENTS.md (universal + stable)
- Domain doc (TypeScript/testing/API/etc)
- Package AGENTS.md (only for that package)
- Delete (redundant/vague/stale)

4) **Rewrite for clarity and scope**
- Remove absolutes unless there is a hard constraint.
- Remove file-path assertions unless stable and essential.
- Replace “do X everywhere” with “do X in <context>” or move to doc.

5) **Build the doc tree**
- Create the minimal root and link out.
- Create the domain docs with headings and “when to read” notes.
- Keep each file short and scannable.

6) **Quality check**
- Root should read in under a minute.
- Domain docs should be independently useful, not copy-pasted noise.

## Quality checklist (pass/fail)
Root AGENTS.md passes if:
- [ ] One-sentence project description exists
- [ ] Package manager/workspaces are explicit (if not npm)
- [ ] Verification commands are clear (build/lint/test) if non-standard
- [ ] It mostly contains pointers to docs, not detail
- [ ] No large style guide sections
- [ ] No brittle file path maps
- [ ] No contradictory rules
- [ ] It is short enough that it feels “slightly too small”, not “finally complete”

## Template: minimal root AGENTS.md
Use this as the target shape.

```md
# AGENTS.md

## Project
<One sentence describing what this repo is and why it exists.>

## Tooling
- Package manager: <npm|pnpm|yarn|bun> (<workspaces if relevant>)
- Runtime constraints (if needed): <eg Node 20>

## Verify changes
- Build: <command>
- Lint: <command>
- Tests: <command>

## More context (read when relevant)
- Build and scripts: docs/BUILD.md
- Testing: docs/TESTING.md
- TypeScript conventions: docs/TYPESCRIPT.md
- API conventions: docs/API_CONVENTIONS.md
- Architecture: docs/ARCHITECTURE.md
