# Ownership, Borrowing & Resource Management

## Core Questions

- **Who should own this data, and for how long?**
- **What ownership pattern does this resource need?**
- **Why does this data need to change, and who can change it?**

## Error → Design Question

| Error | Don't Just Say | Ask Instead |
|-------|----------------|-------------|
| E0382 | "Clone it" | Who should own this data? |
| E0597 | "Extend lifetime" | Is the scope boundary correct? |
| E0506 | "End borrow first" | Should mutation happen elsewhere? |
| E0507 | "Clone before move" | Why are we moving from a reference? |
| E0515 | "Return owned" | Should caller own the data? |
| E0716 | "Bind to variable" | Why is this temporary? |
| E0106 | "Add 'a" | What is the actual lifetime relationship? |
| E0596 | "Add mut" | Should this really be mutable? |
| E0499 | "Split borrows" | Is the data structure right? |
| E0502 | "Separate scopes" | Why do we need both borrows? |

## Ownership Patterns

| Pattern | Cost | Use When |
|---------|------|----------|
| Move | Zero | Caller doesn't need data |
| `&T` | Zero | Read-only access |
| `&mut T` | Zero | Need to modify |
| `clone()` | Alloc + copy | Actually need a copy |
| `Cow<T>` | Alloc if mutated | Might modify borrowed data |

## Smart Pointer Decision

```
Need heap allocation?
├─ Yes → Single owner?
│        ├─ Yes → Box<T>
│        └─ No → Multi-thread?
│                ├─ Yes → Arc<T>
│                └─ No → Rc<T>
└─ No → Stack allocation (default)

Have reference cycles?
├─ Yes → One direction must be Weak
└─ No → Regular Rc/Arc

Need interior mutability?
├─ Yes → Thread-safe needed?
│        ├─ Yes → Mutex<T> or RwLock<T>
│        └─ No → T: Copy? → Cell<T> : RefCell<T>
└─ No → Use &mut T
```

## Smart Pointer Quick Reference

| Type | Ownership | Thread-Safe | Use When |
|------|-----------|-------------|----------|
| `Box<T>` | Single | Yes | Heap allocation, recursive types |
| `Rc<T>` | Shared | No | Single-thread shared ownership |
| `Arc<T>` | Shared | Yes | Multi-thread shared ownership |
| `Weak<T>` | Weak ref | Same as Rc/Arc | Break reference cycles |
| `Cell<T>` | Single | No | Interior mutability (Copy types) |
| `RefCell<T>` | Single | No | Interior mutability (runtime check) |

## Interior Mutability Decision

| Scenario | Choose |
|----------|--------|
| T: Copy, single-thread | `Cell<T>` |
| T: !Copy, single-thread | `RefCell<T>` |
| T: Copy, multi-thread | `AtomicXxx` |
| T: !Copy, multi-thread | `Mutex<T>` or `RwLock<T>` |
| Read-heavy, multi-thread | `RwLock<T>` |
| Simple flags/counters | `AtomicBool`, `AtomicUsize` |

## Borrow Rules

```
At any time, you can have EITHER:
├─ Multiple &T (immutable borrows)
└─ OR one &mut T (mutable borrow)
Never both simultaneously.
```

## Error Code Reference

| Error | Cause | Quick Fix |
|-------|-------|-----------|
| E0382 | Value moved | Clone, reference, or redesign ownership |
| E0597 | Reference outlives owner | Extend owner scope or restructure |
| E0506 | Assign while borrowed | End borrow before mutation |
| E0507 | Move out of borrowed | Clone or use reference |
| E0515 | Return local reference | Return owned value |
| E0716 | Temporary dropped | Bind to variable |
| E0106 | Missing lifetime | Add `'a` annotation |
| E0596 | Borrowing immutable as mutable | Add `mut` or redesign |
| E0499 | Multiple mutable borrows | Restructure code flow |
| E0502 | &mut while & exists | Separate borrow scopes |
| Rc cycle leak | Mutual strong refs | Use Weak for one direction |
| RefCell panic | Borrow conflict at runtime | Use try_borrow or restructure |

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| `.clone()` everywhere | Hides design issues | Design ownership properly |
| Fight borrow checker | Increases complexity | Work with the compiler |
| `'static` for everything | Restricts flexibility | Use appropriate lifetimes |
| `Box::leak` to avoid lifetimes | Memory leak | Proper lifetime design |
| Arc everywhere | Unnecessary atomic overhead | Use Rc for single-thread |
| RefCell everywhere | Runtime panics | Design clear ownership |
| Box for small types | Unnecessary allocation | Stack allocation |
| Mutex for single-thread | Unnecessary overhead | RefCell |
| Lock inside hot loop | Performance killer | Batch operations |

For code examples, see `examples/ownership-patterns.md` and `examples/lifetime-patterns.md`.
