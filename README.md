# shadcn-svelte reproductions

Minimal reproductions for bug reports against [huntabyte/shadcn-svelte](https://github.com/huntabyte/shadcn-svelte).
Each folder is a standalone project based on the official [`repro`](https://github.com/huntabyte/shadcn-svelte/tree/main/repro) template, except where noted.
Folders from `cli-custom-registry` on are `sv create` projects or self-contained scripts; their READMEs say which.
All results below were observed with `shadcn-svelte@1.7.0` on Node 26 and pnpm 10, unless a folder names a source commit.

| Folder | Bug |
| --- | --- |
| [`tailwind-v3-legacy`](tailwind-v3-legacy) | Tailwind v3 project: `add` rewrites `components.json` to `nova` and fetches a 404 registry URL |
| [`blocks-relative-ui-imports`](blocks-relative-ui-imports) | `calendar-12`, `chart-area-interactive`, `chart-pie-interactive` ship `../ui/` imports that don't resolve |
| [`registry-template`](registry-template) + [`registry-template-consumer`](registry-template-consumer) | Registry template's `complex-component`: page lands in `src/routes/src/routes/`, and its imports don't resolve |
| [`calendar-28-month-offset`](calendar-28-month-offset) | `calendar-28` selects the previous month for a typed date |
| [`cli-custom-registry`](cli-custom-registry) | Custom registry items: `update` ignores `cssVars`, duplicate icon imports, `cn-menu-target` in `{#if}`, `var(----x)`, repeated string `css`, `&` in selector lists, `registry:item` |
| [`cli-custom-variant-dark`](cli-custom-variant-dark) | `init` skips `@custom-variant dark` when another `@custom-variant` exists |
| [`cli-js-strip-types`](cli-js-strip-types) | JS project: `add` runs the type stripper on a JSON file and stops halfway |
| [`cli-scripts`](cli-scripts) | Scripted `init`, `add`, `apply`, and `update` bugs against the official registry |
| [`registry-build`](registry-build) | `registry build`: `--cwd` paths, `catalog:` versions, peer overrides, alias order |
| [`parity`](parity) | `packages/parity`: ignored fragments, dropped negative utilities, `calc()` rewrites, signal exit codes |
| [`primitives`](primitives) | `@shadcn-svelte/primitives`: MessageScroller and Questionnaire browser tests |

Each folder's `README.md` lists the exact steps and the observed output.
