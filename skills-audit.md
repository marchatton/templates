# Skills Audit

Date: February 01, 2026

## Scope
- All skills under .agents/ are local copies (no symlinks).
- Upstream mappings tracked via .agents/register.json (agent-scripts + compound-engineering-plugin).

## Summary
- Local skills with upstream mapping: 32 skills.
- Local-only (no upstream mapping): 11 skills.

## Tracked Skills (local copies with upstream mapping)
- agent-browser -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/agent-browser
- agent-native-architecture -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/agent-native-architecture
- agent-native-reviewer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/agent-native-reviewer.md
- architecture-strategist -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/architecture-strategist.md
- best-practices-researcher -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/best-practices-researcher.md
- bug-reproduction-validator -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/bug-reproduction-validator.md
- code-simplicity-reviewer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/code-simplicity-reviewer.md
- compound-docs -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/compound-docs
- create-agent-skills -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/create-agent-skills
- create-cli -> inspiration/agent-scripts/skills/create-cli
- data-integrity-guardian -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/data-integrity-guardian.md
- data-migration-expert -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/data-migration-expert.md
- deployment-verification-agent -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/deployment-verification-agent.md
- every-style-editor -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/every-style-editor
- framework-docs-researcher -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/framework-docs-researcher.md
- frontend-design -> inspiration/agent-scripts/skills/frontend-design
- gemini-imagegen -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/gemini-imagegen
- git-history-analyzer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/git-history-analyzer.md
- kieran-python-reviewer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/kieran-python-reviewer.md
- kieran-typescript-reviewer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/kieran-typescript-reviewer.md
- markdown-converter -> inspiration/agent-scripts/skills/markdown-converter
- nano-banana-pro -> inspiration/agent-scripts/skills/nano-banana-pro
- openai-image-gen -> inspiration/agent-scripts/skills/openai-image-gen
- oracle -> inspiration/agent-scripts/skills/oracle
- pattern-recognition-specialist -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/pattern-recognition-specialist.md
- performance-oracle -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/performance-oracle.md
- pr-comment-resolver -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/pr-comment-resolver.md
- repo-research-analyst -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/research/repo-research-analyst.md
- security-sentinel -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/review/security-sentinel.md
- skill-creator -> inspiration/compound-engineering-plugin/plugins/compound-engineering/skills/skill-creator
- spec-flow-analyzer -> inspiration/compound-engineering-plugin/plugins/compound-engineering/agents/workflow/spec-flow-analyzer.md
- video-transcript-downloader -> inspiration/agent-scripts/skills/video-transcript-downloader

## Local-Only Skills (no upstream mapping)
- agentation
- ask-questions-if-underspecified
- beautiful-mermaid
- create-json-prd
- create-prd
- docs-list
- file-todos
- modular-skills-architect
- use-ai-sdk
- verify

## Notes
- Local copies allow in-repo edits; use scripts/skills_diff.sh to review upstream changes.
- Use scripts/skills_copy.sh <skill> --force to pull in upstream changes selectively.
- file-todos remains intentionally customized (TODOS_DIR + location tweaks).
