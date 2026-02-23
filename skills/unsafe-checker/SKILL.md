---
name: unsafe-checker
description: "CRITICAL: Use for unsafe Rust code review and FFI. Triggers on: unsafe, raw pointer, FFI, extern, transmute, *mut, *const, union, #[repr(C)], libc, std::ffi, MaybeUninit, NonNull, SAFETY comment, soundness, undefined behavior, UB, safe wrapper, memory layout, bindgen, cbindgen, CString, CStr"
globs: ["**/*.rs"]
---

# Unsafe Rust Checker

## Routing

For comprehensive unsafe Rust rules and checklists, read the relevant reference:

| Topic | Reference |
|-------|-----------|
| Full rule index, clippy mapping, decision tree | `./AGENTS.md` |
| Pre-writing checklist | `./checklists/before-unsafe.md` |
| Code review checklist | `./checklists/review-unsafe.md` |
| Common pitfalls | `./checklists/common-pitfalls.md` |
| Safe wrapper patterns | `./examples/safe-abstraction.md` |
| FFI best practices | `./examples/ffi-patterns.md` |
| Individual rules | `./rules/` directory |

## When Unsafe is Valid

| Use Case | Example |
|----------|---------|
| FFI | Calling C functions |
| Low-level abstractions | Implementing `Vec`, `Arc` |
| Performance | Measured bottleneck with safe alternative too slow |

**NOT valid:** Escaping borrow checker without understanding why.

## Required Documentation

```rust
// SAFETY: <why this is safe>
unsafe { ... }

/// # Safety
/// <caller requirements>
pub unsafe fn dangerous() { ... }
```

## Quick Reference

| Operation | Safety Requirements |
|-----------|---------------------|
| `*ptr` deref | Valid, aligned, initialized |
| `&*ptr` | + No aliasing violations |
| `transmute` | Same size, valid bit pattern |
| `extern "C"` | Correct signature, ABI |
| `static mut` | Synchronization guaranteed |
| `impl Send/Sync` | Actually thread-safe |

## Common Errors

| Error | Fix |
|-------|-----|
| Null pointer deref | Check for null before deref |
| Use after free | Ensure lifetime validity |
| Data race | Add proper synchronization |
| Alignment violation | Use `#[repr(C)]`, check alignment |
| Invalid bit pattern | Use `MaybeUninit` |
| Missing SAFETY comment | Add `// SAFETY:` |

## Pitfalls

| Pattern | Problem | Fix |
|---------|---------|-----|
| `mem::uninitialized()` | Instant UB | `MaybeUninit<T>` |
| `mem::zeroed()` for refs | Null reference UB | `MaybeUninit<T>` |
| Raw pointer arithmetic | Easy to go OOB | `NonNull<T>`, `ptr::add` |
| `CString::new().unwrap().as_ptr()` | Dangling pointer: `CString` is dropped at end of statement, pointer is invalid | Store `CString` in a binding first |
| `static mut` | Data races | `AtomicT` or `Mutex` |
| Manual extern | Error-prone signatures | `bindgen` |

## FFI Crates

| Direction | Crate |
|-----------|-------|
| C → Rust | bindgen |
| Rust → C | cbindgen |
| Python | PyO3 |
| Node.js | napi-rs |
