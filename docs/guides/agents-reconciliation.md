# Agents Reconciliation (2026-01-29)

## Scope
- Reconciling skills, commands, hooks, agents templates in this repo.
- Sources: `.agents/register.json`, `.agents/vendors.json`, `changelog/agent-scripts.md`, `changelog/compound-engineering-plugin.md`, on-disk files.
- Note: changelog paths use `skills/` and `commands/` without the `.agents/` prefix; this report maps them to `.agents/...` when comparing to disk.

## Snapshot
- Register: skills=43, commands=0, hooks=0, agentsDocs=0.
- On disk: skills=32, commands=11, hooks files=1, agents templates=9.
- Placeholder-like skills on disk: 28/32.
- Exact duplicate SKILL.md files: none.

## Skills

### Ported (from changelog)
- Compound plugin → `.agents/skills/compound/compound-docs/`, `.agents/skills/review/agent-native-architecture/`, plus utilities.
- Agent-scripts → utilities: `oracle`, `frontend-design`, `markdown-converter`, `nano-banana-pro`, `openai-image-gen`, `video-transcript-downloader`.

### Vendor sync (from `.agents/vendors.json`)
- Utilities expected by sync but missing on disk:
  - `.agents/skills/utilities/agent-browser/` sync (CLI wrapper)
  - `.agents/skills/utilities/create-agent-skills/` sync
  - `.agents/skills/utilities/every-style-editor/` sync
  - `.agents/skills/utilities/file-todos/` sync
  - `.agents/skills/utilities/frontend-design/` sync
  - `.agents/skills/utilities/gemini-imagegen/` sync
  - `.agents/skills/utilities/markdown-converter/` sync
  - `.agents/skills/utilities/nano-banana-pro/` sync
  - `.agents/skills/utilities/openai-image-gen/` sync
  - `.agents/skills/utilities/skill-creator/` sync
  - `.agents/skills/utilities/video-transcript-downloader/` sync (yt-dlp transcript workflow)

### Non-placeholder skills on disk (keep)
- `.agents/skills/develop/use-ai-sdk/SKILL.md` (CLI wrapper)
- `.agents/skills/review/agentation/SKILL.md` (CLI wrapper)
- `.agents/skills/utilities/ask-questions-if-underspecified/SKILL.md` (fork)
- `.agents/skills/utilities/modular-skills-architect/SKILL.md` (created)

### Placeholder-like skills on disk
- Ported (keep):
  - `.agents/skills/compound/compound-docs/SKILL.md` (sync)
  - `.agents/skills/review/agent-native-architecture/SKILL.md` (sync)
  - `.agents/skills/utilities/oracle/SKILL.md` (CLI wrapper)
- Explicit keep (per user):
  - `.agents/skills/utilities/docs-list/SKILL.md`
  - `.agents/skills/utilities/create-cli/SKILL.md`
- Delete candidates (placeholder + not in changelogs, not in vendor sync):
  - `.agents/skills/develop/report-bug/SKILL.md` (command exists upstream)
  - `.agents/skills/develop/reproduce-bug/SKILL.md` (command exists upstream)
  - `.agents/skills/develop/resolve-pr-feedback/SKILL.md` (command exists upstream)
  - `.agents/skills/develop/resolve-todos/SKILL.md` (command exists upstream)
  - `.agents/skills/develop/work-execute/SKILL.md` (workflow exists upstream)
  - `.agents/skills/explore/customer-segmentation/SKILL.md` (delete)
  - `.agents/skills/explore/opportunity-solution-tree/SKILL.md` (delete)
  - `.agents/skills/explore/positioning/SKILL.md` (delete)
  - `.agents/skills/explore/pricing-packaging/SKILL.md` (delete)
  - `.agents/skills/explore/roadmap/SKILL.md` (delete)
  - `.agents/skills/release/changelog-draft/SKILL.md` (command exists upstream)
  - `.agents/skills/release/post-release-verify/SKILL.md` (workflow exists upstream)
  - `.agents/skills/release/release-checklist/SKILL.md` (workflow exists upstream)
  - `.agents/skills/review/browser-qa/SKILL.md` (command exists upstream)
  - `.agents/skills/review/pr-review/SKILL.md` (review workflow exists upstream)
  - `.agents/skills/shape/breadboard/SKILL.md` (delete)
  - `.agents/skills/shape/create-json-prd/SKILL.md`
  - `.agents/skills/shape/create-prd/SKILL.md` (not in changelogs)
  - `.agents/skills/shape/deepen-plan/SKILL.md` (command exists upstream)
  - `.agents/skills/shape/prd-review/SKILL.md` (not in changelogs)
  - `.agents/skills/shape/spike-plan/SKILL.md` (delete)
  - `.agents/skills/utilities/multi-agent-routing/SKILL.md` (delete; track TODO in plan2)
  - `.agents/skills/utilities/trash/SKILL.md` (script exists upstream in agent-scripts)

