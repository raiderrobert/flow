---
name: rust-lsp
description: "Use for Rust code analysis via LSP. Keywords: symbols, project structure, list structs, list traits, list functions, trait implementations, find implementations, go to definition, find references, call hierarchy, call graph, dependency graph, visualize deps, refactor, rename symbol, move function, extract function"
argument-hint: "[file.rs] [--type struct|trait|fn|mod]"
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Bash"]
---

# Rust LSP Toolkit

Unified skill for Rust code analysis, navigation, and refactoring using Grep, Glob, Read, Bash, and cargo tools.

## Analysis Techniques

| Technique | Tool | Use When |
|-----------|------|----------|
| Symbol search | `Grep("^(pub )?(struct\|fn\|trait) Name")` | Finding definitions |
| Find references | `Grep("SymbolName", glob: "**/*.rs")` | Finding all usages |
| File structure | `Grep` + `Read` on target file | Analyzing a single file |
| Type info | `Grep` definition + `Read` context | Getting type signatures and docs |
| Compiler diagnostics | `Bash("cargo check 2>&1")` | Checking for errors |

> **Primary tools:** Grep and Glob for search, Read for context, Bash for cargo commands.

## Capability Routing

| Task | Reference | Primary Tools |
|------|-----------|---------------|
| Project structure, list symbols | `./symbol-analyzer.md` | Glob + Grep + Read |
| Trait implementations | `./trait-explorer.md` | Grep + Read |
| Navigate definitions/references | `./code-navigator.md` | Grep + Read |
| Call hierarchy visualization | `./call-graph.md` | Grep + Read |
| Dependency tree visualization | `./deps-visualizer.md` | Bash (cargo tree, cargo metadata) |
| Safe refactoring | `./refactor-helper.md` | Grep + Read + Edit |

## Reference Files

- `./symbol-analyzer.md` - Project structure analysis
- `./trait-explorer.md` - Trait implementation discovery
- `./code-navigator.md` - Definition/reference navigation
- `./call-graph.md` - Call hierarchy visualization
- `./deps-visualizer.md` - Dependency tree visualization
- `./refactor-helper.md` - Safe refactoring workflows
