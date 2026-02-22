# Error Handling

## Core Questions

- **Is this failure expected or a bug?**
- **Who needs to handle this error, and how should they recover?**

## Error → Design Question

| Pattern | Don't Just Say | Ask Instead |
|---------|----------------|-------------|
| unwrap panics | "Use ?" | Is None/Err actually possible here? |
| Type mismatch on ? | "Use anyhow" | Are error types designed correctly? |
| Lost error context | "Add .context()" | What does the caller need to know? |
| Too many error variants | "Use Box\<dyn Error\>" | Is error granularity right? |

## Decision Flowchart

```
Is failure expected?
├─ Yes → Is absence the only "failure"?
│        ├─ Yes → Option<T>
│        └─ No → Result<T, E>
│                 ├─ Library → thiserror
│                 └─ Application → anyhow
└─ No → Is it a bug?
        ├─ Yes → panic!, assert!
        └─ No → Consider if really unrecoverable

Use ? → Need context?
├─ Yes → .context("message")
└─ No → Plain ?
```

## Library vs Application

| Context | Error Crate | Why |
|---------|-------------|-----|
| Library | `thiserror` | Typed errors for consumers |
| Application | `anyhow` | Ergonomic error handling |
| Mixed | Both | thiserror at boundaries, anyhow internally |

## Error Categorization (Domain Errors)

| Error Type | Audience | Recovery | Example |
|------------|----------|----------|---------|
| User-facing | End users | Guide action | `InvalidEmail`, `NotFound` |
| Internal | Developers | Debug info | `DatabaseError`, `ParseError` |
| System | Ops/SRE | Monitor/alert | `ConnectionTimeout`, `RateLimited` |
| Transient | Automation | Retry | `NetworkError`, `ServiceUnavailable` |
| Permanent | Human | Investigate | `ConfigInvalid`, `DataCorrupted` |

## Recovery Patterns

| Pattern | When | Implementation |
|---------|------|----------------|
| Retry | Transient failures | exponential backoff (`tokio-retry`, `backoff`) |
| Fallback | Degraded mode | cached/default value |
| Circuit Breaker | Cascading failures | `failsafe-rs` |
| Timeout | Slow operations | `tokio::time::timeout` |
| Bulkhead | Isolation | separate thread pools |

## Quick Reference

| Pattern | When | Example |
|---------|------|---------|
| `Result<T, E>` | Recoverable error | `fn read() -> Result<String, io::Error>` |
| `Option<T>` | Absence is normal | `fn find() -> Option<&Item>` |
| `?` | Propagate error | `let data = file.read()?;` |
| `unwrap()` | Dev/test only | `config.get("key").unwrap()` |
| `expect()` | Invariant holds | `env.get("HOME").expect("HOME set")` |
| `panic!` | Unrecoverable | `panic!("critical failure")` |

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `unwrap()` panic | Unhandled None/Err | Use `?` or match |
| Type mismatch | Different error types | Use `anyhow` or `From` |
| Lost context | `?` without context | Add `.context()` |
| `cannot use ?` | Missing Result return | Return `Result<(), E>` |

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| `.unwrap()` everywhere | Panics in production | `.expect("reason")` or `?` |
| Ignore errors silently | Bugs hidden | Handle or propagate |
| `panic!` for expected errors | Bad UX, no recovery | Result |
| `Box<dyn Error>` everywhere | Lost type info | thiserror |
| String errors | No structure | thiserror types |
| Retry everything | Wasted resources | Only transient errors |
| Infinite retry | DoS self | Max attempts + backoff |
| Expose internal errors | Security risk | User-friendly messages |
| No context | Hard to debug | .context() everywhere |
| Error in happy path | Performance | Early validation |

For code examples, see `examples/error-patterns.md`.
