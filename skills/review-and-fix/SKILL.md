---
name: review-and-fix
description: "Use when the user wants to review code on a branch, find issues, and dispatch parallel fixes. Triggers include: review and fix, review this branch, find and fix issues, dispatch fixes, parallel fix, review then fix, fix all issues, code review with fixes."
---

# Review and Fix: Parallel Code Review with Automated Dispatch

Review code on a branch using a domain skill, document all findings, dispatch each fix to a parallel worktree subagent, cherry-pick results back, verify, and push.

---

## Workflow

### 1. Understand the Scope

Determine what to review. Default is the current branch's diff against `main`.

```bash
git log main..HEAD --oneline
git diff main --stat
```

Check if the user wants to review:
- The full branch diff (default)
- A specific module or directory
- Only recent commits

Read the project's `CLAUDE.md` for pre-commit validation commands — you'll need these later.

### 2. Review with a Domain Skill

Invoke the appropriate domain skill for the language/framework:
- **Rust** — use the `rust` skill
- **TypeScript** — use general review or a TS skill if available
- **Other** — do a thorough general code review

Focus the review on the branch diff, not the entire codebase. Look for:
- Bugs and correctness issues
- Performance problems
- Design issues (wrong abstraction, coupling, missing error handling)
- Minor issues (naming, style, redundancy)

Produce a structured list of findings.

### 3. Document Findings

Write findings to a temporary markdown file in the repo root: `_review-findings.md`

Format each finding as:

```markdown
## Finding N: [Title]

**Severity:** bug | perf | design | minor
**Files:** `path/to/file.rs:42`, `path/to/other.rs:17`

**Description:**
[What the issue is and why it matters]

**Fix approach:**
[Specific steps to fix. Include before/after code snippets when possible]
```

Present the findings to the user. Ask if they want to:
- Fix all findings
- Fix only specific findings (by number)
- Skip the dispatch and just keep the review document

If the user says to proceed, continue to step 4.

### 4. Create Task List

Create one task per finding using `TaskCreate`. Include the finding number, title, severity, and file list in each task description.

### 5. Dispatch Parallel Worktree Agents

Launch one `general-purpose` subagent per fix. Use `isolation: "worktree"`, `run_in_background: true`, and `mode: "bypassPermissions"`.

**Dispatch order:** Least-coupled fixes first. If two fixes touch the same file, note the dependency and dispatch them sequentially or flag the potential conflict.

**Agent prompt template:**

```
You are fixing a specific issue found during code review.

## Task
[Finding title and description from the findings doc]

## Files to Modify
[Exact file paths and line numbers]

## Fix Approach
[Step-by-step fix instructions, with before/after code when available]

## Validation
After making the fix, run these commands and ensure they all pass:
[Pre-commit validation commands from project CLAUDE.md]

## Commit
Create a single commit with this message:
[Conventional commit message, e.g., fix(module): description]

Do NOT add any co-authored-by lines.
Do NOT modify any files beyond what is needed for this fix.
Do NOT add comments, docstrings, or formatting changes to code you didn't change.
```

### 6. Cherry-Pick Results

As each agent completes:

1. Check the agent's result for the worktree path and branch name.
2. Find the commit SHA:
   ```bash
   git log --oneline -1 <worktree-branch>
   ```
3. Cherry-pick onto the working branch:
   ```bash
   git cherry-pick <sha>
   ```
4. If the cherry-pick conflicts:
   - Check if the conflict is trivial (overlapping context lines) — resolve manually.
   - If the conflict is substantive (two fixes changed the same logic), re-dispatch one of them with the other's changes already applied.
5. Mark the corresponding task as completed.

**Cherry-pick in dependency order:** If fixes were dispatched with noted dependencies, cherry-pick the prerequisite first.

### 7. Verify

Run the full pre-commit validation suite on the integrated result:

```bash
# Example for Rust — use whatever the project's CLAUDE.md specifies
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

All checks must pass. If something fails:
- Identify which cherry-picked fix caused the failure.
- Either fix it directly or re-dispatch that specific fix with the current branch state.

### 8. Push and Clean Up

1. Push the branch:
   ```bash
   git push
   ```
2. If a PR exists for this branch, update its description with a "Code review fixes" section listing each finding and its resolution.
3. Delete the `_review-findings.md` file (or keep it if the user wants it).

---

## Key Conventions

- **Always read the project's CLAUDE.md first.** Pre-commit validation commands vary per project.
- **Use `mode: "bypassPermissions"` for worktree agents.** They're isolated and can't affect the main tree.
- **Cherry-pick in dependency order.** Least-coupled first, then fixes that depend on earlier ones.
- **If cherry-pick conflicts, resolve or re-dispatch.** Don't force through broken merges.
- **No co-authored-by lines.** Per user preference — encode this in every agent prompt.
- **Clean up after yourself.** Remove the findings file, mark tasks complete, report final status.

---

## Output Quality Checklist

Before reporting completion to the user:

- [ ] All dispatched fixes have been cherry-picked
- [ ] Pre-commit validation passes on the integrated result
- [ ] Branch has been pushed
- [ ] PR description updated (if a PR exists)
- [ ] Findings file cleaned up
- [ ] Task list shows all findings resolved
