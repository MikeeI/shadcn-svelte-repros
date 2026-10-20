# shadcn-svelte reproductions

Minimal reproductions for bug reports against [huntabyte/shadcn-svelte](https://github.com/huntabyte/shadcn-svelte).
Each folder is a standalone project based on the official [`repro`](https://github.com/huntabyte/shadcn-svelte/tree/main/repro) template, except where noted.
All results below were observed with `shadcn-svelte@1.7.0` on Node 26 and pnpm 10.

| Folder | Bug |
| --- | --- |
| [`tailwind-v3-legacy`](tailwind-v3-legacy) | Tailwind v3 project: `add` rewrites `components.json` to `nova` and fetches a 404 registry URL |
| [`blocks-relative-ui-imports`](blocks-relative-ui-imports) | `calendar-12`, `chart-area-interactive`, `chart-pie-interactive` ship `../ui/` imports that don't resolve |
| [`registry-template`](registry-template) + [`registry-template-consumer`](registry-template-consumer) | Registry template's `complex-component`: page lands in `src/routes/src/routes/`, and its imports don't resolve |
| [`calendar-28-month-offset`](calendar-28-month-offset) | `calendar-28` selects the previous month for a typed date |

Each folder's `README.md` lists the exact steps and the observed output.
