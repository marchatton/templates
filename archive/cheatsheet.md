# Templates Cheatsheet

Quick reference for commands, skills, and hooks in this repo.

## Commands

- `wf-explore` - Product strategy, opportunity briefs, experiments (Codex: `/prompts:wf-explore`, Claude: `/wf-explore`)
- `wf-shape` - PRDs, specs, architecture sketches (Codex: `/prompts:wf-shape`, Claude: `/wf-shape`)
- `wf-plan` - Transform ideas into structured plans (Codex: `/prompts:wf-plan`, Claude: `/wf-plan`)
- `wf-work` - Execute work plans with quality checks (Codex: `/prompts:wf-work`, Claude: `/wf-work`)
- `wf-review` - Structured code review with todo capture (Codex: `/prompts:wf-review`, Claude: `/wf-review`)
- `wf-release` - Release checklist, deploy verification, comms (Codex: `/prompts:wf-release`, Claude: `/wf-release`)
- `wf-compound` - Capture solved problems as docs (Codex: `/prompts:wf-compound`, Claude: `/wf-compound`)
- `c-handoff` - Package session state for next agent (Codex: `/prompts:c-handoff`, Claude: `/c-handoff`)
- `c-pickup` - Rehydrate context when starting work (Codex: `/prompts:c-pickup`, Claude: `/c-pickup`)
- `c-landpr` - Land PRs with rebase, gate, merge (Codex: `/prompts:c-landpr <pr>`, Claude: `/c-landpr <pr>`)

## Skills

- `skills/compound/compound-docs/` - Capture solved problems as categorized docs with YAML frontmatter
- `skills/review/agent-native-architecture/` - Build apps where agents are first-class citizens
- `skills/utilities/agent-browser/` - Browser automation via Vercel's agent-browser CLI
- `skills/utilities/create-agent-skills/` - Expert guidance for creating agent skills
- `skills/utilities/every-style-editor/` - Review/edit copy against Every style guide
- `skills/utilities/file-todos/` - File-based todo tracking in docs/todos/ directory
- `skills/utilities/gemini-imagegen/` - Image generation/editing with Gemini API
- `skills/utilities/markdown-converter/` - Convert documents to Markdown via markitdown
- `skills/utilities/nano-banana-pro/` - Image generation/editing with Nano Banana Pro (Gemini)
- `skills/utilities/openai-image-gen/` - Batch image generation via OpenAI Images API
- `skills/utilities/oracle/` - Bundle prompt+files for second-model review
- `skills/utilities/skill-creator/` - Official skill creator from Anthropic spec
- `skills/utilities/video-transcript-downloader/` - Download videos, audio, subtitles, transcripts
- `skills/work/frontend-design/` - Distinctive, production-grade UI with high design quality

## Hooks

- `hooks/git/pre-commit.sample` - Run lint/format if package.json exists
- `hooks/git/pre-push.sample` - Run typecheck/test if package.json exists

## Scripts

- `scripts/install_codex_prompts.sh` - Copy commands to `~/.codex/prompts/`
- `scripts/install_claude_commands.sh` - Copy commands to `.claude/commands/`
- `scripts/install_git_hooks.sh` - Install hook templates to `.git/hooks/`
- `scripts/committer` - Scoped git commit helper (stages only listed paths)
- `scripts/verify.sh` - Verify repo structure and print smoke test steps

## Artifact Paths (for target repos)

- Plans: `docs/plans/<type>-<slug>.md` (wf-plan)
- Todos: `docs/todos/{id}-{status}-{priority}-{desc}.md` (wf-review)
- Solutions: `docs/solutions/<category>/<slug>.md` (wf-compound)

## Quick Verification

- `./scripts/verify.sh`
