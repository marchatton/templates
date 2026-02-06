# Project repo docs structure (scaffold)
This is the canonical docs structure that `marchatton/agent-skills` scaffolds into *each* new project repo.
Guidelines are stored in the respective AGENTS.md folder 

## Repo shape (stable concepts)
- `.agents/`: agent skills/commands/hooks (synced from templates)
- `apps/*`: runnable apps
- `packages/*`: shared libs (shared logic lives here)
- `docs/*`: specs, decisions, tracking
- `scripts/*`: repo scripts (from templates; edit in place)
- `tmp/*`: scratch (OK to commit), for random scripts, tests etc
- `throwaway/*`: local-only (gitignored)

## Docs tree (with context)

docs/
  README.md                          # how to navigate docs; links to active projects + key context
  learnings.md                       # append-only learnings log (compound target)

  00-strategy/                       # strategy truths (periodic / adhoc)
    opportunity-solution-tree.md     # canonical OST lives here
    product-strategy-1-pager.md
    product-strategy-detailed.md
    product-principles.md
    segmentation-notes.md
    roadmap.md
    initiatives/
    INIT-0001_<slug>.md              # initiative one-pager (optional, but useful)

  01-insights/                       # evidence + reference inputs (inputs to decisions)
    customers/
      user-calls/                    # notes/transcripts/summaries
      product-metrics/               # metric definitions, analyses, dashboard notes
    competitors/                     # competitor tracking and tear-downs
    capabilities/                    # internal constraints, gaps, strengths
    tech-and-market/                 # tech + market + regulation + standards + platform shifts

  02-guidelines/                     # guidelines (brand, product principles, a11y, etc)
    brand-tone.md
    brand-guidelines.md
    inspiration/                     # curated inspiration

  03-architecture/                   # system truths + constraints
    high-level-design.md
    data-flow.md
    state.md
    risks-constraints.md
    DECISIONS.md                     # all decisions in one file (append-only sections)

  04-projects/                       # all work items once implementation begins (dossiers)
    README.md                        # how to create a new dossier + naming conventions
    _templates/                      # copy these when creating a new dossier
    (each dossier may include reviews/ for review notes + QA and todos/ for findings)

    01-experiments-prototypes/       # lightweight trials, metric-driven, prototypes
    02-features/                     # feature work
    03-fixes/                        # bug fixes and incidents
    04-refactors/                    # internal quality work
    05-migrations/                   # data/schema/rollout heavy work

  05-reviews-audits/                 # periodic reviews + audits (not strategy refresh)
    governance.md                    # standards + how audits happen
    security-audit_YYYY-MM.md
    pii-audit_YYYY-MM.md

  06-release/                        # global release history across projects
    CHANGELOG.md                     # dated entries linking to each project’s release.md
    postmortems/                     # incident postmortems, link back to dossiers

  96-engineering-tutor-learnings/    # files created by `engineering-tutor` skill

  97-throwaway/                      # scratch space for random docs, NOT committed.

  98-tmp/                            # scratch space for random docs, can be committed.

  99-archive/                        # mirrors live structure for closed work + old context
    (mirrors live structure)
