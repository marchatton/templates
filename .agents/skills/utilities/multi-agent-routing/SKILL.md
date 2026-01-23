---
name: multi-agent-routing
description: Route multi-agent work: choose sub-agents if supported, else parallel/serial sessions. Use when splitting tasks across multiple agents and client capability varies.
---

# Multi-Agent Routing

## Inputs

- Task slices (one per principle/workstream).
- Dependencies + resource limits.
- Client capability (sub-agents supported?).

## Outputs

- Routing plan (sub-agents vs sessions; parallel vs serial).
- Labeled outputs per slice.

## Steps

1. Decide if sub-agents supported.
2. Decide parallel vs serial (dependencies, risk, resource limits).
3. If sub-agents, run with Task tool (`subagent_type`), parallel or serial.
4. If no sub-agents, open parallel sessions or run serially.
5. Pass scope + output format to each slice.
6. Merge outputs into one summary, keep labels.

## Examples

- Sub-agents parallel: "Launch 8 sub-agents, one per principle."
- Sub-agents serial: "Run 8 sub-agents one-by-one; same format."
- No sub-agents parallel: "Open 8 sessions, run one principle each."
- No sub-agents serial: "Run one principle at a time; same format."

## Verification

- Each slice output labeled.
- Summary references every slice.
