---
name: beautiful-mermaid
description: Render Mermaid diagrams to SVG or ASCII/Unicode with beautiful-mermaid (Node/Bun/Deno/browser, no DOM). Use when you need Mermaid render without DOM.
---

# Beautiful Mermaid

## Purpose
Mermaid code -> SVG or ASCII/Unicode. Themed output. TS-first.

## When
- Need Mermaid render without DOM.
- Need themed SVG for web/assets.
- Need terminal-safe ASCII/Unicode.

## Install
- `pnpm add beautiful-mermaid`

## API
- `renderMermaid(code, opts?) -> Promise<string>` (SVG)
- `renderMermaidAscii(code, opts?) -> Promise<string>` (ASCII/Unicode)
- `fromShikiTheme(themeName) -> MermaidConfig["theme"]`

## Example (TS)
```ts
import { renderMermaid, renderMermaidAscii, fromShikiTheme } from "beautiful-mermaid";

const code = "flowchart LR\nA-->B";

const svg = await renderMermaid(code, {
  theme: fromShikiTheme("catppuccin-mocha"),
  backgroundColor: "#1e1e2e",
});

const ascii = await renderMermaidAscii(code, {
  useUnicode: true,
  maxWidth: 80,
});
```

## renderMermaid opts
- `theme`: MermaidConfig["theme"]. Default `"default"`.
- `backgroundColor`: string. Default `"transparent"`.
- `themeConfig`: MermaidConfig["themeConfig"].
- `mermaidConfig`: MermaidConfig.
- `svgOptimize`: SvgoConfig or `false`.

## renderMermaidAscii opts
- `useUnicode`: boolean. Default `true`.
- `wrap`: boolean. Default `true`.
- `maxWidth`: number. Default `80`.
- `bg`: string. Default `"#FFFFFF"`.
- `fg`: string. Default `"#000000"`.

## Built-in themes
default, forest, dark, neutral, base, ocean, dimmed, darkes, light, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha, dracula, dracula-soft, one-dark-pro, material-dark, material-light, material-darker, material-palenight, material-ocean, material-lighter, tokyo-night, tokyo-night-storm, tokyo-night-light, github-light, github-dark, github-dark-dimmed

## Output
- SVG string: save `.svg` or inline in HTML.
- ASCII/Unicode string: print to terminal/log.
