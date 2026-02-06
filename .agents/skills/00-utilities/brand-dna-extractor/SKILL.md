---
name: brand-dna-extractor
description: This skill should be used when users want to scrape multiple websites (Firecrawl or equivalent), extract brand guidelines signals, generate per-site prompt packs, and blend sources into a composite brand direction with three outputs - brand_guidelines.md, prompt_library.json, design_tokens.json.
---

## Scope

Extract brand signals from multiple websites, convert each source into a traceable prompt pack, and blend sources into a single composite brand direction.

Produce exactly three artefacts:

1) `brand_guidelines.md`
2) `prompt_library.json`
3) `design_tokens.json`

Do not claim real scraping happened unless tool calls were actually executed in the current run.

## Inputs and configuration

Accept a configuration object with these fields and defaults:

```json
{
  "urls": [],
  "include_paths": [],
  "exclude_paths": ["*/privacy*", "*/terms*", "*/cookie*", "*/legal*"],
  "max_depth": 2,
  "max_pages": 25,
  "render_js": true,
  "locale": "en",
  "focus_pages": ["home", "pricing", "product", "about", "blog"],
  "weights": {},
  "blend_mode": "harmonise",
  "output_style": "standard",
  "quote_limit_words": 20,
  "min_meaningful_pages_per_site": 3,
  "download_images": false,
  "take_screenshots": false
}
```

Configuration rules:

- Treat `urls` as required.
- If `weights` is empty, weight all sites equally.
- If `weights` is provided, normalise weights so they sum to 1 across included URLs.
- Enforce `quote_limit_words` on any excerpt copied from a single page (including in evidence maps).
- If fewer than `min_meaningful_pages_per_site` pages are extracted for a site, still continue but mark the site as low-confidence and include a limitation.

## Workflow

Follow this sequence. Keep the pipeline modular: crawl → extract → infer → summarise → promptify → blend → package outputs.

1) Validate inputs
- Validate `urls` is a non-empty list.
- Normalise URLs (strip tracking params, remove fragments, standardise trailing slashes).
- Build a per-site run plan using `focus_pages`, `include_paths`, `exclude_paths`, `max_depth`, and `max_pages`.

2) Crawl and scrape (Firecrawl-friendly, tool-agnostic)
- Prefer sitemap and internal link discovery.
- Prioritise likely brand signal pages early:
  - homepage
  - product / features
  - blog index and one recent article
  - brand / assets pages
- Apply allow/deny rules:
  - If `include_paths` is non-empty, crawl only those subpaths.
  - Always apply `exclude_paths`.
- Dedupe:
  - Strip `utm_*`, `gclid`, `fbclid` params.
  - Treat hash fragments as the same page.
  - Dedupe near-identical pages using (a) main text similarity and (b) DOM structure signature.
- For each kept page, collect artefacts (best effort):
  - URL, status, timestamp
  - page title, meta description
  - headings (H1–H3)
  - main text (readable extraction)
  - raw HTML (rendered HTML if `render_js=true` and available)
  - linked CSS URLs + inline style blocks
  - style snapshot for key elements (body, headings, links, buttons, inputs, cards), using computed styles if available
  - if `download_images=true`: hero images + other dominant images (save URLs at minimum)
  - if `take_screenshots=true`: a full-page screenshot (or above-the-fold)

Resilience:
- Retry failed fetches up to 2 times.
- Use a per-page timeout of 20 seconds.
- If blocked:
  - toggle JS rendering strategy if possible
  - fall back to text-only extraction
- If content is noisy, keep the page but down-rank it in signal extraction.

Noise removal (must do before inference):
- Remove cookie banners, consent modals, newsletter popups.
- Down-rank nav/footer repeated blocks (detect by repeated DOM blocks across pages).
- Down-rank third-party widgets (chat, embedded social, video embeds) unless visually dominant.

3) Build per-site page corpus
- Build a “clean copy corpus” containing:
  - hero headlines, subheads
  - product feature bullets
  - CTA labels and microcopy
  - pricing plan labels
  - any error/help text if discoverable
- Build a “style corpus” containing:
  - CSS variables
  - computed styles from key elements
  - component-like DOM fragments (buttons, cards, forms, nav)

4) Infer brand signals (per site)
Extract signals with confidence scores and evidence pointers for every claim. Never rely on vibes alone.

