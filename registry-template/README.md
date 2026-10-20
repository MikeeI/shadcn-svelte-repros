# Registry template (unmodified)

Created with:

```bash
npx sv@0.16.6 create registry-template --template minimal --types ts --add tailwindcss="plugins:none" "@shadcn-svelte/registry=demo:no" --install pnpm
pnpm build:registry
```

The built output is committed in `static/r/`, so items can be installed from raw GitHub URLs, e.g.:

```text
https://raw.githubusercontent.com/MikeeI/shadcn-svelte-repros/main/registry-template/static/r/complex-component.json
```

See [`../registry-template-consumer`](../registry-template-consumer) for the install result.
