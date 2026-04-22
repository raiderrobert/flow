# Codebase Audit Skill — Design Spec

**Goal:** A skill that performs a comprehensive structural review of a codebase's organization, looking for architectural smells and quality issues. Not a bug hunt or PR review — an audit of how code is organized.

**Skill name:** `codebase-audit`
**Location:** `skills/codebase-audit/SKILL.md`
**Repo:** `flow`

---

## Trigger Phrases

codebase audit, structural review, architecture audit, code organization review, audit this codebase, how is this repo organized, code health check, audit the code

Distinct from existing skills:
- `review-and-fix` — PR-scoped, includes fix dispatch
- `iterative-review-fix` — repeated review-fix loop on a branch
- `review-with-research` — validates approach soundness with external research
- `design-audit` — visual/frontend design quality

---

## Workflow

### 1. Read project docs

Read AGENTS.md, ARCHITECTURE.md, CLAUDE.md, CONTRIBUTING.md, README.md (whatever exists). AGENTS.md is a good starting place as it often documents project conventions in agent-friendly form. Extract the project's own documented conventions and boundaries. These become the "project-specific" criteria.

### 2. Map the codebase

Get the shape before reading individual files:
- File tree and directory structure
- Line counts per module/file
- Import/dependency graph (which modules import which)

This step identifies the largest files, the most-imported modules, and the overall layering.

### 3. Read source files

For codebases under ~10K lines, read all source files. For larger codebases, sample strategically:
- Public API surfaces (exports, interfaces, `__init__` / index files)
- Module boundaries (top-level of each package/directory)
- Largest files (most likely to have cohesion issues)
- Files with the most imports or most importers (coupling hotspots)

### 4. Evaluate against checklist

Apply the default checklist plus project-specific criteria derived from step 1.

### 5. Produce findings

Structured report organized by file, with severity, criterion, description, and recommendation.

---

## Default Checklist

Six categories, grounded in established software engineering principles (Fowler's code smells, coupling/cohesion metrics, architecture review literature).

### Boundaries & Dependencies

- **Dependency direction violations** — does the documented or implied layering hold? Do lower layers import from higher layers?
- **Circular dependencies** — deferred/lazy imports used to break import cycles, or mutual function-level coupling between modules
- **Private API access** — modules reaching into another module's private internals (underscore-prefixed in Python, unexported in Go, `pub(crate)` in Rust, non-exported in TS)
- **Leaky abstractions** — implementation details visible in public interfaces
- **Feature envy** — code that uses another module's data or functions more than its own
- **Fan-out hotspots** — modules with too many dependencies (high coupling)
- **Hidden dependencies** — dependencies not visible from the interface (global state, implicit ordering)

### Cohesion & Responsibility

- **God files/modules** — too large, too many responsibilities, too many reasons to change
- **Divergent change** — one module that changes for many unrelated reasons (low cohesion)
- **Shotgun surgery** — one logical change requires edits scattered across many files
- **Speculative generality** — unused abstractions, interfaces nobody implements, parameters nobody passes (YAGNI violations)
- **Data clumps** — groups of values that always travel together but aren't a named type

### Error Handling

- **Overly broad error handling** — catching all errors instead of specific types (`except Exception` in Python, untyped `catch(e)` in TS, `recover()` swallowing panics in Go, `.unwrap()` throughout in Rust)
- **Inconsistent error strategies** — similar modules handling errors in fundamentally different ways
- **Wrong-layer error handling** — errors caught too early (swallowed before the caller can act) or too late (propagated without context)
- **Unused error types** — custom error types defined but not raised/returned

### Code Hygiene

- **Duplicated logic** — repeated code across modules that should be extracted
- **Dead code** — unused functions, unreachable branches, commented-out code
- **Magic strings/numbers** — hardcoded values that should be named constants
- **Inconsistent patterns** — similar operations done differently in different places for no good reason

### Documentation Alignment

- **Stale architecture docs** — documentation that doesn't match the actual code
- **Documented but unenforced conventions** — rules written down that the code violates
- **Undocumented conventions** — implicit rules the code follows that aren't written anywhere

### Project-Specific

- Whatever conventions the project documents in AGENTS.md, ARCHITECTURE.md, CLAUDE.md, or CONTRIBUTING.md
- Examples: "core/ must not import from commands/", "all commands export `run_<command>()`", "type hints on all signatures"

---

## Finding Format

```
### [file_path:line]

**Criterion:** [checklist item name]
**Severity:** HIGH | MEDIUM | LOW
**Description:** [what's wrong, with code snippet]
**Recommendation:** [how to fix]
```

Severity definitions:
- **HIGH** — architectural violation, likely bug source, or data loss risk
- **MEDIUM** — code smell that meaningfully hurts maintainability
- **LOW** — style/convention nit or minor inconsistency

Findings organized by file, not by criterion — makes them actionable.

---

## Report Structure

```
# Codebase Audit: [project name]

**Date:** YYYY-MM-DD
**Scope:** [files reviewed, line count]

## Summary
[2-3 sentences: finding count, severity breakdown, biggest themes]

## Findings
[organized by file, using the finding format above]

## Themes
[recurring patterns across findings — what systemic issues do they point to?]

## What's Working Well
[positive observations — validated conventions, clean boundaries, good patterns]
```

---

## What This Skill Does NOT Do

- **Bug hunting** — this is structural, not functional
- **Security audit** — no OWASP/CVE scanning
- **Performance profiling** — no hot path analysis
- **PR review** — use `review-and-fix` for that
- **Fix dispatch** — this skill produces a report, not fixes. The user decides what to act on.
- **Automated fixes** — pair with `review-and-fix` or `iterative-review-fix` if you want automated remediation

---

## Composability

This skill is a single-agent, single-pass audit. For more rigor:
- Wrap with `diverge-critique-converge` for multi-perspective review
- Follow up with `review-and-fix` or `iterative-review-fix` to act on findings
- Use findings to create GitHub issues via `gh issue create`
