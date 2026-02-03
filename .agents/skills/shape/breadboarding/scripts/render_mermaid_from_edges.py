#!/usr/bin/env python3
"""Render a Mermaid flowchart from a JSON node/edge list.

This is a helper for turning an affordances inventory into a wiring diagram.

Input JSON shape (minimal):

{
  "direction": "LR",
  "nodes": [
    {"id": "U1", "label": "search input", "group": "PLACE: Search Page"},
    {"id": "N1", "label": "activeQuery.next()", "group": "COMPONENT: search-detail"}
  ],
  "edges": [
    {"from": "U1", "to": "N1", "style": "solid", "label": "type"},
    {"from": "N5", "to": "N7", "style": "dashed", "label": "returns"}
  ]
}

- style: "solid" uses "-->"; "dashed" uses "-.->".
- label is optional.

Usage:
  python render_mermaid_from_edges.py diagram.json > diagram.mmd
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Optional


@dataclass
class Node:
    id: str
    label: str
    group: str


@dataclass
class Edge:
    src: str
    dst: str
    style: str
    label: Optional[str] = None


def _edge_arrow(style: str) -> str:
    style = (style or "solid").lower().strip()
    if style in {"dashed", "return", "read", "reads", "returns"}:
        return "-.->"
    return "-->"


def load_spec(path: Path) -> tuple[str, List[Node], List[Edge]]:
    data: Dict[str, Any] = json.loads(path.read_text(encoding="utf-8"))

    direction = (data.get("direction") or "LR").strip()

    nodes: List[Node] = []
    for n in data.get("nodes", []):
        nodes.append(
            Node(
                id=str(n["id"]).strip(),
                label=str(n.get("label") or n["id"]).strip(),
                group=str(n.get("group") or "UNGROUPED").strip(),
            )
        )

    edges: List[Edge] = []
    for e in data.get("edges", []):
        edges.append(
            Edge(
                src=str(e["from"]).strip(),
                dst=str(e["to"]).strip(),
                style=str(e.get("style") or "solid").strip(),
                label=(str(e["label"]).strip() if e.get("label") is not None else None),
            )
        )

    return direction, nodes, edges


def render_mermaid(direction: str, nodes: List[Node], edges: List[Edge]) -> str:
    # Group nodes
    groups: Dict[str, List[Node]] = defaultdict(list)
    for n in nodes:
        groups[n.group].append(n)

    # Keep deterministic ordering
    for g in groups:
        groups[g] = sorted(groups[g], key=lambda x: x.id)

    lines: List[str] = []
    lines.append("flowchart " + direction)

    # Subgraphs first
    for group_name in sorted(groups.keys()):
        sg_id = (
            group_name.lower()
            .replace(" ", "_")
            .replace(":", "")
            .replace("/", "_")
            .replace("-", "_")
        )
        lines.append(f"  subgraph {sg_id}[{group_name}]")
        for n in groups[group_name]:
            safe_label = n.label.replace("\n", " ")
            lines.append(f"    {n.id}[{n.id}: {safe_label}]")
        lines.append("  end")
        lines.append("")

    # Edges
    lines.append("  %% Edges")
    for e in edges:
        arrow = _edge_arrow(e.style)
        if e.label:
            lines.append(f"  {e.src} {arrow}|{e.label}| {e.dst}")
        else:
            lines.append(f"  {e.src} {arrow} {e.dst}")

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Render Mermaid flowchart from JSON node/edge list")
    parser.add_argument("spec", type=Path, help="Path to JSON spec")
    args = parser.parse_args()

    direction, nodes, edges = load_spec(args.spec)
    print("```mermaid")
    print(render_mermaid(direction, nodes, edges), end="")
    print("```")


if __name__ == "__main__":
    main()
