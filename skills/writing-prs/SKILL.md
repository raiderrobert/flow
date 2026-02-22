---
name: writing-prs
description: Use when writing a pull request title or description. Triggers on gh pr create, opening a PR, drafting a PR body.
---

# Writing Pull Requests

## Core principle

Explain the **problem** first. The reader needs to understand what was wrong before they care what changed.

## One PR per issue

Each PR addresses one issue. If you find yourself writing "this also fixes..." or listing multiple unrelated things, split the PR.

## PR description format

Write prose, not bullet points. Two paragraphs is usually enough.

**Paragraph 1 — the problem:**
What was wrong and why it mattered. Write as if explaining to a teammate who hasn't been following the work. No jargon. No "this implements diecut-xyz." Just: what was the problem?

**Paragraph 2 — what changed:**
One or two sentences on what you did to fix it. This can include a short code snippet if the before/after is clarifying.

**Test plan (optional):**
Only include this section if there's something CI won't catch — manual steps, edge cases that need human verification, deployment checks, etc. Don't list things like lint or test suite runs; CI handles those.

## What to avoid

**Don't lead with what changed.** "Added Default derive" tells the reader nothing without context.

**Don't use bullet point summaries.** Bullets fragment the reasoning. Write a sentence.

**Don't include the issue ID in the body.** It's already in the branch name and will be linked automatically.

**Don't say "Generated with Claude Code."**

## Example

Bad:
```
## Summary
- Added `#[derive(Default)]` to VariableType and VariableConfig
- Updated tests to use struct update syntax
```

Good:
```
Every test that builds a `VariableConfig` had to spell out all 9 fields, even when only one was
relevant to the test. It made the test bodies long and obscured what each test was checking.

Added `#[derive(Default)]` to both types. Tests can now use `VariableConfig { secret: true, ..Default::default() }`.
```
