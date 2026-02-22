# Flow

A Claude Code plugin with Rust skills, domain expertise, and development workflows.

## Installation

### Claude Code (via Plugin Marketplace)

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add raiderrobert/flow
```

Then install the plugin:

```bash
/plugin install flow@flow-dev
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

### Rust Core

| Skill | Description |
|-------|-------------|
| rust | Comprehensive Rust guidance: ownership, traits, errors, async, design patterns, performance, ecosystem, anti-patterns, and mental models |

### Rust Tooling

| Skill | Description |
|-------|-------------|
| rust-learner | Rust version and crate information lookup |
| rust-daily | Daily Rust learning and practice |
| rust-skill-creator | Create skills from crate or std docs |
| unsafe-checker | Audit unsafe code blocks for soundness |

### Rust LSP

| Skill | Description |
|-------|-------------|
| rust-symbol-analyzer | Analyze project structure via LSP symbols |
| rust-trait-explorer | Explore trait implementations via LSP |
| rust-code-navigator | Navigate definitions and references via LSP |
| rust-call-graph | Visualize function call hierarchies |
| rust-deps-visualizer | Visualize project dependency graphs as ASCII |
| rust-refactor-helper | Safe refactoring with LSP analysis |

### Domain

| Skill | Description |
|-------|-------------|
| domain-web | Building web services and REST APIs |
| domain-cli | Building CLI tools and TUI applications |
| domain-cloud-native | Cloud-native, Kubernetes, and microservices |
| domain-embedded | Embedded and no_std Rust development |
| domain-fintech | Fintech, trading, and financial applications |
| domain-iot | IoT, sensors, and edge computing |
| domain-ml | Machine learning and AI in Rust |

### Tooling

| Skill | Description |
|-------|-------------|
| diecut-new | Generate projects from diecut templates |
| diecut-create-template | Create new diecut template repositories |
| writing-prs | Write pull request titles and descriptions |

### Meta / Core

| Skill | Description |
|-------|-------------|
| core-actionbook | Internal action orchestration tool |
| core-agent-browser | Internal agent browsing tool |
| core-dynamic-skills | Dynamic skill loading and management |
| core-fix-skill-docs | Internal skill documentation maintenance |
| meta-cognition-parallel | Three-layer parallel meta-cognition analysis |

## License

MIT
