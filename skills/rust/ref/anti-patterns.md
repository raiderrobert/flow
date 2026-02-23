# Anti-Patterns & Mental Models

## Core Questions

- **Is this pattern hiding a design problem?**
- **What's the right way to think about this Rust concept?**

## Top Beginner Mistakes

| Rank | Mistake | Fix |
|------|---------|-----|
| 1 | Clone to escape borrow checker | Use references, redesign ownership |
| 2 | Unwrap in production | Propagate with `?` |
| 3 | String for everything | Use `&str`, `Cow<str>` |
| 4 | Index loops | Use iterators |
| 5 | Fighting lifetimes | Restructure to own data |

## Anti-Pattern → Better Pattern

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| `.clone()` everywhere | Hides ownership issues | Proper references or ownership |
| `.unwrap()` in production | Runtime panics | `?`, `expect`, or handling |
| `Rc` when single owner | Unnecessary overhead | Simple ownership |
| `unsafe` for convenience | UB risk | Find safe pattern |
| OOP via `Deref` | Misleading API | Composition, traits |
| Giant match arms | Unmaintainable | Extract to methods |
| `String` everywhere | Allocation waste | `&str`, `Cow<str>` |
| Ignoring `#[must_use]` | Lost errors | Handle or `let _ =` |

## Code Smell → Refactoring

| Smell | Indicates | Refactoring |
|-------|-----------|-------------|
| Many `.clone()` | Ownership unclear | Clarify data flow |
| Many `.unwrap()` | Error handling missing | Add proper handling |
| Many `pub` fields | Encapsulation broken | Private + accessors |
| Deep nesting | Complex logic | Extract methods |
| Long functions | Multiple responsibilities | Split |
| Giant enums | Missing abstraction | Trait + types |

## Deprecated → Better

| Deprecated | Better |
|------------|--------|
| Index-based loops | `.iter()`, `.enumerate()` |
| `collect::<Vec<_>>()` then iterate | Chain iterators |
| Manual unsafe cell | `Cell`, `RefCell` |
| `mem::transmute` for casts | `as` or `TryFrom` |
| Custom linked list | `Vec`, `VecDeque` |
| `lazy_static!` | `std::sync::OnceLock` |

## Quick Review Checklist

- [ ] No `.clone()` without justification
- [ ] No `.unwrap()` in library code
- [ ] No `pub` fields with invariants
- [ ] No index loops when iterator works
- [ ] No `String` where `&str` suffices
- [ ] No ignored `#[must_use]` warnings
- [ ] No `unsafe` without SAFETY comment
- [ ] No giant functions (>50 lines)

## Mental Models

| Concept | Mental Model | Analogy |
|---------|--------------|---------|
| Ownership | Unique key | Only one person has the house key |
| Move | Key handover | Giving away your key |
| `&T` | Lending for reading | Lending a book |
| `&mut T` | Exclusive editing | Only you can edit the doc |
| Lifetime `'a` | Valid scope | "Ticket valid until..." |
| `Box<T>` | Heap pointer | Remote control to TV |
| `Rc<T>` | Shared ownership | Multiple remotes, last turns off |
| `Arc<T>` | Thread-safe Rc | Remotes from any room |

## Coming From Other Languages

| From | Key Shift |
|------|-----------|
| Java/C# | Values are owned, not references by default |
| C/C++ | Compiler enforces safety rules; move is default, not copy |
| Python/Go | No GC, deterministic destruction |
| Functional | Mutability is safe via ownership |
| JavaScript | No null, use Option instead |

For detailed comparisons, see `examples/language-comparison.md`.

## Common Misconceptions

| Error | Wrong Model | Correct Model |
|-------|-------------|---------------|
| E0382 use after move | GC cleans up | Ownership = unique key transfer |
| E0502 borrow conflict | Multiple writers OK | Only one writer at a time |
| E0499 multiple mut borrows | Aliased mutation | Exclusive access for mutation |
| E0106 missing lifetime | Ignoring scope | References have validity scope |
| E0507 cannot move from `&T` | Implicit clone | References don't own data |

## Deprecated Thinking

| Deprecated | Better |
|------------|--------|
| "Rust is like C++" | Different ownership model |
| "Lifetimes are GC" | Compile-time validity scope |
| "Clone solves everything" | Restructure ownership |
| "Fight the borrow checker" | Work with the compiler |
| "`unsafe` to avoid rules" | Understand safe patterns first |

## Ownership Visualization

```
Stack                          Heap
+----------------+            +----------------+
| main()         |            |                |
|   s1 ──────────────────────>│ "hello"        |
|                |            |                |
| fn takes(s) {  |            |                |
|   s2 (moved) ──────────────>│ "hello"        |
| }              |            | (s1 invalid)   |
+----------------+            +----------------+
```

## Reference Visualization

```
data: String ──────────> "hello"
       ^
       │ &data (immutable borrow)
  reader1    reader2    (multiple OK)

data: String ──────────> "hello"
       ^
       │ &mut data (mutable borrow)
  writer (only one)
```

## Key Problem-Solving Patterns

### The "Make It Own" Pattern
When lifetimes get complex, make the struct own its data:
```rust
// Complex: struct with references
struct Parser<'a> { input: &'a str, current: &'a str }

// Simpler: struct owns data
struct Parser { input: String, position: usize }
```

### The "Split the Borrow" Pattern
```rust
let Data { field_a, field_b } = self;
for a in field_a.iter() {
    field_b.push(*a);  // OK: separate borrows
}
```

## Learning Path

| Stage | Focus | Reference |
|-------|-------|-----------|
| Beginner | Ownership basics | `ref/ownership.md` |
| Intermediate | Smart pointers, error handling | `ref/ownership.md`, `ref/error-handling.md` |
| Advanced | Concurrency, unsafe | `ref/concurrency.md`, `unsafe-checker` skill |
| Expert | Design patterns, domain | `ref/design-patterns.md`, `rust-domain` skill |
