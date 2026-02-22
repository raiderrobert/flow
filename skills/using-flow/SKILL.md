---
name: using-flow
description: Use when starting any conversation - establishes how to find and use flow skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to the user's request, you MUST invoke it using the Skill tool BEFORE generating any other response - including clarifying questions, explanations, or partial answers. The skill may contain critical instructions that change how you should respond.
</EXTREMELY-IMPORTANT>

## How to Access Skills

All flow skills are invoked using the **Skill tool**. When a user's message matches any skill trigger, call:

```
Skill(skill: "skill-name")
```

You can also pass arguments:

```
Skill(skill: "skill-name", args: "user's question or context")
```

Skills are loaded on-demand. You do NOT have their full content in context -- you must invoke them to access their instructions.

## The Rule

**ALWAYS invoke the matching skill BEFORE responding.** No exceptions.

- Before answering a Rust question -> invoke the skill
- Before asking a clarifying question -> invoke the skill
- Before saying "I think..." -> invoke the skill
- Before writing any code -> invoke the skill

The skill may completely change how you should approach the response. You cannot know this without loading it first.

## Red Flags

If you catch yourself thinking any of these, STOP and invoke the skill instead:

| Rationalization | Why It's Wrong |
|---|---|
| "I already know the answer" | The skill may have specific instructions that override your default behavior |
| "This is a simple question" | Simple questions often have skill-specific handling rules |
| "I'll just answer quickly first" | The skill MUST come first, not after |
| "The skill probably doesn't apply" | If there's even 1% chance, invoke it |
| "I need to ask a clarifying question first" | Invoke the skill first -- it may already address the ambiguity |
| "Let me just explain the concept" | The skill may have a specific teaching methodology |

## Skill Priority

When multiple skills could match, use this priority order:

1. **rust-router** -- for ANY Rust question (it routes to specialized skills internally)
2. **Domain-specific skills** -- if the question is clearly about a specific domain (web, CLI, embedded, etc.)
3. **Module skills (m01-m15)** -- for specific Rust concept questions
4. **Tooling skills** -- for project tooling and workflow questions
5. **Meta skills** -- for analysis and meta-cognitive tasks

## Skill Types

| Type | Description | Examples |
|---|---|---|
| **Router** | Routes to other skills based on analysis | `rust-router` |
| **Module** | Deep expertise on a specific Rust concept | `m01-ownership`, `m06-error-handling` |
| **Domain** | Domain-specific Rust patterns and crates | `domain-web`, `domain-cli` |
| **LSP** | Code analysis using LSP capabilities | `rust-symbol-analyzer`, `rust-call-graph` |
| **Tooling** | Project tooling and workflow | `diecut-new`, `writing-prs` |
| **Meta** | Analysis and cognitive frameworks | `meta-cognition-parallel` |
| **Core** | Internal plugin infrastructure | `core-actionbook`, `core-dynamic-skills` |

## Available Skills (41 total)

### Rust Core Modules (m01-m15)

| Skill | Trigger | Key Signals |
|---|---|---|
| `m01-ownership` | Ownership, borrowing, lifetime issues | E0382, E0597, E0506, E0507, E0515, E0716, E0106, `value moved`, `borrowed value does not live long enough`, `cannot move out of`, `'a`, `'static`, `move`, `clone`, `Copy` |
| `m02-resource` | Smart pointers and resource management | `Box`, `Rc`, `Arc`, `Weak`, `RefCell`, `Cell`, smart pointer, heap allocation, reference counting, RAII, `Drop` |
| `m03-mutability` | Mutability issues | E0596, E0499, E0502, `cannot borrow as mutable`, `already borrowed as immutable`, `mut`, `&mut`, interior mutability, `Cell`, `RefCell`, `Mutex`, `RwLock` |
| `m04-zero-cost` | Generics, traits, zero-cost abstraction | E0277, E0308, E0599, generic, trait, `impl`, `dyn`, `where`, monomorphization, static dispatch, dynamic dispatch |
| `m05-type-driven` | Type-driven design | type state, `PhantomData`, newtype, marker trait, builder pattern, make invalid states unrepresentable, compile-time validation, sealed trait, ZST |
| `m06-error-handling` | Error handling | `Result`, `Option`, `Error`, `?`, `unwrap`, `expect`, `panic`, `anyhow`, `thiserror`, custom error |
| `m07-concurrency` | Concurrency and async | E0277 Send/Sync, thread, spawn, channel, `mpsc`, `Mutex`, `RwLock`, `Atomic`, `async`, `await`, `Future`, `tokio`, deadlock |
| `m09-domain` | Domain modeling | domain model, DDD, entity, value object, aggregate, repository pattern, business rules, validation, invariant |
| `m10-performance` | Performance optimization | performance, optimization, benchmark, profiling, flamegraph, criterion, slow, fast, allocation, cache, SIMD |
| `m11-ecosystem` | Crate and ecosystem questions | crate, cargo, dependency, feature flag, workspace, crate recommendation, `Cargo.toml`, `PyO3`, wasm, bindgen |
| `m12-lifecycle` | Resource lifecycle design | RAII, `Drop`, resource lifecycle, connection pool, lazy initialization, `OnceCell`, `OnceLock`, cleanup, scope guard |
| `m13-domain-error` | Domain error handling design | domain error, error categorization, recovery strategy, retry, fallback, circuit breaker, graceful degradation |
| `m14-mental-model` | Learning Rust concepts | mental model, how to think about ownership, understanding borrow checker, visualizing memory layout, analogy, explain like I'm, coming from Java/Python |
| `m15-anti-pattern` | Code review for anti-patterns | anti-pattern, common mistake, pitfall, code smell, bad practice, code review, idiomatic way, clone everywhere, unwrap in production |

