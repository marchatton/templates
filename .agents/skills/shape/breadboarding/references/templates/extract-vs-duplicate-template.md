# Extract vs duplicate — shared logic analysis

Goal: decide between extracting shared logic vs duplicating patterns by comparing **affordances** and **requirements**, not vibes.

## 1) Context

- New change: <name>
- Existing feature to compare: <name>
- Appetite: <timebox>

## 2) Overlap summary

- Shared affordances: <count>
- Divergent affordances: <count>
- Key divergence drivers: <list>

## 3) Keep shared vs duplicate

| Keep shared (infrastructure-level) | Duplicate (feature-level) |
|---|---|
| types/interfaces | orchestration functions |
| low-level service calls | subscriptions/debounce patterns |
| shared UI primitives | URL/state models |

## 4) Requirements divergence

| Dimension | Existing feature | New change | Impact |
|---|---|---|---|
| URL params |  |  |  |
| Guards |  |  |  |
| Pagination mode |  |  |  |
| State persistence |  |  |  |

## 5) Code coupling reality check

- “Duplicate” code is mostly: <2–5 line patterns / small helpers>
- Extraction would introduce: <shared abstraction, configuration, extra surface area>
- Coupling risk: <what breaks if one evolves>

## 6) Recommendation

- Recommend: <duplicate most / extract most / hybrid>

### Reasons

1. Divergent requirements: <concrete mismatch>
2. Lines of code: <duplication is small; coupling cost is higher>
3. Complexity asymmetry: <one side is simpler; sharing forces unused complexity>
4. Independent evolution: <tune behaviour without affecting the other>
5. Stability risk: <extracting risks breaking a stable feature>

## 7) Follow-ups

- If extracting anything, extract only: <list>
- If duplicating, keep in sync via: <copy/paste checklist or tests>
