---
name: brand-dna-extractor
description: "This skill should be used when users want to scrape multiple websites (Firecrawl, Parallel, or hybrid), extract brand guideline signals (including CSS variables + computed styles via browser probing), generate per-site prompt packs, and blend sources into a composite brand direction with exactly three outputs: brand_guidelines.md, prompt_library.json, design_tokens.json."
license: Complete terms in LICENSE.txt
---

# brand-dna-extractor

## Purpose

Extract brand signals from multiple sites, ground every claim in evidence, and blend sources into a single composite direction.

## When to use

Use when asked to:
- scrape or crawl multiple sites for brand signals
- create brand guidelines, prompt packs, or design tokens from real websites
- compare and blend multiple brands into a “composite DNA”
- capture “CSS etc” (CSS variables, computed styles, hover/focus states)

## Outputs

Produce exactly three artefacts:
1) `brand_guidelines.md`
2) `prompt_library.json`
3) `design_tokens.json`

Do not output additional artefacts. Do not claim scraping or probing happened unless tool calls were actually executed in the current run.

## Inputs

Accept a configuration object (see `assets/sample_config.json` for a working example). Support:

- optional run metadata: `run_id` (recommended) to name artefact folders / receipts
- scraping lane provider: Firecrawl / Parallel / hybrid
- browser-probe lane: agent-browser (recommended) or equivalent Playwright-class tooling
- limits: max_pages, max_depth, pages_per_site for probing
- evidence limits: quote_limit_words

## The 3-Pronged Approach (Scrape + Extract + Probe)

This skill works best as three parallel “lanes”, each producing different kinds of evidence:

Pick a `run_folder` for each run (where the three required outputs live). When brand docs are the source of truth,
it often makes sense to use something like `docs/02-guidelines/inspiration/<run_id>/` so the outputs and receipts
live together.

### Prong 1: Firecrawl (crawl/map + scrape)

Use Firecrawl for breadth and structured web scraping, especially within a domain:
- **Best for:** mapping/crawling a site, getting broad page coverage, and pulling “main content” markdown.
- **Nice bonus:** Firecrawl `branding` format can yield structured hints for colours/fonts/buttons (treat as hints, not truth).
- **Evidence produced:** `excerpt` (from scraped markdown), plus provider metadata (`scrapeId`, status, etc.).
- **Common failure modes:** JS-heavy pages, auth walls, noisy nav/footer content, rate limits.

Recommended receipts:
- Store Firecrawl outputs under `<run_folder>/.firecrawl/<run_id>/...` and reference them in evidence objects via `path_or_url`.

### Prong 2: Parallel (Search + Extract)

Use Parallel for discovery and clean objective-led extraction:
- **Best for:** discovering hidden pages (Search), extracting cleaner markdown/excerpts from JS-heavy pages or PDFs (Extract).
- **Evidence produced:** `excerpt` evidence aligned to an explicit objective (often higher signal-to-noise than raw crawls).
- **Common failure modes:** API availability/rate limits, objective too vague, extraction returning boilerplate.

Recommended receipts:
- Store Parallel outputs under `<run_folder>/.parallel/<run_id>/...` and reference them in evidence objects via `path_or_url` (or config metadata).

### Prong 3: Browser probe (agent-browser)

Use a real browser to ground visual claims in computed reality:
- **Best for:** CSS variables, computed styles (fonts/colours/radius/shadows), and interaction state deltas (hover/focus).
- **Evidence produced:** `css_variable`, `computed_style`, `computed_style_diff`, `screenshot` (if enabled).
- **Common failure modes:** cross-origin stylesheet rule access, dynamic rendering, bot protection.

Recommended receipts:
- Store probe JSON (and optional screenshots) under `<run_folder>/.probe/<run_id>/...` and reference them in evidence objects via `path_or_url`.

### Why three prongs?

- **Scrape (Firecrawl)** gives you coverage and copy.
- **Extract (Parallel)** gives you cleaner, objective-aligned excerpts and better handling of hard pages.
- **Probe (browser)** gives you the “truth” for style and interaction, which scrapers can’t reliably infer.

## Workflow

Follow this modular pipeline:

1) Validate inputs  
2) Plan per-site run (pages to scrape + pages to extract + pages to probe)  
3) Scrape/extract pages (Firecrawl + Parallel, via `scraping.provider`)  
4) Probe styling + interaction (agent-browser)  
5) Build corpora (copy + style)  
6) Infer signals per site with confidence + evidence  
7) Generate per-site prompt packs  
8) Blend into composite direction (with weights + blend_mode)  
9) Package exactly three outputs using the reference templates and schemas  
10) Run quality checks and record limitations

### 1) Validate inputs

- Require `urls` to be a non-empty list.
- Normalise URLs:
  - strip `utm_*`, `gclid`, `fbclid`
  - remove fragments
  - standardise trailing slashes
- Normalise weights:
  - if empty: equal weights
  - if provided: normalise to sum to 1 across included URLs

### 2) Plan pages per site

- Build a candidate list from:
  - home, product/features, pricing, about
  - docs/help (important for real UI patterns)
  - blog index + one recent post
  - brand/press/assets pages
- Assign pages to lanes:
  - scrape/extract: enough pages to cover copy + positioning + key flows
  - probe: fewer pages, but must include the most “UI representative” surfaces
- Apply allow/deny:
  - if include_paths present, restrict to those
  - always apply exclude_paths

### 3) Scrape/extract lanes (Firecrawl / Parallel / hybrid)

Implement a provider adapter that yields a shared `PageArtefact` shape (even if tool outputs differ):

