---
name: generating-tailwind-brand-config
description: Transforms Brand DNA artefacts (docs/02-guidelines/inspiration/brand_guidelines.md, design_tokens.json, prompt_library.json) into Tailwind-ready design system config (CSS variables + Tailwind preset) for a web app and a marketing site. Use when wiring tokens into Tailwind, setting up light/dark mode, or generating reusable presets and component recipes.
---

# Generating Tailwind Brand Config

## Quick Start

Default inputs (source of truth):
- `docs/02-guidelines/inspiration/brand_guidelines.md`
- `docs/02-guidelines/inspiration/design_tokens.json`
- `docs/02-guidelines/inspiration/prompt_library.json`

Outputs (when executing this skill):
- `tokens.css` (CSS variables for light/dark)
- `tailwind.preset.ts` (shared Tailwind preset using CSS variables)
- `tailwind.config.ts` snippets for:
  - web app (product UI)
  - website (marketing)
- `component-recipes.md` (Tailwind class recipes + interaction states)

See:
- `references/output-contract.md`
- `references/templates.md`
- `references/semantic-token-derivation.md`

Optional helper:
- `scripts/generate_pack.ts` can generate `tokens.css` + `tailwind.preset.ts` directly from `design_tokens.json`.

## Need-to-Know Questions (Ask If Missing)

Ask at most 4. Reply format: `1a 2a 3a 4a` or `defaults`.

1) Tailwind setup target?
- a) **Config-first preset** (`tailwind.preset.ts` + `tokens.css`) (Recommended)
- b) Tailwind v4 CSS-first only (`@theme` in CSS)
- c) Not sure, use recommended

2) Dark mode strategy?
- a) **Class-based** (`.dark`) (Recommended)
- b) Media-based (`prefers-color-scheme`)
- c) Both (class wins)

3) Output layout?
- a) **Shared preset + per-app wrapper configs** (Recommended)
- b) Two fully separate presets (app vs marketing)
- c) Inline per app (no shared preset)

4) Status colors (error/success/warn)?
- a) **Keep Tailwind defaults** (Recommended)
- b) Derive brand status tokens (requires product decision)

If the user says “proceed with defaults”, proceed with `1a 2a 3a 4a`.

## Principles (Do Not Violate)

- Source of truth is the docs inputs. Do not invent a new palette.
- Prefer Tailwind defaults. Add new names; don’t override built-in scales unless required.
- Accessibility is part of the token system: define foreground (“on-*”) colors with contrast.
- Web app UI is calmer/simpler than marketing: keep motion minimal by default.

## Workflow (Execution Order)

### 1) Define primitives and rules (App + Website)

Use:
- `interface-design` to define:
  - app primitives: surface hierarchy, borders, focus treatment, density
  - marketing primitives: typography scale, section spacing, hero posture
- `baseline-ui` to prevent generic output and enforce constraints

### 2) Parse Brand DNA inputs

- Load `design_tokens.json` and extract `composite_tokens` as the base tokens.
- Treat `composite_tokens.colour.themes.dark` as the dark override for colors.
- Use `brand_guidelines.md` as intent checks (don’t contradict it).
- Use `prompt_library.json` to keep naming/voice consistent when writing docs and recipes.

### 3) Derive semantic tokens (minimal set)

- Convert base hex colors to RGB triplets and write CSS variables.
- Define `--*-foreground` tokens (text/icon color on filled backgrounds) by contrast checks.
- Define `--border`, `--ring`, and a small surface set (`--card`, `--muted`) as derived blends.
- Do not create new hues. Derived tokens must be blends of existing roles.

Details: `references/semantic-token-derivation.md`.

### 4) Generate Tailwind preset + tokens CSS

Use `tailwind-css-patterns` for best-practice Tailwind setup.

Use templates in `references/templates.md`. Ensure:
- `darkMode: ["class"]` (unless user picked otherwise)
- `colors` map to CSS variables with alpha support
- fonts map to Brand DNA typography stacks
- radius/shadows/motion are added under new keys (don’t override Tailwind defaults)

### 5) Produce component recipes (not full components)

Use:
- `composition-patterns` to propose scalable component variants (avoid boolean prop explosions)
- `interaction-design` for hover/focus/active/disabled patterns and timing
- `fixing-accessibility` to ensure keyboard/focus behavior is covered

Output `component-recipes.md` with recipes for:
- Button (primary/secondary/ghost; use Tailwind defaults for destructive)
- Input/Textarea/Select
- Card/Panel
- Badge/Chip
- Modal/Popover base styling
- Focus ring and reduced-motion rules

### 6) Marketing site layer (optional but recommended)

Use:
- `frontend-design` to define marketing composition rules that still use the same tokens
- `fixing-metadata` to propose theme-color and OG defaults derived from tokens (do not implement unless asked)

## Done Definition

This skill is done when it produces the outputs in `references/output-contract.md` and the preset can be dropped into a Tailwind project with light/dark mode working.

## Verification Checklist

- Tokens:
  - `:root` and `.dark` blocks exist
  - `--primary-foreground` etc meet AA for normal text where used
- Tailwind preset:
  - No accidental overrides of default spacing/typography scales
  - Colors support alpha (`rgb(var(--token) / <alpha-value>)`)
- Recipes:
  - Focus ring always visible
  - Motion respects `prefers-reduced-motion`
  - No hover-only interactions without keyboard equivalent
