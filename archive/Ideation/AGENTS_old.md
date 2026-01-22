# AGENTS.md (Merged Lite)

**Purpose:** Lean, repo-specific guardrails for Codex. Be precise; skip agent meta. Defaults: **pnpm**, Next.js App Router + TypeScript, Tailwind + shadcn/ui, Vitest, Vercel.

in all Interactions
▌ and comment messages, Be extremely concise and sacrifice grammar for
▌ the sake of concision.

---

## 0) Engineering Principles

- **TDD**: write a failing test for bugs/new behavior, then implement to green.
- **KISS**: prefer simple, boring solutions over clever ones.
- **YAGNI**: ship only what the current requirement needs.
- **DRY**: extract shared logic into `packages/lib` or shared components; favor codemods for dedup.

## 1) Project Profile & Non‑negotiables

- **Monorepo:** pnpm workspaces (`apps/*`, `packages/*`)
- **App:** Next.js (App Router)
- **UI:** Tailwind + shadcn/ui + Radix; icons via `lucide-react`
- **State:** Server‑first; client state sparingly (Zustand when needed)
- **Forms:** React Hook Form + Zod
- **Testing:** Vitest + Testing Library + MSW; **chrome‑devtools MCP** for smoke (not Playwright MCP)
- **Scanning:** **ast‑grep** (scan/refactor signals only), **knip**, **jscpd**
- **Git hooks:** **Husky** + lint‑staged

---

## 2) Structure & Security Boundaries (apps/web)

**Repo top-level**

```
/
  apps/
  packages/
  docs/                 # human-authored docs
    specs/
    tracking/
    inspiration/
    decisions/          # ADRs & rationale
  temp/                 # scratch/testing; allowed to push
  throwaway/            # local testing; gitignored
```

**Web app (apps/web)**

```
apps/web/src/
  app/
    (public)/        # no auth
    (protected)/     # auth required (middleware enforces)
    api/
      auth/          # auth only
      v1/            # versioned endpoints
      webhooks/      # verify signatures
  client/            # FRONTEND ONLY (components, hooks, stores)
  server/            # BACKEND ONLY (db, services, validators)
  middleware/        # rateLimit -> cors -> sanitize -> auth -> logger
```

**CRITICAL RULES**

- **NEVER** import `server/` into `client/`.
- **ALWAYS** validate at boundaries (client→API→DB) via Zod.
- **NEVER** leak internal errors to clients; map to safe messages.
- Client‑visible envs **MUST** use `NEXT_PUBLIC_` prefix.
- Use Next’s `server-only` / `client-only` modules to enforce boundaries (import in files at risk).

---

## 3) Do / Don’t (Repo‑specific)

**Do**

- Use **pnpm** (workspace filters `-F`).
- Keep diffs **small & atomic**; one concern per PR.
- Centralize API in `/lib/api/*` (+ Zod, typed errors). Server actions for mutations with **idempotency keys**.
- Reflect UI state in **URL** (filters/tabs/pagination) — prefer `nuqs`.
- Use design tokens/Tailwind; avoid hard‑coded colors/sizes.
- Add MSW mocks for new network code; bug → failing test → fix → green.

**Don’t**

- Add heavy deps without approval (charting/date/CSS‑in‑JS).
- Fetch in client components or write data in `useEffect`.
- Bypass hooks/CI; commit failing type/lint/tests.

---

## 4) Commands (pnpm)

```bash
# Typecheck
pnpm -F web typecheck                # project
pnpm -F web typecheck:file path/to/file.tsx

# Lint & Format
pnpm -F web lint
pnpm -F web format:write

# Tests
pnpm -F web test -t "NameOrPattern"
pnpm -F web test path/to/file.test.tsx
pnpm -F web test:browser             # chrome‑devtools MCP smoke

# Scans / Refactor checks
pnpm -F web scan                     # ast‑grep
pnpm -F web dead                     # knip
pnpm -F web dupes                    # jscpd
pnpm -F web refactor:check           # scan + dead + dupes

# Dev / Build
pnpm -F web dev
pnpm -F web build                    # explicit only
```

