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
| m01-ownership | Ownership, borrowing, and lifetime issues |
| m02-resource | Smart pointers and resource management |
| m03-mutability | Mutability and interior mutability patterns |
| m04-zero-cost | Generics, traits, and zero-cost abstractions |
| m05-type-driven | Type-driven design and compile-time validation |
| m06-error-handling | Error handling with Result, Option, and crates |
| m07-concurrency | Concurrency, async, and thread safety |
| m09-domain | Domain modeling and domain-driven design |
| m10-performance | Performance optimization and benchmarking |
| m11-ecosystem | Crate integration and ecosystem guidance |
| m12-lifecycle | Resource lifecycles, RAII, and cleanup patterns |
| m13-domain-error | Domain error hierarchies and recovery strategies |
| m14-mental-model | Mental models for learning Rust concepts |
| m15-anti-pattern | Anti-patterns, pitfalls, and code smells |

### Rust Tooling

| Skill | Description |
|-------|-------------|
| coding-guidelines | Rust code style and best practices |
| rust-router | Routes all Rust questions to skills |
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
| using-flow | Bootstrapper for discovering flow skills |

## License

MIT
