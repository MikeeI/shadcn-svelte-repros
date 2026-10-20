# Installing the registry template's `complex-component`

Official `repro` template with `complex-component` from [`../registry-template`](../registry-template) installed (files committed unmodified).

## Steps

```bash
pnpm install
pnpm dlx shadcn-svelte@latest add https://raw.githubusercontent.com/MikeeI/shadcn-svelte-repros/main/registry-template/static/r/complex-component.json --yes --overwrite
pnpm check
```

## Observed (`shadcn-svelte@1.7.0`)

1. The page target `src/routes/pokemon/+page.svelte` is written to `src/routes/src/routes/pokemon/+page.svelte`.
2. The installed files keep imports that don't resolve in the consumer project:

```text
ERROR "src/lib/components/pokemon-card.svelte" 2:29 "Cannot find module '$lib/registry/blocks/complex-component/lib/pokemon.js' ..."
ERROR "src/lib/components/pokemon-card.svelte" 4:27 "Cannot find module '$lib/registry/blocks/complex-component/components/pokemon-image.svelte' ..."
ERROR "src/lib/components/pokemon-image.svelte" 2:34 "Cannot find module '$lib/registry/blocks/complex-component/hooks/use-pokemon.svelte' ..."
ERROR "src/routes/src/routes/pokemon/+page.svelte" 2:26 "Cannot find module './components/pokemon-card.svelte' ..."
ERROR "src/routes/src/routes/pokemon/+page.svelte" 3:33 "Cannot find module './lib/pokemon.js' ..."
```
