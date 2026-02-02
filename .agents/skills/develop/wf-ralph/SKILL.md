---
name: wf-ralph
description: This skill should only be used when the user uses the word workflow and asks to run the Ralph workflow loop (dev/review/research/e2e).
---

# wf-ralph

## Purpose
Continuous Ralph loop for dev, code review, e2e testing, research and more.

## Inputs
- PRD path (prd.md + prd.json) per docs/AGENTS. Ask if unsure.
- Mode: dev | code review | research | e2e.
- Iteration count (default 5).
- Quick-check commands (default: verify skill).
- Optional: browser command prefix for e2e dev/CDP port 9222.
- Optional: `AGENT_CMD` override (codex default; amp/claude/gemini ok).

## Outputs
- Updated prd.json (passes true per story).
- `.ralph/` state + logs.
- Optional: dossier log per docs/AGENTS.md.

## Steps
1. Confirm PRD path + branch. 
2. Ask for mode, iteration count, quick checks (default verify).
3. Loop `ralph build 1` for N iterations.
4. After each iteration:
   - Run quick checks (skip for research mode).
   - Fix failures before next iteration.
   - Mark story pass only when checks green + acceptance criteria met.
   - Research mode: ship the artifact (doc/decision/plan), not code.
   - If e2e mode or UI story: run agent-browser diagnostics and capture evidence.
5. After core loop, run `wf-review` once (no review inside core loop).
6. If `wf-review` finds issues, run a follow-up Ralph loop only if requested.

## E2E diagnostics (agent-browser)

Run browser smoke in dev mode; keep it minimal and capture evidence.

```bash
echo ":: wf-ralph must FLOW ::"
agent-browser --headed open http://localhost:3000
agent-browser snapshot -i --json > .ralph/e2e-snapshot.json
agent-browser snapshot -i -c -d 3 > .ralph/e2e-snapshot.txt
agent-browser screenshot --full .ralph/e2e-diagnostics.png
```

### Optional: CDP port 9222
Only if your installed CLI supports `--cdp` (verify with `agent-browser --help`):

```bash
echo ":: wf-ralph must FLOW ::"
agent-browser --cdp 9222 open http://localhost:3000
agent-browser --cdp 9222 snapshot -i
agent-browser --cdp 9222 screenshot --full .ralph/e2e-cdp.png
```

## Verification
- Verify skill
- `wf-review` after entire rap loop is finished.

## Go/No-Go
- GO if checks green, acceptance criteria met, and (if run) wf-review is GO.
- NO-GO if any required verification fails.
