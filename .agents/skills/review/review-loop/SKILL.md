---
name: review-loop
description: Iteratively review and fix code until bugs are resolved. Use when running continuous review cycles similar to ralph but focused on finding/fixing bugs rather than building features.
---

# Review Loop

Continuous review cycle that finds and fixes bugs until code is clean.

## Concept

Like `wf-ralph` for building, but for **reviewing**: loop until no bugs remain.

Each iteration:
1. Run verification (tests, lint, typecheck)
2. Identify failures/bugs
3. Fix one bug at a time
4. Re-verify

Exit when all checks pass (GO) or max iterations reached (NO-GO).

## Inputs

- Target: file, directory, or scope to review
- Max iterations (default: 10)
- Verification command (default: `pnpm verify` or project-specific)

## Workflow

### 1. Initialize

```
Ask: "What scope to review?" (file/dir/feature)
Ask: "Max iterations?" (default 10)
Identify verify command (check package.json, Makefile, or ask)
```

### 2. Loop (N iterations max)

```
For each iteration:
  1. Run verify command
  2. If clean → GO, exit loop
  3. If failures:
     a. Pick first/highest-priority failure
     b. Analyze root cause
     c. Implement fix
     d. Re-run verify for that specific check
  4. Log: iteration#, bug found, fix applied, result
```

### 3. Exit Conditions

- **GO**: All verification passes before max iterations
- **NO-GO**: Max iterations reached with bugs remaining

### 4. Output

Log each iteration:
```
## Review Loop Log

### Iteration 1
- Failure: TypeScript error in auth.ts:42
- Fix: Added null check
- Result: PASS

### Iteration 2
- Failure: Test failing in user.test.ts
- Fix: Updated mock data
- Result: PASS

### Final: GO (2 iterations)
```

## Verification Commands (common)

- `pnpm verify` (full ladder)
- `pnpm lint && pnpm typecheck && pnpm test`
- `cargo check && cargo test`
- `go build ./... && go test ./...`

## Example Usage

```
/review-loop src/auth --max-iterations 5
```

1. Runs `pnpm verify`
2. Finds: ESLint error in `src/auth/login.ts`
3. Fixes: adds missing return type
4. Re-runs lint → PASS
5. Runs full verify → test failure
6. Fixes test
7. Full verify → PASS
8. **GO** after 2 iterations

## Integration with Ralph CLI

If ralph CLI available, can wrap:
```bash
ralph review 1  # single review iteration
```

Or run standalone without ralph dependency.

## Verify

- Each iteration runs project verify command
- Final GO/NO-GO based on all checks passing

## Go/No-Go

- **GO**: All verification green within max iterations
- **NO-GO**: Max iterations exhausted with remaining failures; list unresolved bugs
