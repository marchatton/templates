#!/usr/bin/env bash
# Verify templates repo structure and compliance
# Run from repo root: ./scripts/verify.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

errors=0
warnings=0

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; ((errors++)) || true; }
warn() { echo "  ⚠ $1"; ((warnings++)) || true; }

extract_section() {
  local heading="$1"
  awk -v heading="$heading" '
    $0 == heading { in_section=1; next }
    /^## / { in_section=0 }
    in_section { print }
  ' cheatsheet.md
}

extract_bullets() {
  sed -n 's/^- *`\([^`]*\)`.*/\1/p'
}

echo "=== Templates Repo Verification ==="
echo ""

# 1. Required directory structure
echo "## Directory Structure"
for dir in skills/explore skills/shape skills/work skills/review skills/release skills/compound skills/utilities commands hooks/git scripts; do
  if [ -d "$dir" ]; then
    pass "$dir/"
  else
    fail "$dir/ missing"
  fi
done
echo ""

# 2. Each skill folder has SKILL.md
echo "## Skills"
skill_count=0
for skill_dir in skills/*/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    # Extract only the first YAML frontmatter block (between first and second ---)
    frontmatter=$(awk 'NR==1 && /^---$/{start=1; next} start && /^---$/{exit} start{print}' "$skill_dir/SKILL.md" || true)
    has_name=$(echo "$frontmatter" | grep -c '^name:' || true)
    has_desc=$(echo "$frontmatter" | grep -c '^description:' || true)
    # Check for extra fields (not name, description, or empty/whitespace lines)
    extra_fields=$(echo "$frontmatter" | grep -v '^name:' | grep -v '^description:' | grep -v '^[[:space:]]*$' | head -1 || true)
    
    if [ "$has_name" -ge 1 ] && [ "$has_desc" -ge 1 ]; then
      if [ -n "$extra_fields" ]; then
        warn "$skill_name: extra frontmatter field detected: $extra_fields"
      else
        pass "$skill_name"
      fi
    else
      fail "$skill_name: missing name or description in frontmatter"
    fi
    ((skill_count++)) || true
  else
    fail "$skill_name: missing SKILL.md"
  fi
done
echo "  Total skills: $skill_count"
echo ""

# 3. Baseline command set
echo "## Commands"
baseline_commands="wf-explore wf-shape wf-plan wf-work wf-review wf-release wf-compound c-handoff c-pickup c-landpr"
for cmd in $baseline_commands; do
  if [ -f "commands/${cmd}.md" ]; then
    pass "$cmd.md"
  else
    fail "$cmd.md missing"
  fi
done
cmd_count=$(ls -1 commands/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  Total commands: $cmd_count"
echo ""

# 3b. Command content checks (Codex-friendly)
echo "## Command Content Checks"
claude_only_patterns=(
  "Task\\("
  "AskUserQuestion"
  "figma-design-sync"
  "\\bimgup\\b"
  "\\bsubagent\\b"
  "\\bworktree\\b"
)
for pattern in "${claude_only_patterns[@]}"; do
  if rg -n --pcre2 "$pattern" commands >/dev/null; then
    fail "Claude-only construct found in commands: $pattern"
  else
    pass "No Claude-only construct: $pattern"
  fi
done

if rg -n "Placeholder stub|TODO: Implement" commands >/dev/null; then
  fail "Command stubs detected (placeholder/TODO)"
else
  pass "No command stubs detected"
fi
echo ""

# 4. Cheatsheet exists and has required sections
echo "## Cheatsheet"
if [ -f "cheatsheet.md" ]; then
  pass "cheatsheet.md exists"
  for section in "## Commands" "## Skills" "## Hooks"; do
    if grep -q "$section" cheatsheet.md; then
      pass "Has $section section"
    else
      fail "Missing $section section"
    fi
  done

  cmd_expected=$(ls -1 commands/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort)
  cmd_actual=$(extract_section "## Commands" | extract_bullets | sort -u)
  if [ -z "$cmd_actual" ]; then
    fail "Commands section missing bullet list"
  else
    cmd_missing=$(comm -23 <(printf '%s\n' "$cmd_expected") <(printf '%s\n' "$cmd_actual") || true)
    cmd_extra=$(comm -13 <(printf '%s\n' "$cmd_expected") <(printf '%s\n' "$cmd_actual") || true)
    if [ -n "$cmd_missing" ]; then
      fail "Commands missing from cheatsheet: $(echo "$cmd_missing" | tr '\n' ' ')"
    fi
    if [ -n "$cmd_extra" ]; then
      warn "Commands extra in cheatsheet: $(echo "$cmd_extra" | tr '\n' ' ')"
    fi
  fi

  skill_expected=$(find skills -mindepth 2 -maxdepth 2 -type d | sort | sed 's:/*$::')
  skill_actual=$(extract_section "## Skills" | extract_bullets | sed 's:/*$::' | sort -u)
  if [ -z "$skill_actual" ]; then
    fail "Skills section missing bullet list"
  else
    skill_missing=$(comm -23 <(printf '%s\n' "$skill_expected") <(printf '%s\n' "$skill_actual") || true)
    skill_extra=$(comm -13 <(printf '%s\n' "$skill_expected") <(printf '%s\n' "$skill_actual") || true)
    if [ -n "$skill_missing" ]; then
      fail "Skills missing from cheatsheet: $(echo "$skill_missing" | tr '\n' ' ')"
    fi
    if [ -n "$skill_extra" ]; then
      warn "Skills extra in cheatsheet: $(echo "$skill_extra" | tr '\n' ' ')"
    fi
  fi

  hook_expected=$(ls -1 hooks/git/*.sample 2>/dev/null | sed 's:/*$::' | sort)
  hook_actual=$(extract_section "## Hooks" | extract_bullets | sed 's:/*$::' | sort -u)
  if [ -z "$hook_actual" ]; then
    fail "Hooks section missing bullet list"
  else
    hook_missing=$(comm -23 <(printf '%s\n' "$hook_expected") <(printf '%s\n' "$hook_actual") || true)
    hook_extra=$(comm -13 <(printf '%s\n' "$hook_expected") <(printf '%s\n' "$hook_actual") || true)
    if [ -n "$hook_missing" ]; then
      fail "Hooks missing from cheatsheet: $(echo "$hook_missing" | tr '\n' ' ')"
    fi
    if [ -n "$hook_extra" ]; then
      warn "Hooks extra in cheatsheet: $(echo "$hook_extra" | tr '\n' ' ')"
    fi
  fi
else
  fail "cheatsheet.md missing"
fi
echo ""

# 5. Path and pnpm checks
echo "## Path and Package Checks"
if rg -n --pcre2 "(?<!docs/)plans/" commands skills >/dev/null; then
  fail "Found non-docs plan paths in commands/skills"
else
  pass "Plans paths use docs/plans/"
fi

if rg -n --pcre2 "(?<!docs/)(?<!file-)todos/" commands skills >/dev/null; then
  fail "Found non-docs todo paths in commands/skills"
else
  pass "Todos paths use docs/todos/"
fi

if rg -n "skills/file-todos" commands skills >/dev/null; then
  fail "Found deprecated skills/file-todos path"
else
  pass "No deprecated skills/file-todos path"
fi

if rg -n "\\bnpm\\b" commands skills >/dev/null; then
  fail "Found npm usage in commands/skills (pnpm-only)"
else
  pass "No npm usage in commands/skills"
fi
echo ""

# 6. Skill packaging checks
echo "## Skill Packaging Checks"
long_skills=$(find skills -name SKILL.md -maxdepth 4 -print0 | xargs -0 wc -l | awk '$2 != "total" && $1 > 500 {print $2 ":" $1}')
if [ -n "$long_skills" ]; then
  fail "SKILL.md over 500 lines: $(echo "$long_skills" | tr '\n' ' ')"
else
  pass "All SKILL.md files under 500 lines"
fi

name_mismatches=0
for skill_dir in skills/*/*/; do
  [ -d "$skill_dir" ] || continue
  folder_name=$(basename "$skill_dir")
  skill_name=$(awk 'NR==1 && /^---$/{start=1; next} start && /^name:/{print $2; exit} start && /^---$/{exit}' "$skill_dir/SKILL.md" || true)
  if [ -n "$skill_name" ] && [ "$skill_name" != "$folder_name" ]; then
    fail "Skill name mismatch: $folder_name vs $skill_name"
    name_mismatches=$((name_mismatches+1))
  fi
