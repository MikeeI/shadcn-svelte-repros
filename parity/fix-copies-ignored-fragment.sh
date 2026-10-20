#!/usr/bin/env bash
set -eu
git clone https://github.com/huntabyte/shadcn-svelte.git source
git -C source checkout 97fdb9364926716d33b3c5570ae3a84dd6493428
(cd source && npm exec --yes --package=pnpm@10.32.1 -- pnpm install --frozen-lockfile --ignore-scripts && npm exec --yes --package=pnpm@10.32.1 -- pnpm -F shadcn-svelte build)
git -C source status --porcelain
mkdir -p fixture/docs/src/lib/registry/ui/button fixture/docs/static/registry/styles/nova fixture/upstream/apps/v4/registry/bases/radix/ui
cat > fixture/docs/static/registry/styles/nova/index.json <<'EOF'
[{"name":"button","type":"registry:ui"}]
EOF
cat > fixture/docs/src/lib/registry/ui/button/button.svelte <<'EOF'
<button class={cn(
  "flex items-center gap-2 p-2",
  // parity-ignore: preserve this local typography
  "text-red-500"
)}>Example</button>
EOF
cat > fixture/upstream/apps/v4/registry/bases/radix/ui/button.tsx <<'EOF'
export function Button() {
  return <button className="flex items-center gap-2 p-4">Example</button>;
}
EOF
SHADCN_UI="$PWD/fixture/upstream" node source/packages/parity/src/index.ts fix button --docs "$PWD/fixture/docs" --dry-run
cat fixture/docs/src/lib/registry/ui/button/button.svelte
git -C source status --porcelain
