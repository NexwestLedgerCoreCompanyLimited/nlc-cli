# Publishing NLC CLI to npm

Goal: let people run `npm install -g nlc-cli` then `nlc`, like `npm i -g @anthropic-ai/claude-code`.

## Status
- ✅ npm name **`nlc-cli` is available**
- ✅ root `package.json` is `private: false`
- ⚠️ This is a **compiled TUI monorepo** (bun + native `node-pty`), not a single JS file. The
  publishable CLI lives in **`packages/opencode`** (bin `opencode`). It must be rebranded +
  built before publishing — it is NOT `npm install`-able yet.

## Already configured ✅
In `packages/opencode/package.json`: name=`nlc-cli`, bin=`{ "nlc": "./bin/opencode" }`, `private:false`, version `1.0.0`, publishConfig public, repo/homepage set. (No code imports the package by name, so the rename is safe.)

## Remaining (run on a machine with bun + npm login)

1. **Rebrand the CLI package** — in `packages/opencode/package.json`:
   - `"name": "nlc-cli"`
   - `"bin": { "nlc": "./bin/opencode" }`  (so the command is `nlc`)
   - set a `"version"` (e.g. `1.0.0`) and a `"description"`, `"repository"`, `"homepage": "https://oddsforge.org"`
   - ensure `"files"` includes the built output + `bin/`
   - rename the launcher `bin/opencode` → `bin/nlc` (and update the bin map)

2. **Lock to the NLC provider** so the published CLI only talks to oddsforge.org (see OPENSOURCE.md),
   and run the gate: `bash scripts/check-publish.sh` → must be 0.

3. **Build**:
   ```bash
   bun install
   bun run --filter nlc-cli build      # or the package's build script
   ```

4. **Publish** (needs YOUR npm account):
   ```bash
   npm login
   npm publish --access public          # from packages/opencode (now "nlc-cli")
   ```

5. Verify: `npm install -g nlc-cli && nlc`

## Note on native binaries
opencode ships platform-specific helper packages (for `node-pty`, the TUI renderer). If you want
the same one-command install on all OSes, you'll publish those companion packages too (see how the
upstream `opencode` package declares optionalDependencies). For a first release you can target your
own platform and expand later.

> I can help configure the publishable package, but the **build + `npm publish` must run on your
> machine** (needs bun + your npm login) — the server here has neither.

## ✅ Build VERIFIED (2026-06-23, on the server)
`bun install` (2417 pkgs) + `bun run --cwd packages/opencode build` succeeded. It produced
platform binaries for all targets in `packages/opencode/dist/` (named **`nlc-cli-{platform}`** —
linux/macos/windows × x64/arm64 + musl/baseline), and the build's own smoke test (`--version`)
passed. The Linux binary runs: `nlc-cli-linux-x64/bin/opencode --version` → prints a version.

Distribution model (opencode-style): per-platform binaries are uploaded to a **GitHub Release**,
and a thin npm package fetches the right one on `npm install -g nlc-cli`. To ship:
1. Set a real version (the build defaults to a dev timestamp); tag e.g. `v1.0.0`.
2. Run the build with `GH_REPO=NexGerCore/nlc-cli` so it uploads binaries to the release (gh is authed).
3. `npm login` and publish the launcher package (`npm publish` from `packages/opencode`).

The hard part (it compiles + runs) is proven. Remaining = version + your `npm login`.
