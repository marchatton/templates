# AGENTS.md

## Tooling
- Package manager: pnpm (workspaces)
- Prefer TypeScript for new code unless the repo already uses something else

## Principles
We follow core ideas from *The Pragmatic Programmer* (Andy Hunt, Dave Thomas):

- **Take ownership.** If something’s broken/unclear/risky or “not your job”, act anyway: flag it, fix it, or shape a better path.
- **Keep learning.** Maintain a “knowledge portfolio”. Store learnings in `docs/LEARNINGS.md`.
- **Avoid duplication (DRY).** Duplicate knowledge is as bad as duplicate code. Keep one source of truth and reuse it.
- **Build orthogonally.** Reduce coupling, keep dependencies explicit, and interfaces small.
- **Use tight feedback loops.** Small steps, fast validation. Use tracer bullets (thin end-to-end slices). One concern per commit/PR. Prefer the simplest thing that meets the requirement.
- **Prototype to learn, then bin it (when needed).** Don’t let prototypes silently become production.
- **Make behaviour explicit.** Clear contracts, assert assumptions, fail loudly when they break.
- **Automate boring/error-prone work.** Builds, tests, formatting, releases, setup, checks. If you do it twice, consider scripting it.
- **Keep code easy to change.** Refactor continuously, rename aggressively, optimise for readability.
- **Debug systematically.** Reproduce, isolate, change one thing at a time. Use tools properly.
- **Fix broken windows.** Small messes spread — tidy early.
- **Communicate trade-offs.** Requirements/estimates are conversations. Explain options, risks, and costs plainly.

Vibe: be practical, stay curious, optimise for long-term leverage over short-term heroics.

## Error handling + safety (high level)
- Validate external inputs at boundaries (Zod) and return safe user-facing errors
- Don’t leak internal errors/details to clients
- Unexpected issues: fail loudly (log/throw). Only show user-facing errors when needed

## Compatibility
- Backwards compatibility usually not required

## Agent files
- `AGENTS.md`: Repo‑wide engineering standards, tooling, and verification rules.
- `apps/web/AGENTS.md`: Stack and guardrails for the Next.js web app.
- `docs/AGENTS.md`: Structure and rules for the docs/knowledge hub.
- `docs/02-guidelines/AGENTS.md`: Brand/tone/a11y guidance + Brand DNA outputs (including Tailwind-ready token/preset artefacts).
- `docs/03-architecture/AGENTS.md`: Architecture boundaries and security posture rules.
- `docs/04-projects/AGENTS.md`: Dossier conventions and delivery workflow for project work.
- `docs/06-release/AGENTS.md`: Release process and changelog/postmortem expectations

## File management
- Oracle bundles (`oracle --render`) are committed under:
  - Dossier work: `<dossier>/tmp-oracle/` (inside `docs/04-projects/...`)
  - Non-dossier work: `docs/98-tmp/oracle/`
- Handoff notes (`handoff` skill) are committed under:
  - Dossier work: `<dossier>/tmp-handoffs/` (inside `docs/04-projects/...`)
  - Non-dossier or cross-dossier: `docs/98-tmp/handoffs/`
- Filenames:
  - Oracle bundles: `oracle-bundle_<slug>.md` (or `oracle-bundle_<id>_<slug>.md` inside dossiers)
  - Handoff notes: `handoff_YYYY-MM-DD_HH-MM-SS_<slug>.md`
- Store local-only scratch in root `throwaway/` (gitignored; not synced to GitHub)
- Store other random tmp files in root `tmp/` folder (synced to GitHub)
- When working on a project, follow the conventions outlined in `docs/04-projects/AGENTS.md`

## Core skills to use
- `ask-questions-if-underspecified` skill when unclear
- `oracle` skill for deep research
- `verify` skill for checking code changes

## Canonical instructions + local agent setup
- Canonical skills/commands/hooks live in `marchatton/agent-skills` — fix/add missing/wrong skills there NOT in this repo
- `.agents/` contains all skills etc in this repo (e.g. `codex`). For other tools, use `iannuttall/dotagents` to symlink `.agents` into tool-specific locations
- `AGENTS.md` is the source of truth; other agent files should be symlinks (don’t fork instructions per tool)
