# Agent-scripts Changelog

Track what we pull from https://github.com/steipete/agent-scripts into `inspiration/agent-scripts/` for syncing or not.

Rules
- Entries are paths relative to repo root.
- New upstream items go in Unclassified first.
- Move items to Sync (include) or Ignore with a short rationale.
- Keep lists sorted by path for quick diffing.

## Fork (one-off)

- inspiration/agent-scripts/AGENTS.MD - one-off fork to `agents/` for baseline guardrails
- inspiration/agent-scripts/tools.md - one-off fork; tool-call template
- inspiration/agent-scripts/README.md - one-off fork; upstream sync context


## Sync (include)

Docs
- inspiration/agent-scripts/docs/slash-commands.md - command registry overview
- inspiration/agent-scripts/docs/slash-commands/ - per-command docs

Scripts
- inspiration/agent-scripts/scripts/committer - scoped git commit helper

Skills
- inspiration/agent-scripts/skills/frontend-design - UI design guidance
- inspiration/agent-scripts/skills/markdown-converter - Markdown conversion
- inspiration/agent-scripts/skills/nano-banana-pro - Gemini image generation/editing
- inspiration/agent-scripts/skills/openai-image-gen - image generation workflow
- inspiration/agent-scripts/skills/oracle - external LLM helper workflow
- inspiration/agent-scripts/skills/video-transcript-downloader - transcript automation

## Ignore

Repo metadata - nested git + upstream repo bookkeeping.
- inspiration/agent-scripts/.git/ - nested repository metadata
- inspiration/agent-scripts/.gitignore - upstream ignore rules
- inspiration/agent-scripts/CHANGELOG.md - upstream changelog only

Upstream docs - background context only.
- inspiration/agent-scripts/LICENSE - upstream license

Release and app docs - Mac app release operations, not skills.
- inspiration/agent-scripts/docs/RELEASING.md - app-specific release steps
- inspiration/agent-scripts/docs/RELEASING-MAC.md - app-specific release steps
- inspiration/agent-scripts/docs/concurrency.md - app-specific notes
- inspiration/agent-scripts/docs/mac-app.md - app-specific guidance
- inspiration/agent-scripts/docs/npm-publish-with-1password.md - tooling-specific
- inspiration/agent-scripts/docs/update-changelog.md - upstream process doc
- inspiration/agent-scripts/docs/windows.md - app-specific guidance
- inspiration/agent-scripts/release/ - release scripts for upstream app

Scripts (replaced or niche)
- inspiration/agent-scripts/scripts/browser-tools.ts - replace with `inspiration/agent-browser`
- inspiration/agent-scripts/scripts/shazam-song - specialized helper

Skills (platform or tool-specific)
- inspiration/agent-scripts/skills/1password - depends on 1Password CLI
- inspiration/agent-scripts/skills/brave-search - depends on Brave API
- inspiration/agent-scripts/skills/domain-dns-ops - DNS operations workflows
- inspiration/agent-scripts/skills/instruments-profiling - Apple Instruments focus
- inspiration/agent-scripts/skills/native-app-performance - native app profiling focus
- inspiration/agent-scripts/skills/swift-concurrency-expert - Swift specific
- inspiration/agent-scripts/skills/swiftui-liquid-glass - SwiftUI specific
- inspiration/agent-scripts/skills/swiftui-performance-audit - SwiftUI specific
- inspiration/agent-scripts/skills/swiftui-view-refactor - SwiftUI specific

## Unclassified

Use for new/changed upstream items until triaged into Fork/Sync/Ignore.

Docs
- inspiration/agent-scripts/docs/subagent.md - subagent workflow

Scripts
- inspiration/agent-scripts/scripts/docs-list.ts - doc index generator
- inspiration/agent-scripts/scripts/nanobanana - Gemini image edit script (overlaps nano-banana-pro)
- inspiration/agent-scripts/scripts/trash.ts - safe delete helper

Skills
- inspiration/agent-scripts/skills/create-cli - CLI scaffolding guidance
