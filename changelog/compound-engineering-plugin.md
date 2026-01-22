# Compound-engineering-plugin Changelog

Track what we pull from `inspiration/compound-engineering-plugin/` when syncing.

## Sync strategy

**Synced content**: pull latest from upstream on `./scripts/agents_refresh.sh`. Human reviews diff before committing.

Rules
- Entries are paths relative to repo root.
- New upstream items go in Unclassified first.
- Move items to Fork or Sync or Ignore with a short rationale.
- Keep lists sorted by path for quick diffing.

## Ported (2026-01-16)

The following items were ported to canonical locations:

Commands (→ commands/)
- workflows/plan.md → commands/wf-shape.md (renamed: plan → shape)
- workflows/work.md → commands/wf-develop.md (renamed: work → develop)
- workflows/review.md → commands/wf-review.md
- workflows/compound.md → commands/compound.md (utility, not workflow)

Skills (→ skills/)
- skills/agent-browser/ → skills/utilities/agent-browser/
- skills/agent-native-architecture/ → skills/review/agent-native-architecture/
- skills/compound-docs/ → skills/compound/compound-docs/
- skills/create-agent-skills/ → skills/utilities/create-agent-skills/
- skills/every-style-editor/ → skills/utilities/every-style-editor/
- skills/file-todos/ → skills/utilities/file-todos/
- skills/gemini-imagegen/ → skills/utilities/gemini-imagegen/
- skills/skill-creator/ → skills/utilities/skill-creator/

## Fork (one-off)

- inspiration/compound-engineering-plugin/plugins/compound-engineering/CLAUDE.md - upstream config; one-off fork for agents.md structure

## Sync (include)

Plugin metadata
- inspiration/compound-engineering-plugin/plugins/compound-engineering/CHANGELOG.md - upstream changelog
- inspiration/compound-engineering-plugin/plugins/compound-engineering/LICENSE - upstream license
- inspiration/compound-engineering-plugin/plugins/compound-engineering/README.md - upstream component list

Commands
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/agent-native-audit.md - agent-native audit
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/changelog.md - release notes
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/create-agent-skill.md - skill creation
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/deepen-plan.md - planning depth
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/generate_command.md - command creation
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/heal-skill.md - skill repair
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/plan_review.md - plan review
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/report-bug.md - bug report
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/reproduce-bug.md - bug repro
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/resolve_parallel.md - parallel fixes
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/resolve_pr_parallel.md - PR fixes
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/resolve_todo_parallel.md - TODO sweep
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/test-browser.md - browser QA
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/triage.md - issue triage
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/workflows/compound.md - compound loop
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/workflows/plan.md - plan
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/workflows/review.md - review
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/workflows/work.md - work execution

Skills
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/agent-browser/ - browser automation
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/agent-native-architecture/ - prompt-native patterns
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/compound-docs/ - knowledge compounding
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/create-agent-skills/ - skill creation workflows
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/every-style-editor/ - Every copy style
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/file-todos/ - file-based todos
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/gemini-imagegen/ - image gen
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/skill-creator/ - skill scaffolding

## Ignore

Repo metadata + upstream docs
- inspiration/compound-engineering-plugin/CLAUDE.md - upstream config
- inspiration/compound-engineering-plugin/LICENSE - upstream license
- inspiration/compound-engineering-plugin/README.md - upstream overview
- inspiration/compound-engineering-plugin/docs/ - upstream docs site
- inspiration/compound-engineering-plugin/plans/ - upstream planning docs

Other plugin
- inspiration/compound-engineering-plugin/plugins/coding-tutor/ - separate plugin

Commands (non-web or external)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/deploy-docs.md - docs deploy
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/feature-video.md - promo video
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/lfg.md - ralph-wiggum dependency
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/release-docs.md - docs release
- inspiration/compound-engineering-plugin/plugins/compound-engineering/commands/xcode-test.md - iOS only

Agents (kept in inspiration only)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/design/design-iterator.md - iterative UI passes
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/agent-native-reviewer.md - action/context parity
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/architecture-strategist.md - architecture review
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/code-simplicity-reviewer.md - simplicity pass
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/data-integrity-guardian.md - migration safety
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/data-migration-expert.md - mapping checks
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/deployment-verification-agent.md - go/no-go checks
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/julik-frontend-races-reviewer.md - JS races
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/kieran-typescript-reviewer.md - TS conventions
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/pattern-recognition-specialist.md - anti-pattern scan
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/performance-oracle.md - perf analysis
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/security-sentinel.md - security audit
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/bug-reproduction-validator.md - repro workflow
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/every-style-editor.md - copy polish
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/pr-comment-resolver.md - PR followup
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/spec-flow-analyzer.md - spec gaps

Agents (excluded)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/design/design-implementation-reviewer.md - UI parity checks
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/design/figma-design-sync.md - Figma sync
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/best-practices-researcher.md - external best practices
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/framework-docs-researcher.md - framework docs
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/git-history-analyzer.md - git history
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/repo-research-analyst.md - repo research

Agents (language-specific)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/docs/ankane-readme-writer.md - Ruby gem README
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/dhh-rails-reviewer.md - Rails only
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/kieran-python-reviewer.md - Python only
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/kieran-rails-reviewer.md - Rails only
- inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/lint.md - Ruby/ERB lint

Skills (excluded)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/frontend-design/ - UI build (using agent-scripts version instead)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/git-worktree/ - worktree ops (avoid worktrees by default)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/rclone/ - file transfer

Skills (language-specific)
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/andrew-kane-gem-writer/ - Ruby gems
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/dhh-rails-style/ - Rails style
- inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/dspy-ruby/ - Ruby LLM apps

## Unclassified

Use for new/changed upstream items until triaged into Fork/Sync/Ignore.

- (empty)
