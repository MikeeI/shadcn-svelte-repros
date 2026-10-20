#!/usr/bin/env bash
set -euo pipefail

CLI="${CLI:-npx --yes shadcn-svelte@latest}"
ROOT="$(mktemp -d)"
TOOLING="$(mktemp -d)"
trap 'rm -rf "$ROOT" "$TOOLING"' EXIT
npm install --prefix "$TOOLING" --ignore-scripts --no-audit --no-fund pnpm@10.32.1 >/dev/null
PNPM="$TOOLING/node_modules/.bin/pnpm"
mkdir -p "$ROOT/src"

cat > "$ROOT/package.json" <<'EOF'
{
  "name": "registry-catalog-repro",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {"is-number": "catalog:"}
}
EOF
cat > "$ROOT/pnpm-workspace.yaml" <<'EOF'
packages:
  - .
catalog:
  is-number: 7.0.0
EOF
cat > "$ROOT/registry.json" <<'EOF'
{
  "name": "catalog-repro",
  "homepage": "https://example.test",
  "items": [{
    "name": "widget",
    "type": "registry:component",
    "registryDependencies": [],
    "files": [{"path": "src/widget.ts", "type": "registry:file"}]
  }]
}
EOF
cat > "$ROOT/src/widget.ts" <<'EOF'
import isNumber from "is-number";
export const valid = isNumber("7");
EOF

(cd "$ROOT" && "$PNPM" install --ignore-scripts --no-frozen-lockfile)
(cd "$ROOT" && $CLI registry build -c . -o static/r)
cat "$ROOT/static/r/widget.json"
