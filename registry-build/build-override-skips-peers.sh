#!/usr/bin/env bash
set -euo pipefail

CLI="${CLI:-npx --yes shadcn-svelte@latest}"
ROOT="$(mktemp -d)"
trap 'rm -rf "$ROOT"' EXIT
mkdir -p "$ROOT/src" "$ROOT/packages/consumer" "$ROOT/packages/peer" "$ROOT/node_modules"

cat > "$ROOT/package.json" <<'EOF'
{
  "name": "registry-peer-repro",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "registry-consumer": "1.0.0",
    "registry-peer": "1.2.3"
  }
}
EOF
cat > "$ROOT/packages/consumer/package.json" <<'EOF'
{
  "name": "registry-consumer",
  "version": "1.0.0",
  "type": "module",
  "peerDependencies": {"registry-peer": "^1.0.0"}
}
EOF
cat > "$ROOT/packages/consumer/index.js" <<'EOF'
export const value = "consumer";
EOF
cat > "$ROOT/packages/peer/package.json" <<'EOF'
{
  "name": "registry-peer",
  "version": "1.2.3",
  "type": "module"
}
EOF
cat > "$ROOT/packages/peer/index.js" <<'EOF'
export const value = "peer";
EOF
ln -s ../packages/consumer "$ROOT/node_modules/registry-consumer"
ln -s ../packages/peer "$ROOT/node_modules/registry-peer"
cat > "$ROOT/registry.json" <<'EOF'
{
  "name": "peer-repro",
  "homepage": "https://example.test",
  "overrideDependencies": ["registry-peer@9.9.9"],
  "items": [{
    "name": "widget",
    "type": "registry:component",
    "registryDependencies": [],
    "files": [{"path": "src/widget.ts", "type": "registry:file"}]
  }]
}
EOF
cat > "$ROOT/src/widget.ts" <<'EOF'
import { value } from "registry-consumer";
export { value };
EOF

(cd "$ROOT" && $CLI registry build -c . -o static/r)
cat "$ROOT/static/r/widget.json"
