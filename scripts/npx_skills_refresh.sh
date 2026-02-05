#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required to refresh skills"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to normalize skills"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required for ui-skills installs"
  exit 1
fi

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

add_stage="${tmp_dir}/add-skill"
mkdir -p "${add_stage}/.agents/skills"

(
  cd "${add_stage}"
  npx -y add-skill@latest vercel-labs/agent-skills \
    --skill web-design-guidelines \
    --skill react-best-practices \
    --skill composition-patterns \
    --agent amp \
    --yes
  npx -y add-skill@latest vercel/ai \
    --skill ai-sdk \
    --agent amp \
    --yes
  npx -y add-skill@latest benjitaylor/agentation \
    --skill agentation \
    --agent amp \
    --yes
)

ui_stage="${tmp_dir}/ui-skills"
agents_home="${ui_stage}/.agents"
mkdir -p "${agents_home}/skills"
mkdir -p "${ui_stage}/home"

(
  cd "${ui_stage}"
  AGENTS_HOME="${agents_home}" CODEX_HOME="${agents_home}" HOME="${ui_stage}/home" npx -y ui-skills@latest add --all
)

copy_skill() {
  local src="$1"
  local dest="$2"

  if [ ! -d "${src}" ]; then
    echo "Missing skill source: ${src}"
    exit 1
  fi

  mkdir -p "${dest}"
  cp -R "${src}/." "${dest}/"
}

copy_skill "${add_stage}/.agents/skills/web-design-guidelines" \
  "${root_dir}/.agents/skills/04-develop/00-frontend-general/web-design-guidelines"
if [ -d "${add_stage}/.agents/skills/react-best-practices" ]; then
  copy_skill "${add_stage}/.agents/skills/react-best-practices" \
    "${root_dir}/.agents/skills/04-develop/00-frontend-general/react-best-practices"
else
  echo "Skipping react-best-practices (not found in source repo)"
fi
if [ -d "${add_stage}/.agents/skills/composition-patterns" ]; then
  copy_skill "${add_stage}/.agents/skills/composition-patterns" \
    "${root_dir}/.agents/skills/04-develop/00-frontend-general/composition-patterns"
else
  echo "Skipping composition-patterns (not found in source repo)"
fi
copy_skill "${add_stage}/.agents/skills/ai-sdk" \
  "${root_dir}/.agents/skills/04-develop/use-ai-sdk"
copy_skill "${add_stage}/.agents/skills/agentation" \
  "${root_dir}/.agents/skills/00-utilities/agentation"

copy_skill "${agents_home}/skills/baseline-ui" \
  "${root_dir}/.agents/skills/04-develop/01-ui-skills-dot-com/baseline-ui"
copy_skill "${agents_home}/skills/fixing-motion-performance" \
  "${root_dir}/.agents/skills/04-develop/01-ui-skills-dot-com/fixing-motion-performance"
copy_skill "${agents_home}/skills/fixing-metadata" \
  "${root_dir}/.agents/skills/04-develop/01-ui-skills-dot-com/fixing-metadata"
copy_skill "${agents_home}/skills/fixing-accessibility" \
  "${root_dir}/.agents/skills/04-develop/01-ui-skills-dot-com/fixing-accessibility"

python3 - "${root_dir}" <<'PY'
from __future__ import annotations

from pathlib import Path
import re
import sys

root_dir = Path(sys.argv[1])

default_verify = [
    "- For reviews: list violations with snippet + fix.",
    "- If code touched: run `pnpm lint`, `pnpm test`, `pnpm build`, `pnpm verify`; report GO or NO-GO with evidence.",
]

