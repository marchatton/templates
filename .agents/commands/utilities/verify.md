# verify

## Purpose
Run the pnpm verification ladder with clear GO/NO-GO output.

## Inputs
- Target repo path.
- Optional: `--skip-verify "reason"`.

## Outputs
- Command results summary.
- GO/NO-GO decision.

## Steps
1. If `package.json` exists, run the pnpm ladder.
2. If `package.json` is missing:
   - If `docs/verify.md` exists, run fenced `bash` blocks.
   - Otherwise print NO-GO guidance.
3. Summarize results and record GO/NO-GO.

## Verification
- `pnpm lint`
- `pnpm typecheck`
- `pnpm test`
- `pnpm build`
- `pnpm verify`

Fallback:
- If no pnpm: NO-GO with guidance to create `docs/verify.md` or pass `--skip-verify "reason"`.

## Go/No-Go
- GO if all checks pass.
- NO-GO if any check fails or no verification path is defined.
