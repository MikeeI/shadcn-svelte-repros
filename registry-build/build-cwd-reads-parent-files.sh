#!/usr/bin/env bash
set -euo pipefail

CLI="${CLI:-npx --yes shadcn-svelte@latest}"
ROOT="$(mktemp -d)"
trap 'rm -rf "$ROOT"' EXIT
mkdir -p "$ROOT/src" "$ROOT/demo/src"

cat > "$ROOT/package.json" <<'EOF'
{"name":"registry-path-parent","version":"1.0.0","type":"module"}
EOF
cat > "$ROOT/src/card.svelte" <<'EOF'
<script>const origin = "parent";</script>
<div>{origin}</div>
EOF
cat > "$ROOT/demo/package.json" <<'EOF'
{"name":"registry-path-demo","version":"1.0.0","type":"module"}
EOF
cat > "$ROOT/demo/registry.json" <<'EOF'
{
  "name": "path-repro",
  "homepage": "https://example.test",
  "items": [{
    "name": "card",
    "type": "registry:component",
    "registryDependencies": [],
    "files": [{"path": "src/card.svelte", "type": "registry:file"}]
  }]
}
EOF
cat > "$ROOT/demo/src/card.svelte" <<'EOF'
<script>const origin = "project";</script>
<div>{origin}</div>
EOF

cd "$ROOT"
$CLI registry build registry.json --cwd demo --output static/r
cat "$ROOT/demo/static/r/card.json"
