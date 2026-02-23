# Symbol Analyzer

Analyze project structure by examining symbols across your Rust codebase.

## Usage

```
/rust-lsp [file.rs] [--type struct|trait|fn|mod]
```

**Examples:**
- `/rust-lsp` - Analyze entire project
- `/rust-lsp src/lib.rs` - Analyze single file
- `/rust-lsp --type trait` - List all traits in project

## LSP Operations

### 1. Document Symbols (Single File)

Get all symbols in a file with their hierarchy.

```
LSP(
  operation: "documentSymbol",
  filePath: "src/lib.rs",
  line: 1,
  character: 1
)
```

**Returns:** Nested structure of modules, structs, functions, etc.

### 2. Workspace Symbols (Entire Project)

Search for symbols across the workspace.

```
LSP(
  operation: "workspaceSymbol",
  filePath: "src/lib.rs",
  line: 1,
  character: 1
)
```

## Workflow

```
User: "What's the structure of this project?"
    |
    v
[1] Find all Rust files
    Glob("**/*.rs")
    |
    v
[2] Get symbols from each key file
    LSP(documentSymbol) for lib.rs, main.rs
    |
    v
[3] Categorize by type
    |
    v
[4] Generate structure visualization
```

## Output Format

### Project Overview

```
## Project Structure: my-project

### Modules
src/
  lib.rs (root)
  config/
    mod.rs
    parser.rs
  handlers/
    mod.rs
    auth.rs
    api.rs
  models/
    mod.rs
    user.rs
    order.rs
tests/
  integration.rs
```

### By Symbol Type

```
## Symbols by Type

### Structs (12)
| Name | Location | Fields | Derives |
|------|----------|--------|---------|
| Config | src/config.rs:10 | 5 | Debug, Clone |
| User | src/models/user.rs:8 | 4 | Debug, Serialize |

### Traits (4)
| Name | Location | Methods | Implementors |
|------|----------|---------|--------------|
| Handler | src/handlers/mod.rs:5 | 3 | AuthHandler, ApiHandler |

### Functions (25)
| Name | Location | Visibility | Async |
|------|----------|------------|-------|
| main | src/main.rs:10 | pub | yes |

### Enums (6)
| Name | Location | Variants |
|------|----------|----------|
| Error | src/error.rs:5 | 8 |
```

## Symbol Types

| Type | LSP Kind |
|------|----------|
| Module | Module |
| Struct | Struct |
| Enum | Enum |
| Trait | Interface |
| Function | Function |
| Method | Method |
| Constant | Constant |
| Field | Field |

## Common Queries

| User Says | Analysis |
|-----------|----------|
| "What structs are in this project?" | workspaceSymbol + filter |
| "Show me src/lib.rs structure" | documentSymbol |
| "Find all async functions" | workspaceSymbol + async filter |
| "List public API" | documentSymbol + pub filter |
