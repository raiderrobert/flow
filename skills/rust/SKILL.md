---
name: rust
description: "Use for ALL Rust questions including errors, design, patterns, and coding.
Triggers on: Rust, cargo, rustc, crate, Cargo.toml,
compile error, borrow error, lifetime error, ownership error, type error, trait error,
value moved, cannot borrow, does not live long enough, mismatched types, not satisfied,
E0382, E0597, E0277, E0308, E0499, E0502, E0596, E0506, E0507, E0515, E0716, E0106,
E0038, E0599, E0433, E0603,
async, await, Send, Sync, tokio, concurrency, thread, spawn, channel, Mutex, deadlock,
Result, Option, Error, panic, anyhow, thiserror, unwrap, expect,
Box, Rc, Arc, RefCell, Cell, smart pointer, RAII, Drop,
generic, trait, impl, dyn, monomorphization, static dispatch, dynamic dispatch,
type state, PhantomData, newtype, builder pattern,
domain model, DDD, entity, value object, aggregate,
performance, optimization, benchmark, profiling, flamegraph, criterion,
crate, dependency, feature flag, workspace, PyO3, wasm, bindgen,
resource lifecycle, connection pool, lazy initialization, OnceLock,
mental model, how to think about ownership, coming from Java, coming from Python,
anti-pattern, common mistake, pitfall, code smell, code review, idiomatic,
naming, formatting, clippy, rustfmt, code style, best practice,
mut, interior mutability, move, clone, Copy, lifetime, borrow, ownership"
globs: ["**/Cargo.toml", "**/*.rs"]
---

# Rust

## Project Defaults

When creating new Rust projects or Cargo.toml files:

```toml
[package]
edition = "2024"
rust-version = "1.85"

[lints.rust]
unsafe_code = "warn"

[lints.clippy]
all = "warn"
pedantic = "warn"
```

## Error Code Routing

When the user has a compiler error, read the relevant reference file for detailed guidance.

| Error Code | Topic | Reference |
|------------|-------|-----------|
| E0382 | Use of moved value | `ref/ownership.md` |
| E0597 | Lifetime too short | `ref/ownership.md` |
| E0506 | Cannot assign to borrowed | `ref/ownership.md` |
| E0507 | Cannot move out of borrowed | `ref/ownership.md` |
| E0515 | Return local reference | `ref/ownership.md` |
| E0716 | Temporary value dropped | `ref/ownership.md` |
| E0106 | Missing lifetime specifier | `ref/ownership.md` |
| E0596 | Cannot borrow as mutable | `ref/ownership.md` |
| E0499 | Multiple mutable borrows | `ref/ownership.md` |
| E0502 | Borrow conflict | `ref/ownership.md` |
| E0277 | Trait bound not satisfied | `ref/types-and-traits.md` (or `ref/concurrency.md` if Send/Sync) |
| E0308 | Type mismatch | `ref/types-and-traits.md` |
| E0599 | No method found | `ref/types-and-traits.md` |
| E0038 | Trait not object-safe | `ref/types-and-traits.md` |
| E0433 | Cannot find crate/module | `ref/ecosystem.md` |
| E0603 | Private item access | `ref/ecosystem.md` |

## Keyword Routing

When the user asks about a topic, read the relevant reference file for detailed guidance.

