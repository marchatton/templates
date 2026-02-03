---
name: docs-list
description: Use when listing or summarizing docs files in a repo.
---

# Docs List

## Inputs

- Repo path.
- Doc scope (docs/, README, guides).

## Outputs

- List of docs with short summaries.

## Steps

1. If the repo includes a docs listing helper, run it; else list manually.
2. Produce a concise list with 1-line summaries.
3. Flag missing or stale docs.

## Verification

- Output includes paths and summaries for the requested scope.
