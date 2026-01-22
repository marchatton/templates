# AGENTS.md
Make the plan extremely concise. Sacrifice grammar for the sake of concision.

## Stack defaults
* pnpm workspaces (apps/*, packages/*); Next.js App Router + TypeScript; deploy Vercel.
* UI: Tailwind + shadcn/ui + Radix; icons lucide-react.
* Forms: React Hook Form + Zod. State: server-first; Zustand only if needed.
* Tests: Vitest + Testing Library + MSW. Smoke UI: chrome-devtools MCP (not Playwright MCP).

## Structure + boundaries
* apps/web/src: app/(public|protected), api/(auth|v1|webhooks), client/, server/, middleware/.
* NEVER import server/ into client/. Use Next `server-only` / `client-only` to hard fail.
* Validate at all boundaries (client→API→DB) with Zod; map errors to safe messages.
* Env: only NEXT_PUBLIC_* reaches client. Never log secrets.

## Behaviour rules
* No backwards compat. Change interface, update all call sites.
* Prefer KISS/YAGNI. Simplest readable change wins.
* TDD: failing test first for bugs/behaviour, then implement, then green.
* Keep diffs small, atomic, 1 concern.
* Mutations: server actions, include idempotency keys; cache invalidate via tags/revalidate.
* URL is state (filters/tabs/pagination), prefer nuqs https://nuqs.dev/.

## React + component rules
* No client fetch. No data writes in useEffect. Prefer RSC loaders + server actions.
* Avoid useEffect for derived state or URL sync. Only imperative escapes, always cleanup.
* Separate concerns: leaf components render only. Business logic (fetch/state) in parents.
* Enforce in view components via ESLint (example):
```js
'no-restricted-syntax':['error',
 {selector:'CallExpression[callee.name="useState"]',message:'View: no state, controlled props.'},
 {selector:'CallExpression[callee.name="useEffect"]',message:'View: no effects, move up.'},
]
```
* Tailwind: no ad-hoc colours/spacing. Use tokens only. ESLint restricts utilities, eg ban p-4/p-8, allow p-base/p-double.

## Lint, scans, debug output
* Prefer tsgolint for type-aware lint https://github.com/oxc-project/tsgolint). If it errors, fallback to Biome.
* Ban lint silencing: eslint-plugin-eslint-comments no-restricted-disable https://mysticatea.github.io/eslint-plugin-eslint-comments/rules/no-restricted-disable.html) + ESLint --no-inline-config.
* Scans: ast-grep https://ast-grep.github.io/, knip https://knip.dev/, jscpd https://github.com/kucherenko/jscpd.
* Hooks: Husky https://typicode.github.io/husky + lint-staged https://github.com/lint-staged/lint-staged
* Before push: pnpm -r typecheck && pnpm -r test && pnpm -r lint && pnpm -F web scan && pnpm -F web dupes.
* Always log: command, exit code, stdout/stderr (Cursor-style debug).

## Tools
* Oracle: get help. bundle prompt+files for external LLM runs, use when stuck https://github.com/steipete/oracle.
* Markdansi v0.2.0: render Markdown in TUI/streams https://github.com/steipete/Markdansi/releases/tag/v0.2.0.
* Summarize v0.7.1: summarise webpages/URLs https://github.com/steipete/summarize/releases/tag/v0.7.1.

## Skills placeholder
* TODO: link /skills/* that matter here (testing, refactors, perf, security, release).
