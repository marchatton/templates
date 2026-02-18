# Product + UI guidelines

## Purpose
- Keep product tone + interaction consistent.

## Brand
- Follow:
  - `docs/02-guidelines/brand-tone.md`
  - `docs/02-guidelines/brand-guidelines.md`
  - `docs/00-strategy/product-principles.md` (if present)
- Don't invent a new voice or UI conventions.

These are generated artefacts. Prefer regenerating via the Brand DNA skills over hand-editing.
Inspiration run snapshots live under `docs/02-guidelines/inspiration`.

Expected generated outputs for app + marketing Tailwind setups:
- `docs/02-guidelines/inspiration/tailwind/tokens.css`
- `docs/02-guidelines/inspiration/tailwind/tailwind.preset.ts`
- `docs/02-guidelines/inspiration/tailwind/component-recipes.md`
- `docs/02-guidelines/inspiration/tailwind/integration.md` (optional; snippets may live in `component-recipes.md` instead)

Assume Tailwind CSS v4+ (CSS-first configuration via `@theme` where possible).

Use the `generating-tailwind-brand-config` skill to regenerate these consistently.

Regenerate (defaults):
```bash
node --experimental-strip-types .agents/skills/04-develop/00-frontend-general/generating-tailwind-brand-config/scripts/generate_pack.ts \
  --tokens docs/02-guidelines/inspiration/design_tokens.json \
  --out-dir docs/02-guidelines/inspiration/tailwind \
  --force
```

## Accessibility baseline (minimum)
- Keyboard support + visible focus.
- Targets >= 24px (>= 44px on mobile).
- Inline errors with aria-live="polite"; focus first invalid on submit.
- Confirm destructive actions (or Undo).
- Honor prefers-reduced-motion (opacity/transform only).
- Never block paste, rely on color-only, or disable zoom.

If missing, search within `docs/02-guidelines/`.

## Key Skills
- `generating-tailwind-brand-config` for brand tokens/config
- `baseline-ui`, `interface-design`, `frontend-design` and `web-design-guidelines` for UI

## Helpers
- Use `docs-list` to locate guidance fast.
