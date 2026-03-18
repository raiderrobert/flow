---
name: parallel-ticket-pipeline
description: Use when working on multiple tickets simultaneously, dispatching parallel subagents across worktrees, or needing a CI-fix loop to get branches green. Covers worktree setup, parallel planning, implementation, PRs, tests, and CI monitoring.
---

# Parallel Ticket Pipeline

## Overview

Take N tickets, spin up isolated worktrees, dispatch parallel subagents for planning/implementation/tests, create PRs, and run CI-fix loops until green. Each phase feeds the next.

## When to Use

- User provides multiple tickets to work on simultaneously
- Work can be parallelized across independent branches
- Need automated CI monitoring and fixing

## Pipeline Phases

```dot
digraph pipeline {
  rankdir=LR;
  "Identify tickets" -> "Create worktrees" -> "Fetch ticket details" -> "Plan (parallel agents)" -> "Implement" -> "Push + PRs" -> "Tests (parallel agents)" -> "CI loop (parallel agents)" -> "Done";
}
```

## Phase 1: Setup

### Identify tickets
Filter the user's list to relevant tickets. Confirm scope with user if ambiguous.

### Create worktrees
```bash
# Check for existing worktree directory
ls -d .worktrees 2>/dev/null
git check-ignore -q .worktrees  # Verify ignored

# Create one worktree per ticket
git worktree add .worktrees/TICKET-123-short-name -b TICKET-123-short-name
```

### Fetch ticket details
Use Jira CLI (`acli jira workitem view TICKET-123`) or equivalent in parallel for all tickets.

## Phase 2: Plan (Parallel Agents)

Dispatch one subagent per ticket with `mode: "plan"` and `run_in_background: true`.

Each agent prompt needs:
- **Worktree path** as working directory
- **Ticket details** from Jira
- **Event/feature spec** if available (spreadsheet data, etc.)
- **Codebase conventions** (reference skill docs, CLAUDE.md patterns)
- **Commit conventions** (`feat(TICKET-123): description`, no co-authored-by)

Agents return plans. Present summaries to user for approval.

## Phase 3: Implement

### Subagent limitations
Subagents often cannot get edit/bash permissions regardless of mode (`plan`, `acceptEdits`, `bypassPermissions`). Be prepared for this.

### Strategy
1. **Try subagents first** with `mode: "bypassPermissions"` and `run_in_background: true`
2. **If agents can't edit**, implement directly using their plans as blueprints
3. **For small changes**, implement directly from the start (faster than agent round-trips)

### Worktree commit gotchas
```bash
# Husky pre-commit hooks break in worktrees
git commit --no-verify -m "feat(TICKET-123): description"

# GPG signing can timeout - use --no-gpg-sign as fallback
git commit --no-verify --no-gpg-sign -m "feat(TICKET-123): description"

# ALWAYS run prettier/eslint manually since --no-verify skips hooks
npx prettier --write <changed-files>
npx eslint --fix <changed-files>
```

## Phase 4: Push + PRs

Push all branches and create draft PRs in parallel:
```bash
# Push from each worktree
cd .worktrees/TICKET-123-short-name && git push -u origin TICKET-123-short-name

# Create draft PR with Jira link
gh pr create --draft --title "feat(TICKET-123): short description" --body "$(cat <<'EOF'
[TICKET-123](https://your-jira.atlassian.net/browse/TICKET-123)

Short description of changes.
EOF
)"
```

### SSH key issues
Hardware security keys can lock between operations. Batch pushes when key is available. If push fails with `agent refused operation`, notify user to unlock and retry.

## Phase 5: Tests (Parallel Agents)

Dispatch one agent per ticket to write tests. Each prompt needs:
- Working directory (worktree path)
- What was changed (files, functions, patterns)
- Existing test patterns in the codebase (provide a reference test file)
- Instructions to run tests, lint, commit, and push

**Key**: agents often can't bash either. Be prepared to:
1. Let agents write test files
2. Run tests locally: `TZ=America/Los_Angeles npx vitest run <TestName>`
3. Run lint: `npx prettier --write <file> && npx eslint --fix <file>`
4. Commit and push yourself

## Phase 6: CI Loop (Parallel Agents)

Dispatch one CI monitor agent per PR. Each agent:

```
Loop (max 5 attempts):
  1. Check CI: gh pr checks <PR_NUMBER>
  2. If all pass → done
  3. If failure → investigate:
     - gh run view <run-id> --log-failed
     - Read failing output
     - Fix the issue
     - Commit with --no-verify --no-gpg-sign
     - Push
     - Back to step 1
```

### Common CI failures after --no-verify commits
| Failure | Fix |
|---------|-----|
| Prettier formatting | `npx prettier --write <file>` |
| Import ordering | `npx eslint --fix <file>` |
| Unused imports | Remove the import |
| React hooks rules | Move hooks before early returns |
| `vitest/require-top-level-describe` | Move `beforeEach` inside `describe` blocks |
| Type errors in tests | Use `as unknown as Type` for partial mocks |

### Verifying CI status
`gh pr checks` can show stale results. After pushing fixes, verify the check is from the latest commit:
```bash
# Compare latest commit vs what CI ran
git rev-parse --short HEAD
gh api repos/OWNER/REPO/commits/BRANCH/status --jq '.statuses[] | {context, state}'
```

### Non-blocking checks
Codacy Static Code Analysis and Codacy Diff Coverage are typically non-blocking. Focus on CircleCI checks (lint, tests, build).

## Reporting

After each phase, give the user an honest status table:

```
| Ticket | PR | Status | Notes |
|--------|----|--------|-------|
| TICKET-123 | #42 | Green | Complete |
| TICKET-456 | #43 | Lint fail | Fix pushed, waiting for CI |
```

Don't report stale CI results as green. Check before claiming success.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reporting stale CI as green | Always `gh pr checks` before claiming status |
| Skipping prettier before push | Commits with --no-verify skip all hooks |
| Agents can't edit but you keep retrying | Implement directly after first failure |
| Pushing during SSH key lockout | Batch pushes, notify user to unlock |
| Modifying shared files across worktrees | Each worktree is independent; shared changes may need coordination |
| Not verifying tests pass locally | Always run tests before committing |
