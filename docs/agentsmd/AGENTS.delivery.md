# Projects (dossiers) + delivery

This folder tracks work items once implementation begins.

## Dossier conventions
- Work items live under `docs/04-projects/<lane>/<id>_<slug>/`.
- Within each work item:
  - `prd.md` and `prd.json`, which form handoff between shaping, planning and development.
  - Reviews for a work item live inside the dossier (e.g. `reviews/`).
  - Store oracle bundles + handoff notes in git-tracked dossier tmp folders (synced to GitHub):
    - `tmp-oracle/`
    - `tmp-handoffs/`
  - Store local-only scratch in the dossier’s `throwaway/` folder (gitignored; not synced).
  - Store other tmp files in `tmp/` folder (synced to GitHub).
  - If using file-based todos, store them in the dossier’s `todos/` folder.

## Workflow defaults
- Keep PRs small; one concern per PR.
- Bugs / behaviour changes: add a failing test (or repro) first, then fix to green.
- KISS / YAGNI: ship what the requirement needs, no speculative scaffolding.
- DRY only when it’s real reuse: shared logic belongs in `packages/*` (or shared components).
