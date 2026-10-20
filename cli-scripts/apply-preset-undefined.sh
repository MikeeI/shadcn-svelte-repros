#!/usr/bin/env bash
set -euo pipefail
root="$(mktemp -d)"; project="$root/tsapp"
npx --yes sv@latest create "$project" --template minimal --types ts --add tailwindcss=plugins:none --no-download-check --install npm
cat > "$project/tsconfig.json" <<'EOF'
{
	"extends": "$app/tsconfig",
	"compilerOptions": { "strict": true, "paths": { "$lib/*": ["./src/lib/*"] } },
	"include": ["src", "vite.config.ts"]
}
EOF
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '$lib' --components-alias '$lib/components' --ui-alias '$lib/components/ui' --utils-alias '$lib/utils' --hooks-alias '$lib/hooks' --no-deps --skip-preflight --reinstall
npx --yes shadcn-svelte@latest apply b0 --cwd "$project" --only theme --skip-preflight
