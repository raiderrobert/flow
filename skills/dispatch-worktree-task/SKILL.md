---
name: dispatch-worktree-task
description: "Use when a task has a clear implementation plan and should be executed by a subagent in an isolated git worktree. Triggers on phrases like: dispatch this, send to a subagent, work on this in a worktree, dispatch to worktree, background task, isolated execution."
---

# Dispatch Worktree Task

## Overview

Packages a task with a clear plan, creates an isolated git worktree, and dispatches a subagent to implement, validate, verify, commit, and push — all in the background.

**Core principle:** Plan in the main session, execute in isolation, verify before pushing.

## When to Use

- Implementation plan is written and approved
- Task is self-contained (no back-and-forth needed)
- You want background execution while continuing other work

**When NOT to use:**
- Task requires interactive clarification mid-implementation
- Changes span multiple repos or need coordination with other branches
- Quick single-file fix (just do it inline)

## Workflow

```dot
digraph dispatch {
  rankdir=TB;
  node [shape=box];

  plan [label="1. Prepare implementation plan"];
  worktree [label="2. Create git worktree\non new branch"];
  dispatch [label="3. Dispatch subagent\n(implement, verify, push)"];
  review [label="4. Review diff + PR"];
  cleanup [label="5. Remove worktree"];

  plan -> worktree -> dispatch -> review -> cleanup;
}
```

### 1. Prepare the implementation plan

Write a detailed plan that includes:
- **Context** — why this change, what was tried/rejected
- **Step-by-step plan** — numbered, specific files and code patterns
- **Pre-commit validation** — exact commands to run (read from project's CLAUDE.md)
- **Reproduction command** — a command that exercises the original scenario (bug or feature). Adapt paths, use temp dirs, etc., but exercise the same behavior. The subagent must run it after implementing and confirm the fix works.
- **What NOT to do** — anti-patterns to avoid

### 2. Create worktree

```bash
git worktree add .worktrees/<branch-name> -b <branch-name> main
```

Use `.worktrees/` directory. Check that `.worktrees/` is in `.gitignore`. If not, add it before creating the worktree. Branch name should match the work (e.g., `fix/cache-lock-fs4`).

> **Why manual worktrees instead of `isolation: "worktree"`?** The branch is the deliverable — it gets pushed and PR'd. You need a named branch you control. For fan-out/fan-in where you cherry-pick temporary commits back, see `review-and-fix`.

### 3. Dispatch subagent

Use the Task tool with these settings:

| Parameter | Value |
|-----------|-------|
| `subagent_type` | `general-purpose` |
| `mode` | `bypassPermissions` |
| `run_in_background` | `true` |

**Prompt must include:**
- Worktree path and branch name
- **Explicit `cd <worktree-absolute-path>` as the subagent's first action.** The Task tool starts subagents in the parent's working directory, not the worktree.
- Full implementation plan
- Pre-commit validation commands (from project CLAUDE.md)
- **Reproduction command** — a command that exercises the same scenario as the original report. Adapt for the worktree context (temp output dirs, etc.) but verify the same behavior.
- Commit message to use (conventional commits)
- `git push -u origin <branch>` as final step
- Project conventions (no co-authored-by lines, etc.)

**Subagent execution order:**
1. Implement the change
2. Run pre-commit validation (from project CLAUDE.md)
3. **Reproduce the original scenario** — build and run a command that exercises the same behavior from the original report. Adapt for safety (temp dirs, non-destructive variants) but verify the same scenario.
4. Commit and push

If the reproduction command fails, the subagent must fix the issue and re-verify before pushing. If it cannot fix it, it should commit but NOT push, and report the failure.

### 4. Review and create PR

When the agent reports back:
- Check `git log` and `git diff --stat` on the branch
- Read the actual diff for the key files
- Confirm the reproduction command passed in the agent's output
- Create the PR (or remind the user)

### 5. Clean up worktree

After the PR is created, remove the worktree:

```bash
git worktree remove .worktrees/<branch-name>
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| No reproduction command in prompt | Always include a command that exercises the original scenario |
| Reproduction command is just "run tests" | Tests verify correctness; reproduction verifies the original complaint is resolved |
| Reproduction command is destructive | Adapt for safety — use temp dirs, non-destructive variants — but verify the same behavior |
| Vague subagent prompt | Paste the full plan — subagents have no prior context |
| Not verifying the diff | Always read the key file diffs before creating the PR |
| Skipping pre-commit in prompt | Agent won't know to run validation unless told |
| Forgetting the PR | Always create or remind about PR after reviewing |
