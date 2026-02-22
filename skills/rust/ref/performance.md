# Performance Optimization

## Core Question

**What's the bottleneck, and is optimization worth it?**

Before optimizing: Have you measured? Don't guess.

## Optimization Priority

```
1. Algorithm choice     (10x - 1000x)
2. Data structure       (2x - 10x)
3. Allocation reduction (2x - 5x)
4. Cache optimization   (1.5x - 3x)
5. SIMD/Parallelism     (2x - 8x)
```

## Profiling Tools

| Tool | Purpose |
|------|---------|
| `cargo bench` | Micro-benchmarks |
| `criterion` | Statistical benchmarks |
| `cargo flamegraph` | CPU profiling |
| `heaptrack` | Allocation tracking |
| `valgrind --tool=cachegrind` | Cache analysis |

## Common Techniques

| Technique | When | How |
|-----------|------|-----|
| Pre-allocation | Known size | `Vec::with_capacity(n)` |
| Avoid cloning | Hot paths | Use references or `Cow<T>` |
| Batch operations | Many small ops | Collect then process |
| SmallVec | Usually small | `smallvec::SmallVec<[T; N]>` |
| Inline buffers | Fixed-size data | Arrays over Vec |
| Buffer reuse | Repeated allocs | `.clear()` then reuse |

## Collections Guide

| Need | Collection | Notes |
|------|------------|-------|
| Sequential access | `Vec<T>` | Best cache locality |
| Random access by key | `HashMap<K, V>` | O(1) lookup |
| Ordered keys | `BTreeMap<K, V>` | O(log n) lookup |
| Small sets (<20) | `Vec<T>` + linear search | Lower overhead |
| FIFO queue | `VecDeque<T>` | O(1) push/pop both ends |

## String Optimization

```rust
// BAD: O(n²) allocations in loop
let mut result = String::new();
for s in strings { result = result + &s; }

// GOOD: pre-allocate + push_str
let total: usize = strings.iter().map(|s| s.len()).sum();
let mut result = String::with_capacity(total);
for s in strings { result.push_str(&s); }

// BEST: use join for simple cases
let result = strings.join("");
```

## Iterator Optimization

```rust
// BAD: bounds checking on each access
for i in 0..vec.len() { sum += vec[i]; }

// GOOD: no bounds checking
let sum: i32 = vec.iter().sum();

// BAD: unnecessary intermediate allocation
let filtered: Vec<_> = items.iter().filter(|x| x.valid).collect();
let count = filtered.len();

// GOOD: no allocation
let count = items.iter().filter(|x| x.valid).count();
```

## Parallelism with Rayon

```rust
use rayon::prelude::*;

// Sequential → Parallel (one-line change)
let sum: i32 = (0..1_000_000).into_par_iter().map(|x| x * x).sum();

// Parallel chunks
let results: Vec<_> = data.par_chunks(1000).map(process_chunk).collect();
```

## Memory Layout

```rust
// BAD: 24 bytes due to padding
struct Bad { a: u8, b: u64, c: u8 }

// GOOD: 16 bytes
struct Good { b: u64, a: u8, c: u8 }

// Box large enum variants
enum Message {
    Quit,
    Data(Box<[u8; 10000]>),  // not Data([u8; 10000])
}
```

## Async Performance

```rust
// BAD: blocking call in async
async fn bad() {
    std::thread::sleep(Duration::from_secs(1));  // blocks executor!
}

// GOOD: async versions
async fn good() {
    tokio::time::sleep(Duration::from_secs(1)).await;
}

// For CPU work: spawn_blocking
async fn compute() -> i32 {
    tokio::task::spawn_blocking(|| heavy_computation()).await.unwrap()
}
```

## Release Build Settings

```toml
[profile.release]
lto = true           # Link-time optimization
codegen-units = 1    # Slower compile, faster code
panic = "abort"      # Smaller binary
strip = true         # Strip symbols
```

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| Optimize without profiling | Wrong target | Profile first |
| Benchmark in debug mode | Meaningless | Always `--release` |
| Use LinkedList | Cache unfriendly | `Vec` or `VecDeque` |
| Hidden `.clone()` | Unnecessary allocs | Use references |
| Clone to avoid lifetimes | Performance cost | Proper ownership |
| Box everything | Indirection cost | Stack when possible |
| HashMap for small sets | Overhead | Vec with linear search |
| String concat in loop | O(n²) | `with_capacity` or `join` |
| Premature optimization | Wasted effort | Make it work first |

## Checklist

Before optimizing:
- [ ] Profile to find actual bottlenecks
- [ ] Have benchmarks to measure improvement
- [ ] Consider if optimization is worth complexity

Common wins:
- [ ] Reduce allocations (Cow, reuse buffers)
- [ ] Use appropriate collections
- [ ] Pre-allocate with_capacity
- [ ] Use iterators instead of indexing
- [ ] Enable LTO for release builds
- [ ] Use rayon for CPU-bound parallel workloads
