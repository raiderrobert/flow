#!/usr/bin/env bash
# Skill audit tests — verifies audit findings are resolved.
# Run from repo root: bash tests/skill-audit.sh

set -uo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"  # "pass" or "fail"
  if [[ "$result" == "pass" ]]; then
    echo "PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

# ---------- Test 1: No LSP( pseudo-code in skills/rust-lsp/ ----------
if grep -r 'LSP(' skills/rust-lsp/ >/dev/null 2>&1; then
  check "No LSP( pseudo-code in rust-lsp/" "fail"
else
  check "No LSP( pseudo-code in rust-lsp/" "pass"
fi

# ---------- Test 2: language-comparison.md is deleted or referenced ----------
if [[ ! -f skills/rust/examples/language-comparison.md ]] || \
   grep -r 'language-comparison' skills/rust/ >/dev/null 2>&1; then
  check "language-comparison.md deleted or referenced in rust/" "pass"
else
  check "language-comparison.md deleted or referenced in rust/" "fail"
fi

# ---------- Test 3: metadata.json is deleted or referenced ----------
if [[ ! -f skills/unsafe-checker/metadata.json ]] || \
   grep -r 'metadata.json' skills/unsafe-checker/ >/dev/null 2>&1; then
  check "metadata.json deleted or referenced in unsafe-checker/" "pass"
else
  check "metadata.json deleted or referenced in unsafe-checker/" "fail"
fi

# ---------- Test 4: AGENTS.md renamed to rule-index.md ----------
agents_ok="pass"
if [[ -f skills/unsafe-checker/AGENTS.md ]]; then
  agents_ok="fail"
fi
if [[ ! -f skills/unsafe-checker/rule-index.md ]]; then
  agents_ok="fail"
fi
check "AGENTS.md renamed to rule-index.md" "$agents_ok"

# ---------- Test 5: No duplicate globs on unsafe-checker ----------
if grep -q 'globs' skills/unsafe-checker/SKILL.md 2>/dev/null; then
  check "No duplicate globs in unsafe-checker/SKILL.md" "fail"
else
  check "No duplicate globs in unsafe-checker/SKILL.md" "pass"
fi

# ---------- Test 6: diecut has globs for auto-triggering ----------
if grep -q 'globs' skills/diecut/SKILL.md 2>/dev/null; then
  check "diecut/SKILL.md has globs for auto-triggering" "pass"
else
  check "diecut/SKILL.md has globs for auto-triggering" "fail"
fi

# ---------- Summary ----------
TOTAL=$((PASS + FAIL))
echo ""
echo "${PASS}/${TOTAL} passed"
if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
