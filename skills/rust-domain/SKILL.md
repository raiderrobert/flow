---
name: rust-domain
description: "Use when building domain-specific Rust applications. Keywords: web server, HTTP, REST API, GraphQL, WebSocket, axum, actix, tower, CLI, command line, terminal, clap, TUI, ratatui, kubernetes, k8s, docker, grpc, tonic, microservice, cloud, embedded, no_std, MCU, ARM, firmware, embassy, RTIC, fintech, trading, decimal, currency, financial, ledger, IoT, sensor, MQTT, edge computing, machine learning, ML, AI, tensor, model, inference, candle, burn"
globs: ["**/Cargo.toml"]
user-invocable: false
---

# Rust Domain Expertise

Consolidated domain guidance for building Rust applications across web, CLI, cloud-native, embedded, fintech, IoT, and machine learning domains.

## Domain Routing

| Keywords | Reference |
|----------|-----------|
| web, HTTP, REST, axum, actix, tower, middleware | `./web.md` |
| CLI, terminal, clap, TUI, ratatui, progress bar | `./cli.md` |
| kubernetes, docker, grpc, tonic, microservice | `./cloud-native.md` |
| embedded, no_std, MCU, ARM, firmware, embassy | `./embedded.md` |
| fintech, trading, decimal, currency, ledger | `./fintech.md` |
| IoT, sensor, MQTT, edge computing | `./iot.md` |
| ML, AI, tensor, model, inference, candle, burn | `./ml.md` |

## Cross-Domain Patterns

| Pattern | Domains | Implementation |
|---------|---------|----------------|
| Async runtime | Web, Cloud, IoT | tokio, async/await |
| Graceful shutdown | Web, Cloud | SIGTERM handling |
| Structured logging | All | tracing crate |
| Error handling | All | thiserror/anyhow |
| Configuration | Web, Cloud, CLI | figment, clap |
| State management | Web, Cloud | Arc<T>, extractors |

## Reference Files

- `./web.md` - Web services (axum, actix, tower, etc.)
- `./cli.md` - CLI tools (clap, ratatui, indicatif, etc.)
- `./cloud-native.md` - Cloud-native (kubernetes, gRPC, observability)
- `./embedded.md` - Embedded / no_std (HAL, RTIC, embassy)
- `./fintech.md` - Financial applications (decimal, ledger, audit)
- `./iot.md` - IoT (MQTT, sensors, edge computing)
- `./ml.md` - Machine learning (candle, burn, tract, polars)
