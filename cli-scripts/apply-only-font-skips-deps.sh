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
npx --yes shadcn-svelte@latest init --cwd "$project" --preset b0 --css src/routes/layout.css --lib-alias '$lib' --components-alias '$lib/components' --ui-alias '$lib/components/ui' --utils-alias '$lib/utils' --hooks-alias '$lib/hooks' --no-deps-install --skip-preflight --reinstall
npx --yes shadcn-svelte@latest apply --cwd "$project" --preset bGW --only theme font --skip-preflight --silent
node -e 'const p=JSON.parse(require("node:fs").readFileSync(process.argv[1],"utf8")); console.log(JSON.stringify({inter:p.devDependencies["@fontsource-variable/inter"],notoSans:p.devDependencies["@fontsource-variable/noto-sans"]??null}));' "$project/package.json"
node -e 'const fs=require("node:fs"); console.log(fs.readFileSync(process.argv[1],"utf8").split(/\r?\n/).filter(x=>x.includes("@fontsource-variable/")).join("\n"));' "$project/src/routes/layout.css"
