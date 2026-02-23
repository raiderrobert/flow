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

# ---------- Test 7: No findReferences as tool call in rust-lsp ----------
if grep -r 'findReferences' skills/rust-lsp/ >/dev/null 2>&1; then
  check "No findReferences in rust-lsp/" "fail"
else
  check "No findReferences in rust-lsp/" "pass"
fi

# ---------- Test 8: No "Language Server Protocol" in rust-lsp ref files ----------
if grep -r 'Language Server Protocol' skills/rust-lsp/ --include='*.md' | grep -v 'SKILL.md' | grep -q .; then
  check "No 'Language Server Protocol' in rust-lsp ref files" "fail"
else
  check "No 'Language Server Protocol' in rust-lsp ref files" "pass"
fi

# ---------- Test 9: No "LSP references" in rust-lsp ----------
if grep -r 'LSP references' skills/rust-lsp/ >/dev/null 2>&1; then
  check "No 'LSP references' in rust-lsp/" "fail"
else
  check "No 'LSP references' in rust-lsp/" "pass"
fi

# ---------- Test 10: std::sync::mpsc not in Deprecated table ----------
# Check that mpsc is NOT in the Deprecated Patterns section (between "### Deprecated" and next "###")
if sed -n '/### Deprecated/,/^###/p' skills/rust/SKILL.md | grep -q 'mpsc'; then
  check "std::sync::mpsc not in Deprecated table" "fail"
else
  check "std::sync::mpsc not in Deprecated table" "pass"
fi

# ---------- Test 11: tokio-retry not recommended without qualification ----------
if grep 'tokio-retry' skills/rust/ref/error-handling.md >/dev/null 2>&1; then
  check "tokio-retry not recommended without qualification" "fail"
else
  check "tokio-retry not recommended without qualification" "pass"
fi

# ---------- Test 12: No failsafe-rs without alternative ----------
if grep 'failsafe' skills/rust/ref/error-handling.md >/dev/null 2>&1; then
  check "No failsafe-rs in error-handling.md" "fail"
else
  check "No failsafe-rs in error-handling.md" "pass"
fi

# ---------- Test 13: No into_shape in ml.md ----------
if grep 'into_shape' skills/rust-domain/ml.md >/dev/null 2>&1; then
  check "No into_shape in ml.md" "fail"
else
  check "No into_shape in ml.md" "pass"
fi

# ---------- Test 14: No bare warp recommendation ----------
if grep '^| warp ' skills/rust-domain/web.md >/dev/null 2>&1; then
  check "No bare warp recommendation in web.md" "fail"
else
  check "No bare warp recommendation in web.md" "pass"
fi

# ---------- Test 15: fintech.md Amount::add uses clone ----------
if grep 'self\.currency)' skills/rust-domain/fintech.md | grep -v 'clone()' | grep -q .; then
  check "fintech.md Amount::add uses clone on currency" "fail"
else
  check "fintech.md Amount::add uses clone on currency" "pass"
fi

# ---------- Test 16: iot.md clones client before spawn ----------
if grep -q 'client\.clone()' skills/rust-domain/iot.md; then
  check "iot.md clones client before spawn" "pass"
else
  check "iot.md clones client before spawn" "fail"
fi

# ---------- Test 17: cloud-native.md handles SIGTERM ----------
if grep -q 'SignalKind::terminate' skills/rust-domain/cloud-native.md; then
  check "cloud-native.md handles SIGTERM" "pass"
else
  check "cloud-native.md handles SIGTERM" "fail"
fi

# ---------- Test 18: cli.md recommends doc comments not #[arg(help)] ----------
if grep 'arg(help' skills/rust-domain/cli.md >/dev/null 2>&1; then
  check "cli.md recommends doc comments not arg(help)" "fail"
else
  check "cli.md recommends doc comments not arg(help)" "pass"
fi

# ---------- Test 19: ffi-patterns.md Pattern 4 has catch_unwind import ----------
if grep -q 'use std::panic.*catch_unwind' skills/unsafe-checker/examples/ffi-patterns.md; then
  check "ffi-patterns.md Pattern 4 has catch_unwind import" "pass"
else
  check "ffi-patterns.md Pattern 4 has catch_unwind import" "fail"
fi

# ---------- Test 20: ffi-04 no dangling pointer in get_last_error ----------
if grep 'as_ptr.*c_char' skills/unsafe-checker/rules/ffi-04-panic-boundary.md >/dev/null 2>&1; then
  check "ffi-04 no dangling pointer in get_last_error" "fail"
else
  check "ffi-04 no dangling pointer in get_last_error" "pass"
fi

# ---------- Test 21: mem-06 no nightly label ----------
if grep -i 'nightly' skills/unsafe-checker/rules/mem-06-maybeuninit.md >/dev/null 2>&1; then
  check "mem-06 no nightly label" "fail"
else
  check "mem-06 no nightly label" "pass"
fi

# ---------- Summary ----------
TOTAL=$((PASS + FAIL))
echo ""
echo "${PASS}/${TOTAL} passed"
if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
