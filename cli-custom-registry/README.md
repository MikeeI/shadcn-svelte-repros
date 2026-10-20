# CLI with a custom registry: CSS, icon, menu, and item-type bugs

SvelteKit 3 + Svelte 5 + Tailwind CSS v4 project, created with `npx sv@latest create --template minimal --types ts --add tailwindcss`.
It was then initialized with `shadcn-svelte init --preset b0` and `#lib` aliases.
`registry/r/` and `registry-v2/r/` hold small hand-written registry items that trigger each bug.
All results below were observed with `shadcn-svelte@1.7.0` on Node 26 and pnpm 10.

## Setup

```bash
pnpm install
npx http-server registry -p 5555      # terminal 1
npx http-server registry-v2 -p 5556   # terminal 2, only needed for "update"
```

Any static file server works.

## `update` ignores `cssVars` of changed items

```bash
COMPONENTS_REGISTRY_URL=http://localhost:5555/r/ pnpm dlx shadcn-svelte@latest add e2card --yes --no-deps
COMPONENTS_REGISTRY_URL=http://localhost:5556/r/ pnpm dlx shadcn-svelte@latest update e2card --yes --no-deps
grep -n -- '--e2' src/routes/layout.css
```

`registry-v2/r/e2card.json` adds the CSS variable `e2-new`.
`update` prints `Success! Component update completed.`, but `layout.css` only contains `--e2` and `--color-e2`.
`add e2card --overwrite` against the same v2 registry does write `--e2-new` and `--color-e2-new`.

## Two `IconPlaceholder`s with the same icon produce a duplicate import

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e6icons.json --yes --no-deps
head -3 src/lib/components/ui/e6icons/e6icons.svelte
```

```svelte
<script lang="ts">
	import CheckIcon from '@lucide/svelte/icons/check';
	import CheckIcon from '@lucide/svelte/icons/check';
```

The component then fails to compile with `Identifier 'CheckIcon' has already been declared`.

## `cn-menu-target` is only replaced outside `{#if}` blocks

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/a1menu.json --yes --no-deps
cat src/lib/components/ui/a1menu/a1menu.svelte
```

The marker on the top-level `div` is removed, but the one inside `{#if open}` stays: `class="cn-menu-target p-4"`.

## `cssVars` keys with a leading `--` produce `var(----name)`

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e19vars.json --yes --no-deps
grep -n brand src/routes/layout.css
```

```css
--brand: oklch(0.5 0.1 200);
--color-brand: var(----brand);
```

## String `css` values are appended again on every `add --overwrite`

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e20css.json --yes --no-deps --overwrite
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e20css.json --yes --no-deps --overwrite
```

```css
h1 {
	font-size: 2rem;
	font-size: 2rem;
}
```

## Nested `&` in a selector list only applies to the last selector

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e21css.json --yes --no-deps
```

The item has `"h1, h2": { "&:hover": { "color": "blue" } }`.
The output contains `h1, h2:hover { color: blue; }` instead of `h1:hover, h2:hover`.

## `registry:item` is accepted by the schema but rejected on install

```bash
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e22item.json --yes --no-deps
```

```text
└  Error: TODO: unhandled item type registry:item
```

The command exits with status 1.
