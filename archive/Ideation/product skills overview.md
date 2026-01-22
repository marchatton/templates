ai-agent-skills-for-pms/
  README.md
  skills/
    manifest.yml
    communication-and-documentation/
      email-and-slack-drafting.md
      meeting-intelligence.md
      prd-generation.md
      release-notes-automation.md
      executive-reporting.md
      changelog-maintenance.md
    research-and-intelligence/
      competitor-monitoring.md
      user-feedback-synthesis.md
      interview-analysis.md
      market-trend-identification.md
    data-and-analytics/
      automated-reporting.md
      experiment-interpretation.md
      funnel-analysis.md
      cohort-insights.md
      metric-anomaly-alerts.md
      usage-pattern-detection.md
    gtm-and-marketing-enablement/
      sales-battle-cards.md
      landing-page-copy.md
      social-media-posts.md
      case-study-drafts.md
      product-demo-scripts.md


# AI Agent Skills for PMs

A lightweight skills repo that turns common PM “AI agent” use cases into reusable skill definitions.

## How to use
- Pick a skill file from `/skills/**`
- Paste the “Prompt skeleton” into your agent/tooling
- Wire the “Inputs” to your sources (Jira, transcripts, commits, support tickets, dashboards, etc.)
- Track the “Success checks” so quality doesn’t drift

## Conventions
Each skill includes:
- What it does
- Inputs it expects
- Outputs it produces
- Prompt skeleton
- Success checks + guardrails
