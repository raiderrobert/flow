---
name: rust-lsp
description: "Use for Rust code analysis via LSP. Keywords: symbols, project structure, list structs, list traits, list functions, trait implementations, find implementations, go to definition, find references, call hierarchy, call graph, dependency graph, visualize deps, refactor, rename symbol, move function, extract function"
argument-hint: "[file.rs] [--type struct|trait|fn|mod]"
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Bash"]
---

# Rust LSP Toolkit

Unified skill for Rust code analysis, navigation, and refactoring using Language Server Protocol and cargo tools.

## Supported LSP Operations

| Operation | Use When |
|-----------|----------|
| `documentSymbol` | Analyzing a single file's structure |
| `goToDefinition` | Finding where something is defined |
| `findReferences` | Finding all usages of a symbol |
| `hover` | Getting type info and documentation |
| `getDiagnostics` | Checking for compiler errors |

> **Note:** For advanced analysis (workspace-wide symbol search, trait implementation discovery, call graphs), this skill supplements LSP with `Grep` and `Glob` tools.

## Capability Routing

| Task | Reference | Primary Tools |
|------|-----------|---------------|
| Project structure, list symbols | `./symbol-analyzer.md` | Glob + documentSymbol |
| Trait implementations | `./trait-explorer.md` | Grep + findReferences |
| Navigate definitions/references | `./code-navigator.md` | goToDefinition, findReferences, hover |
| Call hierarchy visualization | `./call-graph.md` | Grep + findReferences |
| Dependency tree visualization | `./deps-visualizer.md` | cargo tree, cargo metadata |
| Safe refactoring | `./refactor-helper.md` | findReferences, hover, Edit |

## Reference Files

- `./symbol-analyzer.md` - Project structure analysis
- `./trait-explorer.md` - Trait implementation discovery
- `./code-navigator.md` - Definition/reference navigation
- `./call-graph.md` - Call hierarchy visualization
- `./deps-visualizer.md` - Dependency tree visualization
- `./refactor-helper.md` - Safe refactoring workflows
