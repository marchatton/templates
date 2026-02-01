# Projects (dossiers) + delivery

This folder tracks work items once implementation begins.

## Dossier conventions
- Work items live under `docs/04-projects/<lane>/<id>_<slug>/`.
- Each work item includes `prd.md` and `prd.json`.
- Reviews for a work item live inside the dossier (e.g. `reviews/`).
- If using file-based todos, store them in the dossier’s `review-to-dos/` folder.

## Workflow defaults
- Keep PRs small; one concern per PR.
- Bugs / behaviour changes: add a failing test (or repro) first, then fix to green.
- KISS / YAGNI: ship what the requirement needs, no speculative scaffolding.
- DRY only when it’s real reuse: shared logic belongs in `packages/*` (or shared components).

## Data, mutations, errors
- Validate inputs with Zod and return safe user-facing messages.
- Prefer idempotent mutations where retries are possible (idempotency keys if needed).
- Cache with intent: revalidate where safe; invalidate tags/keys on mutation.

## Commands (common, if present)
- Repo: `pnpm -r lint`, `pnpm -r test`, `pnpm -r build`
- Package/app: `pnpm -F <pkg> <script>` (check `package.json` scripts for canonical names)
- Some repos include refactor signals like `scan`, `dead`, `dupes`, `refactor:check` — run when doing refactors.

## Tooling intent
- ESLint/Prettier configs are the source of truth.
- If something is repeatable, prefer skills/commands/hooks using/updating from `marchatton/templates` over adding more prose here.
