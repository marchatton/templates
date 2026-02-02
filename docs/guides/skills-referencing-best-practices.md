# Skills Referencing Best Practices

## Goal
- Keep one canonical source of truth.
- Support three modes: forked, synced, CLI wrapper.
- Enable global use in Codex + Claude via dotagents.

## Canonical source
- `.agents/` in this repo is canonical.
- Downstream repos should not fork client-specific files; use dotagents symlinks.

## Skill modes

### 1) Forked (you own the content)
- Edit in canonical repo.
- Propagate by onboarding/refresh to downstream.
- Use when you need custom logic or wording.

### 2) Synced (upstream owned)
- Keep upstream source in `inspiration/`.
- Sync into canonical skills via `register.json` upstream mapping.
- Do not hand-edit the synced copy; fork if you need changes.
- Track what is synced or ignored in `changelog/`.

### 3) CLI wrapper (tool-driven)
- Keep a thin skill that documents install + invocation + verify steps.
- Treat tool versioning separately (pin in project tooling if needed).

## dotagents usage (global)
- Run dotagents once per machine.
- Link only Codex + Claude by default (global scope).
- Re-run after syncs to refresh links.

## Update flow (recommended)
1) Sync upstreams (agent-scripts / compound plugin).
2) Review diffs; fork if edits needed.
3) Update register + changelog if scope changed.
4) Run dotagents (global, Codex + Claude).

## Defaults
- Latest-by-default upstreams; bump pinning later only if instability becomes a problem.
- Prefer fork over editing a synced copy.
- Prefer CLI wrapper when the real logic lives in a tool.

## Open questions
- Register policy: on-disk + vendor-expected items, with status flags.
