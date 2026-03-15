# Flow

Skills that keep you in the flow. Domain expertise baked in so you don't have to stop and explain every detail.

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

## Skills Catalog

| Skill | Description |
|-------|-------------|
| rust | Comprehensive Rust guidance: ownership, traits, errors, async, design patterns, performance, ecosystem, anti-patterns, and mental models |
| rust-domain | Domain-specific guidance for web, CLI, cloud-native, embedded, fintech, IoT, and ML |
| rust-lsp | Code analysis, navigation, and refactoring via LSP and cargo tools |
| rust-unsafe | Audit unsafe code blocks for soundness |
| diecut | Project scaffolding and template creation with diecut |
| design-preflight | Design constraints gate before Pencil .pen file work |
| design-frontend | Pre-set aesthetic constraints for web components |
| design-audit | Post-generation review catching AI design defaults |
| dispatch-worktree-task | Isolated subagent execution in git worktrees |
| iterative-review-fix | Serial review-fix convergence loop |
| review-and-fix | Parallel code review with dispatched fixes |

## License

MIT