done
if [ "$name_mismatches" -eq 0 ]; then
  pass "All skill names match folder names"
fi
echo ""

# 5. Install scripts
echo "## Install Scripts"
for script in install_codex_prompts.sh install_claude_commands.sh install_git_hooks.sh; do
  if [ -f "scripts/$script" ] && [ -x "scripts/$script" ]; then
    pass "$script (executable)"
  elif [ -f "scripts/$script" ]; then
    warn "$script exists but not executable"
  else
    fail "$script missing"
  fi
done
echo ""

# 6. Hooks
echo "## Hooks"
for hook in pre-commit.sample pre-push.sample; do
  if [ -f "hooks/git/$hook" ]; then
    pass "$hook"
  else
    warn "$hook missing (optional)"
  fi
done
echo ""

# Summary
echo "=== Summary ==="
if [ $errors -eq 0 ]; then
  echo "✓ All checks passed ($warnings warnings)"
  echo ""
  echo "=== Manual Smoke Test Steps ==="
  echo ""
  echo "1. Install commands:"
  echo "   ./scripts/install_codex_prompts.sh"
  echo "   ./scripts/install_claude_commands.sh  # in target repo"
  echo "   ./scripts/install_git_hooks.sh        # in target repo"
  echo ""
  echo "2. Test wf-plan in Codex:"
  echo "   /prompts:wf-plan 'Add user authentication'"
  echo "   → Confirm plan file created in docs/plans/"
  echo ""
  echo "3. Test review artefact flow:"
  echo "   → Create plan → run review lane → check docs/todos/"
  echo ""
  exit 0
else
  echo "✗ $errors error(s), $warnings warning(s)"
  exit 1
fi
