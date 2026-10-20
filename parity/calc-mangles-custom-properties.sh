#!/usr/bin/env bash
set -eu
git clone https://github.com/huntabyte/shadcn-svelte.git source
git -C source checkout 97fdb9364926716d33b3c5570ae3a84dd6493428
(cd source && npm exec --yes --package=pnpm@10.32.1 -- pnpm install --frozen-lockfile --ignore-scripts && npm exec --yes --package=pnpm@10.32.1 -- pnpm -F shadcn-svelte build)
git -C source status --porcelain
cat > tokens.mjs <<'EOF'
import { toSourceToken, fixClassString } from './source/packages/parity/src/compare.ts';
for (const input of ['w-[calc(var(--sidebar-width)+2rem)]', 'h-[calc(100vh-var(--header-height))]']) {
  console.log(JSON.stringify({input, output: toSourceToken(input)}));
}
console.log(JSON.stringify({fixed: fixClassString('w-10 flex', ['w-10'], ['w-[calc(var(--sidebar-width)+2rem)]'])}));
EOF
node tokens.mjs
git -C source status --porcelain
