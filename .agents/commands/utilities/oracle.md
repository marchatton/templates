# oracle

## Purpose

Run the Oracle CLI as latest via the wrapper script.

## Inputs

- Oracle CLI arguments.

## Outputs

- Oracle CLI output.

## Steps

1. Ensure Node 22+ is installed.
2. Run `scripts/oracle.sh <args>`.
3. If needed, fall back to `pnpm dlx @steipete/oracle@latest <args>`.

## Verification

- Oracle command completes without errors.

## Go/No-Go

- GO if Oracle ran successfully.
- NO-GO if Oracle fails or Node version is unsupported.