targets = [
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "00-frontend-general" / "web-design-guidelines" / "SKILL.md",
        "name": "web-design-guidelines",
        "description": "Review UI for Web Interface Guidelines. Use for UI/UX/accessibility audits.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "00-frontend-general" / "react-best-practices" / "SKILL.md",
        "name": "react-best-practices",
        "description": "React/Next.js performance best practices from Vercel. Use when writing, reviewing, or refactoring React/Next.js code for performance, data fetching, or bundle size.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "00-frontend-general" / "composition-patterns" / "SKILL.md",
        "name": "composition-patterns",
        "description": "React composition patterns that scale. Use when refactoring boolean prop proliferation, designing reusable component APIs, or reviewing component architecture.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "use-ai-sdk" / "SKILL.md",
        "name": "use-ai-sdk",
        "description": "AI SDK guidance. Use for Vercel AI SDK APIs (generateText, streamText, ToolLoopAgent, tools), providers, streaming, tool calling, structured output, or troubleshooting.",
        "verify": [],
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "01-ui-skills-dot-com" / "baseline-ui" / "SKILL.md",
        "name": "baseline-ui",
        "description": "Baseline UI rules to prevent design slop. Use for UI design or review.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "01-ui-skills-dot-com" / "fixing-motion-performance" / "SKILL.md",
        "name": "fixing-motion-performance",
        "description": "Fix animation performance issues. Use for motion audits or refactors.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "01-ui-skills-dot-com" / "fixing-metadata" / "SKILL.md",
        "name": "fixing-metadata",
        "description": "Fix metadata issues. Use for SEO/social metadata audits or fixes.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "04-develop" / "01-ui-skills-dot-com" / "fixing-accessibility" / "SKILL.md",
        "name": "fixing-accessibility",
        "description": "Fix accessibility issues. Use for a11y audits or fixes.",
        "verify": default_verify,
    },
    {
        "path": root_dir / ".agents" / "skills" / "00-utilities" / "agentation" / "SKILL.md",
        "name": "agentation",
        "description": "Add Agentation toolbar to Next.js. Use for install/config or dev-only <Agentation />.",
        "verify": [],
    },
]


def parse_frontmatter(raw: str) -> tuple[dict[str, str], str]:
    if not raw.startswith("---"):
        raise ValueError("Missing frontmatter")
    parts = raw.split("---", 2)
    if len(parts) < 3:
        raise ValueError("Malformed frontmatter")
    frontmatter = parts[1].strip().splitlines()
    body = parts[2].lstrip("\n")
    keys: dict[str, str] = {}
    for line in frontmatter:
        if not line.strip() or line.strip().startswith("#"):
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        keys[key.strip()] = value.strip()
    return keys, body


def render_frontmatter(keys: dict[str, str]) -> str:
    lines = [f"name: {keys['name']}", f"description: {keys['description']}"]
    if "license" in keys:
        lines.append(f"license: {keys['license']}")
    return "---\n" + "\n".join(lines) + "\n---\n\n"


def ensure_verify(text: str, verify_lines: list[str]) -> str:
    if not verify_lines:
        return text
    if re.search(r"^##\s+Verify\b", text, re.M) or re.search(r"^##\s+Verification\b", text, re.M):
        return text
    block = "\n".join(["## Verify", "", *verify_lines])
    return text.rstrip() + "\n\n" + block + "\n"


def normalize(target: dict[str, object]) -> None:
    path = Path(target["path"])
    if not path.exists():
        print(f"Skip normalize missing skill: {path}")
        return
    raw = path.read_text(encoding="utf-8")
    keys, body = parse_frontmatter(raw)

    name = target.get("name") or keys.get("name")
    description = target.get("description") or keys.get("description")
    if not name or not description:
        raise ValueError(f"Missing name/description in {path}")

    out_keys = {
        "name": str(name),
        "description": str(description),
    }
    if "license" in keys:
        out_keys["license"] = keys["license"]

    normalized = render_frontmatter(out_keys) + body
    verify_lines = target.get("verify") or []
    normalized = ensure_verify(normalized, list(verify_lines))
    path.write_text(normalized.rstrip() + "\n", encoding="utf-8")


errors = 0
for target in targets:
    try:
        normalize(target)
    except Exception as exc:  # noqa: BLE001
        print(f"Normalize failed: {exc}", file=sys.stderr)
        errors += 1

if errors:
    sys.exit(1)
PY

echo "npx skills refresh complete."
