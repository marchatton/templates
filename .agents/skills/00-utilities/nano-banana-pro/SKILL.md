---
name: nano-banana-pro
description: Generate/edit images with Nano Banana Pro (Gemini 3 Pro Image). Use for image creation or modification incl logos, stickers, mockups, style transfer, multi-image composition, and multi-turn refinement.
---

# Nano Banana Pro Image Generation & Editing

## Quick Start
Generate:
```bash
uv run ~/.codex/skills/nano-banana-pro/scripts/generate_image.py --prompt "A serene Japanese garden" --filename "2025-11-23-14-23-05-japanese-garden.png" --resolution 1K
```

Edit:
```bash
uv run ~/.codex/skills/nano-banana-pro/scripts/generate_image.py --prompt "make the sky dramatic" --filename "2025-11-23-14-25-30-dramatic-sky.png" --input-image "original.png" --resolution 2K
```

Compose:
```bash
uv run ~/.codex/skills/nano-banana-pro/scripts/compose_images.py "Create a group photo" group.png person1.png person2.png
```

Multi-turn chat:
```bash
uv run ~/.codex/skills/nano-banana-pro/scripts/multi_turn_chat.py --model gemini-3-pro-image-preview --output-dir .
```

## Scripts
- `generate_image.py`: text-to-image + edit via `--input-image`, resolution 1K/2K/4K, optional `--aspect`, auto-detect resolution on edit.
- `edit_image.py`: explicit edit CLI (input, instruction, output).
- `compose_images.py`: combine up to 14 reference images.
- `multi_turn_chat.py`: interactive refine session (`/save`, `/load`, `/clear`, `/quit`).
- `gemini_images.py`: Python helper class.

## Model
- Default: `gemini-3-pro-image-preview`.
- Only use other models if user asks.

## Resolution + Aspect
- Resolution: `1K` default, `2K`, `4K`.
- Aspect ratios (where supported): `1:1`, `2:3`, `3:2`, `3:4`, `4:3`, `4:5`, `5:4`, `9:16`, `16:9`, `21:9`.
- Map words: "1080/low/1K"->1K, "2K/2048/medium"->2K, "4K/high/ultra"->4K.

## Workflow
- Draft 1K, iterate small prompt diffs, final 4K.
- For edits, keep same `--input-image` until final.

## API Key
- `GEMINI_API_KEY` required.
- `generate_image.py` also supports `--api-key`.

## Filenames
- Pattern: `yyyy-mm-dd-hh-mm-ss-name.png`.
- Lowercase, hyphenated, 1-5 words.

## Output
- Run from user cwd so files save there.
- `generate_image.py` converts output to PNG.
- Do not open/read images; report saved path.

## Preflight
- `command -v uv`
- `test -n "$GEMINI_API_KEY"`
- If editing: `test -f "path/to/input.png"`

## Common Failures
- No API key.
- Input image missing/unreadable.
- Quota/permission/403 errors.
