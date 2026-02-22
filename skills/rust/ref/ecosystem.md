# Ecosystem & Coding Guidelines

## Core Question

**What's the right crate for this job, and how should it integrate?**

## Common Crate Choices

| Need | Crates |
|------|--------|
| Serialization | serde, serde_json |
| Async runtime | tokio (most popular) |
| HTTP client | reqwest |
| HTTP server | axum, actix-web |
| Database | sqlx, diesel |
| CLI parsing | clap |
| Error handling | anyhow (app), thiserror (lib) |
| Logging | tracing, log |

## Language Interop

| Integration | Crate/Tool | Use Case |
|-------------|------------|----------|
| C/C++ → Rust | `bindgen` | Auto-generate bindings |
| Rust → C | `cbindgen` | Export C headers |
| Python ↔ Rust | `pyo3` | Python extensions |
| Node.js ↔ Rust | `napi-rs` | Node addons |
| WebAssembly | `wasm-bindgen` | Browser/WASI |

## Cargo Features

| Feature | Purpose |
|---------|---------|
| `[features]` | Optional functionality |
| `default = [...]` | Default features |
| `feature = "serde"` | Conditional deps |
| `[workspace]` | Multi-crate projects |

## Crate Selection Criteria

| Criterion | Good Sign | Warning Sign |
|-----------|-----------|--------------|
| Maintenance | Recent commits | Years inactive |
| Community | Active issues/PRs | No response |
| Documentation | Examples, API docs | Minimal docs |
| Stability | Semantic versioning | Frequent breaking |
| Dependencies | Minimal, well-known | Heavy, obscure |

## Error Code Reference

| Error | Cause | Fix |
|-------|-------|-----|
| E0433 | Can't find crate | Add to Cargo.toml |
| E0603 | Private item | Check crate docs |
| Feature not enabled | Optional feature | Enable in `features` |
| Version conflict | Incompatible deps | `cargo update` or pin |
| Duplicate types | Different crate versions | Unify in workspace |

## Rust Coding Style

### Naming

| Rule | Guideline |
|------|-----------|
| No `get_` prefix | `fn name()` not `fn get_name()` |
| Iterator convention | `iter()` / `iter_mut()` / `into_iter()` |
| Conversion naming | `as_` (cheap &), `to_` (expensive), `into_` (ownership) |
| Static var prefix | `G_CONFIG` for `static`, no prefix for `const` |
| Naming format | snake_case (fn/var), CamelCase (type), SCREAMING_CASE (const) |

### Data Types

| Rule | Guideline |
|------|-----------|
| Use newtypes | `struct Email(String)` for domain semantics |
| Prefer slice patterns | `if let [first, .., last] = slice` |
| Pre-allocate | `Vec::with_capacity()`, `String::with_capacity()` |
| Avoid Vec abuse | Use arrays for fixed sizes |

### Strings

| Rule | Guideline |
|------|-----------|
| Prefer bytes | `s.bytes()` over `s.chars()` when ASCII |
| Use `Cow<str>` | When might modify borrowed data |
| Use `format!` | Over string concatenation with `+` |

### Error Handling Style

| Rule | Guideline |
|------|-----------|
| Use `?` propagation | Not `try!()` macro |
| `expect()` over `unwrap()` | When value guaranteed |
| Assertions for invariants | `assert!` at function entry |

### Memory Style

| Rule | Guideline |
|------|-----------|
| Meaningful lifetimes | `'src`, `'ctx` not just `'a` |
| `try_borrow()` for RefCell | Avoid panic |
| Shadowing for transformation | `let x = x.parse()?` |

### Concurrency Style

| Rule | Guideline |
|------|-----------|
| Identify lock ordering | Prevent deadlocks |
| Atomics for primitives | Not Mutex for bool/usize |
| Sync for CPU-bound | Async is for I/O |
| Don't hold locks across await | Use scoped guards |

### Formatting & Docs

```
Format: rustfmt (just use it)
Docs: /// for public items, //! for module docs
Lint: #![warn(clippy::all)]
Macros: Avoid unless necessary, prefer functions/generics
```

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| `extern crate` | Outdated (2018+) | Just `use` |
| `#[macro_use]` | Global pollution | Explicit import |
| Wildcard deps `*` | Unpredictable | Specific versions |
| Too many deps | Supply chain risk | Evaluate necessity |
| Macros for simple ops | Hard to debug | Functions |
