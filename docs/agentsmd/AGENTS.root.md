# AGENTS.md

## Tooling
- Package manager: pnpm (workspaces).

## Principles
- Keep changes small and focused (one concern per commit/PR).
- Prefer the simplest thing that meets the requirement (avoid enterprise edge-case soup).
- Prefer TypeScript for new code unless the repo already uses something else.

## Error handling + safety (high level)
- Validate external inputs at boundaries (Zod) and return safe user-facing errors.
- Don’t leak internal errors/details to clients.
- Unexpected issues: fail loudly (log/throw). Only surface user-facing errors when needed.

## Compatibility
- Local/unreleased workspace changes: optimise for speed; compatibility usually not required.
- Anything already released: ask before making breaking changes.

## Verification (required)
- Use the `verify` skill. Report commands + results. If blocked, return NO-GO + smallest unblock.
- Don’t guess scripts. Check relevant `package.json` (repo root + target package).
- Monorepo/shared scope: `pnpm -r lint`, `pnpm -r test`, `pnpm -r build`.
- Single package/app: `pnpm -F <pkg> lint`, `pnpm -F <pkg> test`, `pnpm -F <pkg> build`.
- UI/user-flow changes: browser smoke + basic a11y spot-check (keyboard, focus, labels).

## Core skills to use frequently
- `ask-questions-if-underspecified` when unclear.
- `oracle` for deep research.


## Canonical and local agents files and instructions (skills, commands, hooks etc)
- For other agentic tools (not Codex), respective skills and files etc will be symlinked using `iannuttal/dotagents`. Don’t fork instructions per agentic tool (e.g. Claude, Amp).
- `AGENTS.md` is the source of truth. Any other agent-specific files are symlinks — don’t fork instructions per tool.
- Canonical skills/commands/hooks live in `marchatton/templates` (synced into this repo via symlinks). If a skill/command seems missing or wrong, fix it there.
