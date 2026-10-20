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
npx --yes shadcn-svelte@latest add button --cwd "$project" --yes --no-deps --skip-preflight
cp "$project/components.json" "$project/components.before.json"
set +e
npx --yes shadcn-svelte@latest init --cwd "$project" --preset bJKzdQW --css src/routes/layout.css --lib-alias '$lib' --components-alias '$lib/components' --ui-alias '$lib/components/ui' --utils-alias '$lib/utils' --hooks-alias '$lib/hooks' --proxy http://127.0.0.1:9 --no-deps --skip-preflight
failure_status=$?
set -e
printf 'failed_init_exit=%s\n' "$failure_status"
diff -u "$project/components.before.json" "$project/components.json" || true
# Rerun without --reinstall; only utils is offered in overwrite prompts, not button.
npx --yes shadcn-svelte@latest init --cwd "$project" --preset bJKzdQW --css src/routes/layout.css --lib-alias '$lib' --components-alias '$lib/components' --ui-alias '$lib/components/ui' --utils-alias '$lib/utils' --hooks-alias '$lib/hooks' --no-deps --skip-preflight
