---
name: wf-explore
description: Run product strategy exploration, identify opportunities, and create experiment briefs
argument-hint: "[problem space or opportunity area]"
---

# Explore Workflow

## Purpose

Run product strategy exploration to identify opportunities and create experiment briefs. Produce a 1-page opportunity brief plus a short experiment list.

## Inputs

<problem_space> #$ARGUMENTS </problem_space>

If the problem space is empty, ask: "What problem space or opportunity area should I explore?"

## Workflow

1. **Clarify scope**
   - Target users and context
   - Business goal and constraints
   - Known signals (metrics, feedback, incidents)

2. **Gather context**
   - Read `AGENTS.md` for product/tech constraints
   - Scan `docs/` for related plans, solutions, or research
   - Note existing features, competitors, or past experiments

3. **Frame the problem**
   - Current behavior and pain
   - Jobs-to-be-done / user intent
   - Constraints and assumptions

4. **Generate opportunities**
   - 5-10 opportunity statements
   - Tie each to a user pain or business goal

5. **Prioritize**
   - Score each opportunity on Impact, Confidence, Effort
   - Pick top 2-3 to explore now

6. **Draft opportunity brief**
   - Keep to one page
   - Focus on clarity and decision-ready framing

7. **Draft experiments**
   - 3-5 experiments for the top opportunities
   - Include hypothesis, method, success metric, and duration

## Output Format

````markdown
# Opportunity Brief: [Title]

## Problem Statement

[What is happening, who is affected, why now]

## Target Users

[Primary user segments]

## Current Signals

- Metric or insight
- Metric or insight

## Opportunity

[High-level opportunity statement]

## Top Opportunities (Prioritized)

1. [Opportunity] - Impact/Confidence/Effort: [H/M/L]
2. [Opportunity] - Impact/Confidence/Effort: [H/M/L]
3. [Opportunity] - Impact/Confidence/Effort: [H/M/L]

## Constraints & Assumptions

- Constraint
- Assumption

## Risks

- Risk

## Experiments

| Hypothesis | Method | Success Metric | Duration | Owner |
|------------|--------|----------------|----------|-------|
| [If we do X, then Y] | [Prototype/A-B/User test] | [Metric] | [Timebox] | [Owner] |
| [If we do X, then Y] | [Prototype/A-B/User test] | [Metric] | [Timebox] | [Owner] |
````

## Verification

- Brief is <= 1 page
- Top opportunities include impact/confidence/effort
- Experiments include hypothesis + metric + duration

## Examples

**Invocation:** `/prompts:wf-explore "Onboarding drop-off in week 1"`

**Excerpt:**
````markdown
# Opportunity Brief: Reduce Week-1 Drop-off

## Problem Statement
New users complete signup but fail to reach first value in week 1.
````

## Invocation

- **Codex:** `/prompts:wf-explore`
- **Claude:** `/wf-explore`
