#!/usr/bin/env bash
set -eu
git clone https://github.com/huntabyte/shadcn-svelte.git source
git -C source checkout 97fdb9364926716d33b3c5570ae3a84dd6493428
(cd source && npm exec --yes --package=pnpm@10.32.1 -- pnpm install --frozen-lockfile --ignore-scripts && npm exec --yes --package=pnpm@10.32.1 -- pnpm -F shadcn-svelte build)
git -C source status --porcelain
node source/packages/parity/src/index.ts base carousel --verbose
cat > extract.mjs <<'EOF'
import fs from 'node:fs';
import { extractClassStrings } from './source/packages/parity/src/compare.ts';
const content = fs.readFileSync('./source/docs/src/lib/registry/ui/carousel/carousel-content.svelte', 'utf8');
console.log('source: ' + content.split('\n').find(line => line.includes('"-ms-4"')).trim());
console.log('extracted: ' + JSON.stringify(extractClassStrings(content).map(entry => entry.merged)));
for (const input of ['-ms-4', '-mt-4 flex-col', 'flex-col', 'aspect-video', 'object-cover']) {
  console.log(JSON.stringify({input, extracted: extractClassStrings(`className="${input}"`).map(entry => entry.merged)}));
}
EOF
node extract.mjs
mkdir -p fixture/docs/src/lib/registry/ui/button fixture/docs/static/registry/styles/nova fixture/upstream/apps/v4/registry/bases/radix/ui
cat > fixture/docs/static/registry/styles/nova/index.json <<'EOF'
[{"name":"button","type":"registry:ui"}]
EOF
cat > fixture/docs/src/lib/registry/ui/button/button.svelte <<'EOF'
<button class="-ms-4">Example</button>
EOF
cat > fixture/upstream/apps/v4/registry/bases/radix/ui/button.tsx <<'EOF'
export function Button() { return <button className="-ms-8">Example</button>; }
EOF
SHADCN_UI="$PWD/fixture/upstream" node source/packages/parity/src/index.ts base button --docs "$PWD/fixture/docs" --verbose --check
git -C source status --porcelain
