# Types, Traits & Zero-Cost Abstractions

## Core Questions

- **Do we need compile-time or runtime polymorphism?**
- **How can the type system prevent invalid states?**

## Error → Design Question

| Error | Don't Just Say | Ask Instead |
|-------|----------------|-------------|
| E0277 | "Add trait bound" | Is this abstraction at the right level? |
| E0308 | "Fix the type" | Should types be unified or distinct? |
| E0599 | "Import the trait" | Is the trait the right abstraction? |
| E0038 | "Make object-safe" | Do we really need dynamic dispatch? |
| Primitive obsession | "It's just a string" | What does this value represent? |
| Boolean flags | "Add an is_valid flag" | Can states be types? |

## Static vs Dynamic Dispatch

| Pattern | Dispatch | Code Size | Runtime Cost |
|---------|----------|-----------|--------------|
| `fn foo<T: Trait>()` | Static | +bloat | Zero |
| `fn foo(x: &dyn Trait)` | Dynamic | Minimal | vtable lookup |
| `impl Trait` return | Static | +bloat | Zero |
| `Box<dyn Trait>` | Dynamic | Minimal | Allocation + vtable |

```rust
// Static dispatch - type known at compile time
fn process(x: impl Display) { }
fn process<T: Display>(x: T) { }
fn get() -> impl Display { }

// Dynamic dispatch - type determined at runtime
fn process(x: &dyn Display) { }
fn process(x: Box<dyn Display>) { }
```

## Decision Guide

| Scenario | Choose | Why |
|----------|--------|-----|
| Performance critical | Generics | Zero runtime cost |
| Heterogeneous collection | `dyn Trait` | Different types at runtime |
| Plugin architecture | `dyn Trait` | Unknown types at compile |
| Reduce compile time | `dyn Trait` | Less monomorphization |
| Small, known type set | `enum` | No indirection |

## Object Safety

A trait is object-safe if it:
- Doesn't have `Self: Sized` bound
- Doesn't return `Self`
- Doesn't have generic methods
- Uses `where Self: Sized` for non-object-safe methods

## Type-Driven Design Patterns

| Pattern | Purpose | Example |
|---------|---------|---------|
| Newtype | Type safety | `struct UserId(u64);` |
| Type State | State machine | `Connection<Connected>` |
| PhantomData | Variance/lifetime | `PhantomData<&'a T>` |
| Marker Trait | Capability flag | `trait Validated {}` |
| Builder | Gradual construction | `Builder::new().name("x").build()` |
| Sealed Trait | Prevent external impl | `mod private { pub trait Sealed {} }` |

### Newtype

```rust
struct Email(String);

impl Email {
    pub fn new(s: &str) -> Result<Self, ValidationError> {
        validate_email(s)?;
        Ok(Self(s.to_string()))
    }
}
```

### Type State

```rust
struct Connection<State>(TcpStream, PhantomData<State>);
struct Disconnected;
struct Connected;
struct Authenticated;

impl Connection<Disconnected> {
    fn connect(self) -> Connection<Connected> { /* ... */ }
}
impl Connection<Connected> {
    fn authenticate(self) -> Connection<Authenticated> { /* ... */ }
}
```

## Type-Driven Decision Guide

| Need | Pattern |
|------|---------|
| Type safety for primitives | Newtype |
| Compile-time state validation | Type State |
| Lifetime/variance markers | PhantomData |
| Capability flags | Marker Trait |
| Gradual construction | Builder |
| Closed set of impls | Sealed Trait |
| Same behavior, different types | Trait |
| Different behavior, same type | Enum |

## Error Code Reference

| Error | Cause | Quick Fix |
|-------|-------|-----------|
| E0277 | Type doesn't impl trait | Add impl or change bound |
| E0308 | Type mismatch | Check generic params |
| E0599 | No method found | Import trait with `use` |
| E0038 | Trait not object-safe | Use generics or redesign |

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| Over-generic everything | Compile time, complexity | Concrete types when possible |
| `dyn` for known types | Unnecessary indirection | Generics |
| Boolean flags for states | Runtime errors | Type state |
| String for semantic types | No type safety | Newtype |
| Option for uninitialized | Unclear invariant | Builder |
| Public fields with invariants | Invariant violation | Private + validated new() |
| Complex trait hierarchies | Hard to understand | Simpler design |
