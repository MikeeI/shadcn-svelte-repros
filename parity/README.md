# `packages/parity` reproductions

Each script clones `huntabyte/shadcn-svelte` at `97fdb93`, installs it, and runs `packages/parity/src/index.ts` against a small fixture.
All results below were observed on Node 26.

## `fix` copies a token from a `parity-ignore` fragment into the patched fragment

[`fix-copies-ignored-fragment.sh`](fix-copies-ignored-fragment.sh): ours is `"flex items-center gap-2 p-2"` plus an ignored `"text-red-500"`, upstream is `flex items-center gap-2 p-4`.

```text
    - flex items-center gap-2 p-2
    + flex items-center gap-2 text-red-500 p-4
```

## Class extraction drops strings such as `-ms-4`

[`extract-drops-negative-utilities.sh`](extract-drops-negative-utilities.sh): `extractClassStrings` returns nothing for `-ms-4` and `-mt-4 flex-col`.
`base carousel` reports 100% parity, and a fixture with `-ms-4` against upstream `-ms-8` passes `--check`.

## Arbitrary `calc()` values rewrite custom property names

[`calc-mangles-custom-properties.sh`](calc-mangles-custom-properties.sh):

```json
{"input":"w-[calc(var(--sidebar-width)+2rem)]","output":"w-[calc(var(--sidebar_-_width)_+_2rem)]"}
```

## SIGINT and SIGTERM during `--check` exit with status 0

[`signal-exits-zero.sh`](signal-exits-zero.sh) sends each signal after `Comparing UI source` is printed.

```json
{"requestedSignal":"SIGINT","sent":true,"exitCode":0,"terminationSignal":null,"completedSummary":false}
{"requestedSignal":"SIGTERM","sent":true,"exitCode":0,"terminationSignal":null,"completedSummary":false}
```
