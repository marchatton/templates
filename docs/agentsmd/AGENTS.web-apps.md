# Web app (apps/web)
Next.js App Router web application.

## What we use
- Next.js App Router + TypeScript
- React (current) + Server Components
- Tailwind CSS v4 + shadcn/ui + Radix (icons: `lucide-react`)
- Forms: React Hook Form + Zod
- Tests: Vitest + Testing Library (MSW for mocks)
- AI: Vercel AI SDK + AI Gateway + Workflow DevKit (`workflow`)

## Hard “don’t” list (outdated patterns)
- No backwards compatibility layers or “support old + new” implementations.
- No Pages Router patterns:
  - `pages/`, `pages/api`, `getServerSideProps`, `getStaticProps`, `next/router`, `next/head`
- No `middleware.ts` (use `proxy.ts` for request-level routing/auth gates).
- No Express-style API handlers (`req,res`, `NextApiRequest/NextApiResponse`). Use `app/api/**/route.ts` + Web `Request`/`Response`.
- No Tailwind v3 setup:
  - use `@import "tailwindcss";`
  - PostCSS plugin is `@tailwindcss/postcss`
- No old animation libs for this setup:
  - prefer `tw-animate-css` (not `tailwindcss-animate`)
- No old AI SDK streaming helpers (`OpenAIStream`, `StreamingTextResponse`). Use current `ai` patterns + `@ai-sdk/react`.

## How we build (defaults)
- Server-first: fetch on the server (RSC / route handlers / server actions).
- `useEffect` is an escape hatch (imperative interop only).
- Keep server/client boundaries clean (`server-only` / `client-only`).
- Validate external input with Zod and return safe errors.

## Workflow DevKit note
- For AI SDK flows: use Workflow DevKit (`workflow`) and add `"use workflow"` in async TS fns.
- Conventions for `"use workflow"` / steps live in `docs/03-architecture/06_frameworks_agents_rag_evals.md`.

## Frontend skills
- `generating-tailwind-brand-config` for brand tokens/config
- `baseline-ui`, `interface-design`, `frontend-design` and `web-design-guidelines` for UI
- `interaction-design`, `12-principles-of-animation` and `fixing-motion-performance` for motion
- `fixing-accessibility` and `wcag-audit-patterns` for a11y/UX
- `tailwind-css-patterns`, `composition-patterns` and `react-best-practices` for styling/structure/perf/critique. Additionally, you can also use `rams`
