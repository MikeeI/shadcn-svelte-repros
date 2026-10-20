#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; project="$root/jsapp"
npx --yes sv@latest create "$project" --template minimal --types jsdoc --add tailwindcss=plugins:none --no-download-check --install npm
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight --reinstall
printf '%s\n' '// USER-OWNED sentinel: do not overwrite' 'export const localSentinel = "keep-me";' > "$project/src/lib/utils.js"
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight
cat "$project/src/lib/utils.js"
printf '%s\n' '// USER-OWNED sentinel: do not overwrite' 'export const localSentinel = "keep-me";' > "$project/src/lib/hooks/is-mobile.svelte.js"
npx --yes shadcn-svelte@latest add is-mobile --cwd "$project" --yes --no-deps --skip-preflight
cat "$project/src/lib/hooks/is-mobile.svelte.js"
