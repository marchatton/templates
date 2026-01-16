# AGENTS.md
Make skills concise + specific. Sacrifice grammar for concision.

Purpose: agent instructions for skills/commands/hooks across Codex/Claude/Gemini; primary Codex, keep model-agnostic.
Repo mix: curated + custom skills.

## Core principles (skill-creator)
- Assume agent smart; only add non-obvious context.
- SKILL.md required. YAML frontmatter: name + description only.
- Description = trigger + when-to-use. Body = how-to.
- Keep SKILL.md lean (<500 lines). Prefer examples over prose.
- Progressive disclosure: `scripts/` for repeatable code, `references/` for docs, `assets/` for templates.
- Avoid deep nesting. No duplicate info across SKILL.md vs references.
- No extra docs (README, CHANGELOG, etc).
- Set freedom to fragility: high for heuristics, low for brittle sequences.
- Skills should be modular and composable.

## Naming + structure
- name: lowercase/digits/hyphens, <64 chars, verb-led; folder matches name.
- Single-level categories only: `skills/<category>/<skill-name>/`. No nested category dirs.
- Framework-specific skills: encode framework in folder name (react-, next-, cloudflare-). No second-level dirs.
- Plan is a workflow step; no `skills/plan/` category.
- Multi-variant skills: core workflow in SKILL.md; variant details in `references/*` linked once.
- If reference >100 lines, add TOC.

## Creation workflow
- 1) collect usage examples
- 2) plan reusable resources (scripts/references/assets)
- 3) init with `scripts/init_skill.py`
- 4) implement resources + SKILL.md (imperative voice)
- 5) package with `scripts/package_skill.py`
- 6) iterate from real use
- Test scripts you add (sample run ok).

## Attribution
- Credit creator; note framework inspiration (e.g., Shape Up/Ryan Singer).

## Repo focus + constraints
- Product engineers, end-to-end delivery (problem -> ship -> promo).
- Maintain cheatsheet: commands/tools + 1-line description.
- Inspiration repos: store in `inspiration/<repo>`; changelog file per repo in `changelog/<repo>.md`; keep synced; prefer links; credit creator + repo.
- Skills/commands/hooks: include example usage + verification steps.
- Use pnpm, not npm/bun.
- Avoid Git worktrees; prefer multiple small commits.
- Sub-agents optional; use only with clear ROI.

## Skill taxonomy (dirs)
- Explore
- Shape
- Work
- Review
- Release
- Compound
- Utilities

## References
- Skill creator spec: https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- Skill spec: https://agentskills.io/specification
- Inspiration: Steipete, Compound Engineering, Obra Superpowers
