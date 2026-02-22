# Async Patterns in Rust

## Task Spawning

### Basic Spawn
```rust
let handle = tokio::spawn(async {
    expensive_computation().await
});
other_work().await;
let result = handle.await.unwrap();
```

### Spawn with Shared State
```rust
let state = Arc::new(Mutex::new(vec![]));
let handles: Vec<_> = (0..10).map(|i| {
    let state = Arc::clone(&state);
    tokio::spawn(async move {
        state.lock().await.push(i);
    })
}).collect();
for handle in handles { handle.await.unwrap(); }
```

---

## Select Pattern

### Racing Multiple Futures
```rust
select! {
    result = fetch_from_server_a() => println!("A: {:?}", result),
    result = fetch_from_server_b() => println!("B: {:?}", result),
}
```

### Select with Timeout
```rust
// Using select!
select! {
    result = fetch_data() => result,
    _ = sleep(Duration::from_secs(5)) => Err(Error::Timeout),
}

// Using timeout directly
timeout(Duration::from_secs(5), fetch_data()).await
    .map_err(|_| Error::Timeout)?
```

---

## Channel Patterns

### MPSC (Multi-Producer, Single-Consumer)
```rust
let (tx, mut rx) = mpsc::channel(100);
for i in 0..3 {
    let tx = tx.clone();
    tokio::spawn(async move { tx.send(format!("From {}", i)).await.unwrap(); });
}
drop(tx);  // Close channel
while let Some(msg) = rx.recv().await { println!("{}", msg); }
```

### Oneshot (Single-Shot Response)
```rust
let (tx, rx) = oneshot::channel();
tokio::spawn(async move { tx.send(compute().await).unwrap(); });
let response = rx.await.unwrap();
```

### Broadcast (Multi-Consumer)
```rust
let (tx, _) = broadcast::channel(16);
let mut rx1 = tx.subscribe();
let mut rx2 = tx.subscribe();
// Both rx1 and rx2 receive all messages
tx.send("Hello").unwrap();
```

### Watch (Single Latest Value)
```rust
let (tx, mut rx) = watch::channel(Config::default());
tokio::spawn(async move {
    while rx.changed().await.is_ok() {
        let config = rx.borrow();
        apply_config(&config);
    }
});
tx.send(Config::new()).unwrap();
```

---

## Structured Concurrency

### JoinSet for Task Groups
```rust
let mut set = JoinSet::new();
for url in urls {
    set.spawn(async move { fetch(&url).await });
}
let mut results = vec![];
while let Some(res) = set.join_next().await {
    results.push(res.unwrap());
}
```

---

## Cancellation Patterns

### Using CancellationToken
```rust
let token = CancellationToken::new();
let task_token = token.clone();
let handle = tokio::spawn(async move {
    loop {
        select! {
            _ = task_token.cancelled() => break,
            _ = do_work() => {},
        }
    }
});
token.cancel();
handle.await.unwrap();
```

### Graceful Shutdown
```rust
async fn serve_with_shutdown(shutdown: impl Future) {
    let server = TcpListener::bind("0.0.0.0:8080").await.unwrap();
    loop {
        select! {
            Ok((socket, _)) = server.accept() => {
                tokio::spawn(handle_connection(socket));
            }
            _ = &mut shutdown => break,
        }
    }
}
```

---

## Backpressure Patterns

### Bounded Channels
```rust
let (tx, mut rx) = mpsc::channel(10);  // Buffer of 10
// Producer will wait if channel is full
```

### Semaphore for Rate Limiting
```rust
let semaphore = Arc::new(Semaphore::new(10));  // max 10 concurrent
let sem = Arc::clone(&semaphore);
tokio::spawn(async move {
    let _permit = sem.acquire().await.unwrap();
    fetch(&url).await
});
```

---

## Error Handling in Async

### Task Panics
```rust
match handle.await {
    Ok(result) => println!("Success: {:?}", result),
    Err(e) if e.is_panic() => println!("Task panicked: {:?}", e),
    Err(e) => println!("Task cancelled: {:?}", e),
}
```

### Try-Join for Multiple Results
```rust
let (a, b, c) = try_join!(fetch_a(), fetch_b(), fetch_c())?;
```
