#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; project="$root/jsapp"
npx --yes sv@latest create "$project" --template minimal --types jsdoc --add tailwindcss=plugins:none --no-download-check --install npm
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight --reinstall
npx --yes shadcn-svelte@latest add is-mobile --cwd "$project" --yes --no-deps --skip-preflight
npx --yes shadcn-svelte@latest update is-mobile --cwd "$project" --yes --no-deps --skip-preflight
