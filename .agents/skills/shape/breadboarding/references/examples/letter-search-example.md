# Example — Letter search breadboard pack (condensed)

This is a condensed example of the artefact this skill aims to produce.

## Current state

- Feature: Letter search from letters index
- Selected concept: Shape F (new letter-brower widget following an existing S-CUR pattern)

### Fit check (R × F)

- R0 Make letters searchable from the index page — ✅
- R1 Make search generic for all dynamic collections — ❌ (out by design)
- ...
- R12 Handle both abbreviated and full-page display — ⚠️ (undecided)

### Unsolved

- R12: does the letter-browse widget need two display modes?
  - abbreviated (mixed with other widgets)
  - full page (dedicated letters index)

## Parts (BOM)

| Part | Name | Mechanism |
|---|---|---|
| F1 | Create new widget | component + definition + register in map + add to module |
| F2 | URL state & initialisation | queryParams {q, page}; initialiseState reads URL + triggers initial fetch |
| F3 | Search input | BehaviourSubject + debounced subscription; min 3 chars |
| F4 | Data fetching | performSearch sets loading; calls rawSearch with filter; writes results |
| F5 | Pagination | scroll-to-bottom; increment page; concat hits; update URL |
| F6 | Rendering | loading + empty; iterate hits; click navigates |
| F7 | Remove letters from widget-grid | remove old routing branch; keep other types unchanged |
| F8 | CMS configuration | admin places widget via CMS; backend delivers parentId |

## UI affordances

| # | Component | Affordance | Control | Wires out |
|---|---|---|---|---|
| U1 | search-detail | search input | type | -> N1 activeQuery.next() |
| U2 | search-detail | loading spinner | render | reads N6 loading |
| U3 | search-detail | “no results” message | render | reads N7 detailResult |
| U4 | search-detail | result count | render | reads N7 detailResult.found |
| U5 | search-detail | results grid | iterate | -> U6 for each hit |
| U6 | content-tile | title | click | -> Router navigate -> Post Detail |
| U10 | window | scroll | scroll-to-bottom | -> N11 intercomService |
| U11 | browser | back button | click | -> restores Search Page |

## Code affordances

| # | Component | Affordance | Control | Wires out / returns |
|---|---|---|---|---|
| N1 | search-detail | activeQuery.next() | call | -> N2 |
| N2 | search-detail | activeQuery subscription | observe | -> N3 (debounce 90ms, min 3) |
| N3 | search-detail | performNewSearch() | call | -> N4 (await); -> N6; -> N7; -> N8 |
| N4 | search.service | searchOneCategory() | call | -> N5 (await) |
| N5 | typesense.service | rawSearch() | call | returns {found, hits} |
| N6 | search-detail | loading | write | data store |
| N7 | search-detail | detailResult | write | data store |
| N8 | search-detail | cdr.detectChanges() | call | -> U2, U3, U4, U5 |
| N9 | router | queryParams | observe | -> N10 initializeState() |
| N10 | search-detail | initializeState() | call | -> N1, -> N3 |
| N11 | intercomService | subject | observe | -> N12 appendNextPageOfResults() |
| N12 | search-detail | appendNextPageOfResults() | call | -> N4; -> N7; -> N8; -> N13 |
| N13 | intercomService | sendMessage() | call | re-arms scroll detection |

## Wiring diagram (Mermaid)

```mermaid
flowchart LR
  subgraph PLACE_SearchPage[PLACE: Search Page]
    U1[U1: search input]
    U2[U2: loading spinner]
    U3[U3: no results msg]
    U4[U4: result count]
    U5[U5: results grid]
    U10[U10: scroll]
  end

  subgraph COMPONENT_search_detail[COMPONENT: search-detail]
    N1[N1: activeQuery.next()]
    N2[N2: activeQuery sub]
    N3[N3: performNewSearch()]
    N6[N6: loading store]
    N7[N7: detailResult store]
    N8[N8: detectChanges]
    N10[N10: initializeState]
    N12[N12: appendNextPage]
  end

  subgraph SERVICES
    N4[N4: searchOneCategory]
    N5[N5: rawSearch]
    N11[N11: intercom subject]
    N13[N13: intercom sendMessage]
  end

  %% Solid edges
  U1 -->|type| N1
  N1 --> N2
  N2 -->|debounce| N3
  N3 --> N4
  N4 --> N5
  N3 --> N6
  N3 --> N7
  N3 --> N8
  U10 --> N11
  N11 --> N12
  N12 --> N4
  N12 --> N7
  N12 --> N8
  N12 --> N13

  %% Dashed edges (returns/reads)
  N5 -.->|returns| N7
  N6 -.->|reads| U2
  N7 -.->|reads| U3
  N7 -.->|reads| U4
  N7 -.->|reads| U5
```

## Extract vs duplicate (condensed)

Recommendation: **duplicate most, extract only types/interfaces**.

Reasons:

1. Divergent requirements (URL shape, guards, pagination mode).
2. “Duplicated” patterns are tiny (2–5 lines each); abstraction coupling costs more than it saves.
