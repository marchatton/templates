#!/usr/bin/env node
/**
 * Generates `tokens.css` + `tailwind.preset.ts` from Brand DNA `design_tokens.json`.
 *
 * Usage:
 *   node --experimental-strip-types scripts/generate_pack.ts \
 *     --tokens docs/02-guidelines/inspiration/design_tokens.json \
 *     --out-dir tmp/tailwind-brand-config
 *
 * Notes:
 * - This script is intentionally dependency-free.
 * - It does not attempt to generate component code, only config building blocks.
 */

import fs from "node:fs";
import path from "node:path";

type Args = {
  tokensPath: string;
  outDir: string;
  force: boolean;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    tokensPath: "docs/02-guidelines/inspiration/design_tokens.json",
    outDir: "tmp/tailwind-brand-config",
    force: false,
  };

  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--tokens") args.tokensPath = argv[++i] ?? "";
    else if (a === "--out-dir") args.outDir = argv[++i] ?? "";
    else if (a === "--force") args.force = true;
  }

  if (!args.tokensPath) throw new Error("Missing --tokens <path>.");
  if (!args.outDir) throw new Error("Missing --out-dir <dir>.");
  return args;
}

function readJson(filePath: string): unknown {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function hexToRgb(hex: string): [number, number, number] {
  const h = hex.trim().replace(/^#/, "");
  if (!/^[0-9a-fA-F]{6}$/.test(h)) throw new Error(`Invalid hex color: ${hex}`);
  const r = Number.parseInt(h.slice(0, 2), 16);
  const g = Number.parseInt(h.slice(2, 4), 16);
  const b = Number.parseInt(h.slice(4, 6), 16);
  return [r, g, b];
}

function rgbTriplet(hex: string): string {
  const [r, g, b] = hexToRgb(hex);
  return `${r} ${g} ${b}`;
}

function srgbToLinear(c: number): number {
  const s = c / 255;
  return s <= 0.04045 ? s / 12.92 : Math.pow((s + 0.055) / 1.055, 2.4);
}

function relativeLuminance(rgb: [number, number, number]): number {
  const [r, g, b] = rgb;
  const R = srgbToLinear(r);
  const G = srgbToLinear(g);
  const B = srgbToLinear(b);
  return 0.2126 * R + 0.7152 * G + 0.0722 * B;
}

function contrastRatio(a: [number, number, number], b: [number, number, number]): number {
  const La = relativeLuminance(a);
  const Lb = relativeLuminance(b);
  const L1 = Math.max(La, Lb);
  const L2 = Math.min(La, Lb);
  return (L1 + 0.05) / (L2 + 0.05);
}

function pickForeground(fillHex: string, optionAHex: string, optionBHex: string): string {
  const fill = hexToRgb(fillHex);
  const a = hexToRgb(optionAHex);
  const b = hexToRgb(optionBHex);
  const ca = contrastRatio(fill, a);
  const cb = contrastRatio(fill, b);
  return ca >= cb ? optionAHex : optionBHex;
}

function parseFontStack(stack: string | undefined): string[] {
  if (!stack) return [];
  return stack
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
}

function toTsStringArray(values: string[]): string {
  return `[${values.map((v) => JSON.stringify(v)).join(", ")}]`;
}

function chooseRadius(scale: number[]) {
  const s = [...scale].filter((n) => Number.isFinite(n)).sort((a, b) => a - b);
  const min = s[0] ?? 6;
  const md = s[1] ?? min;
  const pill = s.at(-1) ?? 9999;
  const xl = s.find((n) => n >= 24 && n !== pill) ?? s.at(-2) ?? 32;
  const lg = s.find((n) => n >= 10 && n < xl) ?? s.find((n) => n > md) ?? 10;
  return { sm: min, md, lg, xl, pill };
}

type DesignTokens = {
  composite_tokens?: {
    colour?: {
      background?: string;
      text?: string;
      primary?: string;
      secondary?: string;
      accent?: string;
      themes?: {
        dark?: Partial<{
          background: string;
          text: string;
          primary: string;
          secondary: string;
          accent: string;
        }>;
      };
    };
    typography?: {
      body?: { font_family?: string };
      headings?: { font_family?: string };
      ui?: { monospace?: string };
    };
    radius?: { scale?: number[] };
    elevation?: { shadows?: string[] };
    motion?: {
      transition_durations_ms?: number[];
      timing_functions?: string[];
    };
  };
};

function required<T>(value: T | undefined | null, label: string): T {
  if (value === undefined || value === null) throw new Error(`Missing required field: ${label}`);
  return value;
}

function main() {
  const args = parseArgs(process.argv.slice(2));

  const json = readJson(args.tokensPath) as DesignTokens;
  const ct = required(json.composite_tokens, "composite_tokens");
  const colour = required(ct.colour, "composite_tokens.colour");

  const light = {
    background: required(colour.background, "composite_tokens.colour.background"),
    text: required(colour.text, "composite_tokens.colour.text"),
    primary: required(colour.primary, "composite_tokens.colour.primary"),
    secondary: required(colour.secondary, "composite_tokens.colour.secondary"),
    accent: required(colour.accent, "composite_tokens.colour.accent"),
  };

  const darkOverrides = colour.themes?.dark ?? {};
  const dark = {
    background: darkOverrides.background ?? light.background,
    text: darkOverrides.text ?? light.text,
    primary: darkOverrides.primary ?? light.primary,
    secondary: darkOverrides.secondary ?? light.secondary,
    accent: darkOverrides.accent ?? light.accent,
  };

  const lightOn = {
    primary: pickForeground(light.primary, light.text, light.background),
    secondary: pickForeground(light.secondary, light.text, light.background),
    accent: pickForeground(light.accent, light.text, light.background),
  };

  const darkOn = {
    primary: pickForeground(dark.primary, dark.text, dark.background),
    secondary: pickForeground(dark.secondary, dark.text, dark.background),
    accent: pickForeground(dark.accent, dark.text, dark.background),
  };

  const radiusScale = ct.radius?.scale ?? [4, 6, 10, 32, 9999];
  const r = chooseRadius(radiusScale);

  const shadows = ct.elevation?.shadows ?? ["0px 1px 2px rgba(0,0,0,0.05)", "0px 8px 24px rgba(0,0,0,0.10)"];
  const shadowSm = shadows[0] ?? "0px 1px 2px rgba(0,0,0,0.05)";
  const shadowLg = shadows[1] ?? "0px 8px 24px rgba(0,0,0,0.10)";

  const durations = ct.motion?.transition_durations_ms ?? [150, 200, 400];
  const dMicro = durations[0] ?? 150;
  const dStd = durations[1] ?? 200;
  const dLarge = durations[2] ?? 400;

  const easing = (ct.motion?.timing_functions ?? []).find((t) => t.includes("cubic-bezier")) ?? "cubic-bezier(0.4, 0, 0.2, 1)";

  const bodyFonts = parseFontStack(ct.typography?.body?.font_family);
  const headingFonts = parseFontStack(ct.typography?.headings?.font_family);
  const monoFonts = parseFontStack(ct.typography?.ui?.monospace);

  const tokensCss = `/* Generated from ${args.tokensPath} */\n` +
    `@layer base {\n` +
    `  :root {\n` +
    `    --background: ${rgbTriplet(light.background)};\n` +
    `    --foreground: ${rgbTriplet(light.text)};\n\n` +
    `    --primary: ${rgbTriplet(light.primary)};\n` +
    `    --primary-foreground: ${rgbTriplet(lightOn.primary)};\n` +
    `    --secondary: ${rgbTriplet(light.secondary)};\n` +
    `    --secondary-foreground: ${rgbTriplet(lightOn.secondary)};\n` +
    `    --accent: ${rgbTriplet(light.accent)};\n` +
    `    --accent-foreground: ${rgbTriplet(lightOn.accent)};\n\n` +
    `    --card: var(--background);\n` +
    `    --card-foreground: var(--foreground);\n` +
    `    --muted: var(--background);\n` +
    `    --muted-foreground: var(--foreground);\n\n` +
    `    --border: var(--foreground);\n` +
    `    --ring: var(--accent);\n\n` +
    `    --radius-sm: ${r.sm}px;\n` +
    `    --radius-md: ${r.md}px;\n` +
    `    --radius-lg: ${r.lg}px;\n` +
    `    --radius-xl: ${r.xl}px;\n` +
    `    --radius-pill: ${r.pill}px;\n` +
    `  }\n\n` +
    `  .dark {\n` +
    `    --background: ${rgbTriplet(dark.background)};\n` +
    `    --foreground: ${rgbTriplet(dark.text)};\n\n` +
    `    --primary: ${rgbTriplet(dark.primary)};\n` +
    `    --primary-foreground: ${rgbTriplet(darkOn.primary)};\n` +
    `    --secondary: ${rgbTriplet(dark.secondary)};\n` +
    `    --secondary-foreground: ${rgbTriplet(darkOn.secondary)};\n` +
    `    --accent: ${rgbTriplet(dark.accent)};\n` +
    `    --accent-foreground: ${rgbTriplet(darkOn.accent)};\n\n` +
    `    --card: var(--background);\n` +
    `    --card-foreground: var(--foreground);\n` +
    `    --muted: var(--background);\n` +
    `    --muted-foreground: var(--foreground);\n\n` +
    `    --border: var(--foreground);\n` +
    `    --ring: var(--accent);\n` +
    `  }\n\n` +
    `  html {\n` +
    `    color: rgb(var(--foreground));\n` +
    `    background: rgb(var(--background));\n` +
    `  }\n` +
    `}\n`;

  const presetTs =
    `import type { Config } from \"tailwindcss\";\n\n` +
    `export default {\n` +
    `  darkMode: [\"class\"],\n` +
    `  theme: {\n` +
    `    extend: {\n` +
    `      colors: {\n` +
    `        background: \"rgb(var(--background) / <alpha-value>)\",\n` +
    `        foreground: \"rgb(var(--foreground) / <alpha-value>)\",\n\n` +
    `        card: {\n` +
    `          DEFAULT: \"rgb(var(--card) / <alpha-value>)\",\n` +
    `          foreground: \"rgb(var(--card-foreground) / <alpha-value>)\",\n` +
    `        },\n\n` +
    `        primary: {\n` +
    `          DEFAULT: \"rgb(var(--primary) / <alpha-value>)\",\n` +
    `          foreground: \"rgb(var(--primary-foreground) / <alpha-value>)\",\n` +
    `        },\n` +
    `        secondary: {\n` +
    `          DEFAULT: \"rgb(var(--secondary) / <alpha-value>)\",\n` +
    `          foreground: \"rgb(var(--secondary-foreground) / <alpha-value>)\",\n` +
    `        },\n` +
    `        accent: {\n` +
    `          DEFAULT: \"rgb(var(--accent) / <alpha-value>)\",\n` +
    `          foreground: \"rgb(var(--accent-foreground) / <alpha-value>)\",\n` +
    `        },\n\n` +
    `        muted: {\n` +
    `          DEFAULT: \"rgb(var(--muted) / <alpha-value>)\",\n` +
    `          foreground: \"rgb(var(--muted-foreground) / <alpha-value>)\",\n` +
    `        },\n\n` +
    `        border: \"rgb(var(--border) / <alpha-value>)\",\n` +
    `        ring: \"rgb(var(--ring) / <alpha-value>)\",\n` +
    `      },\n` +
    `      borderRadius: {\n` +
    `        \"ui-sm\": \"var(--radius-sm)\",\n` +
    `        \"ui-md\": \"var(--radius-md)\",\n` +
    `        \"ui-lg\": \"var(--radius-lg)\",\n` +
    `        \"ui-xl\": \"var(--radius-xl)\",\n` +
    `        pill: \"var(--radius-pill)\",\n` +
    `      },\n` +
    `      boxShadow: {\n` +
    `        \"ui-sm\": ${JSON.stringify(shadowSm)},\n` +
    `        \"ui-lg\": ${JSON.stringify(shadowLg)},\n` +
    `      },\n` +
    `      transitionDuration: {\n` +
    `        micro: \"${dMicro}ms\",\n` +
    `        standard: \"${dStd}ms\",\n` +
    `        large: \"${dLarge}ms\",\n` +
    `      },\n` +
    `      transitionTimingFunction: {\n` +
    `        \"brand-standard\": ${JSON.stringify(easing)},\n` +
    `      },\n` +
    `      fontFamily: {\n` +
    (bodyFonts.length ? `        sans: ${toTsStringArray(bodyFonts)},\n` : "") +
    (headingFonts.length ? `        serif: ${toTsStringArray(headingFonts)},\n` : "") +
    (monoFonts.length ? `        mono: ${toTsStringArray(monoFonts)},\n` : "") +
    `      },\n` +
    `    },\n` +
    `  },\n` +
    `} satisfies Config;\n`;

  fs.mkdirSync(args.outDir, { recursive: true });

  const tokensOut = path.join(args.outDir, "tokens.css");
  const presetOut = path.join(args.outDir, "tailwind.preset.ts");

  for (const out of [tokensOut, presetOut]) {
    if (fs.existsSync(out) && !args.force) {
      throw new Error(`Refusing to overwrite existing file: ${out}. Re-run with --force.`);
    }
  }

  fs.writeFileSync(tokensOut, tokensCss);
  fs.writeFileSync(presetOut, presetTs);

  // eslint-disable-next-line no-console
  console.log(`Wrote:\n- ${tokensOut}\n- ${presetOut}`);
}

main();

