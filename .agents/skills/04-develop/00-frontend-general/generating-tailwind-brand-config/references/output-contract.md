# Output Contract (Tailwind Brand Config)

This skill generates a Tailwind “design system pack” from Brand DNA artefacts.

## Inputs (default)

- `docs/02-guidelines/inspiration/brand_guidelines.md`
- `docs/02-guidelines/inspiration/design_tokens.json`
- `docs/02-guidelines/inspiration/prompt_library.json`

## Required outputs (when executing this skill)

You must produce:

1) `tokens.css`
- CSS variables for light and dark mode.
- Must include `:root` and `.dark`.
- Must define “on-*” foreground tokens (e.g. `--primary-foreground`) with contrast checks.

2) `tailwind.preset.ts`
- A Tailwind preset that maps colors to CSS variables (alpha-capable).
- Must not override Tailwind’s spacing scale.
- Should add custom keys for brand radius/shadows/motion (do not overwrite Tailwind defaults).

3) `component-recipes.md`
- A compact list of Tailwind class recipes + state rules for common primitives:
  - Button, input, card, badge/chip, table baseline, modal/popover baseline.
- Must include focus rules and reduced motion guidance.

4) Integration snippet(s)
- Provide copy-paste snippets for:
  - `tailwind.config.ts` (app + marketing)
  - CSS import order for `tokens.css`

## Optional outputs

Only produce these if explicitly requested:
- A shared preset package (monorepo) layout and per-app wrapper configs.
- Marketing metadata defaults (theme-color, OG) derived from tokens.

## Acceptance criteria

- Dark mode works (class toggle by default).
- Primary button text is readable (AA for normal text).
- The palette and fonts match `design_tokens.json` (no invented hues).

