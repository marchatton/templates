# Templates Repo Implementation Summary

**Date:** 2026-01-16  
**PRD:** docs/plans/plan.md  
**Thread:** T-019bc8ad-d1d8-7753-a0b6-3cfce0ee8788

## Overview

Implemented the full PRD for a Codex-first product engineering templates repo. Ported all Sync items from inspiration repos, created canonical directory structure, install scripts, verification tooling, and documentation.

## What Was Created

### Directory Structure

```
templates/
├── skills/
│   ├── explore/                         # placeholder
│   ├── shape/                           # placeholder
│   ├── work/
│   │   └── frontend-design/             # from agent-scripts
│   ├── review/
│   │   └── agent-native-architecture/   # from compound-engineering
│   ├── release/                         # placeholder
│   ├── compound/
│   │   └── compound-docs/               # from compound-engineering
│   └── utilities/
│       ├── agent-browser/
│       ├── create-agent-skills/
│       ├── every-style-editor/
│       ├── file-todos/
│       ├── gemini-imagegen/
│       ├── markdown-converter/
│       ├── nano-banana-pro/
│       ├── openai-image-gen/
│       ├── oracle/
│       ├── skill-creator/
│       └── video-transcript-downloader/
├── commands/
│   ├── wf-explore.md      # net-new placeholder
│   ├── wf-shape.md        # net-new placeholder
│   ├── wf-plan.md         # from compound-engineering
│   ├── wf-work.md         # from compound-engineering
│   ├── wf-review.md       # from compound-engineering
│   ├── wf-release.md      # net-new placeholder
│   ├── wf-compound.md     # from compound-engineering
│   ├── c-handoff.md       # from agent-scripts
│   ├── c-pickup.md        # from agent-scripts
│   └── c-landpr.md        # from agent-scripts
├── hooks/git/
│   ├── pre-commit.sample
│   └── pre-push.sample
├── scripts/
│   ├── install_codex_prompts.sh
│   ├── install_claude_commands.sh
│   ├── install_git_hooks.sh
│   ├── committer
│   └── verify.sh
├── cheatsheet.md
├── docs/
│   ├── plans/
│   └── solutions/
└── changelog/
    ├── compound-engineering-plugin.md   # updated
    └── agent-scripts.md                 # updated
```

## Skills Ported (14 total)

| Skill | Source | Destination | Category |
|-------|--------|-------------|----------|
| frontend-design | agent-scripts | skills/work/ | work |
| agent-native-architecture | compound-engineering | skills/review/ | review |
| compound-docs | compound-engineering | skills/compound/ | compound |
| agent-browser | compound-engineering | skills/utilities/ | utilities |
| create-agent-skills | compound-engineering | skills/utilities/ | utilities |
| every-style-editor | compound-engineering | skills/utilities/ | utilities |
| file-todos | compound-engineering | skills/utilities/ | utilities |
| gemini-imagegen | compound-engineering | skills/utilities/ | utilities |
| skill-creator | compound-engineering | skills/utilities/ | utilities |
| markdown-converter | agent-scripts | skills/utilities/ | utilities |
| nano-banana-pro | agent-scripts | skills/utilities/ | utilities |
| openai-image-gen | agent-scripts | skills/utilities/ | utilities |
| oracle | agent-scripts | skills/utilities/ | utilities |
| video-transcript-downloader | agent-scripts | skills/utilities/ | utilities |

### Skill Format Applied

All skills have:
- YAML frontmatter with **name + description only** (removed license, allowed-tools, preconditions, model fields)
- Attribution blockquote after frontmatter: `> **Attribution:** Ported from [repo](url) by Author.`
- Body content preserved as-is
- Subdirectories (references/, assets/, scripts/) copied where they existed

## Commands Created (10 total)

| Command | Type | Source | Notes |
|---------|------|--------|-------|
| wf-explore | workflow | net-new | Placeholder stub with TODOs |
| wf-shape | workflow | net-new | Placeholder stub with TODOs |
| wf-plan | workflow | compound-engineering | Renamed from workflows:plan |
| wf-work | workflow | compound-engineering | Renamed, worktree marked OPTIONAL |
| wf-review | workflow | compound-engineering | Renamed, skill paths updated |
| wf-release | workflow | net-new | Placeholder stub with TODOs |
| wf-compound | workflow | compound-engineering | Renamed from workflows:compound |
| c-handoff | utility | agent-scripts | Session handoff checklist |
| c-pickup | utility | agent-scripts | Task pickup checklist |
| c-landpr | utility | agent-scripts | PR landing workflow |

### Command Adaptations

- Changed `name:` from `workflows:xxx` to `wf-xxx`
- Replaced `.claude/skills/` paths with `skills/`
- Marked worktree flows as OPTIONAL (not default)
- Added invocation examples for Codex (`/prompts:wf-plan`) and Claude (`/wf-plan`)
- Added attribution blockquotes

## Scripts Created (5 total)

| Script | Purpose |
|--------|---------|
| install_codex_prompts.sh | Copy commands/*.md → ~/.codex/prompts/ |
| install_claude_commands.sh | Copy commands/*.md → .claude/commands/ |
| install_git_hooks.sh | Install hooks/git/*.sample → .git/hooks/ |
| committer | Scoped git commit helper (from agent-scripts) |
| verify.sh | Verify repo structure, print smoke test steps |

## Hooks Created (2 templates)

| Hook | Behavior |
|------|----------|
| pre-commit.sample | Runs pnpm lint/format if package.json exists; silent otherwise |
| pre-push.sample | Runs pnpm typecheck/test if package.json exists; silent otherwise |

Hooks are templates only - they never brick repos or produce noisy errors.

## Cheatsheet

Created `cheatsheet.md` with required sections:
- **## Commands** - All wf-* and c-* commands with invocation patterns
- **## Skills** - All skills grouped by category
- **## Hooks** - Hook templates
- **## Scripts** - All scripts with purpose
- **## Artifact Paths** - docs/plans/, docs/todos/, docs/solutions/

## Changelogs Updated

Both changelog files now include a **## Ported (2026-01-16)** section documenting:
- Source path → destination path mapping
- Clear record of what was ported and where

## Verification

`scripts/verify.sh` passes all checks:
- ✓ Directory structure exists (all 7 skill categories + commands + hooks + scripts)
- ✓ 14 skills with compliant SKILL.md frontmatter
- ✓ 10 baseline commands exist
- ✓ cheatsheet.md with required sections
- ✓ Install scripts are executable
- ✓ Hook templates exist

## What Was NOT Ported (per PRD)

- **git-worktree skill** - Marked Ignore (avoid worktrees by default)
- **Agents** - Kept in inspiration/ only
- **Pack files** - Plan file serves as context bundle
- **Language-specific skills** - Rails/Ruby/Swift skills stayed in Ignore

## Key Design Decisions

1. **Frontmatter constraint enforced**: name + description only
2. **Attribution standardized**: Blockquote format after frontmatter
3. **Command naming**: wf-* for workflows, c-* for utilities
4. **Hooks as templates**: .sample extension, silent no-op if package.json missing
5. **Install scripts run FROM templates repo**: Copy to global (Codex) or local (Claude)
6. **Artifact paths use docs/ prefix**: docs/plans/, docs/todos/, docs/solutions/

## Next Steps (Manual Smoke Test)

1. Run install scripts:
   ```bash
   ./scripts/install_codex_prompts.sh
   ```

2. Test wf-plan in Codex:
   ```
   /prompts:wf-plan 'Add user authentication'
   ```
   → Confirm plan file created in docs/plans/

3. Test review flow:
   → Create plan → run review lane → check todos/
