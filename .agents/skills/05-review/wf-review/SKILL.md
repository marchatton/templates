---
name: wf-review
description: This skill should only be used when the user uses the word workflow and asks to review changes (select mode = light, light-plus, heavy) with verification and context handoff/pickup to avoid context rot.
---

# wf-review

## Purpose

Review changes at the right depth, then produce a clear GO/NO-GO with evidence.

Default mode: light-plus.

Always run basic verification (verify skill). Treat review as provisional if verification cannot be run.

## Note on plan.md

`plan.md` may not exist (it’s optional).
Review should still be completed against:
- `prd.json` acceptance criteria (preferred), or `prd.md`
- the actual diff
- verification results

## Args (free text)

Parse mode + target from user text.

Mode tokens (first match wins):
- `light`
- `light-plus`
- `heavy`

Accept either:
- `wf-review light PR#123`
- `wf-review mode: heavy target: <url>`
- `wf-review <target>` (mode missing)

Target examples:
- PR number/URL
- branch name
- file path (doc review)
- dossier folder path
- empty = current branch

If mode missing: default light-plus.
If target missing: default current branch (but ask if ambiguous).

## Outputs

All modes:
- Review summary + severity (P1/P2/P3)
- Verification result (verify skill) + GO/NO-GO
- Explicit check against PRD acceptance criteria
- Optional handoff notes (recommended)

Heavy only:
- Todo files for findings (file-todos skill)

## Mode behaviours

### light
Minimum: run verify skill and then native `/review` only (no extra passes).

Use when:
- small diffs
- low risk
- you mostly want a sanity check

### light-plus (default)
Run:
- verify skill
- native `/review`
- repo prompt review: `/rp-review`

Use when:
- most PRs
- you want repo-specific conventions checked too

### heavy
Do light-plus, then:
- deep scenario passes (security, data integrity, ops)
- synthesize + de-dupe
- create todos for all findings (file-todos)
- optional `test-browser` if UI/user flow changed
- final GO/NO-GO

Use when:
- auth/payments/privacy/external APIs/migrations
- big refactors / large surface area
- repeated CI failures / flaky behaviour
- user explicitly asks for “thorough”

## Steps (all modes)

1) Determine mode + target
- mode default light-plus
- target default current branch (unless user says otherwise)

2) (Recommended) Pickup if starting fresh thread / resuming
- Invoke `pickup` if:
  - new chat/thread, or
  - user says “resume / pick up”, or
  - repo/branch uncertain

3) Gather review context
- If dossier provided: load `prd.json` (preferred) + `plan.md` if present.
- If PR number/URL: capture title/body/files/diff via `gh pr view --json` if available.
- If branch: confirm current branch matches target (ask before switching).
- If file path: open the file and treat as doc review.

4) Run review analysis for chosen mode
- light: `/review`
- light-plus: `/review` then `/rp-review`
- heavy: do light-plus, then run the heavy checklist

5) Run basic verification (all modes)
- Invoke `verify` skill in target repo.
- If verify cannot be run: mark as “unverified” and block GO unless docs-only.

6) Summarise + decide
- De-dupe findings.
- Label severity:
  - P1 blocks merge/release
  - P2 should fix
  - P3 nice-to-have
- Explicitly check: do changes satisfy `prd.json` acceptance criteria?
- Write GO/NO-GO with reasons + evidence.

7) (Recommended) Handoff at workflow boundary
- If switching workflows next (fix work, release, more Ralph): invoke `handoff`.
- If user wants clean context: recommend starting a new thread and running `pickup` there with the handoff note path.

## Heavy checklist (only when mode=heavy)

A) Review passes (single-agent, sequential; no sub-agents)
- `security-sentinel` skill
- `performance-oracle` skill
- `architecture-strategist` skill
- `data-integrity-guardian`skill
- `agent-native-reviewer` skill
- `pattern-recognition-specialist` skill
- `language reviewer` skill if relevant (kieran-*-reviewer)
- `code-simplicity-reviewer` skill
- if migrations/backfills: `data-migration-expert` skill + `deployment-verification-agent` skill

B) Deep-dive scenarios
- invalid inputs, boundaries, concurrency, scale, timeouts, resource exhaustion
- data corruption, security attacks, cascading failures

C) Todo creation (mandatory in heavy)
- Invoke `file-todos` for all findings.
- Store under the active dossier if present:
  - `docs/04-projects/<lane>/<id>_<slug>/todos/`
- Otherwise fall back:
  - `todos/`

D) Verify loop
- Run verify skill.
- If verify fails: ask “Fix failures now? (y/n)”
  - If yes: loop up to N iterations (default 10): fix top failure, rerun verify
  - If no: proceed to summary with failures called out

E) Optional browser QA
- If UI/user-flow changed: run `test-browser` and record evidence.

F) Mandatory handoff
- End heavy review with `handoff`.
- Recommend a new thread for fix work: `/new` then `pickup` + read the handoff note.

## Verification

- Verify skill run (or explicitly marked unverified)
- Heavy: todo files created for all findings

## Go/No-Go

- GO if verify is green and no P1 gaps remain (and PRD acceptance criteria are satisfied).
- NO-GO if verify fails, or correctness/security/rollout risks remain unresolved.
