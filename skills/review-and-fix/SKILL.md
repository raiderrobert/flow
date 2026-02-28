---
name: review-and-fix
description: "Use when the user wants to review existing work on a branch, find issues, and dispatch parallel fixes that get cherry-picked back. Triggers include: review and fix, review and fix this branch, find and fix issues, dispatch fixes, parallel fix, review then fix, fix all issues, code review with fixes."
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

Apply domain knowledge from the relevant skill's reference files (e.g., the rust skill's anti-patterns and style references). Do not invoke the Skill tool — stay in this workflow.

- **Rust** — use the `rust` skill's reference files
- **TypeScript** — use general review or a TS skill's reference files if available
- **Other** — do a thorough general code review

Focus the review on the branch diff, not the entire codebase. Look for:
- Bugs and correctness issues
- Performance problems
- Design issues (wrong abstraction, coupling, missing error handling)
- Minor issues (naming, style, redundancy)

Produce a structured list of findings.

**If the review finds no issues, report a clean review to the user and stop.** Do not proceed to dispatch.

### 3. Document Findings

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
- Skip the dispatch and keep the review document

If the user chooses to **skip dispatch**, write findings to `_review-findings.md` in the repo root and stop. Otherwise, write findings to `_review-findings.md` as a backup (dispatch involves multiple background agents and context compression could lose them), then continue. Delete the file in step 8 after all fixes land.

### 4. Create Task List

Create one task per finding using `TaskCreate`. Include the finding number, title, severity, and file list in each task description. Step 5 uses this as the dispatch manifest — tasks are marked in-progress as agents launch and completed as cherry-picks land.

### 5. Dispatch Parallel Worktree Agents

Launch one `general-purpose` subagent per fix. Use `isolation: "worktree"`, `run_in_background: true`, and `mode: "bypassPermissions"`.

> **Why `isolation: "worktree"` instead of manual worktrees?** These worktrees are temporary scaffolding — you cherry-pick the commits back by SHA and the worktree is discarded. You don't need named branches. For backgrounding a single task where the branch is the deliverable, see `dispatch-worktree-task`.

**Dispatch order:** Least-coupled fixes first. If two fixes touch the same file, they cannot run in parallel — cherry-pick the first fix BEFORE creating the second worktree so the second agent branches from the updated state.

**Wave strategy:** For more than 4 findings, dispatch in waves of 3–4. Complete the wave, cherry-pick all results, then dispatch the next wave. This gives the next wave a more complete starting state and reduces conflicts. Mark tasks in-progress as agents launch.

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

As each agent completes (or after each wave):

1. The Agent tool result includes the worktree branch name. Use it to find the commit SHA:
   ```bash
   git log --oneline -1 <worktree-branch>
   ```
2. Cherry-pick onto the working branch:
   ```bash
   git cherry-pick <sha>
   ```
3. If the cherry-pick conflicts:
   - Check if the conflict is trivial (overlapping context lines) — resolve manually and `git cherry-pick --continue`.
   - If the conflict is substantive (two fixes changed the same logic), abort with `git cherry-pick --abort` and re-dispatch one of them with the other's changes already applied.
4. Mark the corresponding task as completed.

**Cherry-pick in dependency order:** If fixes were dispatched with noted dependencies, cherry-pick the prerequisite first.

### 7. Verify

Run pre-commit validation after each cherry-pick (not just at the end) to catch failures early:

```bash
# Example for Rust — use whatever the project's CLAUDE.md specifies
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

If a check fails after a cherry-pick (the cherry-pick succeeded but validation doesn't pass):
1. Undo the cherry-pick: `git reset --hard HEAD~1`
2. Identify what the fix broke in the current branch state
3. Re-dispatch that specific fix with the current branch state as context

After all cherry-picks land, run the full validation suite once more to confirm the integrated result passes.

### 8. Push and Clean Up

1. Show the user what will be pushed:
   ```bash
   git log main..HEAD --oneline
   ```
   Along with validation results. Ask the user to confirm before pushing.
2. Push the branch:
   ```bash
   git push
   ```
3. If a PR exists for this branch, update its description with a "Code review fixes" section listing each finding and its resolution.
4. Remove stale worktrees created by `isolation: "worktree"` agents. List them and remove any that correspond to completed fixes:
   ```bash
   git worktree list
   git worktree remove <worktree-path>
   ```
5. Delete `_review-findings.md` (the backup from step 3).

---

## Key Conventions

- **Always read the project's CLAUDE.md first.** Pre-commit validation commands vary per project.
- **Use `mode: "bypassPermissions"` for worktree agents.** They're isolated and can't affect the main tree.
- **Cherry-pick in dependency order.** Least-coupled first, then fixes that depend on earlier ones.
- **If cherry-pick conflicts, resolve or re-dispatch.** Don't force through broken merges.
- **No co-authored-by lines.** Per user preference — encode this in every agent prompt.
- **Clean up after yourself.** Mark tasks complete, report final status.

---

## Output Quality Checklist

Before reporting completion to the user:

- [ ] All dispatched fixes have been cherry-picked
- [ ] Pre-commit validation passes on the integrated result
- [ ] User confirmed push after seeing `git log` and validation results
- [ ] Branch has been pushed
- [ ] PR description updated (if a PR exists)
- [ ] Stale worktrees removed
- [ ] `_review-findings.md` deleted
- [ ] Task list shows all findings resolved
