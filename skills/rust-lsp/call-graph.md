# Call Graph

Visualize function call relationships using LSP call hierarchy.

## Usage

```
/rust-lsp <function_name> [--depth N] [--direction in|out|both]
```

**Options:**
- `--depth N`: How many levels to traverse (default: 3)
- `--direction`: `in` (callers), `out` (callees), `both`

## LSP Operations

### 1. Prepare Call Hierarchy

```
LSP(
  operation: "prepareCallHierarchy",
  filePath: "src/handler.rs",
  line: 45,
  character: 8
)
```

### 2. Incoming Calls (Who calls this?)

```
LSP(
  operation: "incomingCalls",
  filePath: "src/handler.rs",
  line: 45,
  character: 8
)
```

### 3. Outgoing Calls (What does this call?)

```
LSP(
  operation: "outgoingCalls",
  filePath: "src/handler.rs",
  line: 45,
  character: 8
)
```

## Workflow

```
User: "Show call graph for process_request"
    |
    v
[1] Find function location
    LSP(workspaceSymbol) or Grep
    |
    v
[2] Prepare call hierarchy
    LSP(prepareCallHierarchy)
    |
    v
[3] Get incoming calls (callers)
    LSP(incomingCalls)
    |
    v
[4] Get outgoing calls (callees)
    LSP(outgoingCalls)
    |
    v
[5] Recursively expand to depth N
    |
    v
[6] Generate ASCII visualization
```

## Output Format

### Incoming Calls (Who calls this?)

```
## Callers of `process_request`

main
  run_server
    handle_connection
      process_request  <-- YOU ARE HERE
```

### Outgoing Calls (What does this call?)

```
## Callees of `process_request`

process_request  <-- YOU ARE HERE
  parse_headers
    validate_header
  authenticate
    check_token
    load_user
  execute_handler
  send_response
    serialize_body
```

## Analysis Insights

After generating the call graph, provide insights:

```
## Analysis

**Entry Points:** main, test_process_request
**Leaf Functions:** validate_header, serialize_body
**Hot Path:** main -> run_server -> handle_connection -> process_request
**Complexity:** 12 functions, 3 levels deep
```

## Common Patterns

| User Says | Direction | Use Case |
|-----------|-----------|----------|
| "Who calls X?" | incoming | Impact analysis |
| "What does X call?" | outgoing | Understanding implementation |
| "Show call graph" | both | Full picture |
| "Trace from main to X" | outgoing | Execution path |

## Visualization Options

| Style | Best For |
|-------|----------|
| Tree (default) | Simple hierarchies |
| Box diagram | Complex relationships |
| Flat list | Many connections |
| Mermaid | Export to docs |
