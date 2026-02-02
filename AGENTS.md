# AGENTS.md
Make skills concise + specific. Sacrifice grammar for concision.

## Scope and guidelines
- This repo is the canonical source for agent skills/commands/hooks and repo scaffolds consumed by downstream projects.

## Guidelines
- Changes here propagate into many repos. Prefer small changes, avoid breaking downstream scaffolds, and call out any intentional breakage in the PR.
- If a workflow is repeatable, prefer adding/updating a skill/command rather than growing AGENTS.
- Avoid brittle file-path assertions in prose. Describe stable concepts and search if unsure.
- For creating new skills, default to `@creating-agent-skills`.

## Template structure
- Canonical repo of skills/commands/hooks lives under .agents
- Canonical docs folder structure `docs/REPO-STRUCTURE.md`
- Canonical document templates `docs/templates`
- Target-repo AGENTS.md templates live in `docs/agentsmd/`.
- For commands, skills, agent files etc; `AGENTS.md` is the source of truth. Agentic tool specific files (e.g. `CLAUDE.md`) should be symlinked via `iannuttal/dotagents` — don’t fork instructions per agentic tool (e.g. Claude, Amp).
- Canonical workflows live under `.agents/skills` (`wf-*`); keep AGENTS references in sync
- .agents/register.json contains all commands/skills/agents + upstream mapping
- .agents/register.json is the canonical schema for register metadata fields; do not guess field names
- skills_copy/skills_diff only handle upstreams in inspiration/ (repo without "/"); use scripts/npx_skills_refresh.sh for GitHub-style upstreams

## Tooling
- Package manager: default pnpm
- When you invoke a skill, print echo: `:: the <skill name> skill must FLOW ::` (only mention here; don't repeat elsewhere)


## Codex web search
- Live web: start with `--yolo` or set `web_search = "live"` in `~/.codex/config.toml`.
- Web search strong lately; avoids outdated framework data from LLM cutoff.

## When unclear
Use `ask-questions-if-underspecified` before making template changes that affect multiple repos.

## Onboarding new repos
- Use onboarding script to copy templates into target repo structure.