**PageArtefact**
- url, status, timestamp
- title, meta_description
- headings (H1–H3)
- main_text (clean)
- markdown (if available)
- raw_html (if available)
- linked_css_urls, inline_style_blocks (best effort)
- images (URLs, optional)
- provider_trace (provider name + request ids + warnings)

Provider rules:
- Use Firecrawl crawl-first for broad, within-domain coverage.
- Use Parallel Search for discovery when crawl coverage is weak or brand pages are hidden.
- Use Parallel Extract for cleaner markdown when:
  - JS-heavy pages break standard scrapers
  - PDFs are involved
  - crawl output is low-quality or boilerplate-heavy

Noise removal (must do before inference):
- remove cookie banners and popups
- down-rank repeated nav/footer blocks
- down-rank third-party widgets unless visually dominant

### 4) Browser-probe lane (agent-browser)

Use browser probing to overcome “CSS variables / computed styles / interaction” limitations.

Probe plan:
- Probe up to `browser_probe.pages_per_site` pages per site.
- Run at least desktop + light mode.
- If configured, also run mobile and dark mode.
- For each page × viewport × media_mode:
  - capture stylesheet inventory (links + inline styles)
  - best-effort CSS variable extraction
  - computed styles snapshots (`getComputedStyle`) for key elements
  - hover/focus diffs (state deltas)
  - motion primitives (transition and animation properties)
  - screenshots if enabled

Use `scripts/probe_css.js` as the default probe payload.

Store evidence in a structured `evidence_map` (see schema in `references/brand_dna_run.schema.json`).

### Evidence receipts (recommended)

To keep the “ground every claim in evidence” promise, store lane outputs as receipts and reference them:
- Keep receipts in hidden, gitignored folders by default:
  - `<run_folder>/.firecrawl/<run_id>/...`
  - `<run_folder>/.parallel/<run_id>/...`
  - `<run_folder>/.probe/<run_id>/...`
- Evidence objects should include `path_or_url` when the schema supports it (e.g. `design_tokens.json` evidence).
- If a lane is disabled or fails for a site/page, record a limitation and reduce confidence accordingly.

### 5) Build corpora

Build two corpora per site:

**Copy corpus**
- hero headlines, subheads
- feature bullets
- CTA labels and microcopy
- pricing plan labels
- help/error text if discoverable

**Style corpus**
- CSS variables (declared tokens)
- computed styles (resolved tokens)
- state diffs (hover/focus)
- component-like fragments and selectors

### 6) Infer brand signals per site

Extract signals with:
- confidence score (0–1)
- evidence pointers for every claim
- needs_human_review=true if evidence is weak or conflicting

Signal categories:
- Colours
- Typography
- Design tokens (spacing, radius, borders, shadows, layout rhythm)
- Components inventory (with variants)
- Imagery style
- Iconography style
- Motion/interaction
- Voice/tone/personality

Evidence rules:
- Never exceed `quote_limit_words` for any single excerpt.
- Prefer selectors, CSS variable names, and computed-style properties over long quotes.
- Attach evidence as one of:
  - excerpt, selector, css_variable, computed_style, computed_style_diff, screenshot

### 7) Generate per-site prompt pack

Produce per-site prompt packs with keys:
- brand_style_prompt
- visual_direction_prompt
- ui_direction_prompt
- copywriting_prompt
- negative_prompt
- token_set (bullets grouped by: colour, type, layout, imagery, voice, motion)

Add evidence anchors like `[site_id:page_id:signal_key]` inline in prompts.

### 8) Blend multiple sites

Normalise each site into comparable token sets:
- colours: roles + hex + hue tags (+ light/dark variants if available)
- typography: families + hierarchy traits
- UI: density, radius, elevation, spacing cadence
- imagery: medium + treatment tags
- voice: traits + cadence + CTA verb style
- motion: transition duration/easing archetypes

Detect conflicts:
- palette clash
- typography clash
- voice clash
- UI shape/density clash
- theme clash (light/dark inconsistencies)

Resolve using blend_mode:
- harmonise
- bold_hybrid
- dominant_source
- theme_collage

Record conflicts and resolutions with provenance.

### 9) Package outputs

Use the reference files:
- `references/brand_guidelines_template.md`
- `references/prompt_library.schema.json`
- `references/design_tokens.schema.json`

Constraints:
- Output exactly three artefacts.
- In `brand_guidelines.md`, include the exact required headings (same order as template).

### 10) Quality checks

Run:
- quote limit enforcement on any excerpt evidence
- required headings check for `brand_guidelines.md`
- required top-level keys check for JSON outputs
- low-confidence site flags if meaningful pages < min_meaningful_pages_per_site
- lane coverage checks (if enabled):
  - Firecrawl/Parallel: at least one meaningful excerpt for positioning + CTA copy per site
  - Browser-probe: at least one page has computed styles for body/h1/primary_cta
- browser-probe coverage checks (if enabled):
  - body, h1, primary_cta computed styles captured at least once
  - dark mode captured if requested, else record limitation
  - at least one hover or focus diff captured if requested, else record limitation

Validate outputs (baseline):
```bash
python3 .agents/skills/00-utilities/brand-dna-extractor/scripts/validate_outputs.py --dir docs/02-guidelines/inspiration
```

## What not to do

- Do not invent CSS variables or computed styles.
- Do not claim hover/focus behaviour exists unless state diffs were captured.
- Do not overfit to cookie banner styling or third-party widgets.
- Do not exceed the quote limit per page excerpt.
- Do not output more than the three required artefacts.
