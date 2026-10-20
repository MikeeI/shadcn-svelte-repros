# CLI reproductions against the official registry

Each script creates a fresh SvelteKit project with `npx sv@latest create` in a temp directory and runs the published CLI.
All results below were observed with `shadcn-svelte@1.7.0`, `sv@1.1.1`, and `@sveltejs/kit@3.1.0` on Node 26.
Some scripts replace `tsconfig.json` so that `$lib` aliases resolve in a SvelteKit 3 project.

| Script | Observed |
| --- | --- |
| [`js-overwrite-without-prompt.sh`](js-overwrite-without-prompt.sh) | JS project: edited `utils.js` and `is-mobile.svelte.js` are replaced without an overwrite prompt |
| [`strip-types-path-replace.sh`](strip-types-path-replace.sh) | JS project in `my.tsapp/`: `utils` is written to `../my.jsapp/src/lib/utils.ts` |
| [`apply-only-font-skips-deps.sh`](apply-only-font-skips-deps.sh) | `apply --only theme font` adds the font `@import` but not its package |
| [`init-base-color-ignored.sh`](init-base-color-ignored.sh) | `init --base-color zinc` writes `"baseColor": "neutral"` |
| [`init-config-written-before-fetch.sh`](init-config-written-before-fetch.sh) | Failed `init` leaves the new `style` and `baseColor`; the rerun no longer offers to reinstall `button` |
| [`update-misses-flat-hooks.sh`](update-misses-flat-hooks.sh) | `update is-mobile` does not list the installed hook |
| [`update-unknown-name-opens-picker.sh`](update-unknown-name-opens-picker.sh) | `update does-not-exist --yes` opens the component picker instead of failing |
| [`apply-preset-undefined.sh`](apply-preset-undefined.sh) | `apply b0` prints `Applied preset undefined to config file` |
| [`auto-detect-dot-git-substring.sh`](auto-detect-dot-git-substring.sh) | Project under `user.github.io/`: `init` suggests `src/app.css` instead of the existing `src/routes/layout.css` |
| [`sigint-exits-zero.sh`](sigint-exits-zero.sh) | Ctrl+C or SIGTERM at a prompt exits with status 0 |

The last two scripts and the final step of `init-config-written-before-fetch.sh` are interactive.
