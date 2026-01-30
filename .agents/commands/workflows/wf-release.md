# wf-release

## Purpose

Ship changes with a release checklist, changelog, and post-release verification.

## Inputs

- Approved PRD and acceptance criteria.
- Release scope and rollout constraints.
- Monitoring and rollback requirements.

## Outputs

- `docs/09-release/release-notes/<slug>_release.md`
- `docs/09-release/release-notes/<slug>_changelog.md`
- Optional: `docs/09-release/release-notes/<slug>_post-release.md`
- Optional: appended entry in `docs/LEARNINGS.md` via `compound`

## Steps

1. Define the work slug (prefer `0001_<short>` for ordering) and gather release context.
2. Run skill `release-checklist` and capture rollout, rollback, monitors.
3. Draft changelog via `changelog-draft`.
4. Run `pnpm verify` in the target repo.
5. If non-trivial, run `compound` to append learnings.
6. Write GO/NO-GO decision with verification evidence.

## Verification

- `pnpm verify`

## Go/No-Go

- GO if verify is green, rollback plan exists, and monitors listed.
- NO-GO otherwise.
