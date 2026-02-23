# Refactor Helper

Perform safe refactoring with comprehensive impact analysis.

## Usage

```
/rust-lsp refactor <action> <target> [--dry-run]
```

**Actions:**
- `rename <old> <new>` - Rename symbol
- `extract-fn <selection>` - Extract to function
- `inline <fn>` - Inline function
- `move <symbol> <dest>` - Move to module

## LSP Operations Used

### Pre-Refactor Analysis

```
# Find all references before renaming
LSP(
  operation: "findReferences",
  filePath: "src/lib.rs",
  line: 25,
  character: 8
)

# Get symbol info
LSP(
  operation: "hover",
  filePath: "src/lib.rs",
  line: 25,
  character: 8
)

# Check callers for move operations
Grep("symbol_name(") or LSP(findReferences)
```

## Refactoring Workflows

### 1. Rename Symbol

```
[1] Find symbol definition
    LSP(goToDefinition)

[2] Find ALL references
    LSP(findReferences)

[3] Categorize by file

[4] Check for conflicts
    - Is new name already used?
    - Are there macro-generated uses?

[5] Show impact analysis (--dry-run)

[6] Apply changes with Edit tool
```

**Output:**

```
## Rename: parse_config -> load_config

### Impact Analysis

**Definition:** src/config.rs:25
**References found:** 8

| File | Line | Context | Change |
|------|------|---------|--------|
| src/config.rs | 25 | `pub fn parse_config(` | Definition |
| src/main.rs | 12 | `config::parse_config` | Import |
| src/lib.rs | 8 | `pub use config::parse_config` | Re-export |
| tests/config_test.rs | 15 | `parse_config("test.toml")` | Test |
```

### 2. Extract Function

```
[1] Read the selected code block

[2] Analyze variables
    - Which are inputs? (used but not defined in block)
    - Which are outputs? (defined and used after block)
    - Which are local? (defined and used only in block)

[3] Determine function signature

[4] Check for early returns, loops, etc.

[5] Generate extracted function

[6] Replace original code with call
```

### 3. Move Symbol

```
[1] Find symbol and all its dependencies

[2] Find all references (callers)
    LSP(findReferences)

[3] Analyze import changes needed

[4] Check for circular dependencies

[5] Generate move plan
```

## Safety Checks

| Check | Purpose |
|-------|---------|
| Reference completeness | Ensure all uses are found |
| Name conflicts | Detect existing symbols with same name |
| Visibility changes | Warn if pub/private scope changes |
| Macro-generated code | Warn about code in macros |
| Documentation | Flag doc comments mentioning symbol |
| Test coverage | Show affected tests |

## Dry Run Mode

Always use `--dry-run` first to preview changes. This shows all changes without applying them.
