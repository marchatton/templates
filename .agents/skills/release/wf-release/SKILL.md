---
name: wf-release
description: This skill should only be used when the user uses the word workflow and asks to release or ship changes with a release checklist.
---

# wf-release

## Purpose

Ship changes with a release checklist, changelog, and post-release verification.

## Inputs

- Approved PRD and acceptance criteria.
- Release scope and rollout constraints.
- Monitoring and rollback requirements.

## Outputs

- Docs artefacts saved per `docs/AGENTS.md` in the target repo (release notes, changelog entry, post-release notes as needed).
- Optional: appended entry in `docs/learnings.md` via `compound`

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering) and gather release context.
2. Capture rollout, rollback, and monitors.
3. Draft the changelog entry.
4. Run the verify skill in the target repo.
5. If non-trivial, run `compound` to append learnings.
6. Write GO/NO-GO decision with verification evidence.

## Verification

- Verify skill

## Go/No-Go

- GO if verify is green, rollback plan exists, and monitors listed.
- NO-GO otherwise.
