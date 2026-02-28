---
name: iterative-review-fix
description: "Use when code needs repeated review-fix cycles until clean. Dispatches a reviewer agent, then a fixer agent, commits, and repeats until findings converge to zero or a cap is reached. Triggers on: iterate until clean, review fix loop, converge, repeated review, keep fixing until done, iterative review."
---

# Iterative Review-Fix Loop

## Overview

Serial review-fix loop: dispatch a read-only reviewer, then a fixer, commit, repeat until findings hit zero, plateau, or an iteration cap. Designed for convergence, not throughput.

**Core principle:** One reviewer, one fixer, per iteration. Each pass commits directly on the current branch. Commits are revert points.

## When to Use

- Code needs multiple rounds of review to converge on clean
- User says "iterate until clean", "keep fixing", or "review fix loop"
- A single review-and-fix pass is insufficient (findings cascade)

**When NOT to use:**
- Single-pass review with parallel dispatch — use `review-and-fix`
- Research-backed review — use `review-with-research`
- One specific bug fix — just fix it inline

## Workflow

### 1. Capture Inputs

Determine three things before starting the loop:

**Review focus** — what to look for. The user provides criteria inline or as a file path. Read the file if a path is given.

**Scope** — what to review. Default: branch diff vs main.
```bash
git diff main --stat
git log main..HEAD --oneline
```
If the user specifies a directory or file list, use that instead.

**Iteration cap** — default 5. The user can override.

Read the project's `CLAUDE.md` for pre-commit validation commands — the fixer needs these.

### 2. Loop (iterations 1..cap)

#### 2a. Dispatch reviewer

Launch a read-only subagent:

| Parameter | Value |
|-----------|-------|
| `subagent_type` | `Explore` |
| `run_in_background` | `true` |

**Reviewer prompt:**

```
You are performing review pass {N} of an iterative review-fix cycle.

## Review Focus
{criteria — inline text or file contents}

## Scope
{branch diff output, directory listing, or file list}

## Output Format
For each issue found, produce:

### Finding: [stable title — same title if same issue persists across passes]
**Severity:** high | medium | low
**File:** `path/to/file:line`
**Description:** [what's wrong and why]
**Fix approach:** [specific steps to fix]

If no issues found, respond with exactly: NO_FINDINGS
```

**Stable titles are critical.** The main session compares findings across passes to detect plateaus. If the reviewer uses a different title for the same issue, plateau detection breaks. Instruct the reviewer to title findings by the problem, not the pass number.

#### 2b. Parse findings

Three outcomes:

1. **Zero findings** (`NO_FINDINGS`) — break the loop, report clean.
2. **Same findings as previous pass** — plateau detected. The fixer is stuck on these issues. Break the loop, report the stuck findings.
3. **New or different findings** — proceed to fixer.

**Plateau detection:** Compare finding titles (not full descriptions) between consecutive passes. If the set of titles is identical, it's a plateau. If a subset overlaps but new findings appeared, it's not a plateau — the fixer made partial progress.

#### 2c. Dispatch fixer

Launch a general-purpose subagent:

| Parameter | Value |
|-----------|-------|
| `subagent_type` | `general-purpose` |
| `mode` | `bypassPermissions` |
| `run_in_background` | `true` |

**Fixer prompt:**

```
You are fixing issues found during review pass {N}.

## Findings
{paste all findings from reviewer — full text, not just titles}

## Validation
After making all fixes, run these commands and confirm they pass:
{pre-commit validation commands from project CLAUDE.md}

## Commit
If all fixes are made and validation passes, create a single commit:
fix: address review findings (pass {N})

Do NOT add co-authored-by lines.
Do NOT modify files beyond what the findings require.
Do NOT commit if validation fails — report the failure instead.
```

**If the fixer reports validation failure:** stop the loop immediately. Report the failure to the user with the fixer's output. Do not continue to the next pass — a broken build state will cascade.

#### 2d. Increment and continue

After a successful fixer pass, increment the counter and loop back to 2a.

### 3. Report

When the loop exits (clean, plateau, or cap), produce a summary:

**Clean exit:**
```
Review-fix loop completed in {N} passes.
Pass 1: {count} findings — fixed and committed
Pass 2: {count} findings — fixed and committed
Pass 3: clean — no findings
```

**Plateau exit:**
```
Review-fix loop plateaued after {N} passes.
Pass 1: {count} findings — fixed and committed
Pass 2: {count} findings — fixed and committed (partial overlap with pass 1)
Pass 3: {count} findings — same as pass 2 (plateau)

Stuck findings:
- [Finding title]: [brief description]
- [Finding title]: [brief description]

These issues may require manual intervention or a different approach.
```

**Cap exit:**
```
Review-fix loop hit iteration cap ({cap}) with {count} findings remaining.
[Per-pass summary as above]

Remaining findings:
[List findings from the last pass]
```

## Key Conventions

- **Serial, not parallel.** One reviewer, one fixer per iteration. Simplicity over throughput.
- **Direct on branch.** No worktrees. Each iteration commits directly. Commits are revert points.
- **Fully autonomous.** No user gate between iterations. Runs until a stopping condition.
- **Fixer gets full findings each pass.** Not deltas. The fixer doesn't know what previous passes did.
- **One commit per pass.** Keeps history clean and gives one revert point per iteration.
- **Pre-commit validation is the fixer's job.** If validation fails, the fixer does NOT commit.
- **No co-authored-by lines.** Encode this in every fixer prompt.

## Stopping Conditions

| Condition | Action |
|-----------|--------|
| Reviewer returns `NO_FINDINGS` | Break — report clean |
| Finding titles identical to previous pass | Break — report plateau with stuck findings |
| Iteration counter reaches cap | Break — report cap hit with remaining findings |
| Fixer reports validation failure | Break — report failure with fixer output |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewer uses different titles for same issue across passes | Prompt reviewer to use stable titles based on the problem |
| Fixer modifies unrelated code | Prompt explicitly: only fix what's in the findings |
| Skipping plateau detection | Always compare finding titles between consecutive passes |
| Continuing after validation failure | Stop immediately — broken builds cascade |
| Not reading project CLAUDE.md first | Pre-commit commands vary per project |
| Running in parallel with other work | This skill commits directly on the branch — no concurrent modifications |
