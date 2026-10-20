#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; project="$root/my.tsapp"
npx --yes sv@latest create "$project" --template minimal --types jsdoc --add tailwindcss=plugins:none --no-download-check --install npm
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight --reinstall
printf 'expected project output exists: '
if [ -f "$project/src/lib/utils.js" ]; then echo yes; else echo no; fi
printf 'actual misplaced output: %s\n' "$root/my.jsapp/src/lib/utils.ts"
cat "$root/my.jsapp/src/lib/utils.ts"
