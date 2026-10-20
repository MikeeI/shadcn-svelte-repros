# Blocks ship relative `../ui/` imports that don't resolve after install

Official `repro` template plus three blocks installed with the CLI (files committed unmodified).

## Steps

```bash
pnpm install
pnpm dlx shadcn-svelte@latest add calendar-12 chart-area-interactive chart-pie-interactive --yes --overwrite
pnpm build
```

`src/routes/+page.svelte` renders the three blocks.

## Observed (`shadcn-svelte@1.7.0`)

```text
[UNRESOLVED_IMPORT] Could not resolve '../ui/range-calendar/range-calendar.svelte' in src/lib/components/calendar-12.svelte
[UNRESOLVED_IMPORT] Could not resolve '../ui/chart/chart-container.svelte' in src/lib/components/chart-area-interactive.svelte
[UNRESOLVED_IMPORT] Could not resolve '../ui/chart/chart-style.svelte' in src/lib/components/chart-pie-interactive.svelte
```
