#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; project="$root/jsapp"
npx --yes sv@latest create "$project" --template minimal --types jsdoc --add tailwindcss=plugins:none --no-download-check --install npm
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '#lib' --components-alias '#lib/components' --ui-alias '#lib/components/ui' --utils-alias '#lib/utils' --hooks-alias '#lib/hooks' --no-deps --skip-preflight --reinstall
printf 'project=%s\n' "$project"
# Run interactively; press Ctrl+C at the component picker for SIGINT.
# For SIGTERM, rerun and send `kill -TERM <Node CLI PID>` from another terminal while the prompt is open.
npx --yes shadcn-svelte@latest add --cwd "$project" --no-deps --skip-preflight
status=$?
printf 'exit=%s\n' "$status"