### Rust Tooling

| Skill | Trigger | Key Signals |
|---|---|---|
| `rust-router` | **ALL Rust questions** (highest priority) | Any Rust question including errors, design, coding, comparisons, best practices |
| `coding-guidelines` | Rust code style and best practices | naming, formatting, clippy, rustfmt, lint, code style, naming convention |
| `rust-learner` | Rust version and crate info | latest version, changelog, Rust 1.x, crate info, crates.io, docs.rs, `cargo add` |
| `rust-daily` | Rust news and reports | Rust news, daily report, weekly report, monthly report, what's new in Rust |
| `rust-skill-creator` | Creating new skills for crates/stdlib | create skill, document crate, skill for, stdlib documentation |
| `unsafe-checker` | Unsafe Rust and FFI review | `unsafe`, raw pointer, FFI, `extern`, `transmute`, `*mut`, `*const`, `union`, `#[repr(C)]`, `libc`, `MaybeUninit` |

### Rust LSP

| Skill | Trigger | Key Signals |
|---|---|---|
| `rust-symbol-analyzer` | Analyze project structure via LSP | `/symbols`, project structure, list structs/traits/functions |
| `rust-trait-explorer` | Explore trait implementations | `/trait-impl`, find implementations, who implements |
| `rust-code-navigator` | Navigate code via LSP | `/navigate`, go to definition, find references |
| `rust-call-graph` | Visualize call graphs | `/call-graph`, call hierarchy, who calls |
| `rust-deps-visualizer` | Visualize dependencies | `/deps-viz`, dependency graph |
| `rust-refactor-helper` | Safe refactoring | `/refactor`, rename symbol, move function, extract |

### Domain

| Skill | Trigger | Key Signals |
|---|---|---|
| `domain-web` | Web services | axum, actix, warp, HTTP, REST, GraphQL, WebSocket |
| `domain-cli` | CLI tools | clap, TUI, ratatui, argument parsing |
| `domain-cloud-native` | Cloud-native apps | kubernetes, gRPC, tonic, microservice, observability |
| `domain-embedded` | Embedded / no_std Rust | microcontroller, HAL, RTIC, embassy, GPIO |
| `domain-fintech` | Fintech apps | trading, decimal, currency, financial, ledger, payment |
| `domain-iot` | IoT apps | sensor, MQTT, edge computing, telemetry, smart home |
| `domain-ml` | ML/AI apps in Rust | tensor, model, inference, ndarray, burn, candle |

### Tooling

| Skill | Trigger | Key Signals |
|---|---|---|
| `diecut-new` | Generate project from diecut template | new project, scaffold, generate from template, diecut |
| `diecut-create-template` | Create new diecut templates | create template, new template, diecut template |
| `writing-prs` | Writing pull request titles/descriptions | PR, pull request, PR title, PR description |

### Meta / Core

| Skill | Trigger | Key Signals |
|---|---|---|
| `meta-cognition-parallel` | Three-layer parallel meta-cognition | `/meta-parallel`, deep analysis, meta-cognition |
| `core-actionbook` | *(internal)* | Automatically used by plugin infrastructure |
| `core-agent-browser` | *(internal)* | Automatically used by plugin infrastructure |
| `core-dynamic-skills` | *(internal)* | Automatically used by plugin infrastructure |
| `core-fix-skill-docs` | *(internal)* | Automatically used by plugin infrastructure |

## User Instructions

If the user has provided additional instructions (via CLAUDE.md, project settings, or inline directives), those instructions take precedence over skill defaults. However, you must still invoke the matching skill first -- user instructions may refine or override the skill's output, but the skill provides the foundation.

When in doubt: **invoke the skill first, then apply user instructions on top.**
