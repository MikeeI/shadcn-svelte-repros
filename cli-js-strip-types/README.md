# JS project: `add` runs the TypeScript stripper on non-code files

SvelteKit 3 + Svelte 5 + Tailwind CSS v4 project with JSDoc types, created with `npx sv@latest create --template minimal --types jsdoc --add tailwindcss`.
It was then initialized with `shadcn-svelte init --preset b0`, so `components.json` has `"typescript": false`.
`registry/r/e18files.json` contains a `registry:lib` file `e18/helper.ts` and a `registry:file` `~/e18-data.json`.

## Steps

```bash
pnpm install
npx http-server registry -p 5555   # separate terminal
pnpm dlx shadcn-svelte@latest add http://localhost:5555/r/e18files.json --yes --no-deps
ls src/lib/e18 e18-data.json
```

## Observed (`shadcn-svelte@1.7.0`)

```text
└  SyntaxError: Unexpected token, expected ";" (2:5)
```

`src/lib/e18/helper.js` was already written, and `e18-data.json` was not.
The JSON file is passed through the TypeScript stripper, which fails to parse it, and the install stops halfway.
