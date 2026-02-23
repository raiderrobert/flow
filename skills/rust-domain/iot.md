# IoT Domain

## Domain Constraints

| Domain Rule | Design Constraint | Rust Implication |
|-------------|-------------------|------------------|
| Unreliable network | Offline-first | Local buffering |
| Power constraints | Efficient code | Sleep modes, minimal alloc |
| Resource limits | Small footprint | no_std where needed |
| Security | Encrypted comms | TLS, signed firmware |
| Reliability | Self-recovery | Watchdog, error handling |
| OTA updates | Safe upgrades | Rollback capability |

## Critical Constraints

### Network Unreliability

```
RULE: Network can fail at any time
WHY: Wireless, remote locations
RUST: Local queue, retry with backoff
```

### Power Management

```
RULE: Minimize power consumption
WHY: Battery life, energy costs
RUST: Sleep modes, efficient algorithms
```

### Device Security

```
RULE: All communication encrypted
WHY: Physical access possible
RUST: TLS, signed messages
```

## Environment Comparison

| Environment | Stack | Crates |
|-------------|-------|--------|
| Linux gateway | tokio + std | rumqttc, reqwest |
| MCU device | embassy + no_std | embedded-hal |
| Hybrid | Split workloads | Both |

## Key Crates

| Purpose | Crate |
|---------|-------|
| MQTT (std) | rumqttc, paho-mqtt |
| Embedded | embedded-hal, embassy |
| Async (std) | tokio |
| Async (no_std) | embassy |
| Logging (no_std) | defmt |
| Logging (std) | tracing |

## Design Patterns

| Pattern | Purpose | Implementation |
|---------|---------|----------------|
| Pub/Sub | Device comms | MQTT topics |
| Edge compute | Local processing | Filter before upload |
| OTA updates | Firmware upgrade | Signed + rollback |
| Power mgmt | Battery life | Sleep + wake events |
| Store & forward | Network reliability | Local queue |

## Code Pattern: MQTT Client

```rust
use rumqttc::{AsyncClient, MqttOptions, QoS};

async fn run_mqtt() -> anyhow::Result<()> {
    let mut options = MqttOptions::new("device-1", "broker.example.com", 1883);
    options.set_keep_alive(Duration::from_secs(30));

    let (client, mut eventloop) = AsyncClient::new(options, 10);

    // Subscribe to commands
    client.subscribe("devices/device-1/commands", QoS::AtLeastOnce).await?;

    // Publish telemetry
    tokio::spawn(async move {
        loop {
            let data = read_sensor().await;
            client.publish("devices/device-1/telemetry", QoS::AtLeastOnce, false, data).await.ok();
            tokio::time::sleep(Duration::from_secs(60)).await;
        }
    });

    // Process events
    loop {
        match eventloop.poll().await {
            Ok(event) => handle_event(event).await,
            Err(e) => {
                tracing::error!("MQTT error: {}", e);
                tokio::time::sleep(Duration::from_secs(5)).await;
            }
        }
    }
}
```

## Common Mistakes

| Mistake | Domain Violation | Fix |
|---------|-----------------|-----|
| No retry logic | Lost data | Exponential backoff |
| Always-on radio | Battery drain | Sleep between sends |
| Unencrypted MQTT | Security risk | TLS |
| No local buffer | Network outage = data loss | Persist locally |
