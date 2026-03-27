# Flow

Skills that keep you in the flow. Domain expertise baked in so you don't have to stop and explain every detail.

## Skills Catalog

| Skill | Description |
|-------|-------------|
| [design-audit](skills/design-audit/SKILL.md) | Post-generation review catching AI design defaults |
| [design-frontend](skills/design-frontend/SKILL.md) | Pre-set aesthetic constraints for web components |
| [design-preflight](skills/design-preflight/SKILL.md) | Design constraints gate before Pencil .pen file work |
| [diecut](skills/diecut/SKILL.md) | Project scaffolding and template creation with diecut |
| [dispatch-worktree-task](skills/dispatch-worktree-task/SKILL.md) | Isolated subagent execution in git worktrees |
| [iterative-review-fix](skills/iterative-review-fix/SKILL.md) | Serial review-fix convergence loop |
| [parallel-ticket-pipeline](skills/parallel-ticket-pipeline/SKILL.md) | Parallel worktree dispatch for multiple tickets with CI-fix loops |
| [review-and-fix](skills/review-and-fix/SKILL.md) | Parallel code review with dispatched fixes |
| [rust](skills/rust/SKILL.md) | Comprehensive Rust guidance: ownership, traits, errors, async, design patterns, performance, ecosystem, anti-patterns, and mental models |
| [rust-domain](skills/rust-domain/SKILL.md) | Domain-specific guidance for web, CLI, cloud-native, embedded, fintech, IoT, and ML |
| [rust-lsp](skills/rust-lsp/SKILL.md) | Code analysis, navigation, and refactoring via LSP and cargo tools |
| [rust-unsafe](skills/rust-unsafe/SKILL.md) | Audit unsafe code blocks for soundness |

## Installation

### Claude Code (via Plugin Marketplace)

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add raiderrobert/flow
```

Then install the plugin:

```bash
/plugin install flow@flow
```

### Cursor

In Cursor Agent chat:

```text
/plugin-add flow
```

### Codex

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/raiderrobert/flow/refs/heads/main/.codex/INSTALL.md
```

### OpenCode

Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/raiderrobert/flow/refs/heads/main/.opencode/INSTALL.md
```

### Verify Installation

Start a new session and ask a Rust question. The agent should automatically invoke the relevant flow skill.

## License

[MIT](LICENSE)
