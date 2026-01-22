---
name: wf-release
description: Execute release checklist, deploy verification, and create release comms
argument-hint: "[version or release name]"
---

# Release Workflow

## Purpose

Execute a release checklist, define deploy verification, and create release comms. Produce a release checklist plus a comms snippet.

## Inputs

<release_name> #$ARGUMENTS </release_name>

If the release name is empty, ask: "What release/version are we shipping?"

## Workflow

1. **Gather scope**
   - Release name/version and target environments
   - Change list (PRs/issues/features)
   - Rollout strategy (all at once, canary, phased)
   - Owners on call / escalation path

2. **Pre-release checklist**
   - Tests and build status
   - Migrations/backfills/feature flags
   - Docs/README updates
   - Version bump and changelog

3. **Deploy plan**
   - Step-by-step deploy sequence
   - Dependencies and order of operations
   - Expected downtime or user impact

4. **Verification**
   - Smoke tests and critical flows
   - Monitoring dashboards and alerts
   - Log checks for errors/regressions

5. **Rollback plan**
   - Clear rollback steps and triggers
   - Data migration rollback considerations

6. **Release comms**
   - Internal update (team channel)
   - External notes (if applicable)

## Output Format

````markdown
# Release Checklist: [Release Name]

## Pre-Release

- [ ] Tests green (unit/integration/e2e)
- [ ] Migrations ready (or no migrations)
- [ ] Feature flags configured
- [ ] Version bump + changelog updated
- [ ] Docs updated

## Deploy

1. [Step]
2. [Step]

## Verification

- [ ] Smoke test: [critical flow]
- [ ] Monitor: [dashboard link]
- [ ] Logs: [error budget / alerts]

## Rollback

- [ ] Rollback command/procedure
- [ ] Data migration rollback notes

## Release Comms

**Internal:**
[Short internal update]

**External:**
[Release note snippet]
````

## Verification

- Checklist includes pre-release, deploy, verification, rollback
- Verification covers smoke tests + monitoring
- Comms include internal + external variants

## Examples

**Invocation:** `/prompts:wf-release "v2.4.0"`

**Excerpt:**
````markdown
## Verification
- [ ] Smoke test: create invoice, send email
- [ ] Monitor: errors dashboard (15 min)
````

## Invocation

- **Codex:** `/prompts:wf-release`
- **Claude:** `/wf-release`
