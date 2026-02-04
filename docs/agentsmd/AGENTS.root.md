# AGENTS.md

## Tooling
- Package manager: pnpm (workspaces).
- Prefer TypeScript for new code unless the repo already uses something else.

## Principles
We mostly follow the core principles of the pragmatic programmer (book by Andy Hunt and Dave Thomas
):
* **Take ownership.** If something’s broken, unclear, risky, or “not your job”, act anyway. Flag it, fix it, or help shape a better path.
* **Always be learning.** Keep a “knowledge portfolio”: read, experiment, learn a language/tool each year, and invest in fundamentals (data structures, debugging, design, communication). We store learnings in  `LEARNINGS.md`
* **Avoid duplication (DRY).** Duplication isn’t just copy-paste code, it’s duplicated *knowledge* across files, services, docs, tests, and people’s heads. Put knowledge in one place and reuse it.
* **Build with orthogonality.** Design components so changes don’t ripple everywhere. Reduce coupling, make dependencies explicit, keep interfaces small and sharp.
* **Think in feedback loops.** Prefer small steps, short cycles, and frequent validation. Use “tracer bullets” (thin end-to-end slices) to prove direction before you optimise or polish. Keep changes small and focused (one concern per commit/PR). Prefer the simplest thing that meets the requirement (avoid enterprise edge-case soup).
* **Prototype to learn, then throw away (when needed).** Prototypes are for answering questions fast. Don’t let them quietly become production by accident.
* **Make behaviour explicit.** Use clear contracts (preconditions, postconditions, invariants), assert assumptions, and fail loudly when those assumptions break.
* **Automate the boring and the error-prone.** Builds, tests, formatting, releases, environment setup, checks. If you do it twice, consider scripting it.
* **Keep the code easy to change.** Refactor continuously, rename aggressively, and keep things readable. Write for the next person, who might be you on a bad day.
* **Debug systematically.** Don’t guess. Reproduce, isolate, change one thing at a time, and use tools properly. “It can’t happen” is a warning sign.
* **Don’t tolerate “broken windows”.** Small messes spread. Fix small issues early so the whole system doesn’t slide into chaos.
* **Communicate and negotiate trade-offs.** Requirements and estimates are conversations, not promises. Explain options, risks, and costs in plain language.

And the vibe throughout is: be practical, stay curious, and optimise for long-term leverage, not short-term heroics.

Other principles: 


## Error handling + safety (high level)
- Validate external inputs at boundaries (Zod) and return safe user-facing errors.
- Don’t leak internal errors/details to clients.
- Unexpected issues: fail loudly (log/throw). Only surface user-facing errors when needed.

## Compatibility
- Bcakwards compatibility usually not required.

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
- `.agents/` is canonical in this repo; Codex reads it directly.
- For other agentic tools, use `iannuttall/dotagents` to symlink `.agents` into tool-specific files/folders. Don’t fork instructions per tool.
- `AGENTS.md` is the source of truth. Any other agent-specific files are symlinks — don’t fork instructions per tool.
- Canonical skills/commands/hooks live in `marchatton/agent-skills`. If a skill/command seems missing or wrong, fix it there.
