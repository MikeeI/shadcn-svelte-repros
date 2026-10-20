#!/usr/bin/env bash
set -euo pipefail

CLI="${CLI:-npx --yes shadcn-svelte@latest}"
ROOT="$(mktemp -d)"
trap 'rm -rf "$ROOT"' EXIT
mkdir -p "$ROOT/src"

cat > "$ROOT/package.json" <<'EOF'
{"name":"registry-alias-repro","version":"1.0.0","type":"module"}
EOF
cat > "$ROOT/registry.json" <<'EOF'
{
  "name": "alias-repro",
  "homepage": "https://example.test",
  "aliases": {
    "components": "$lib/components",
    "ui": "$lib/components/ui"
  },
  "items": [{
    "name": "widget",
    "type": "registry:component",
    "registryDependencies": [],
    "files": [{"path": "src/widget.ts", "type": "registry:file"}]
  }]
}
EOF
cat > "$ROOT/src/widget.ts" <<'EOF'
import Button from "$lib/components/ui/button";
export { Button };
EOF

(cd "$ROOT" && $CLI registry build -c . -o static/r)
cat "$ROOT/static/r/widget.json"