Signal categories:
- Colours
- Typography
- Design tokens (spacing, radius, shadows, borders, layout rhythm)
- Components inventory (with variants)
- Imagery style
- Iconography style
- Motion/interaction
- Voice/tone and brand personality

Evidence rules (strict):
- Attach evidence to every extracted claim:
  - `source_url` + (`selector` OR `excerpt`)
- Never exceed `quote_limit_words` for any excerpt from a single page.
- Prefer selectors, CSS variable names, and short excerpts.
- If evidence is weak, set `needs_human_review=true` and reduce confidence.

See `references/brand_dna_run.schema.json` for the required structure of extracted signals and evidence.

### Heuristics: colours
- Prefer CSS variables that look semantic:
  - `--primary`, `--accent`, `--brand`, `--text`, `--background`, `--surface`
- Next, inspect computed styles:
  - body background, body text colour
  - link colour
  - primary button background/text
  - secondary button border/text
- If `download_images=true`, optionally extract dominant colours from hero imagery, but treat as supporting evidence only.
Guardrails:
- Ignore cookie banners and consent UI unless the same tokens appear in core components.
- Ignore third-party embed colours.

Output:
- `primary`, `secondary`, `accent`, `background`, `text` with hex values
- usage notes
- `confidence` (0–1)
- `needs_human_review` when `confidence < 0.6` or signals conflict

### Heuristics: typography
- Extract font families used for:
  - body
  - headings
  - buttons/CTAs
- Infer hierarchy and scale:
  - heading size ratios, line-heights
  - spacing between sections
- Infer typographic vibe tags:
  - modern sans / geometric / grotesk / serif editorial / mono accents
Guardrails:
- Ignore font usage inside embedded widgets.

### Heuristics: design tokens
Spacing:
- Collect common padding/margin values and infer a base step (4px, 8px, etc).
Radius:
- Detect border-radius on buttons, cards, inputs.
Shadows/borders:
- Detect box-shadow patterns and border usage (flat vs layered).
Layout rhythm:
- Infer max-width containers, section spacing cadence, grid tendency.

### Heuristics: components inventory
Identify repeated component patterns via DOM structure signatures and class patterns.

Track at minimum:
- buttons (primary, secondary, tertiary)
- nav (top, sticky, footer)
- cards
- forms/inputs
- badges/chips
- tables (if present)
- modals (if detectable)

For each component, capture:
- variants
- key styling traits
- interaction notes if detectable (hover, focus, active)

### Heuristics: imagery style
Classify, then describe:
- photo vs illustration vs 3D vs mixed
- subject matter (people, product, abstract)
- composition (tight crop vs roomy)
- lighting (natural vs studio)
- colour treatment (muted vs vivid)
- texture (grain/no grain)
Evidence:
- If images are not downloaded, rely on alt text and surrounding copy and set lower confidence.

### Heuristics: iconography style
Infer from inline SVGs or icon sets when detectable:
- stroke vs filled
- line weight
- rounded vs sharp corners
- metaphor style (literal vs abstract)

### Heuristics: motion/interaction
Detect CSS transitions/animations and interaction affordances:
- hover states, focus rings
- scroll behaviours (if observable)
If not detectable, state “not confidently inferred” and set low confidence.

### Heuristics: voice, tone, personality
Build a copy corpus from multiple page sections.

Infer:
- tone traits (direct, warm, playful, premium, technical, etc)
- cadence (short punchy vs long-form explanatory)
- CTA verb style
- punctuation patterns (exclamation marks, emoji usage)
- reading level proxy (sentence length, jargon density)

Output:
- 5–7 personality traits with evidence
- “do” and “don’t” bullets
- 3 paraphrased example rewrites (never copy slogans)

5) Generate prompt pack (per site)
Generate a prompt pack with these keys:

- `brand_style_prompt` (1–2 paragraphs)
- `visual_direction_prompt` (for image generation)
- `ui_direction_prompt` (for landing page/product UI)
- `copywriting_prompt` (tone + microcopy guidance)
- `negative_prompt` (what to avoid)
- `token_set` (mix-and-match bullets grouped by: colour, type, layout, imagery, voice)

Constraints:
- Ground every prompt in extracted signals.
- Add evidence anchors like `[site_id:page_id:signal_key]` in prompts.
- Do not replicate proprietary slogans or unique lines. Paraphrase.

