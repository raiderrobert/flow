# Ownership: Comparison with Other Languages

## Rust vs C++

### Memory Management

| Aspect | Rust | C++ |
|--------|------|-----|
| Default | Move semantics | Copy semantics (pre-C++11) |
| Move | `let b = a;` (a invalidated) | `auto b = std::move(a);` (a valid but unspecified) |
| Copy | `let b = a.clone();` | `auto b = a;` |
| Safety | Compile-time enforcement | Runtime responsibility |

```rust
// Rust: after move, 'a' is INVALID
let a = String::from("hello");
let b = a;  // a moved
// println!("{}", a);  // COMPILE ERROR

// C++: compiles but undefined
// std::string b = std::move(a);
// std::cout << a;  // UNDEFINED
```

### Smart Pointers

| Rust | C++ | Purpose |
|------|-----|---------|
| `Box<T>` | `std::unique_ptr<T>` | Unique ownership |
| `Rc<T>` | `std::shared_ptr<T>` | Shared ownership |
| `Arc<T>` | `std::shared_ptr<T>` + atomic | Thread-safe shared |
| `RefCell<T>` | (manual runtime checks) | Interior mutability |

---

## Rust vs Go

| Aspect | Rust | Go |
|--------|------|-----|
| Memory | Stack + heap, explicit | GC manages all |
| Ownership | Enforced at compile-time | None (GC handles) |
| Null | `Option<T>` | `nil` for pointers |
| Concurrency | `Send`/`Sync` traits | Channels (less strict) |

```rust
// Rust: explicit about sharing
let data = Arc::new(vec![1, 2, 3]);
let data_clone = Arc::clone(&data);
std::thread::spawn(move || { println!("{:?}", data_clone); });

// Go: implicit sharing
// go func() { fmt.Println(data) }()  // potential race condition
```

### Why No GC in Rust
1. **Deterministic destruction**: freed exactly when scope ends
2. **Zero-cost**: no GC pauses or overhead
3. **Embeddable**: works in OS kernels, embedded systems
4. **Predictable latency**: critical for real-time systems

---

## Rust vs Java/C#

| Aspect | Rust | Java/C# |
|--------|------|---------|
| Objects | Owned by default | Reference by default |
| Null | `Option<T>` | `null` (nullable) |
| Immutability | Default | Must use `final`/`readonly` |
| Copy | Explicit `.clone()` | Reference copy (shallow) |

```rust
// Rust: clear ownership
fn process(data: Vec<i32>) { /* data is ours */ }
let numbers = vec![1, 2, 3];
process(numbers);
// numbers is invalid here

// Java: ambiguous ownership
// void process(List<Integer> data) {
//     // Who owns data? Caller? Callee? Both?
// }
```

---

## Rust vs Python

| Aspect | Rust | Python |
|--------|------|--------|
| Typing | Static, compile-time | Dynamic, runtime |
| Memory | Ownership-based | Reference counting + GC |
| Mutability | Default immutable | Default mutable |
| Performance | Native, zero-cost | Interpreted, higher overhead |

---

## Unique Rust Concepts

1. **Borrow Checker**: No other mainstream language has compile-time borrow checking
2. **Lifetimes**: Explicit annotation of reference validity
3. **Move by Default**: Values move, not copy
4. **No Null**: `Option<T>` instead of null pointers
5. **Affine Types**: Values can be used at most once

## Mental Model Shifts

### From GC Languages (Java, Go, Python)
- Think about ownership at design time
- Returning references requires lifetime thinking
- No more `null` — use `Option<T>`

### From C/C++
- Trust the compiler's errors
- Move is the default (unlike C++ copy)
- Smart pointers are idiomatic, not overhead

### From Functional Languages (Haskell, ML)
- Mutability is safe because of ownership rules
- No persistent data structures needed (usually)
- Performance characteristics are explicit

## Performance Trade-offs

| Language | Memory Overhead | Latency | Throughput |
|----------|-----------------|---------|------------|
| Rust | Minimal (no GC) | Predictable | Excellent |
| C++ | Minimal | Predictable | Excellent |
| Go | GC overhead | GC pauses | Good |
| Java | GC overhead | GC pauses | Good |
| Python | High | Variable | Lower |
