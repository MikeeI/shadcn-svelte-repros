#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; mkdir -p "$root/user.github.io"; project="$root/user.github.io/detect"
npx --yes sv@latest create "$project" --template minimal --types jsdoc --add tailwindcss=plugins:none --no-download-check --install npm
test -f "$project/src/routes/layout.css"
printf 'actual CSS exists: %s\n' "$project/src/routes/layout.css"
# Intentionally omit --css. Prompt defaults to src/app.css; enter src/routes/layout.css to continue.
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight --reinstall
