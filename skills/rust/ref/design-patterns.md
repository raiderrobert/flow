# Design Patterns & Resource Lifecycle

## Core Questions

- **What is this concept's role in the domain?**
- **When should this resource be created, used, and cleaned up?**

## Domain Concept → Rust Pattern

| Domain Concept | Rust Pattern | Ownership Implication |
|----------------|--------------|----------------------|
| Entity | struct + Id | Owned, unique identity |
| Value Object | struct + Clone/Copy | Shareable, immutable |
| Aggregate Root | struct owns children | Clear ownership tree |
| Repository | trait | Abstracts persistence |
| Domain Event | enum | Captures state changes |
| Service | impl block / free fn | Stateless operations |

## Lifecycle Patterns

| Pattern | When | Implementation |
|---------|------|----------------|
| RAII | Auto cleanup | `Drop` trait |
| Lazy init | Deferred creation | `OnceLock`, `LazyLock` |
| Pool | Reuse expensive resources | `r2d2`, `deadpool` |
| Guard | Scoped access | `MutexGuard` pattern |
| Scope | Transaction boundary | Custom struct + Drop |

## Lifecycle Decision

```
What's the resource cost?
├─ Cheap → create per use
├─ Expensive → pool or cache
└─ Global → lazy singleton

What's the scope?
├─ Function-local → stack allocation
├─ Request-scoped → passed or extracted
└─ Application-wide → static or Arc

What about errors in cleanup?
├─ Cleanup must happen → Drop
├─ Cleanup is optional → explicit close
└─ Cleanup can fail → Result from close
```

## Pattern Templates

### Value Object

```rust
struct Email(String);

impl Email {
    pub fn new(s: &str) -> Result<Self, ValidationError> {
        validate_email(s)?;
        Ok(Self(s.to_string()))
    }
}
```

### Entity

```rust
struct UserId(Uuid);

struct User {
    id: UserId,
    email: Email,
}

impl PartialEq for User {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id  // Identity equality
    }
}
```

### Aggregate

```rust
mod order {
    pub struct Order {
        id: OrderId,
        items: Vec<OrderItem>,  // Owned children
    }

    impl Order {
        pub fn add_item(&mut self, item: OrderItem) {
            // Enforce aggregate invariants
        }
    }
}
```

### RAII Guard

```rust
struct FileGuard {
    path: PathBuf,
    _handle: File,
}

impl Drop for FileGuard {
    fn drop(&mut self) {
        let _ = std::fs::remove_file(&self.path);
    }
}
```

### Lazy Singleton

```rust
use std::sync::OnceLock;

static CONFIG: OnceLock<Config> = OnceLock::new();

fn get_config() -> &'static Config {
    CONFIG.get_or_init(|| {
        Config::load().expect("config required")
    })
}
```

## Lifecycle Events

| Event | Rust Mechanism |
|-------|----------------|
| Creation | `new()`, `Default` |
| Lazy Init | `OnceLock::get_or_init` |
| Usage | `&self`, `&mut self` |
| Cleanup | `Drop::drop()` |

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Resource leak | Forgot Drop | Implement Drop or RAII wrapper |
| Double free | Manual memory | Let Rust handle |
| Use after drop | Dangling reference | Check lifetimes |
| E0509 move out of Drop | Moving owned field | `Option::take()` |
| Pool exhaustion | Not returned | Ensure Drop returns |

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| Primitive obsession | No type safety | Newtype wrappers |
| Public fields with invariants | Invariants violated | Private + accessor |
| Leaked aggregate internals | Broken encapsulation | Methods on root |
| String for semantic types | No validation | Validated newtype |
| Manual cleanup | Easy to forget | RAII/Drop |
| `lazy_static!` | External dep | `std::sync::OnceLock` |
| Global mutable state | Thread unsafety | `OnceLock` or proper sync |
