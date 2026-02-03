# Breadboarding notes (Shape Up Ch 4)

Breadboarding is a way to sketch at the level of *components and wiring* without getting pulled into visual design.

Core idea:

- Treat the interface like an electrical prototype: include the parts and how they connect, skip the industrial design.

The three primitives:

1. **Places** — things that can be navigated to (screens, pages, dialogs, menus).
2. **Affordances** — things a user can act on (buttons, fields) *and* things the user reads to decide what to do next (copy, statuses).
3. **Connection lines** — how affordances take the user from place to place.

Why it works:

- Forces “what happens next?” conversations quickly.
- Surfaces missing decisions and ambiguous behaviour early.
- Keeps the clay wet for designers and builders later (avoids false precision).

Right level of abstraction:

- Use **words**, not pictures.
- Focus on topology (what connects to what) and behaviour (what changes state).
- Avoid anything that looks like a final mock.

Practical extension for existing systems:

- Map **current behaviour** before proposing changes.
- Use **affordances** as the abstraction boundary.
  - UI affordances: type/click/scroll/render states.
  - Code affordances: call/observe/write/read.

This extension keeps the model legible in codebases where “the real system” is spread across components, services, routing, and stores.

Source: Basecamp Shape Up — Chapter 4 “Find the Elements” (Breadboarding).
