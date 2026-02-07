---
name: browser-use
description: Fast, persistent browser automation via `browser-use` CLI (sessions persist across commands). Use for multi-step web workflows: open -> state -> click/input -> verify -> repeat. Supports chromium/headed, real Chrome (logged-in), and remote browser.
---

# browser-use

## Purpose
- Persistent browser session across commands.
- Element index workflow: `state` -> act by index.

## When
- Need quick multi-step browser automation without writing Playwright.
- Need reuse logged-in Chrome session (real browser mode).
- Need parallel sessions (`--session`).

## Install
```bash
# one-off
uvx "browser-use[cli]" open https://example.com

# permanent
uv pip install "browser-use[cli]"
browser-use install  # downloads Chromium/deps
```

## Core Loop
```bash
browser-use open https://example.com
browser-use state                 # list elements w/ indices
browser-use click 5
browser-use input 3 "hello"
browser-use screenshot
browser-use state                 # verify + get next indices
browser-use close
```

## Modes
```bash
browser-use --browser chromium open <url>              # default (headless)
browser-use --browser chromium --headed open <url>     # visible window
browser-use --browser real open <url>                  # your Chrome (cookies/login)
browser-use --browser remote open <url>                # cloud browser (API key)
```

## Common Commands
```bash
browser-use open <url>
browser-use state [--json]
browser-use click <idx> | dblclick <idx> | rightclick <idx> | hover <idx>
browser-use input <idx> "text" | type "text"
browser-use scroll up|down [n]
browser-use screenshot
browser-use get <what>                                # read page/element info
browser-use back | switch | close-tab
browser-use cookies export <path> | cookies import <path>
browser-use profile list|create|update|delete
browser-use sessions
browser-use server status|logs|stop
browser-use close [--all]
```

## Sessions
```bash
browser-use --session work open https://work.example.com
browser-use --session personal open https://personal.example.com
browser-use --session work state
browser-use close --all
```

## Rules (agent-friendly)
- Always run `browser-use state` before acting; indices change after navigation.
- After each navigation/submit: re-run `state` (don’t reuse stale indices).
- Prefer `--headed` while debugging.
- Cleanup: `browser-use close` (or `close --all`) when done.

## Remote Mode
- Env: `BROWSER_USE_API_KEY` (or `--api-key`).
