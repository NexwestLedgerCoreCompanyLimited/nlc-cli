#!/usr/bin/env bash
# Pre-publish safety gate for NLC CLI.
# Scans the source tree for upstream provider/model names that must never appear in a public repo
# (brand-identity rule). Exits non-zero if any are found. Run before every push to a public remote.
#
#   bash scripts/check-publish.sh
#
# Tip: also wire this into a .git/hooks/pre-push hook and/or CI.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

# Forbidden, case-insensitive. We block ONLY the identifiers that would reveal OUR origin:
#   - the MiMo/Xiaomi *fork product* names  (mimocode, @mimo-ai)  — these must never appear
#   - our actual upstream codename          (wafer / WAFER_API_KEY / wafer.ai)
# We deliberately do NOT block generic provider/model names (deepseek, fireworks, glm, kimi, qwen,
# minimax, moonshot, and "xiaomi mimo" as a catalog model). A re-forked-from-opencode CLI is a
# GENERIC multi-provider tool; listing many providers is normal and does NOT reveal our backend.
# "anthropic" is also fine — Anthropic protocol support is an advertised feature.
PATTERN='mimocode|@?mimo-ai|\bwafer\b|WAFER_API_KEY'

# Files to search: source, config, docs, scripts. Skip vendored + generated dirs and this script.
HITS=$(grep -rinE "$PATTERN" \
  --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' \
  --include='*.json' --include='*.jsonc' --include='*.md' --include='*.sh' \
  --include='*.toml' --include='*.yml' --include='*.yaml' --include='*.txt' \
  . 2>/dev/null \
  | grep -vE '/(node_modules|dist|build|\.turbo|\.cache|android|ios)/' \
  | grep -vF 'scripts/check-publish.sh' \
  | grep -vF 'OPENSOURCE.md')

if [ -n "$HITS" ]; then
  COUNT=$(printf '%s\n' "$HITS" | wc -l | tr -d ' ')
  echo "❌ check-publish: found $COUNT forbidden upstream reference(s). DO NOT publish."
  echo "----------------------------------------------------------------------"
  printf '%s\n' "$HITS" | head -50
  if [ "$COUNT" -gt 50 ]; then echo "... and $((COUNT-50)) more"; fi
  echo "----------------------------------------------------------------------"
  echo "Fix these (see OPENSOURCE.md), then re-run."
  exit 1
fi

echo "✅ check-publish: no forbidden upstream references found. Safe to publish."
