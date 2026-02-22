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

1. **rust** -- for ANY Rust question (ownership, traits, errors, async, design, style)
2. **Domain-specific skills** -- if the question is clearly about a specific domain (web, CLI, embedded, etc.)
3. **Tooling skills** -- for project tooling and workflow questions
4. **Meta skills** -- for analysis and meta-cognitive tasks

## Skill Types

| Type | Description | Examples |
|---|---|---|
| **Core Rust** | Comprehensive Rust guidance | `rust` |
| **Domain** | Domain-specific Rust patterns and crates | `domain-web`, `domain-cli` |
| **LSP** | Code analysis using LSP capabilities | `rust-symbol-analyzer`, `rust-call-graph` |
| **Tooling** | Project tooling and workflow | `diecut-new`, `writing-prs` |
| **Meta** | Analysis and cognitive frameworks | `meta-cognition-parallel` |
| **Core** | Internal plugin infrastructure | `core-actionbook`, `core-dynamic-skills` |

## Available Skills (27 total)

### Rust Core

| Skill | Trigger | Key Signals |
|---|---|---|
| `rust` | **ALL Rust questions** (highest priority) | Any Rust question: ownership, borrowing, lifetimes, traits, generics, error handling, async, concurrency, Send/Sync, smart pointers, type-driven design, domain modeling, performance, ecosystem, anti-patterns, code style, mental models. All E0xxx compiler errors. |

### Rust Tooling

| Skill | Trigger | Key Signals |
|---|---|---|
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
