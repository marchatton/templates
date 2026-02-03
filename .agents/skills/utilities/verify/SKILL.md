---
name: verify
description: Single verification flow; read docs/AGENTS.md; report PASS/NO-GO. Use before handoff or release.
---

# Verify

## Purpose
Light verification. Code changes: follow AGENTS.md (or equivalent).

## When
Any change affecting behavior/build/tests/types/lint/package/UI. Also skills/docs edits. If blocked, return NO-GO + smallest unblock.

## Steps
1. Classify change: docs/skills-only vs code.
2. Docs/skills-only audit:
   - NO-GO if any year mention.
   - Flag brittle links/paths (advisory).
   - Frontmatter valid (name+description).
   - Description includes trigger keywords.
   - References one level deep.
   - Examples concrete.
3. Code changes: read AGENTS.md (or equivalent) verification section.
4. If a verify command is documented (AGENTS or package scripts), run it first.
5. Run smallest-scope scripts in doc (monorepo: narrowest package).
6. If docs missing: run lint/typecheck/test/build if present; else NO-GO.

## Browser smoke (UI only)
If UI/user-flow changed: after normal checks, use `test-browser` to start the app, exercise the path, capture evidence.

## Output
Include a `Verification` section with commands + results.
Use `PASS:` or `NO-GO:`.
If docs/skills-only: list checks + flags; NO-GO on years.