**apps/web `package.json` (scripts – minimal)**

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "typecheck": "tsc -p tsconfig.json --noEmit",
    "typecheck:file": "tsc --project tsconfig.json --noEmit",
    "lint": "eslint .",
    "format:write": "prettier -w .",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:browser": "chrome-devtools-mcp test",
    "scan": "ast-grep scan -r ./scripts/ast-grep.yml",
    "dead": "knip --production",
    "dupes": "jscpd src --min-lines 5 --min-tokens 30",
    "refactor:check": "pnpm scan && pnpm dead && pnpm dupes"
  }
}
```

---

## 5) Git & Hooks (concise)

- **Conventional Commits:** `feat(scope): …`, `fix`, `chore`, `refactor`, `docs`, `test`.
- **Husky**

  - `pre-commit`: `lint-staged` **then** `pnpm -F web scan`
  - `pre-push`: `pnpm -r typecheck && pnpm -r test && pnpm -r lint && pnpm -F web dupes`
  - `commit-msg`: lightweight regex guard (see appendix)

---

## 6) Lint/Format/Scan

- **ESLint** flat config: typescript‑eslint, jsx‑a11y, tailwindcss, import/order
- **Prettier** (+ Tailwind class sorter)
- **ast‑grep** rules (minimal):

```yaml
# scripts/ast-grep.yml
rules:
  - id: no-client-fetch
    message: "Move data access to server action or /lib/api"
    severity: error
    language: tsx
    pattern: fetch($A)
    constraints:
      all:
        - inside:
            kind: Program
            has:
              kind: ExpressionStatement
              has:
                kind: StringLiteral
                text: '"use client"'
  - id: no-console-log
    message: "Use a logger or remove console.log"
    severity: warning
    language: ts,tsx
    pattern: console.log($$$)
```

- **knip** for dead code; **jscpd** for duplication during refactors.

---

## 7) Testing (minimal but effective)

- **Per feature/commit:** Add/update tests covering new/changed paths (prefer component tests for UI; MSW for network).
- **Unit/Component:** Vitest + Testing Library; **MSW** for HTTP.
- **Smoke (programmatic UI):** **chrome‑devtools MCP** (navigate/fill/assert); keep < 90s.
- **tmux loop (watch):**

```bash
tmux new-session -d -s test 'pnpm -F web test:browser --watch'
tmux attach -t test
```

> One‑liner variant: `tmux new -s test 'pnpm -F web test:browser --watch'`

- **Rule:** Bug → failing test → fix → green.

---

## 8) Data, Errors, Caching

- **Server actions** for mutations; include **idempotency keys**; optimistic UI with rollback.
- **Errors:** Zod‑validated shapes mapped to user messages; on submit focus first invalid field.
- **Caching:** `revalidate` where safe; tag invalidation on mutation.

---

## 8a) Modern React (minimize `useEffect`)

**Default:** Avoid `useEffect` for data fetching, derived state, prop→state sync, or URL sync.
Prefer:

- **Server Components** + async loaders; pass data via props.
- **Server Actions** for mutations; pending UI via `useFormStatus` / `useActionState` (if available).
- **URL state** with `nuqs` (not effects).
- **Suspense** for async UI boundaries; stream where appropriate.
- **Memoization** only when profiling shows need (React DevTools/React Scan). Don’t pre‑optimize with `useMemo/useCallback`.

**Legit `useEffect` cases:** imperative escapes only — event listeners, focus management, observers (Resize/Intersection), 3rd‑party widgets, analytics pings. Always cleanup.

**If React Compiler is enabled:** Keep components pure; remove unnecessary memoization; avoid stale closures; trust the compiler for rerender optimization.

---

## 8b) Bleeding‑edge toggles (opt‑in)

- **React Compiler**: enable when available; keep components pure; remove unnecessary memo; let compiler optimize.
- **`server-only` / `client-only`**: import to assert boundary misuse early.
- **Suspense/Streaming**: prefer async RSC + `<Suspense>` boundaries for slow sections.
- **Tag‑based revalidation**: use fetch/cache tags + invalidate on mutations where helpful.

---

## 9) A11y & UI (core rules)

**MUST** keyboard support + visible `:focus-visible`; manage focus per APG.
**MUST** targets ≥24px (≥44px mobile); never disable zoom; ensure 16px mobile inputs or viewport meta.
**MUST** links are `<a>/<Link>`; URL reflects state; Back/Forward restores scroll.
**MUST** inline errors; `aria-live="polite"`; confirm destructive actions or provide Undo.
**MUST** honor `prefers-reduced-motion`; animate only `transform`/`opacity`.
**NEVER** block paste or rely on color‑only signals.

---

## 10) Performance (budgets)

- Mutations **P95 < 500 ms**; profile with CPU/network throttling.
- Prevent CLS: explicit image sizes/reserved space; preload only above‑fold.
- Virtualize large lists (e.g., `virtua`); track & minimize re‑renders.

---

## 11) Security Essentials

- Secrets via env (Vercel). **Never** commit/log secrets; `NEXT_PUBLIC_` only for client.
- Sanitize any HTML (DOMPurify); prefer React escaping; set CSP where possible.
- Middleware order: **rateLimit → cors → sanitize → auth → logger**.
- SSR/edge guards; secure cookies; CSRF for cross‑origin posts.
- **NEVER** expose internal error details to clients.

**Minimal middleware skeleton**

```ts
// apps/web/src/middleware.ts
import { NextResponse, type NextRequest } from 'next/server'
export async function middleware(req: NextRequest) {
  const p = req.nextUrl.pathname
  // Public routes bypass most checks
  if (p.startsWith('/(public)')) return NextResponse.next()

  // API security
  if (p.startsWith('/api')) {
    if (await isRateLimited(req)) return new NextResponse('Too Many Requests', { status: 429 })
    sanitize(req)
    if (p.startsWith('/api/webhooks') && !(await verifySignature(req)))
      return new NextResponse('Invalid signature', { status: 401 })
  }

  // Protected routes
  if (p.startsWith('/(protected)') || p.startsWith('/api')) {
    const session = await getSession(req)
    if (!session) return NextResponse.redirect(new URL('/login', req.url))
  }
  return NextResponse.next()
}
```

## 12) CI/CD (minimal)

```yaml
name: ci
on: [push, pull_request]
jobs:
  web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: 'pnpm' }
      - run: pnpm install --frozen-lockfile
      - run: pnpm -r typecheck && pnpm -r lint && pnpm -r test
      - run: pnpm -F web scan && pnpm -F web dupes
