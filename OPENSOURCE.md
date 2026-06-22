# Open-sourcing NLC CLI — readiness plan

**Status: NOT ready to publish yet.** This document is the checklist to get there.

## Why the current tree isn't publishable as-is
The current `packages/opencode` tree is a fork of **MiMo Code (Xiaomi)**, which is itself a fork of
[opencode](https://github.com/sst/opencode). An audit found **~6,700 references** to upstream names
that violate our brand-identity rule (never reveal the upstream provider/model):

| Term | ~count | Action |
|------|-------:|--------|
| `mimo` / `mimocode` / `@mimo-ai` | ~3,600 | **Remove** — reveals MiMo/Xiaomi |
| `kimi` (model ids like `opencode/kimi-k2.5`) | ~630 | **Mask** to NLC model ids |
| `opencode` | ~1,370 | Keep attribution in LICENSE/NOTICE; rebrand user-facing strings |
| `anthropic` | ~860 | **Keep** — Anthropic protocol support is a real feature |

No real secrets were found in source (only a test fixture); `.env` is already gitignored.

## Chosen strategy: re-fork from opencode directly
Instead of cleaning the MiMo fork (error-prone, and the MIT license would force us to keep MiMo's
copyright notice — revealing the lineage), start clean from upstream opencode and re-apply only our
NLC layer.

### Automated (recommended)
Run the helper on your machine — it does steps 1–5 below and finishes by running the gate:
```bash
bash scripts/refork-from-opencode.sh ../nlc-cli-fresh
# optional: OPENCODE_REF=v1.2.3 bash scripts/refork-from-opencode.sh ../nlc-cli-fresh
```
It clones opencode, drops the clean `.nlc/` layer + README/LICENSE/OPENSOURCE/NOTICE on top, sets
the package name, and runs `check-publish.sh`. The gate then lists any provider refs that ship with
opencode itself (its multi-provider catalog) for you to trim before going public.

### Manual steps (what the script automates)
1. `git clone https://github.com/sst/opencode nlc-cli-fresh` (pin to a known-good tag).
2. Copy over **only** the NLC-specific layer:
   - `.nlc/` — config (`nlc.jsonc` with `oddsforge.org` URLs), agents, skills, themes, glossary.
   - `README.md`, `LICENSE` (already fixed: NLC + opencode attribution, no MiMo/Xiaomi).
   - `install` script and `package.json` name (`nlc-cli`).
3. Rename the runtime identifiers that opencode ships with:
   - Home env var → `NLC_HOME` (was `OPENCODE_*` / `MIMOCODE_HOME`).
   - Package scope → `@nlc/*` (was `@mimo-ai/*`).
   - Default config dir → `nlc` (was `opencode` / `mimocode`).
4. Mask model ids: anything like `kimi-*`, `glm-*`, `qwen-*`, `deepseek-*` → `nlc-pro` / `nlc-vision`
   / `nlc-fast` (the server already masks upstream ids — keep the CLI consistent).
5. Add a `NOTICE` file crediting opencode (MIT) — required and correct for an MIT fork.
6. Run the pre-publish gate (below) until it passes with **zero** findings.
7. Make the GitHub repo public.

## Pre-publish safety gate
Run **before every push to a public remote**:
```bash
bash scripts/check-publish.sh
```
It scans the tree (excluding `node_modules`) for forbidden upstream terms and **exits non-zero** if
any are found. Wire it into CI and/or a pre-push git hook so a leak can never ship.

## Progress
- [x] `LICENSE` credits only NLC + opencode (Xiaomi/MiMo removed)
- [x] **NLC layer (`.nlc/`) is leak-free** — model ids, `@mimo-ai/*` imports, and provider-name
      glossary entries in `.nlc/agent/translator.md` all scrubbed (verify: `grep -rinE 'mimo|kimi|deepseek|fireworks|glm' .nlc` → 0). This is the layer you drop onto the fresh fork.
- [x] `scripts/check-publish.sh` gate in place
- [ ] Re-fork code from upstream opencode (eliminates the ~6,900 `packages/` leaks at the source)
- [ ] `NOTICE` file present (opencode attribution)
- [ ] Rename runtime identifiers in the fresh fork: `MIMOCODE_HOME`→`NLC_HOME`, `@mimo-ai/*`→`@nlc/*`
- [ ] `scripts/check-publish.sh` passes (0 findings) — then make the repo public
- [ ] README install steps verified on a clean machine

## Why we can't just sed the current tree
The ~6,900 remaining leaks are **all in `packages/`** (the inherited opencode→MiMo fork code), vs
**0 in `.nlc/`** (our own layer, now clean). Renaming thousands of interwoven build identifiers
in place risks breaking the build. Re-forking from clean opencode removes them in one move — then
you copy the already-clean `.nlc/` layer + README + LICENSE on top.
