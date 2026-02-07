# Templates (Tokens + Tailwind Preset)

Use these as starting points. Replace placeholder values with values derived from `design_tokens.json`.

## `tokens.css` (recommended shape)

```css
/* Generated from docs/02-guidelines/inspiration/design_tokens.json */
@layer base {
  :root {
    /* Base brand roles (RGB triplets for alpha support) */
    --background: 0 0 0;
    --foreground: 255 255 255;

    --primary: 0 0 0;
    --primary-foreground: 255 255 255;

    --secondary: 0 0 0;
    --secondary-foreground: 255 255 255;

    --accent: 0 0 0;
    --accent-foreground: 255 255 255;

    /* Semantic tokens (derived blends, no new hues) */
    --card: var(--background);
    --card-foreground: var(--foreground);
    --muted: var(--background);
    --muted-foreground: var(--foreground);

    --border: var(--foreground);
    --ring: var(--accent);

    /* Optional: radius tokens */
    --radius-sm: 4px;
    --radius-md: 6px;
    --radius-lg: 10px;
    --radius-xl: 32px;
    --radius-pill: 9999px;
  }

  .dark {
    --background: 0 0 0;
    --foreground: 255 255 255;

    --primary: 0 0 0;
    --primary-foreground: 255 255 255;

    --secondary: 0 0 0;
    --secondary-foreground: 255 255 255;

    --accent: 0 0 0;
    --accent-foreground: 255 255 255;

    --card: var(--background);
    --card-foreground: var(--foreground);
    --muted: var(--background);
    --muted-foreground: var(--foreground);

    --border: var(--foreground);
    --ring: var(--accent);
  }

  html {
    color: rgb(var(--foreground));
    background: rgb(var(--background));
  }
}
```

## `tailwind.preset.ts` (recommended shape)

```ts
import type { Config } from "tailwindcss";

export default {
  darkMode: ["class"],
  theme: {
    extend: {
      colors: {
        background: "rgb(var(--background) / <alpha-value>)",
        foreground: "rgb(var(--foreground) / <alpha-value>)",

        card: {
          DEFAULT: "rgb(var(--card) / <alpha-value>)",
          foreground: "rgb(var(--card-foreground) / <alpha-value>)",
        },

        primary: {
          DEFAULT: "rgb(var(--primary) / <alpha-value>)",
          foreground: "rgb(var(--primary-foreground) / <alpha-value>)",
        },
        secondary: {
          DEFAULT: "rgb(var(--secondary) / <alpha-value>)",
          foreground: "rgb(var(--secondary-foreground) / <alpha-value>)",
        },
        accent: {
          DEFAULT: "rgb(var(--accent) / <alpha-value>)",
          foreground: "rgb(var(--accent-foreground) / <alpha-value>)",
        },

        muted: {
          DEFAULT: "rgb(var(--muted) / <alpha-value>)",
          foreground: "rgb(var(--muted-foreground) / <alpha-value>)",
        },

        border: "rgb(var(--border) / <alpha-value>)",
        ring: "rgb(var(--ring) / <alpha-value>)",
      },
      borderRadius: {
        "ui-sm": "var(--radius-sm)",
        "ui-md": "var(--radius-md)",
        "ui-lg": "var(--radius-lg)",
        "ui-xl": "var(--radius-xl)",
        pill: "var(--radius-pill)",
      },
      boxShadow: {
        "ui-sm": "0px 1px 2px rgba(0,0,0,0.05)",
        "ui-lg": "0px 8px 24px rgba(0,0,0,0.10)",
      },
      transitionDuration: {
        micro: "150ms",
        standard: "200ms",
        large: "400ms",
      },
      transitionTimingFunction: {
        "brand-standard": "cubic-bezier(0.4, 0, 0.2, 1)",
      },
      fontFamily: {
        sans: ["Switzer", "Inter", "system-ui", "-apple-system", "sans-serif"],
        serif: ["Signifier", "ui-serif", "Georgia", "serif"],
        mono: ["GeistMono", "ui-monospace", "SFMono-Regular", "monospace"],
      },
    },
  },
} satisfies Config;
```

## `tailwind.config.ts` (app wrapper example)

```ts
import type { Config } from "tailwindcss";
import preset from "./tailwind.preset";

export default {
  presets: [preset],
  content: ["./src/**/*.{ts,tsx}"],
} satisfies Config;
```

