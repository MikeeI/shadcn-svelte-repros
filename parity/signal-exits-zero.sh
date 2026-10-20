#!/usr/bin/env bash
set -eu
git clone https://github.com/huntabyte/shadcn-svelte.git source
git -C source checkout 97fdb9364926716d33b3c5570ae3a84dd6493428
(cd source && npm exec --yes --package=pnpm@10.32.1 -- pnpm install --frozen-lockfile --ignore-scripts && npm exec --yes --package=pnpm@10.32.1 -- pnpm -F shadcn-svelte build)
git -C source status --porcelain
cat > signals.mjs <<'EOF'
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
const entry = fileURLToPath(new URL('./source/packages/parity/src/index.ts', import.meta.url));
for (const signal of ['SIGINT', 'SIGTERM']) {
  await new Promise((resolve, reject) => {
    const child = spawn(process.execPath, [entry, 'base', 'carousel', '--refresh', '--check'], {stdio: ['ignore', 'pipe', 'pipe']});
    let sent = false;
    let output = '';
    const timer = setTimeout(() => { child.kill('SIGKILL'); reject(new Error('No CLI startup output')); }, 10000);
    child.stdout.on('data', data => {
      output += data;
      if (!sent && output.includes('Comparing UI source')) {
        sent = true;
        child.kill(signal);
      }
    });
    child.stderr.on('data', data => process.stderr.write(data));
    child.on('error', reject);
    child.on('close', (code, actualSignal) => {
      clearTimeout(timer);
      console.log(JSON.stringify({requestedSignal: signal, sent, exitCode: code, terminationSignal: actualSignal, completedSummary: output.includes('## Summary')}));
      resolve();
    });
  });
}
EOF
node signals.mjs
git -C source status --porcelain
