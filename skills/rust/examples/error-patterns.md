# Error Handling Patterns

## The ? Operator

### Basic Usage
```rust
fn read_config() -> Result<Config, io::Error> {
    let content = std::fs::read_to_string("config.toml")?;
    let config: Config = toml::from_str(&content)?;
    Ok(config)
}
```

### With Different Error Types
```rust
// Box<dyn Error> for quick prototyping
fn process() -> Result<(), Box<dyn Error>> {
    let file = std::fs::read_to_string("data.txt")?;
    let num: i32 = file.trim().parse()?;
    Ok(())
}
```

### Custom Conversion with From
```rust
#[derive(Debug)]
enum MyError { Io(io::Error), Parse(ParseIntError) }

impl From<io::Error> for MyError {
    fn from(err: io::Error) -> Self { MyError::Io(err) }
}
// Now ? auto-converts io::Error to MyError
```

---

## Using thiserror (Libraries)

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum DataError {
    #[error("file not found: {path}")]
    NotFound { path: String },

    #[error("invalid data format")]
    InvalidFormat,

    #[error("IO error")]
    Io(#[from] std::io::Error),

    #[error("parse error: {0}")]
    Parse(#[from] std::num::ParseIntError),
}

pub type Result<T> = std::result::Result<T, DataError>;
```

---

## Using anyhow (Applications)

```rust
use anyhow::{Context, Result, bail, ensure};

fn process_file(path: &str) -> Result<Data> {
    let content = std::fs::read_to_string(path)
        .context("failed to read config file")?;

    ensure!(!content.is_empty(), "config file is empty");

    let data: Data = serde_json::from_str(&content)
        .context("failed to parse JSON")?;

    if data.version < 1 {
        bail!("unsupported config version: {}", data.version);
    }
    Ok(data)
}
```

### Error Chain
```rust
fn deep() -> Result<()> {
    std::fs::read_to_string("missing.txt").context("read file")?;
    Ok(())
}
fn middle() -> Result<()> { deep().context("in deep")? ; Ok(()) }
fn top() -> Result<()> { middle().context("in middle")?; Ok(()) }
// Output: in middle → in deep → read file → os error 2
```

---

## Option Handling

```rust
// Option to Result
find_user(id).ok_or("user not found")
find_user(id).ok_or_else(|| format!("user {} not found", id))

// Chaining Options
data.config.as_ref()?.nested.as_ref()?.value.as_deref()
```

---

## Result Combinators

```rust
// map_err: transform error type
s.parse::<u16>().map_err(|e| ParseError::InvalidPort(e))

// and_then: chain fallible operations
validate(input).and_then(save).and_then(notify)

// unwrap_or: default value
let port = config.port().unwrap_or(8080);
```

## Early Return vs Combinators

| Style | Best For |
|-------|----------|
| Early return (`?`) | Most cases, clearer flow |
| Combinators | Functional pipelines, one-liners |
| Match | Complex branching on errors |

---

## Library Error Design

### Principles
1. Define specific error types (not anyhow)
2. Implement `std::error::Error`
3. Provide matchable variants
4. Include source errors
5. Be `Send + Sync` for async

```rust
#[derive(thiserror::Error, Debug)]
pub enum DatabaseError {
    #[error("connection failed: {host}:{port}")]
    ConnectionFailed { host: String, port: u16, #[source] source: io::Error },

    #[error("record not found: {table}.{id}")]
    NotFound { table: String, id: String },
}
```

## Application Error Design

### Principles
1. Use anyhow for convenience
2. Add `.context()` at boundaries
3. Log at boundaries, not in libraries
4. Convert to user-friendly messages

```rust
async fn run_server() -> Result<()> {
    let config = load_config().context("load config")?;
    let db = Database::connect(&config.db_url).await.context("connect db")?;
    server.run(db).await.context("server error")
}
```

### HTTP API Error Response
```rust
enum AppError {
    NotFound(String),
    BadRequest(String),
    Internal(anyhow::Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        match self {
            AppError::NotFound(msg) => (StatusCode::NOT_FOUND, msg),
            AppError::BadRequest(msg) => (StatusCode::BAD_REQUEST, msg),
            AppError::Internal(e) => {
                tracing::error!("Internal: {:#}", e);
                (StatusCode::INTERNAL_SERVER_ERROR, "Internal error".into())
            }
        }.into_response()
    }
}
```

---

## Domain Error Hierarchy

```rust
#[derive(thiserror::Error, Debug)]
pub enum AppError {
    #[error("Invalid input: {0}")]
    Validation(String),

    #[error("Service temporarily unavailable")]
    ServiceUnavailable(#[source] reqwest::Error),

    #[error("Internal error")]
    Internal(#[source] anyhow::Error),
}

impl AppError {
    pub fn is_retryable(&self) -> bool {
        matches!(self, Self::ServiceUnavailable(_))
    }
}
```

### Retry Pattern
```rust
let strategy = ExponentialBackoff::from_millis(100)
    .max_delay(Duration::from_secs(10))
    .take(5);
Retry::spawn(strategy, || operation()).await
```

---

## Testing Errors

```rust
#[test]
fn test_not_found() {
    let result = db.get_user("nonexistent");
    assert!(matches!(result, Err(DatabaseError::NotFound { .. })));
}

#[test]
fn test_error_message() {
    let err = DatabaseError::NotFound { table: "users".into(), id: "123".into() };
    assert_eq!(err.to_string(), "record not found: users.123");
}

#[test]
fn test_with_anyhow() -> anyhow::Result<()> {
    let result = process("valid input")?;
    assert_eq!(result, expected);
    Ok(())
}
```
