---
name: rust-lsp
description: "Use for Rust code analysis via LSP. Keywords: symbols, project structure, list structs, list traits, list functions, trait implementations, find implementations, go to definition, find references, call hierarchy, call graph, dependency graph, visualize deps, refactor, rename symbol, move function, extract function"
argument-hint: "[file.rs] [--type struct|trait|fn|mod]"
allowed-tools: ["LSP", "Read", "Glob", "Grep", "Edit", "Bash"]
---

# Rust LSP Toolkit

Unified skill for Rust code analysis, navigation, and refactoring using Language Server Protocol and cargo tools.

## Capability Routing

| Task | Reference | LSP Operations |
|------|-----------|---------------|
| Project structure, list symbols | `./symbol-analyzer.md` | documentSymbol, workspaceSymbol |
| Trait implementations | `./trait-explorer.md` | goToImplementation |
| Navigate definitions/references | `./code-navigator.md` | goToDefinition, findReferences, hover |
| Call hierarchy visualization | `./call-graph.md` | prepareCallHierarchy, incomingCalls, outgoingCalls |
| Dependency tree visualization | `./deps-visualizer.md` | cargo tree, cargo metadata |
| Safe refactoring | `./refactor-helper.md` | findReferences, hover, Edit |

## Common LSP Operations

| Operation | Use When |
|-----------|----------|
| `documentSymbol` | Analyzing a single file's structure |
| `workspaceSymbol` | Searching across the entire project |
| `goToDefinition` | Finding where something is defined |
| `findReferences` | Finding all usages of a symbol |
| `goToImplementation` | Finding trait implementors |
| `hover` | Getting type info and documentation |
| `prepareCallHierarchy` | Setting up call graph analysis |
| `incomingCalls` | Finding who calls a function |
| `outgoingCalls` | Finding what a function calls |

## Quick Patterns

### Find all structs in project
```
LSP(operation: "workspaceSymbol", filePath: "src/lib.rs", line: 1, character: 1)
→ Filter by kind: Struct
```

### Find who implements a trait
```
LSP(operation: "goToImplementation", filePath: "<trait_file>", line: <trait_line>, character: <col>)
```

### Safe rename
```
1. LSP(findReferences) → get all usages
2. Check for conflicts
3. Apply with Edit tool
```

## Reference Files

- `./symbol-analyzer.md` - Project structure analysis
- `./trait-explorer.md` - Trait implementation discovery
- `./code-navigator.md` - Definition/reference navigation
- `./call-graph.md` - Call hierarchy visualization
- `./deps-visualizer.md` - Dependency tree visualization
- `./refactor-helper.md` - Safe refactoring workflows
