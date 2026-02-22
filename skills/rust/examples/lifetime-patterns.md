# Lifetime Patterns

## Basic Lifetime Annotation

### When Required
```rust
// ERROR: missing lifetime specifier
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}

// FIX: explicit lifetime
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

### Lifetime Elision Rules
1. Each input reference gets its own lifetime
2. If one input lifetime, output uses same
3. If `&self` or `&mut self`, output uses self's lifetime

```rust
// These are equivalent (elision applies):
fn first_word(s: &str) -> &str { ... }
fn first_word<'a>(s: &'a str) -> &'a str { ... }

// Method with self (elision applies):
impl MyStruct {
    fn get_ref(&self) -> &str { ... }
    // Equivalent to:
    fn get_ref<'a>(&'a self) -> &'a str { ... }
}
```

---

## Struct Lifetimes

### Struct Holding References
```rust
struct Excerpt<'a> {
    part: &'a str,
}

impl<'a> Excerpt<'a> {
    fn level(&self) -> i32 { 3 }

    fn get_part(&self) -> &str {
        self.part
    }
}
```

### Multiple Lifetimes in Struct
```rust
struct Multi<'a, 'b> {
    x: &'a str,
    y: &'b str,
}

fn make_multi<'a, 'b>(x: &'a str, y: &'b str) -> Multi<'a, 'b> {
    Multi { x, y }
}
```

---

## 'static Lifetime

### When to Use
```rust
// String literals are 'static
let s: &'static str = "hello";

// Thread spawn requires 'static or move
std::thread::spawn(move || {
    // closure owns data, satisfies 'static
});
```

### Avoid Overusing 'static
```rust
// BAD: requires 'static unnecessarily
fn process(s: &'static str) { ... }

// GOOD: use generic lifetime
fn process(s: &str) { ... }
```

---

## Higher-Ranked Trait Bounds (HRTB)

### for<'a> Syntax
```rust
fn apply_to_ref<F>(f: F)
where
    F: for<'a> Fn(&'a str) -> &'a str,
{
    let s = String::from("hello");
    let result = f(&s);
    println!("{}", result);
}
```

---

## Lifetime Bounds

### 'a: 'b (Outlives)
```rust
fn coerce<'a, 'b>(x: &'a str) -> &'b str
where
    'a: 'b,
{
    x
}
```

### T: 'a (Type Outlives Lifetime)
```rust
struct Wrapper<'a, T: 'a> {
    value: &'a T,
}
```

---

## Common Lifetime Mistakes

### Returning Reference to Local
```rust
// WRONG
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // s dropped, reference invalid
}

// RIGHT
fn no_dangle() -> String {
    String::from("hello")
}
```

### Conflicting Lifetimes
```rust
// WRONG: y might not live as long as 'a
fn wrong<'a, 'b>(x: &'a str, y: &'b str) -> &'a str {
    y  // ERROR
}

// RIGHT: use same lifetime
fn right<'a>(x: &'a str, y: &'a str) -> &'a str {
    y
}
```

### Struct Outlives Reference
```rust
// WRONG
let r;
{
    let s = String::from("hello");
    r = Excerpt { part: &s };  // ERROR
}
println!("{}", r.part);  // s already dropped

// RIGHT: ensure source outlives struct
let s = String::from("hello");
let r = Excerpt { part: &s };
println!("{}", r.part);  // OK
```

---

## Subtyping and Variance

### Covariance
```rust
// &'a T is covariant in 'a
// Can use &'long where &'short expected
fn example<'short, 'long: 'short>(long_ref: &'long str) {
    let short_ref: &'short str = long_ref;  // OK
}
```

### Invariance
```rust
// &'a mut T is invariant in 'a
fn example<'a, 'b>(x: &'a mut &'b str, y: &'b str) {
    *x = y;  // ERROR if 'a and 'b are different
}
```
