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

## Approach

### 1. Document Symbols (Single File)

Get all symbols in a file with their hierarchy.

```
Grep("^(pub )?(struct|enum|trait|fn|impl|mod|const|type) ", filePath: "src/lib.rs")
```

Then Read the file to understand the full hierarchy and nesting.

**Returns:** Categorized list of modules, structs, functions, etc.

### 2. Project-Wide Symbol Search

Find symbols across the workspace using Glob + Grep.

```
1. Glob("**/*.rs") → find all Rust files
2. Grep key patterns on entry files (lib.rs, main.rs, mod.rs):
   - Structs: Grep("^pub struct \w+")
   - Traits: Grep("^pub trait \w+")
   - Functions: Grep("^pub fn \w+")
3. Read each entry file for module structure and re-exports
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
    Grep("^(pub )?(struct|enum|trait|fn|impl|mod) ") on lib.rs, main.rs
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

| Type | Grep Pattern |
|------|-------------|
| Module | `^(pub )?mod \w+` |
| Struct | `^(pub )?struct \w+` |
| Enum | `^(pub )?enum \w+` |
| Trait | `^(pub )?trait \w+` |
| Function | `^(pub )?(async )?fn \w+` |
| Method | `fn \w+\(&(mut )?self` |
| Constant | `^(pub )?const \w+` |
| Field | Read struct body after locating it |

## Common Queries

| User Says | Analysis |
|-----------|----------|
| "What structs are in this project?" | Grep("^pub struct") across **/*.rs |
| "Show me src/lib.rs structure" | Grep + Read on src/lib.rs |
| "Find all async functions" | Grep("async fn") across **/*.rs |
| "List public API" | Grep("^pub ") + Read for context |
