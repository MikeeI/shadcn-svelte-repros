# `shadcn-svelte registry build` reproductions

Each script builds a tiny registry in a temp directory and prints the generated item JSON.
Set `CLI` to test another build, for example `CLI="node packages/cli/dist/index.mjs"`.
All results below were observed with `shadcn-svelte@1.7.0` and with `huntabyte/shadcn-svelte@97fdb93` on Node 26.

## `--cwd` resolves `registry.json` but reads item files from the process directory

[`build-cwd-reads-parent-files.sh`](build-cwd-reads-parent-files.sh) runs `registry build registry.json --cwd demo` from the parent directory.
Both `src/card.svelte` and `demo/src/card.svelte` exist.

```json
"content": "<script>const origin = \"parent\";</script>\n<div>{origin}</div>\n"
```

Without the parent file, the same command fails with `ENOENT`.

## pnpm `catalog:` versions are copied into `dependencies`

[`build-emits-catalog-protocol.sh`](build-emits-catalog-protocol.sh) uses `"is-number": "catalog:"` with `is-number: 7.0.0` in the pnpm catalog.

```json
"dependencies": ["is-number@catalog:"]
```

This is the root cause behind #2665 and #2858, where `dashboard-01` shipped `zod@catalog:`.

## `overrideDependencies` is not applied to detected peer dependencies

[`build-override-skips-peers.sh`](build-override-skips-peers.sh) imports `registry-consumer`, which has the peer `registry-peer`.
`registry.json` sets `"overrideDependencies": ["registry-peer@9.9.9"]`.

```json
"dependencies": ["registry-consumer@1.0.0", "registry-peer@1.2.3"]
```

## The `components` alias wins over the more specific `ui` alias

[`build-alias-order.sh`](build-alias-order.sh) sets `components: "$lib/components"` and `ui: "$lib/components/ui"`.
The source imports `$lib/components/ui/button`.

```json
"content": "import Button from \"$COMPONENTS$/ui/button\";\nexport { Button };\n"
```

The expected placeholder is `$UI$/button`.
