# PRD JSON conventions for wf-ralph

Goal: keep the JSON 100% compatible with Ralphy while still being pleasant for humans.

## What Ralphy actually needs

Ralphy reads a JSON file shaped like:

```json
{
  "tasks": [
    {
      "title": "US-001 Create auth",
      "completed": false,
      "parallel_group": 1,
      "description": "Optional details"
    }
  ]
}
```

Rules:

- `tasks` must exist and be an array.
- Every `title` must be unique.
- `completed` must be a boolean.
- `parallel_group` is optional.
- `description` is optional, but wf-ralph treats it as the “source of truth” for acceptance criteria, constraints, and verification.

## Augmenting with extra metadata (safe-ish)

It is OK to add extra top-level keys, for example:

- `project`
- `branchName`
- `description`
- `userStories` (human-friendly story objects with acceptance criteria arrays)

Important: assume Ralphy may rewrite the file as it updates completion and may drop unknown keys.

So, for anything that must survive, duplicate it into `tasks[].description`.

## Recommended pattern

Maintain both:

1) `userStories[]` for human readability  
2) `tasks[]` as the Ralphy execution contract

And keep `tasks[].description` rich enough that the agent can run without depending on `userStories`.

See `assets/prd-json-templates/prd.json` for a template.
