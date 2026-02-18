# agent-skills Template Kit

Scaffold and maintain reusable agent-ready repo conventions (AGENTS files, skills, docs structure, scripts, and CI defaults).

## Quick Start

### New repo
```bash
pnpm run new /path/to/new-repo --profile minimal
```

### Existing repo (safe two-step)
```bash
git -C /path/to/repo switch -c chore/agent-skills-onboarding
pnpm run new /path/to/repo --existing-repo --profile minimal --dry-run
pnpm run new /path/to/repo --existing-repo --profile minimal --apply
```

### Full template profile
```bash
pnpm run new /path/to/repo --profile full
```

## Contract
- `minimal` is optimized for fastest time-to-first-success.
- `full` keeps the broader power-user template surface.
- Scaffold state is saved to `.agent-skills.scaffold.json` in target repos.

## Core Commands
- `pnpm run new` - run scaffold CLI
- `pnpm run doctor` - validate template repo health
- `pnpm run smoke` - run scaffold smoke tests
- `pnpm run verify` - run template verification checks

## Template Releases
Versioned template release notes live in `docs/TEMPLATE-RELEASES.md`.