| Topic Keywords | Reference |
|----------------|-----------|
| ownership, borrow, lifetime, move, clone, Copy, `'a`, `'static` | `ref/ownership.md` |
| Box, Rc, Arc, Weak, RefCell, Cell, smart pointer, heap | `ref/ownership.md` |
| mut, interior mutability, borrow conflict | `ref/ownership.md` |
| generic, trait, impl, dyn, monomorphization, dispatch | `ref/types-and-traits.md` |
| type state, PhantomData, newtype, builder, sealed trait | `ref/types-and-traits.md` |
| Result, Option, Error, `?`, unwrap, expect, panic, anyhow, thiserror | `ref/error-handling.md` |
| domain error, retry, fallback, circuit breaker, recovery | `ref/error-handling.md` |
| async, await, Send, Sync, thread, channel, Mutex, tokio, deadlock | `ref/concurrency.md` |
| domain model, DDD, entity, value object, aggregate, repository | `ref/design-patterns.md` |
| RAII, Drop, lifecycle, connection pool, OnceLock, LazyLock | `ref/design-patterns.md` |
| performance, optimization, benchmark, profiling, flamegraph | `ref/performance.md` |
| crate, cargo, dependency, feature flag, workspace, interop | `ref/ecosystem.md` |
| naming, formatting, clippy, code style, best practice | `ref/ecosystem.md` |
| anti-pattern, code smell, common mistake, idiomatic | `ref/anti-patterns.md` |
| mental model, learning Rust, coming from Java/Python/C++ | `ref/anti-patterns.md` |

For code examples, read the relevant file from `examples/`.

## Domain Detection

When domain keywords are present alongside a Rust question, also load the domain-specific skill:

| Domain Keywords | Also Load |
|-----------------|-----------|
| Web, HTTP, axum, CLI, clap, kubernetes, gRPC, embedded, no_std, fintech, trading, IoT, MQTT, ML, tensor | `rust-domain` skill |

## Functional Routing

| Pattern | Route To |
|---------|----------|
| unsafe, FFI, extern, raw pointer, transmute | `unsafe-checker` skill |
| project structure, list structs/traits, call graph, refactor | `rust-lsp` skill |

## Quick Decision Trees

### Ownership: Who Should Own This Data?

```
Is the data shared?
├─ No (single owner)
│  ├─ Needs heap? → Box<T>
│  └─ Stack is fine → owned value (default)
├─ Yes, immutable sharing
│  ├─ Single-thread → Rc<T>
│  └─ Multi-thread → Arc<T>
└─ Yes, mutable sharing
   ├─ Single-thread → Rc<RefCell<T>>
   └─ Multi-thread → Arc<Mutex<T>> or Arc<RwLock<T>>
```

### Concurrency: What Model?

```
What type of work?
├─ CPU-bound → std::thread or rayon
├─ I/O-bound → async/await (tokio)
└─ Mixed → spawn_blocking for CPU parts

Need to share data?
├─ No → message passing (channels)
├─ Immutable → Arc<T>
└─ Mutable → Arc<Mutex<T>> or channels
```

### Error Handling: What Strategy?

```
Is failure expected?
├─ Yes
│  ├─ Absence only → Option<T>
│  └─ Real errors → Result<T, E>
│     ├─ Library code → thiserror (typed errors)
│     └─ Application code → anyhow (ergonomic)
└─ No (bug/invariant violation) → panic!, assert!
```

### Static vs Dynamic Dispatch

```
Is the type known at compile time?
├─ Yes → generics / impl Trait (zero-cost)
└─ No → dyn Trait (vtable)
   ├─ Heterogeneous collection → Vec<Box<dyn Trait>>
   └─ Plugin architecture → Box<dyn Trait>
```

## Style Quick Reference

| Rule | Guideline |
|------|-----------|
| No `get_` prefix | `fn name()` not `fn get_name()` |
| Conversion naming | `as_` (cheap &), `to_` (expensive), `into_` (ownership) |
| Iterator convention | `iter()` / `iter_mut()` / `into_iter()` |
| Prefer `?` over `unwrap` | Use `expect()` only when value guaranteed |
| Use newtypes | `struct Email(String)` for domain semantics |
| Meaningful lifetimes | `'src`, `'ctx` not just `'a` |

### Deprecated Patterns

| Deprecated | Better | Since |
|------------|--------|-------|
| `lazy_static!` | `std::sync::OnceLock` | 1.70 |
| `once_cell::Lazy` | `std::sync::LazyLock` | 1.80 |
| `std::sync::mpsc` | `crossbeam::channel` | - |
| `failure`/`error-chain` | `thiserror`/`anyhow` | - |
| `try!()` | `?` operator | 2018 |
| `extern crate` | Just `use` | 2018 |
| `#[macro_use]` | Explicit import | 2018 |
