# Tailwind v3 project: `add` rewrites the style and fetches a 404 registry URL

SvelteKit 2 + Svelte 5 + Tailwind CSS v3 with a `components.json` from the Tailwind v3 era (`"style": "new-york"`).

## Steps

```bash
pnpm install
pnpm dlx shadcn-svelte@latest add button
```

## Observed (`shadcn-svelte@1.7.0`)

```text
◇  Config file components.json updated
└  CLI Error: Failed to fetch registry from https://tw3.shadcn-svelte.com/registry/nova/styles/nova/index.json: 404
```

`components.json` afterwards:

```diff
-	"style": "new-york",
-	"registry": "https://shadcn-svelte.com/registry"
+	"registry": "https://tw3.shadcn-svelte.com/registry/nova",
+	"style": "nova",
+	"iconLibrary": "lucide",
+	"menuColor": "default",
+	"menuAccent": "subtle"
```

For comparison, `https://tw3.shadcn-svelte.com/registry/new-york/index.json` returns 200.
