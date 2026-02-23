# Code Navigator

Navigate large Rust codebases efficiently using Language Server Protocol.

## Usage

```
/rust-lsp <symbol> [in file.rs:line]
```

**Examples:**
- Find definition of parse_config
- Navigate from specific location

## LSP Operations

### 1. Go to Definition

Find where a symbol is defined.

```
LSP(
  operation: "goToDefinition",
  filePath: "src/main.rs",
  line: 25,
  character: 10
)
```

**Use when:**
- User asks "where is X defined?"
- User wants to understand a type/function

### 2. Find References

Find all usages of a symbol.

```
LSP(
  operation: "findReferences",
  filePath: "src/lib.rs",
  line: 15,
  character: 8
)
```

**Use when:**
- User asks "who uses X?"
- Before refactoring/renaming
- Understanding impact of changes

### 3. Hover Information

Get type and documentation for a symbol.

```
LSP(
  operation: "hover",
  filePath: "src/main.rs",
  line: 30,
  character: 15
)
```

**Use when:**
- User asks "what type is X?"
- User wants documentation

## Workflow

```
User: "Where is the Config struct defined?"
    |
    v
[1] Search for "Config" in workspace
    LSP(operation: "workspaceSymbol", ...)
    |
    v
[2] If multiple results, ask user to clarify
    |
    v
[3] Go to definition
    LSP(operation: "goToDefinition", ...)
    |
    v
[4] Show file path and context
    Read surrounding code for context
```

## Output Format

### Definition Found

```
## Config (struct)

**Defined in:** `src/config.rs:15`

(show code block with definition)

**Documentation:** Configuration for the application server.
```

### References Found

```
## References to `Config` (5 found)

| Location | Context |
|----------|---------|
| src/main.rs:10 | `let config = Config::load()?;` |
| src/server.rs:25 | `fn new(config: Config) -> Self` |
| src/tests.rs:15 | `Config::default()` |
```

## Common Patterns

| User Says | LSP Operation |
|-----------|---------------|
| "Where is X defined?" | goToDefinition |
| "Who uses X?" | findReferences |
| "What type is X?" | hover |
| "Find all structs" | workspaceSymbol |
| "What's in this file?" | documentSymbol |

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "No LSP server" | rust-analyzer not running | Suggest: `rustup component add rust-analyzer` |
| "Symbol not found" | Typo or not in scope | Search with workspaceSymbol first |
| "Multiple definitions" | Generics or macros | Show all and let user choose |
