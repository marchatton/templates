# AGENTS.md
Make skills concise + specific. Sacrifice grammar for concision.

## Purpose (WHY)
Guardrails for skills/commands/hooks across Codex/Claude/Gemini (primary: Codex). Model-agnostic.
This repo is the canonical source of product-engineering skills, commands, hooks, templates. Other repos consume, not rewrite.

## Repo map (WHAT)
Canonical surface: `.agents/` (source of truth, everything runnable).
Sync/link mechanism: `iannuttall/dotagents` links `.agents/` into runners/clients and across machines.
Platform: macOS/Linux/WSL only (shell scripts not native Windows).

Structure:
- `.agents/skills/<category>/<skill>/SKILL.md`
- `.agents/commands/<command>.md`
- `.agents/hooks/` optional (examples only in v1)
- `inspiration/<vendor>/` mirrors + `changelog/<vendor>.md` (Sync/Fork/Ignore/Unclassified)
- `scripts/` (refresh/generate/verify, wrappers)
- `docs/templates/` (templates used by skills/commands)

## How to work (HOW)
Principles: KISS, YAGNI, DRY. Prefer simple workflows + verification, not clever automation.
No roles/modes in v1. No sub-agent dependency. Use `multi-agent-routing` if needed (sub-agents if supported, else parallel/serial sessions).
Commands are runbooks. Skills are reusable blocks.

Code-touching work must include verification + GO/NO-GO:
- `pnpm lint`
- `pnpm typecheck`
- `pnpm test`
- `pnpm build`
- `pnpm verify`
Output: GO or NO-GO + the evidence (what ran, what failed, links/paths if relevant).

When creating/updating skills: follow `skill-creator` (reference implementation).

## Skill rules (strict)
- `SKILL.md` required.
- Frontmatter: `name` + `description` only (optional `license`).
- Description = trigger/when-to-use. Body = imperative how-to. Examples > prose.
- Keep <500 lines. Avoid repetition via `scripts/`, `assets/`, `references/` (link refs once).
- No extra per-skill docs (README/CHANGELOG). Move essentials to `references/` or drop.
- Every skill includes **Verify**. If code-touching: pnpm ladder + GO/NO-GO.

Special utility skill: `ask-questions-if-underspecified`
- Must exist exactly as defined.
- Never auto-run. Only when explicitly invoked.

## Command rules (runbooks)
- File: `.agents/commands/<name>.md`
- Must include: purpose, inputs, outputs, steps (which skills), verification + GO/NO-GO, usage examples.
- Workflow commands (keep these names): `wf-explore`, `wf-shape`, `wf-develop`, `wf-review`, `wf-release`, `wf-ralph`
- Utility commands: short names eg `verify`, `landpr`, `handoff`, `pickup`, `compound`

## Naming + taxonomy (invariants)
- Skill name: lowercase/digits/hyphens, <64 chars, verb-noun. Folder matches name.
- Single-level categories only. No deep nesting.
- Framework-specific: encode in folder name (react-, next-, cloudflare-).

Skills must live under exactly:
- `explore/` `shape/` `develop/` `review/` `release/` `compound/` `utilities/`

## Progressive disclosure (read when relevant)
Keep AGENTS.md universal. Put detail in docs and only read on demand:
- `agent_docs/compounding.md` (learnings flow, templates, when `wf-release` runs `compound`)
- `agent_docs/ralph.md` (continuous coding loop, PRD json, iterations, verify + GO/NO-GO)
- `agent_docs/vendors.md` (vendor mirrors, changelog decisions, update/sync scripts, “latest” CLI wrappers)
- `agent_docs/hooks.md` (git hook templates + rules, CI expectations)
- `agent_docs/creation_workflow.md` (the v1 creation steps, examples-first, verify-first)
- `agent_docs/attribution.md` (how to credit upstream + methodology inspiration)
