# Web app (apps/web)
Next.js App Router web application.

## Stack
- Next.js App Router + TypeScript
- Tailwind + shadcn/ui + Radix (icons: `lucide-react`)
- Forms: React Hook Form + Zod
- Tests: Vitest + Testing Library (MSW for mocks)

## Guardrails (high leverage)
- Server-first: fetch on the server (RSC / route handlers / server actions). Avoid client-side data fetching effects.
- Treat `useEffect` as an escape hatch (imperative interop only) — not for data fetching, derived state, prop→state, or URL sync.
- Never import server-only into client components (use `server-only` / `client-only` boundaries).
- Validate external inputs with Zod and map errors to safe user-facing messages.
- AI SDK flows: use Workflow DevKit (`workflow`) and add `"use workflow"` in async TS fns for durability, reliability, observability.

## Frontend skills
- `frontend-design`: build distinctive UI.
- `web-design-guidelines`: audit UI against web interface guidelines.
- `baseline-ui`: enforce UI baseline; prevent design slop.
- `fixing-accessibility`: a11y fixes and audits.
- `fixing-metadata`: SEO/social metadata fixes.
- `fixing-motion-performance`: animation perf fixes.
- `react-best-practices`: React/Next.js performance best practices.
- `composition-patterns`: React composition patterns for scalable component APIs.
- `test-browser`: browser smoke for changed UI paths.
- `rams`: backup UI critique via the `rams` skill (prefer ui-skills first).
