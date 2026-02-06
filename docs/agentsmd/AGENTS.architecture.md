# Architecture

## Purpose
- Boundary rules + security posture. Keep stable.

## Web app patterns (search; don’t assume exact paths)
- Public vs protected routes (often enforced via middleware)
- API split: auth-only routes, versioned routes, webhook routes
- Frontend-only vs backend-only separation (names vary)

## Boundaries (non-negotiable)
- Client-only must not import server-only (and vice versa).
- Validate at boundaries with Zod.
- Never leak internal errors/details to clients.

## Middleware / API security shape (typical)
- Pipeline is usually: rateLimit → cors → sanitise → auth → logging (confirm actual order in code).
- Webhooks: verify signatures before parsing/acting.
- Public endpoints: rate limit + strict validation.

## Docs + decisions
- Artefacts live under `docs/03-architecture/`.
- ADRs: Append to `docs/03-architecture/DECISIONS.md` when you introduce a new cross-cutting pattern (dependency class, boundary rule, auth/security posture). Keep it short and link the PR.
