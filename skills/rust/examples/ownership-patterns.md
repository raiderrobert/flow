# Ownership Patterns & Common Errors

## E0382: Use of Moved Value

```rust
let s = String::from("hello");
let s2 = s;          // s moved here
println!("{}", s);   // ERROR: value borrowed after move
```

**Fix 1: Clone** — `let s2 = s.clone();`
**Fix 2: Borrow** — `let s2 = &s;`
**Fix 3: Rc/Arc** — `let s = Rc::new(...); let s2 = Rc::clone(&s);`

## E0597: Borrowed Value Does Not Live Long Enough

```rust
fn get_str() -> &str {
    let s = String::from("hello");
    &s  // ERROR: s dropped, reference returned
}
```

**Fix 1:** Return owned value — `fn get_str() -> String`
**Fix 2:** Use `'static` — `fn get_str() -> &'static str { "hello" }`
**Fix 3:** Accept reference parameter — `fn get_str<'a>(s: &'a str) -> &'a str`

## E0499: Multiple Mutable Borrows

```rust
let mut s = String::from("hello");
let r1 = &mut s;
let r2 = &mut s;  // ERROR
```

**Fix 1:** Sequential borrows — scope the first `&mut` before creating second
**Fix 2:** RefCell — for runtime-checked interior mutability

## E0502: Cannot Borrow Mutable While Immutable Exists

```rust
let mut v = vec![1, 2, 3];
let first = &v[0];      // immutable borrow
v.push(4);              // ERROR: mutable borrow
println!("{}", first);
```

**Fix 1:** Copy value first — `let first = v[0];`
**Fix 2:** Clone — `let first = v[0].clone();`

## E0507: Cannot Move Out of Borrowed Content

**Fix 1:** Clone — `s.clone()`
**Fix 2:** Take ownership — change `&T` to `T` in signature
**Fix 3:** `mem::take` — `std::mem::take(opt)` for Option/Default types

## E0515: Return Local Reference

**Fix:** Return owned value or `'static` reference.

## E0716: Temporary Value Dropped

**Fix:** Bind to variable first — `let s = String::from(...); let r = &s;`

## Loop Ownership

```rust
// BAD: strings moved into loop
for s in strings { println!("{}", s); }
println!("{:?}", strings);  // ERROR

// GOOD: iterate by reference
for s in &strings { println!("{}", s); }
println!("{:?}", strings);  // OK
```

---

## API Design Patterns

### Prefer Borrowing Over Ownership

```rust
// BAD: takes ownership unnecessarily
fn print_name(name: String) { println!("Name: {}", name); }

// GOOD: borrows instead
fn print_name(name: &str) { println!("Name: {}", name); }
```

### Accept Into\<String\> for Flexibility

```rust
impl User {
    fn new(name: impl Into<String>) -> Self {
        User { name: name.into() }
    }
}
// Works with both &str and String
```

### Use AsRef for Generic Borrowing

```rust
fn process<S: AsRef<str>>(input: S) {
    let s = input.as_ref();
    println!("{}", s);
}
```

### Cow for Clone-on-Write

```rust
fn maybe_modify(s: &str, upper: bool) -> Cow<'_, str> {
    if upper { Cow::Owned(s.to_uppercase()) }
    else { Cow::Borrowed(s) }
}
```

## Struct Design

### Owned Fields vs References

```rust
// Owned fields for most cases
struct User { name: String, email: String }

// References only when lifetime is clear
struct UserView<'a> { name: &'a str, email: &'a str }

// Pattern: owned data + view
impl User {
    fn view(&self) -> UserView<'_> {
        UserView { name: &self.name, email: &self.email }
    }
}
```

### Builder Pattern

```rust
#[derive(Default)]
struct RequestBuilder {
    url: Option<String>,
    method: Option<String>,
}

impl RequestBuilder {
    fn new() -> Self { Self::default() }

    fn url(mut self, url: impl Into<String>) -> Self {
        self.url = Some(url.into());
        self
    }

    fn build(self) -> Result<Request, Error> {
        Ok(Request { url: self.url.ok_or(Error::MissingUrl)? })
    }
}
```

## Collection Patterns

### Entry API

```rust
map.entry("key".to_string())
   .or_insert_with(Vec::new)
   .push(42);
```

### Efficient Iteration

```rust
for item in &items { }         // borrow
for item in &mut items { }     // mutable borrow
let sum: i32 = items.into_iter().sum();  // consume

// Collect Results
let result: Result<Vec<i32>, _> = ["1", "2", "3"]
    .iter().map(|s| s.parse::<i32>()).collect();
```

## Performance Tips

```rust
// BAD: clone to compare
items.iter().any(|s| s.clone() == target)
// GOOD: String implements PartialEq<str>
items.iter().any(|s| s == target)

// BAD: requires Vec
fn sum(numbers: &Vec<i32>) -> i32
// GOOD: accepts any slice
fn sum(numbers: &[i32]) -> i32
```