6) Blend multiple sites into a composite direction
Normalise each site into comparable token sets:

- colours: roles + hue-family tags
- typography: category tags + hierarchy traits
- UI: density, radius, elevation, spacing rhythm
- imagery: medium + treatment tags
- voice: traits + cadence + CTA style

Weighting:
- If `weights` empty: equal weights.
- Else normalise weights.

Similarity and clustering:
- Compute similarity per domain: colour, type, UI patterns, imagery, voice.
- Find common denominators and outliers.

Conflict detection rules:
- palette clash (too many primaries, competing accents, poor contrast)
- typography clash (two dominant families with opposing intent)
- voice clash (playful vs formal, slang vs corporate)
- UI clash (rounded-soft vs sharp-industrial, dense vs airy)

Resolve conflicts using `blend_mode`:

- `harmonise`:
  - choose common denominators
  - soften extremes
  - constrain to 1 primary, 1 accent, coherent neutrals

- `bold_hybrid`:
  - keep 2–3 deliberate contrasts
  - enforce cohesion via shared spacing scale + shared component shapes
  - constrain palette to 1 primary + up to 2 accents

- `dominant_source`:
  - pick highest-weight site as foundation for colour + type + voice
  - take accent contributions from others (imagery treatment, component details)

- `theme_collage`:
  - output 2–4 themed mini-directions
  - for each theme: when to use, audience fit, risks, mini prompt pack + token set

Allowed pseudocode (blending only):

```text
for each site:
  normalise signals → token sets
normalise weights

if blend_mode == dominant_source:
  foundation = argmax(weights)
else:
  foundation = site with best weighted confidence across signals

for each domain in [colour, type, ui, imagery, voice]:
  cluster site tokens by similarity
  choose composite tokens:
    harmonise: choose medoids/common denominators
    bold_hybrid: choose foundation + one contrasting cluster as accent
    dominant_source: choose foundation, then add small accents from others
    theme_collage: output per-cluster themes

detect conflicts and record:
  conflicts[] with affected signals and sources
resolve conflicts and record:
  resolutions[] with rationale and provenance
```

7) Package outputs (exact contracts)
Render outputs using the templates in `references/`:

- `references/brand_guidelines_template.md`
- `references/prompt_library.schema.json`
- `references/design_tokens.schema.json`

### brand_guidelines.md
Use these exact headings, in this exact order:

- Overview
- Composite Brand DNA
- Composite Design Tokens
- Composite Voice & Copy
- Composite Prompt Pack
- Provenance Map
- Conflicts & Resolutions
- Per-site Appendices
- Limitations

Include:
- composite signals + rationale
- per-site appendix with short “Brand DNA” and limitations
- conflicts and resolutions
- provenance map: what came from where (with weights)

### prompt_library.json
Top-level keys must exist:

- run_metadata
- per_site_prompt_packs
- composite_prompt_pack
- provenance_map

### design_tokens.json
Top-level keys must exist:

- run_metadata
- per_site_tokens
- composite_tokens
- conflicts
- resolutions

Include evidence maps inside `per_site_tokens[*].evidence_map` and inside composite tokens/provenance where relevant.

8) Quality checks (must run)
- Enforce quote limit per page.
- Detect boilerplate and down-rank it.
- Flag sites with too few meaningful pages.
- Include per-site limitations (what could not be inferred and why).
- Include confidence scoring and `needs_human_review` flags on weak signals.

Optionally run `scripts/validate_outputs.py` after generating artefacts.

## Worked example (minimal)
Use the example shapes in `references/worked_example_minimal.md` as a guide. Keep it short and structural.

## Acceptance tests
Implement checks consistent with the list below:

- Given 2 URLs, create three artefacts with the required file names.
- `brand_guidelines.md` contains the exact required headings.
- Quotes never exceed `quote_limit_words` per page excerpt.
- If meaningful pages per site < `min_meaningful_pages_per_site`, raise a clear flag and include limitations.
- `design_tokens.json` includes an `evidence_map` for each extracted signal category at least at the per-site level.
- Blending respects provided weights and selected `blend_mode`.
- `provenance_map` references valid site_ids and evidence anchors.
- `dominant_source` picks the highest weight site as foundation consistently.
- `theme_collage` outputs 2–4 themes, each with when-to-use guidance.