```

- PR → Vercel preview; all checks green → merge to `main` → production.

**Auto-fix PR Issues (opt-in, concise)**

```yaml
name: autofix
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  run:
    if: contains(github.event.comment.body, '/autofix') || contains(github.event.comment.body, 'eslint')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.ref }}
      - uses: pnpm/action-setup@v4
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: 'pnpm' }
      - run: pnpm install --frozen-lockfile
      - run: pnpm -F web lint && pnpm prettier -w . || true
      - run: |
          git config user.name 'github-actions[bot]'
          git config user.email 'github-actions[bot]@users.noreply.github.com'
          git add -A
          git diff --staged --quiet || git commit -m "chore(ci): auto-fix lint/style"
          git push
```

---

## 13) Checklists

### PR

- [ ] Conventional Commit title
- [ ] **Tests written/updated for each feature/commit**
- [ ] Typecheck / Lint / Unit tests **green**
- [ ] Smoke (chrome‑devtools MCP) **passes** if UI affected
- [ ] A11y spot‑check (keyboard, focus rings, labels)
- [ ] Screenshots/video for UI changes
- [ ] `/docs` updated (specs/tracking) if behavior or API changed

### Security Review (every PR)

- [ ] No secrets in code/logs (`NEXT_PUBLIC_` only on client)
- [ ] Input validation at all boundaries (Zod)
- [ ] No internal error details leaked to clients
- [ ] Rate limiting on public endpoints
- [ ] Webhook signatures verified (where applicable)

### Human Review Required

- AuthN/AuthZ changes
- DB migrations
- Payments & billing
- Security middleware modifications
- External service integrations
- Anything touching PII

## Appendix — Drop‑in Config (concise)

### `.gitignore` (root)

```
throwaway/
```

### `pnpm-workspace.yaml`

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### Root `package.json` additions

```json
{
  "packageManager": "pnpm@9",
  "scripts": { "prepare": "husky" },
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{md,mdx,json,css}": ["prettier --write"]
  }
}
```

### Husky hooks

**`.husky/pre-commit`**

```sh
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"
pnpm exec lint-staged && pnpm -F web scan
```

**`.husky/pre-push`**

```sh
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"

