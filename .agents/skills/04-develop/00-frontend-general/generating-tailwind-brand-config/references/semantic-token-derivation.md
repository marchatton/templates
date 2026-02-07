# Semantic Token Derivation (Minimal + Practical)

`design_tokens.json` gives you a brand palette and a few mechanical scales. A Tailwind-powered UI needs a few extra semantic tokens to build consistent primitives.

Goal: derive the minimum semantic set without inventing new hues.

## Base inputs (from `design_tokens.json`)

Use `composite_tokens.colour`:
- `background`, `text`
- `primary`, `secondary`, `accent`
- dark overrides under `composite_tokens.colour.themes.dark`

## Convert hex -> RGB triplets

Store color variables as RGB triplets for alpha support:

```css
--primary: 251 99 27; /* #FB631B */
```

Then Tailwind can do:

```ts
"rgb(var(--primary) / <alpha-value>)"
```

## Foreground (“on-*”) colors

For filled surfaces, set readable foreground values:
- `--primary-foreground`
- `--secondary-foreground`
- `--accent-foreground`

Rule:
- Prefer whichever of `background` or `text` gives stronger contrast.
- If neither hits AA (4.5:1) for normal text, pick the stronger one and flag it.

Practical note for this Brand DNA run:
- The orange primaries do not support white button text for normal-size labels; use dark foreground.

## Minimal semantic set

You can build most primitives with:
- `--card` / `--card-foreground`
- `--muted` / `--muted-foreground`
- `--border`
- `--ring`

Guidelines:
- `--border` and `--muted-foreground` can often reuse `--foreground` plus alpha at use sites (via Tailwind `/` opacity).
- If you need multiple surface layers, create `--surface-1`, `--surface-2` as blends of background and foreground (no new hues).

## Recommended defaults (if not specified)

- `--card`: same as background (use border/shadow for separation)
- `--muted`: same as background (use alpha + typography for hierarchy)
- `--border`: same as foreground (use low alpha like `border-border/10` or `border-border/15`)
- `--ring`: use accent (keeps focus distinct from CTAs)

## Radius / shadow / motion mapping

From `design_tokens.json`:
- Radius scale: add new Tailwind radius keys (don’t override Tailwind defaults).
- Elevation: add `shadow-ui-sm` and `shadow-ui-lg` from the two shadow tokens.
- Motion: add `transitionDuration.micro/standard/large` and `ease-brand-standard`.

