# Web app (apps/web)
Next.js App Router web application.

## Stack
- Next.js v16+ App Router + TypeScript
- Tailwind CSS v4 + shadcn/ui + Radix (icons: `lucide-react`)
- Forms: React Hook Form + Zod
- Tests: Vitest + Testing Library (MSW for mocks)

## Version guardrails (avoid outdated examples)
- Next.js v16+ uses `proxy.ts` (NOT `middleware.ts`) for request-level routing/auth gates.
- App Router only: don’t suggest Pages Router APIs (`getServerSideProps`, `getStaticProps`, `next/router`, `pages/api`, `next/head`).
- Tailwind CSS v4 (NOT v3): prefer `@import "tailwindcss";`, PostCSS plugin `@tailwindcss/postcss`, and CSS-first configuration via `@theme`.
- shadcn/ui + Tailwind v4: prefer `tw-animate-css` (NOT `tailwindcss-animate`) and `@import "tw-animate-css";` for animations.
- Fresh codebase: don’t add compatibility shims for older major versions unless explicitly requested.

## Guardrails (high leverage)
- Server-first: fetch on the server (RSC / route handlers / server actions). Avoid client-side data fetching effects.
- Treat `useEffect` as an escape hatch (imperative interop only) — not for data fetching, derived state, prop→state, or URL sync.
- Never import server-only into client components (use `server-only` / `client-only` boundaries).
- Validate external inputs with Zod and map errors to safe user-facing messages.
- AI SDK flows: use Workflow DevKit (`workflow`) and add `"use workflow"` in async TS fns for durability, reliability, observability.
  - Conventions for `"use workflow"` / steps are defined in `docs/03-architecture/06_frameworks_agents_rag_evals.md`.

## Frontend skills
- `generating-tailwind-brand-config` for brand tokens/config
- `baseline-ui`, `interface-design`, `frontend-design` and `web-design-guidelines` for UI
- `interaction-design`, `12-principles-of-animation` and `fixing-motion-performance` for motion
- `fixing-accessibility` and `wcag-audit-patterns` for a11y/UX
- `tailwind-css-patterns`, `composition-patterns` and `react-best-practices` for styling/structure/perf/critique. Additionally, you can also use `rams`
