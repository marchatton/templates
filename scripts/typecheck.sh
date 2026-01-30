#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "AGENTS.md"
  ".agents/AGENTS.md"
  "docs/templates/prd.md"
  "docs/templates/breadboard.md"
  "docs/templates/spike-plan.md"
  "docs/templates/pack.md"
  "docs/templates/release-checklist.md"
  "docs/templates/json-prd.schema.json"
  "docs/templates/learnings.md"
  "docs/templates/learning-entry.md"
  "docs/guides/oracle.md"
  "docs/guides/ralph.md"
  ".agents/commands/workflows/wf-explore.md"
  ".agents/commands/workflows/wf-shape.md"
  ".agents/commands/workflows/wf-develop.md"
  ".agents/commands/workflows/wf-review.md"
  ".agents/commands/workflows/wf-release.md"
  ".agents/commands/workflows/wf-ralph.md"
  ".agents/commands/utilities/verify.md"
  ".agents/commands/utilities/compound.md"
  ".agents/commands/utilities/oracle.md"
  ".agents/hooks/README.md"
  ".agents/ralph/config.sh"
  ".agents/vendors.json"
  "scripts/vendor_update.sh"
  "scripts/vendor_sync.sh"
  "scripts/agents_refresh.sh"
  "scripts/generate_cheatsheet.ts"
  "scripts/verify_repo.sh"
  "scripts/oracle.sh"
  ".agents/skills/review/agent-native-architecture/SKILL.md"
  ".agents/skills/compound/compound-docs/SKILL.md"
  ".agents/skills/utilities/oracle/SKILL.md"
  ".agents/skills/utilities/create-cli/SKILL.md"
  ".agents/skills/utilities/docs-list/SKILL.md"
  ".agents/skills/utilities/ask-questions-if-underspecified/SKILL.md"
  ".agents/skills/develop/bug-reproduction-validator/SKILL.md"
  ".agents/skills/develop/pr-comment-resolver/SKILL.md"
  ".agents/skills/review/agent-native-reviewer/SKILL.md"
  ".agents/skills/review/architecture-strategist/SKILL.md"
  ".agents/skills/review/code-simplicity-reviewer/SKILL.md"
  ".agents/skills/review/data-integrity-guardian/SKILL.md"
  ".agents/skills/review/data-migration-expert/SKILL.md"
  ".agents/skills/review/deployment-verification-agent/SKILL.md"
  ".agents/skills/review/kieran-python-reviewer/SKILL.md"
  ".agents/skills/review/kieran-typescript-reviewer/SKILL.md"
  ".agents/skills/review/pattern-recognition-specialist/SKILL.md"
  ".agents/skills/review/performance-oracle/SKILL.md"
  ".agents/skills/review/security-sentinel/SKILL.md"
  ".agents/skills/shape/spec-flow-analyzer/SKILL.md"
  ".agents/skills/utilities/best-practices-researcher/SKILL.md"
  ".agents/skills/utilities/framework-docs-researcher/SKILL.md"
  ".agents/skills/utilities/git-history-analyzer/SKILL.md"
  ".agents/skills/utilities/repo-research-analyst/SKILL.md"
  "hooks/git/pre-commit"
  "hooks/git/pre-push"
  "hooks/git/prepare-commit-msg"
  "hooks/git/commit-msg"
  "hooks/git/post-merge"
  "scripts/install_git_hooks.sh"
  "scripts/install_codex_skills_copy.sh"
  "cheatsheet.md"
)

missing=()
for file in "${required_files[@]}"; do
  if [ ! -f "${root_dir}/${file}" ]; then
    missing+=("${file}")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  printf "Typecheck failed. Missing required files:\n"
  printf "- %s\n" "${missing[@]}"
  exit 1
fi

echo "Typecheck OK."
