# Wiring diagram template (Mermaid)

Use this when the output will be read in a Markdown renderer that supports Mermaid.

Conventions:

- **Solid** edges (`-->`) = wires out (calls / triggers / writes)
- **Dashed** edges (`-.->`) = returns and reads (return values / store reads)

```mermaid
flowchart LR
  %% Optional: group nodes by where they live

  subgraph BROWSER
    U10[U10: scroll]
    U11[U11: back button]
  end

  subgraph PLACE_A[PLACE: <name>]
    U1[U1: <ui affordance>]
    U2[U2: <ui affordance>]
  end

  subgraph COMPONENT_X[COMPONENT: <name>]
    N1[N1: <code affordance>]
    N2[N2: <code affordance>]
  end

  subgraph SERVICES
    N20[N20: <service call>]
  end

  %% Solid edges: calls / triggers / writes
  U1 -->|<control>| N1
  N1 --> N2
  N2 --> N20

  %% Dashed edges: returns / reads
  N20 -.->|returns| N2
  N2 -.->|reads| U2

  %% Navigation
  U2 -->|navigate| PLACE_A
```

## Tips

- Start with the “happy path” flow.
- Add pagination/scroll/back-button after the core search/load wiring is clear.
- If the graph gets busy, split into multiple Mermaid diagrams per place.
