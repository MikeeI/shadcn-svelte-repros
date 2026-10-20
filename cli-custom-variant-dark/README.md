# `init` skips `@custom-variant dark` when the CSS already has another `@custom-variant`

SvelteKit 3 + Svelte 5 + Tailwind CSS v4 project, created with `npx sv@latest create --template minimal --types ts --add tailwindcss`.
`src/routes/layout.css` has one unrelated custom variant:

```css
@import "tailwindcss";
@custom-variant sidebar-open (&:is(.sidebar-open *));
```

## Steps

```bash
pnpm install
pnpm dlx shadcn-svelte@latest init --preset b0 --css src/routes/layout.css \
  --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' \
  --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps-install
grep -n 'custom-variant\|^\.dark' src/routes/layout.css
```

## Observed (`shadcn-svelte@1.7.0`)

```text
5:@custom-variant sidebar-open (&:is(.sidebar-open *));
42:.dark {
```

`init` writes the `.dark` theme block, but no `@custom-variant dark (&:is(.dark *));`.
Without the `sidebar-open` line, the same command adds the dark variant.
