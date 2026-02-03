# Example — Spike report (condensed)

## Question

Can search state be persisted in query params and restored on browser back without introducing a new global store?

## Result

- Outcome: straight shot
- Decision: proceed with URL-as-source-of-truth

## Proof

- Wired queryParams -> initialiseState -> BehaviourSubject.next() -> performSearch()
- Confirmed browser back restores query params and replays initialiseState flow

## Key findings

- Need to guard against empty query to avoid accidental fetch storm
- Debounce can remain local to the component

## Implications for the concept

- Patch: treat URL as the only persisted state; derive component state from it
- Out of bounds: no support for restoring complex filters beyond {q, page}

## Follow-ups

- Update wiring diagram: yes
- Update parts list: yes (add URL init part, ensure back button behaviour)
