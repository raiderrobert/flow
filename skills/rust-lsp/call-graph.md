# Call Graph

Visualize function call relationships using Grep-based analysis.

## Usage

```
/rust-lsp <function_name> [--depth N] [--direction in|out|both]
```

**Options:**
- `--depth N`: How many levels to traverse (default: 3)
- `--direction`: `in` (callers), `out` (callees), `both`

## Approach

### Finding Callers (Incoming Calls)

Search for all call sites using Grep:

```
Grep("function_name\(", glob: "**/*.rs")
```

This finds all locations where the function is invoked across the codebase.

### Finding Callees (Outgoing Calls)

Read the function body and search for function calls within it:

1. Grep("fn function_name") to find the function definition
2. Read the function body
3. Identify called functions via pattern matching
4. Recursively expand to desired depth

## Workflow

```
User: "Show call graph for process_request"
    |
    v
[1] Find function location
    Grep("fn process_request")
    |
    v
[2] Get incoming calls (callers)
    Grep("process_request(")
    |
    v
[3] Get outgoing calls (callees)
    Read function body, identify called functions
    |
    v
[4] Recursively expand to depth N
    |
    v
[5] Generate ASCII visualization
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
