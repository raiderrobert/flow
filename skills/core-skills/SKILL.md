---
name: core-skills
# Internal tool - no description to prevent auto-triggering
# Triggered by: /sync-crate-skills, /clean-crate-skills, /update-crate-skill, /fix-skill-docs, skill creation requests
argument-hint: "[--force] | <crate_name>"
context: fork
agent: general-purpose
---

# Skill Management

Unified skill for creating, syncing, fixing, and maintaining dynamic skills.

## Capabilities

| Command | Purpose |
|---------|---------|
| `/sync-crate-skills` | Sync all project dependencies to skills |
| `/clean-crate-skills [crate]` | Remove generated skills |
| `/update-crate-skill <crate>` | Update specific skill |
| `/fix-skill-docs [crate] [--check-only]` | Check and fix missing reference files |
| Create skill for `<crate>` | Generate skill from crate/std docs |

---

## Dynamic Skills Sync

Orchestrates on-demand generation of crate-specific skills based on project dependencies.

### Concept

Dynamic skills are:
- Generated locally at `~/.claude/skills/`
- Based on Cargo.toml dependencies
- Created using llms.txt from docs.rs
- Versioned and updatable
- Not committed to the rust-skills repository

### Execution Mode Detection

**CRITICAL: Check if agent and command infrastructure is available.**

Try to read: `../../agents/` directory
Check if `/create-llms-for-skills` and `/create-skills-via-llms` commands work.

### Agent Mode (Plugin Install)

**When full plugin infrastructure is available:**

```
Cargo.toml
    |
Parse dependencies
    |
For each crate:
  - Check ~/.claude/skills/{crate}/
  - If missing: Check actionbook for llms.txt
      - Found: /create-skills-via-llms
      - Not found: /create-llms-for-skills first
  - Load skill
```

#### Workflow Priority

1. **actionbook MCP** - Check for pre-generated llms.txt
2. **/create-llms-for-skills** - Generate llms.txt from docs.rs
3. **/create-skills-via-llms** - Create skills from llms.txt

### Inline Mode (Skills-only Install)

**When agent/command infrastructure is NOT available, execute manually:**

#### Step 1: Parse Cargo.toml

Read Cargo.toml and extract `[dependencies]`, `[dev-dependencies]`, and workspace members.

#### Step 2: Check Existing Skills

```bash
ls ~/.claude/skills/
```

#### Step 3: Generate Missing Skills

For each missing crate, fetch documentation and create skill:

```bash
# 1. Fetch crate documentation
agent-browser open "https://docs.rs/{crate}/latest/{crate}/"
agent-browser get text ".docblock"

# 2. Create skill directory
mkdir -p ~/.claude/skills/{crate}/references

# 3. Create SKILL.md using template below
# 4. Create reference files for key modules
agent-browser close
```

**WebFetch fallback:**
```
WebFetch("https://docs.rs/{crate}/latest/{crate}/", "Extract API documentation overview, key types, and usage examples")
```

---

## Skill Creation

Create skills for Rust crates and std library documentation.

### URL Construction

| Target | URL Template |
|--------|--------------|
| Crate overview | `https://docs.rs/{crate}/latest/{crate}/` |
| Crate module | `https://docs.rs/{crate}/latest/{crate}/{module}/` |
| Std trait | `https://doc.rust-lang.org/std/{module}/trait.{Name}.html` |
| Std struct | `https://doc.rust-lang.org/std/{module}/struct.{Name}.html` |
| Std module | `https://doc.rust-lang.org/std/{module}/index.html` |

### Common Std Library Paths

| Item | Path |
|------|------|
| Send, Sync, Copy, Clone | `std/marker/trait.{Name}.html` |
| Arc, Mutex, RwLock | `std/sync/struct.{Name}.html` |
| Rc, Weak | `std/rc/struct.{Name}.html` |
| RefCell, Cell | `std/cell/struct.{Name}.html` |
| Box | `std/boxed/struct.Box.html` |
| Vec | `std/vec/struct.Vec.html` |
| String | `std/string/struct.String.html` |
| Option | `std/option/enum.Option.html` |
| Result | `std/result/enum.Result.html` |

### SKILL.md Template

```markdown
---
name: {crate_name}
description: "Documentation for {crate_name} crate. Keywords: {keywords}"
---

# {Crate Name}

> **Version:** {version} | **Source:** docs.rs

## Overview
{Brief description from documentation}

## Key Types
### {Type1}
{Description and usage}

## Common Patterns
{Usage patterns extracted from documentation}

## Examples
(code examples from documentation)

## Documentation
- `./references/overview.md` - Main overview
- `./references/{module}.md` - Module documentation

## Links
- [docs.rs](https://docs.rs/{crate})
- [crates.io](https://crates.io/crates/{crate})
```

---

## Fix Skill Docs

Check and fix missing reference files in dynamic skills.

### Usage

```
/fix-skill-docs [crate_name] [--check-only] [--remove-invalid]
```

### Workflow

1. Scan `~/.claude/skills/` for skill directories
2. Parse each SKILL.md for referenced files (`./references/*.md`)
3. Check if referenced files exist
4. Report status
5. Fix missing files by fetching from docs.rs (or remove invalid refs with `--remove-invalid`)

### Report Format

```
=== {crate_name} ===
SKILL.md: OK
references/:
  - sync.md: OK
  - runtime.md: MISSING

Action needed: 1 file missing
```

---

## Tool Chain Priority

Both modes use the same tool chain order:

1. **actionbook MCP** - Get pre-computed selectors first
2. **agent-browser CLI** - Primary execution tool
3. **WebFetch** - Last resort only if agent-browser unavailable

## Local Skills Directory

```
~/.claude/skills/
  tokio/
    SKILL.md
    references/
  serde/
    SKILL.md
    references/
  axum/
    SKILL.md
    references/
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Commands not found | Skills-only install | Use inline mode |
| Cargo.toml not found | Not in Rust project | Navigate to project root |
| docs.rs unavailable | Network issue | Retry or skip crate |
| Permission denied | Directory issue | Check ~/.claude/skills/ permissions |
| Skills directory empty | No skills installed | Run /sync-crate-skills first |
| Invalid SKILL.md format | Corrupted skill | Re-generate skill |

## DO NOT

- Guess documentation URLs without verification
- Skip documentation fetching step
- Use WebSearch for Rust crate info
