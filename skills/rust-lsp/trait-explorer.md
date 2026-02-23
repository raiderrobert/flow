# Trait Explorer

Discover trait implementations and understand polymorphic designs.

## Usage

```
/rust-lsp <TraitName|StructName>
```

**Examples:**
- Find all implementors of Handler trait
- Find all traits implemented by MyStruct

## Approach

### Find Trait Implementors

Use Grep to search for `impl TraitName for` patterns across the codebase.

```
Grep("impl\s+(\w+\s+)?TraitName\s+for")
```

Then use `findReferences` on the trait definition for additional coverage.

### Find Traits for a Type

Search for all `impl` blocks for a given type.

```
Grep("impl\s+(\w+\s+)?(\w+::)*\w+\s+for\s+TypeName")
```

## Workflow

### Find Trait Implementors

```
User: "Who implements the Handler trait?"
    |
    v
[1] Find trait definition
    Grep("trait Handler") or LSP(goToDefinition)
    |
    v
[2] Get implementations
    Grep("impl.*Handler for")
    |
    v
[3] For each impl, get details
    LSP(documentSymbol) for methods
    |
    v
[4] Generate implementation map
```

### Find Traits for a Type

```
User: "What traits does MyStruct implement?"
    |
    v
[1] Find struct definition
    |
    v
[2] Search for "impl * for MyStruct"
    Grep("impl.*for MyStruct")
    |
    v
[3] Get trait details for each
    |
    v
[4] Generate trait list
```

## Output Format

### Trait Implementors

```
## Implementations of `Handler`

**Trait defined at:** src/traits.rs:15

### Implementors (4)

| Type | Location | Notes |
|------|----------|-------|
| AuthHandler | src/handlers/auth.rs:20 | Handles authentication |
| ApiHandler | src/handlers/api.rs:15 | REST API endpoints |
| WebSocketHandler | src/handlers/ws.rs:10 | WebSocket connections |
| MockHandler | tests/mocks.rs:5 | Test mock |
```

### Traits for a Type

```
## Traits implemented by `User`

### Standard Library Traits
| Trait | Derived/Manual | Notes |
|-------|----------------|-------|
| Debug | #[derive] | Auto-generated |
| Clone | #[derive] | Auto-generated |

### Project Traits
| Trait | Location | Methods |
|-------|----------|---------|
| Entity | src/db/entity.rs:30 | id(), created_at() |
| Validatable | src/validation.rs:15 | validate() |
```

## Common Patterns

| User Says | Action |
|-----------|--------|
| "Who implements X?" | Grep("impl.*X for") + findReferences on trait |
| "What traits does Y impl?" | Grep("impl.*for Y") |
| "Show trait hierarchy" | Find super-traits recursively |
| "Is X: Send + Sync?" | Check std trait impls |