### Register mismatches
- Register entries with missing files: the 11 vendor-sync utilities listed above.
- SKILL.md files on disk not in register: none.

## Commands

### On disk (.agents/commands)
- `agent-native-audit.md`
- `compound.md`
- `oracle.md`
- `verify.md`
- `wf-develop.md`
- `wf-explore.md`
- `wf-ralph.md`
- `wf-release.md`
- `wf-review.md`
- `wf-shape.md`

### Ported (from changelog)
- Compound plugin → `commands/wf-shape.md`, `commands/wf-develop.md`, `commands/wf-review.md`, `commands/compound.md`.
- Agent-scripts → `commands/handoff.md`, `commands/pickup.md`, `commands/landpr.md` (not present on disk).

### Vendor sync commands (missing on disk)
- From agent-scripts: `commands/handoff.md`, `commands/pickup.md`, `commands/landpr.md`.
- From compound plugin: `commands/triage.md`, `commands/plan-review.md`, `commands/deepen-plan.md`, `commands/report-bug.md`, `commands/reproduce-bug.md`, `commands/resolve-parallel.md`, `commands/resolve-pr-parallel.md`, `commands/resolve-todo-parallel.md`, `commands/changelog.md`, `commands/generate-command.md`, `commands/create-agent-skill.md`, `commands/heal-skill.md`, `commands/test-browser.md`.

### Register mismatches
- Register has no commands entries; all on-disk commands are unregistered.

## Hooks
- On disk: `.agents/hooks/README.md`, `.agents/hooks/git/*` (canonical git hook templates).
- `hooks/git` is now a symlink to `.agents/hooks/git` for compatibility.
- Register hooks: present.
- Vendor hooks: none.

## Agents / Agents docs
- On disk templates: `docs/agentsmd/*.md` (9 files).
- On disk config: `.agents/ralph/config.sh`.
- Register agentsDocs: none.

## Agent -> Skill conversion (KAS)
- Review: `agent-native-reviewer`, `architecture-strategist`, `code-simplicity-reviewer`, `data-integrity-guardian`, `data-migration-expert`, `deployment-verification-agent`, `kieran-python-reviewer`, `kieran-typescript-reviewer`, `pattern-recognition-specialist`, `performance-oracle`, `security-sentinel`.
- Develop: `bug-reproduction-validator`, `pr-comment-resolver`.
- Shape: `spec-flow-analyzer`.
- Utilities (research): `best-practices-researcher`, `framework-docs-researcher`, `git-history-analyzer`, `repo-research-analyst`.
- Ignored: `julik-frontend-races-reviewer`, `dhh-rails-reviewer`, `kieran-rails-reviewer`, `design-*`, `lint`, `ankane-readme-writer`.
- `every-style-editor` handled by utility skill (sync); no duplicate review skill.

## Decisions (current)
- Delete placeholder skills that are not in changelogs or vendor sync (list above).
- Keep ported placeholders (`compound-docs`, `agent-native-architecture`, `oracle`).
- Keep `docs-list`, `create-cli` by request.
- Keep non-placeholder skills on disk.

## Open questions
- Register should track commands/hooks/agents docs too (pending implementation).

## Inspiration name matches (skill-name search)
- `compound-docs` → skill in compound plugin (plus references/assets)
- `agent-native-architecture` → skill in compound plugin (plus references)
- `oracle` → skill in agent-scripts; also an agent named `performance-oracle` in compound plugin
- `create-cli` → skill in agent-scripts (plus references)
- `docs-list` → script in agent-scripts (`scripts/docs-list.ts`)
- `trash` → script in agent-scripts (`scripts/trash.ts`)
- `report-bug` → command in compound plugin
- `reproduce-bug` → command in compound plugin
- `deepen-plan` → command in compound plugin
