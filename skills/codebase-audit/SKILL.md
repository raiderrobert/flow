---
name: codebase-audit
description: "Use when reviewing a codebase's structural organization, not a PR or branch. Triggers on: codebase audit, structural review, architecture audit, code organization review, audit this codebase, how is this repo organized, code health check, audit the code. Produces a findings report against a standard checklist plus project-specific conventions."
---

# Codebase Audit

Comprehensive structural review of how a codebase is organized. Evaluates architectural boundaries, code smells, error handling patterns, and documentation alignment against a standard checklist plus the project's own documented conventions.

This is not a bug hunt, security audit, or PR review. It examines organization and structure.

---

## Workflow

### 1. Read project docs

Read whatever exists: AGENTS.md, ARCHITECTURE.md, CLAUDE.md, CONTRIBUTING.md, README.md. AGENTS.md is a good starting place — it often documents conventions in agent-friendly form.

Extract two things:
- **Documented boundaries** — layer rules, import restrictions, module responsibilities
- **Documented conventions** — naming, patterns, error handling, testing requirements

These become the project-specific checklist items in step 4.

### 2. Map the codebase

Get the shape before reading individual files:

Use language-appropriate tools:
- File tree and line counts (`find`, `wc -l`, or language-specific tools)
- Import/dependency graph (grep for import statements, or use `cargo tree`, `go mod graph`, etc.)

Identify:
- Largest files (cohesion risk)
- Most-imported modules (coupling hotspots, fan-in)
- Modules with the most imports (fan-out hotspots)
- Overall layering and directory structure

### 3. Read source files

**Under ~10K lines:** Read all source files.

**Over ~10K lines:** Sample strategically:
- Public API surfaces (exports, package-level files, index/init modules)
- Module boundaries (top-level of each package/directory)
- Largest files (most likely to have cohesion problems)
- Files with the most imports or the most importers

### 4. Evaluate against checklist

Apply the default checklist below, plus project-specific criteria from step 1.

For each potential finding:
- Verify it against the actual code (cite file and line)
- Assign severity
- Write a concrete recommendation

Skip anything that is technically true but does not matter in practice.

### 5. Produce report

Write the report using the output format below. Organize findings by file, not by criterion.

---

## Default Checklist

### Boundaries & Dependencies

| Smell | What to look for |
|-------|-----------------|
| Dependency direction | Lower layers importing from higher layers, violating documented or implied architecture |
| Circular dependencies | Deferred/lazy imports to break cycles, mutual function-level coupling between modules |
| Private API access | Modules reaching into another module's internals (language-specific visibility rules) |
| Leaky abstractions | Implementation details visible in public interfaces |
| Feature envy | Code that uses another module's data/functions more than its own |
| Fan-out hotspots | Modules with too many dependencies |
| Hidden dependencies | Dependencies not visible from the interface — global state, implicit ordering, side-effect coupling |

### Cohesion & Responsibility

| Smell | What to look for |
|-------|-----------------|
| God files | Too large, too many responsibilities, too many reasons to change |
| Divergent change | One module that changes for many unrelated reasons |
| Shotgun surgery | One logical change requires edits scattered across many files |
| Speculative generality | Unused abstractions, interfaces nobody implements, parameters nobody passes |
| Data clumps | Groups of values that always travel together but aren't a named type |

### Error Handling

| Smell | What to look for |
|-------|-----------------|
| Overly broad handling | Catching all errors instead of specific types |
| Inconsistent strategies | Similar modules handling errors in fundamentally different ways |
| Wrong-layer handling | Errors swallowed before the caller can act, or propagated without context |
| Unused error types | Custom error types defined but never raised or returned |

### Code Hygiene

| Smell | What to look for |
|-------|-----------------|
| Duplicated logic | Repeated code across modules that should be extracted |
| Dead code | Unused functions, unreachable branches, commented-out code |
| Magic values | Hardcoded strings or numbers that should be named constants |
| Inconsistent patterns | Similar operations done differently in different places for no reason |

### Documentation Alignment

| Smell | What to look for |
|-------|-----------------|
| Stale docs | Architecture documentation that doesn't match the actual code |
| Unenforced conventions | Rules written down that the code violates |
| Undocumented conventions | Implicit rules the code follows that aren't written anywhere |

### Project-Specific

Derived from step 1. Whatever conventions the project documents as its own rules.

Examples: "core/ must not import from commands/", "all handlers return a Result type", "every module has a corresponding test file"

---

## Output Format

```markdown
# Codebase Audit: [project name]

**Date:** YYYY-MM-DD
**Scope:** [files reviewed, total line count]

## Summary

[2-3 sentences: finding count by severity, biggest themes]

## Findings

### src/path/to/file.ext:42

**Criterion:** [checklist item name]
**Severity:** HIGH | MEDIUM | LOW
**Description:** [what's wrong, with code snippet]
**Recommendation:** [how to fix]

### src/path/to/other.ext:17

...

## Themes

[Recurring patterns across findings — what systemic issues do they point to?]

## What's Working Well

[Positive observations — validated conventions, clean boundaries, good patterns worth preserving]
```

**Severity definitions:**
- **HIGH** — architectural violation, likely bug source, or data loss risk
- **MEDIUM** — code smell that meaningfully hurts maintainability
- **LOW** — style or convention nit

---

## Scope Boundaries

This skill produces a report. It does not fix anything.

| Need | Use instead |
|------|-------------|
| Review a PR or branch diff | `review-and-fix` |
| Repeated review-fix cycles | `iterative-review-fix` |
| Validate whether an approach is sound | `review-with-research` |
| Audit visual/frontend design | `design-audit` |
| Multi-perspective review | Wrap this skill with `diverge-critique-converge` |
| Automated remediation | Follow up findings with `review-and-fix` or `iterative-review-fix` |
| Track findings as tickets | Use `gh issue create` on each finding |