pnpm -r typecheck && pnpm -r test && pnpm -r lint && pnpm -F web dupes
```

**`.husky/commit-msg`** (light Conventional‑Commit guard)

```sh
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"
msg=$(cat "$1")
case "$msg" in
  feat\(*\):*|fix\(*\):*|chore\(*\):*|refactor\(*\):*|docs\(*\):*|test\(*\):*|feat:*|fix:*|chore:*|refactor:*|docs:*|test:*) exit 0;;
  *) echo "Use Conventional Commits, e.g. feat(scope): summary" >&2; exit 1;;
 esac
```

### `scripts/ast-grep.yml`

```yaml
rules:
  - id: no-client-fetch
    message: Move data access to server action or /lib/api
    severity: error
    language: tsx
    pattern: fetch($A)
    constraints:
      all:
        - inside:
            kind: Program
            has:
              kind: ExpressionStatement
              has:
                kind: StringLiteral
                text: '"use client"'
  - id: no-console-log
    message: Use a logger or remove console.log
    severity: warning
    language: ts,tsx
    pattern: console.log($$$)
```

### `tsconfig.base.json` (root) & `apps/web/tsconfig.json`

```json
{ "compilerOptions": { "target": "ES2022", "lib": ["ES2022","DOM","DOM.Iterable"], "module": "ESNext", "moduleResolution": "Bundler", "strict": true, "skipLibCheck": true, "noEmit": true, "jsx": "preserve", "resolveJsonModule": true, "forceConsistentCasingInFileNames": true, "types": ["vitest/globals"] } }
```

```json
{ "extends": "../../tsconfig.base.json", "compilerOptions": { "plugins": [{ "name": "next" }] }, "include": ["next-env.d.ts","**/*.ts","**/*.tsx",".next/types/**/*.ts"], "exclude": ["node_modules"] }
```

### `eslint.config.mjs` (flat, minimal)

```js
import js from '@eslint/js'
import tseslint from 'typescript-eslint'
import react from 'eslint-plugin-react'
import jsxA11y from 'eslint-plugin-jsx-a11y'
import tailwind from 'eslint-plugin-tailwindcss'
export default [
  { ignores: ['.next/**','dist/**','coverage/**'] },
  js.configs.recommended,
  ...tseslint.configs.recommendedTypeChecked,
  { files: ['**/*.{ts,tsx}'], plugins: { react, 'jsx-a11y': jsxA11y, tailwindcss: tailwind },
    languageOptions: { parserOptions: { project: true, ecmaVersion: 'latest', sourceType: 'module' } },
    settings: { react: { version: 'detect' } },
    rules: { 'react/jsx-key': 'error', 'jsx-a11y/no-autofocus': 'warn', 'tailwindcss/classnames-order': 'warn' } }
]
```

**End.** Keep this file lean; add rules only when a pattern recurs.

### Appendix B — DevDependencies (paste into `package.json`)

> Minimal block for the requested tools only. Update with `pnpm up -L` as needed.

```json
{
  "devDependencies": {
    "@ast-grep/cli": "^0.39.5",
    "eslint": "^9.37.0",
    "husky": "^9.1.7",
    "jscpd": "^4.0.5",
    "knip": "^5.65.0",
    "lint-staged": "^16.2.4",
    "msw": "^2.11.5",
    "prettier": "^3.6.2",
    "vitest": "^3.2.4"
  }
}
```

### Appendix C — Optional Auto‑fix PR Workflow (lean)

```yaml
# .github/workflows/auto-fix.yml
name: Auto-fix PR Issues
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  autofix:
    if: contains(github.event.comment.body, '/autofix') || contains(github.event.comment.body, 'eslint')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { token: ${{ secrets.GITHUB_TOKEN }}, ref: ${{ github.event.pull_request.head.ref }} }
      - uses: pnpm/action-setup@v4
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: 'pnpm' }
      - run: pnpm install --frozen-lockfile
      - run: pnpm -r lint && pnpm -r format:write
      - name: Commit fixes
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email 'github-actions[bot]@users.noreply.github.com'
          git add -A
          git diff --staged --quiet || git commit -m "fix: auto-fix lint/style via /autofix"
          git push
```
