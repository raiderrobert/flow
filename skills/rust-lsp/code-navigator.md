# Code Navigator

Navigate large Rust codebases efficiently using Language Server Protocol.

## Usage

```
/rust-lsp <symbol> [in file.rs:line]
```

**Examples:**
- Find definition of parse_config
- Navigate from specific location

## Analysis Techniques

### 1. Go to Definition

Find where a symbol is defined.

```
Grep("(struct|enum|trait|fn|type|const|static|mod) SymbolName", glob: "**/*.rs")
```

Then Read the file at the matching location for full context.

**Use when:**
- User asks "where is X defined?"
- User wants to understand a type/function

### 2. Find References

Find all usages of a symbol.

```
Grep("SymbolName", glob: "**/*.rs")
```

**Use when:**
- User asks "who uses X?"
- Before refactoring/renaming
- Understanding impact of changes

### 3. Type and Documentation Info

Get type and documentation for a symbol.

```
1. Grep("(struct|fn|type) SymbolName") to locate definition
2. Read the file at that location to see type signature and doc comments
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
    Grep("struct Config") or Glob("**/config*.rs")
    |
    v
[2] If multiple results, ask user to clarify
    |
    v
[3] Go to definition
    Read the file at the Grep match location
    |
    v
[4] Show file path and context
    Read surrounding code for full definition
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

| User Says | Tool |
|-----------|------|
| "Where is X defined?" | Grep definition pattern + Read |
| "Who uses X?" | Grep("SymbolName") across **/*.rs |
| "What type is X?" | Grep definition + Read for signature |
| "Find all structs" | Grep("^pub struct") |
| "What's in this file?" | Grep + Read for structure |

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| No matches found | Typo or not in scope | Try broader Grep pattern |
| Multiple definitions | Generics or macros | Show all and let user choose |
| Symbol in macro | Generated code not greppable | Check macro expansion with `cargo expand` |
