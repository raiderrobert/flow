# README Examples

Calibration examples across project sizes, plus real-world counter-examples. Match the density and tone, not the specific content.

## Small CLI Tool (~80 lines)

Based on [raiderrobert/graft](https://github.com/raiderrobert/graft).

```markdown
# graft

A "package manager" for paths, both files and dirs.

- **Pin files, not packages.** Pull a Makefile, a CI workflow, or a linter config from any GitHub repo and lock it to a version.
- **Edit freely, upgrade safely.** Your local changes are preserved through three-way merge on upgrade.
- **No registry, no publishing.** Tag your source repo. Any file in any GitHub repo is a valid dependency.
- **CI-ready.** `graft check` exits non-zero if anything is modified or stale.

## Install

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/raiderrobert/graft/main/install.sh | sh
\`\`\`

Or build from source:

\`\`\`bash
cargo install --path .
\`\`\`

Or grab a binary from [GitHub Releases](https://github.com/raiderrobert/graft/releases).

## Quick Start

\`\`\`bash
graft add gh:raiderrobert/graft/justfile@v0.1.0
\`\`\`

That's it. Graft fetches the file, writes it to `justfile` (matching the source path), and records it in `graft.toml`:

\`\`\`toml
[deps.justfile]
source = "gh:raiderrobert/graft/justfile"
version = "v0.1.0"
dest = "justfile"
\`\`\`

Later, check for updates and upgrade:

\`\`\`bash
graft outdated        # see what's newer
graft upgrade         # pull updates, three-way merge if you've edited locally
\`\`\`

## Commands

\`\`\`
graft init                  Create graft.toml
graft add <src@ver> [dest]  Fetch and track a file
graft sync                  Fetch all dependencies
graft list                  Show grafts with status
graft check                 Verify all clean (for CI)
graft outdated              Show newer upstream versions
graft upgrade [name]        Upgrade with three-way merge
graft remove <name>         Stop tracking (keeps file)
\`\`\`

## License

[PolyForm Shield 1.0.0](LICENSE)
```

**What to notice:**
- 4 feature bullets, all with bold lead + short explanation
- Install shortest-first (curl, cargo, binary)
- Quick Start is ONE command, then shows what happened
- Commands section is a compact aligned block, not one heading per command
- No backstory, no "Welcome to", no emoji

## Small Tool with DSL (~90 lines)

Based on [captainsafia/hone](https://github.com/captainsafia/hone).

```markdown
# Hone

A CLI integration test runner for command-line applications, inspired by Hurl.

Write tests in a simple, line-oriented DSL that executes real shell commands and asserts on output, exit codes, file contents, and timing.

- **Simple, readable test syntax**
- **Real shell execution** with persistent state
- **Rich assertions** for stdout, stderr, exit codes, files, and timing
- **Built-in Language Server (LSP)** for editor integration
- **Single binary** with no runtime dependencies

## Quick Example

\`\`\`
TEST "echo works"

RUN echo "Hello, World!"
ASSERT exit_code == 0
ASSERT stdout contains "Hello"
\`\`\`

\`\`\`sh
hone run example.hone
\`\`\`

## Install

\`\`\`sh
curl https://i.safia.sh/captainsafia/hone/preview | sh
\`\`\`

## Documentation

**[hone.safia.dev](https://hone.safia.dev)** — Getting started, DSL reference, examples.

## License

MIT
```

**What to notice:**
- Tagline is two sentences: what it is + what it does (acceptable when the second sentence shows what the experience looks like)
- Feature bullets use bold lead but no trailing explanation when the phrase is self-explanatory
- Quick Example before Install — when the DSL IS the product, showing it first is the right call
- Docs link is one bold line, not a bulleted list — proportional to project size
- Entire README is ~50 lines — doesn't try to be more than it needs to be

## Library with Docs Site (~70 lines)

Based on [mitsuhiko/insta](https://github.com/mitsuhiko/insta).

```markdown
# insta

A snapshot testing library for Rust.

## Introduction

Snapshot tests (also called approval tests) assert values against a
reference value (the snapshot). Unlike `assert_eq!`, snapshot tests
let you test against complex values and come with tools to review changes.

## Example

\`\`\`rust
#[test]
fn test_hello_world() {
    insta::assert_debug_snapshot!(vec![1, 2, 3]);
}
\`\`\`

Watch the [5 minute introduction](https://insta.rs/docs/quickstart/)
or the [screencast](https://www.youtube.com/watch?v=rCHrMqE4JOY).

## Install

\`\`\`bash
cargo add insta
\`\`\`

## Editor Support

VSCode extension for syntax highlighting, snapshot review, and more:
[view on marketplace](https://marketplace.visualstudio.com/items?itemName=mitsuhiko.insta).

## Documentation

- [Project Website](https://insta.rs/)
- [API Docs](https://docs.rs/insta/)

## License

[Apache-2.0](LICENSE)
```

**What to notice:**
- Tagline is 7 words — no qualifiers, no implementation language (it's implied by the ecosystem)
- "Introduction" is 2 sentences explaining the *concept* for people who haven't used snapshot testing
- Code example is 5 lines — the minimum to show what using the library looks like
- Screencast and quickstart linked, not embedded — README stays short
- Editor support section is a differentiator worth showing; it's not generic fluff
- The README is a gateway to [insta.rs](https://insta.rs/), not a replacement for it

## Collection / Catalog README (~60 lines)

Based on [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff).

```markdown
# Agent Stuff

Skills and extensions that I use across projects.

Released on npm as `mitsupi` for use with the Pi package loader.

## Skills

All skills live in the `skills` folder:

* [`/commit`](skills/commit) - Create git commits using Conventional Commits-style subjects.
* [`/github`](skills/github) - Interact with GitHub using the `gh` CLI (issues, PRs, runs, APIs).
* [`/sentry`](skills/sentry) - Fetch and analyze Sentry issues, events, and logs.
* [`/tmux`](skills/tmux) - Drive tmux sessions via keystrokes and pane output scraping.
* [`/web-browser`](skills/web-browser) - Browser automation via Chrome/Chromium CDP.

## Extensions

* [`answer.ts`](extensions/answer.ts) - Interactive TUI for answering questions.
* [`notify.ts`](extensions/notify.ts) - Desktop notifications when the agent finishes.
* [`review.ts`](extensions/review.ts) - Code review command with optional fix loop.
```

**What to notice:**
- This isn't a tool — it's a curated collection. The README is a catalog, not a landing page.
- One-line description, then straight into organized lists
- Each item: link + dash + one-line description. Scannable, consistent.
- No install instructions because the tagline already says how (`npm as mitsupi`)
- No feature bullets — the catalog IS the feature list
- Works because it's honest about what it is: a personal dotfiles-style repo, not a product

## Medium-Large Project (~200 lines)

Based on [astral-sh/uv](https://github.com/astral-sh/uv).

```markdown
# uv

An extremely fast Python package and project manager, written in Rust.

## Highlights

- A single tool to replace `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more.
- [10-100x faster](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md) than `pip`.
- Provides comprehensive project management, with a universal lockfile.
- Runs scripts, with support for inline dependency metadata.
- Installs and manages Python versions.
- Supports macOS, Linux, and Windows.

## Installation

\`\`\`bash
# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh
\`\`\`

\`\`\`bash
# On Windows.
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
\`\`\`

Or, from PyPI:

\`\`\`bash
pip install uv
\`\`\`

## Documentation

uv's documentation is available at [docs.astral.sh/uv](https://docs.astral.sh/uv).

## Features

### Projects

uv manages project dependencies and environments:

\`\`\`console
$ uv init example
Initialized project `example` at `/home/user/example`

$ cd example

$ uv add ruff
Creating virtual environment at: .venv
Resolved 2 packages in 170ms
Installed 2 packages in 1ms

$ uv run ruff check
All checks passed!
\`\`\`

See the [project documentation](https://docs.astral.sh/uv/guides/projects/) to get started.

### Scripts

uv manages dependencies and environments for single-file scripts.

\`\`\`console
$ uv run example.py
Reading inline script metadata from: example.py
Installed 5 packages in 12ms
<Response [200]>
\`\`\`

See the [scripts documentation](https://docs.astral.sh/uv/guides/scripts/) to get started.

## Contributing

See the [contributing guide](https://github.com/astral-sh/uv/CONTRIBUTING.md) to get started.

## License

[MIT](LICENSE-MIT) / [Apache-2.0](LICENSE-APACHE)
```

**What to notice:**
- Tagline names the speed differentiator and the implementation language
- Highlights names what it replaces (pip, poetry, etc.) — the comparison IS the value prop
- Docs link comes early, before detailed features
- Feature sections show real `console` output, not pseudo-code
- Each feature section ends with a docs link ("See the X documentation to get started")
- README doesn't try to be the full docs — it's a landing page with curated examples

---

## Counter-Examples: Real Problems

These are patterns from real projects, showing specific structural mistakes.

### Problem: Abstract Spec-Speak Instead of a Tagline

From [openresponses/openresponses](https://github.com/openresponses/openresponses):

> Open Responses is an open-source specification for multi-provider, interoperable LLM interfaces inspired by the OpenAI Responses API. It defines a shared request/response model, streaming semantics, and tool invocation patterns so clients and providers can exchange structured inputs and outputs in a consistent shape.

**What's wrong:**
- The first paragraph is 2 dense sentences of jargon — "multi-provider, interoperable LLM interfaces", "streaming semantics", "tool invocation patterns"
- A visitor can't tell in 5 seconds what this project actually does for them
- No install, no quick start — jumps to "What's in this repo" (file listing) and compliance testing
- The entire README is about the spec and testing the spec, not about using it

**Fix:** One-sentence tagline ("A spec for building LLM clients that work with any provider"), then show a concrete before/after or usage example.

### Problem: README as Full Documentation (~600 lines)

From [badlogic/pi-mono/packages/coding-agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent):

**What's wrong:**
- The README IS the documentation — every feature, every flag, every keyboard shortcut, every environment variable is inline
- Non-product content above the fold: OSS weekend banner, domain donation acknowledgement, and a "Share your sessions" pitch all appear before Quick Start
- Table of Contents with 30+ entries before any useful content
- Philosophy section mid-README explaining design decisions ("No MCP", "No sub-agents", "No plan mode")
- CLI Reference section alone is ~150 lines of tables
- At ~600 lines, a new user has to scroll past dozens of sections to find what they need

**Fix:** Move the full reference to a docs site or `docs/` directory. The README should be a landing page: tagline, 5-8 feature bullets, install, quick start, docs link, license. Philosophy belongs in a blog post or `docs/philosophy.md`. Banner and promotional content should not displace the product pitch.

### Problem: Monorepo README That Buries the Product

From [badlogic/pi-mono](https://github.com/badlogic/pi-mono) (root):

**What's wrong:**
- The actual product (the coding agent) is buried in a blockquote: "> Looking for the pi coding agent? See packages/coding-agent"
- Before that: OSS weekend banner, logo, badges, domain donation block
- "Share your OSS sessions" pitch with multiple links comes before the package table
- Tagline is generic: "Tools for building AI agents and managing LLM deployments" — could describe dozens of projects
- A visitor landing on the GitHub page has no idea what this project actually does until they click through to a subdirectory

**Fix:** Lead with what the project is famous for. If one package is the main attraction, the root README should make that obvious in the first 3 lines, not hide it in a blockquote below promotional content.

### Problem: Prose-Heavy README with No Install Section

From [mitsuhiko/minijinja](https://github.com/mitsuhiko/minijinja):

**What's wrong:**
- Three dense paragraphs of prose explanation before any code example — buries the lede
- Shows `cargo tree` output (dependency tree) as a selling point instead of showing how to use it
- "Goals" section is a 14-item bullet list mixing genuine features ("minimal dependencies"), links to docs, and boilerplate ("well tested", "well documented") — unscannable, no bold leads
- No Install section at all — `cargo add minijinja` never appears
- Code example is buried below the goals list
- "Use Cases and Users" section is a massive wall of links that belongs on a website, not a README
- "AI Use Disclaimer" and "Sponsor" sections before docs/license links
- Documentation links buried at the very bottom after sponsor and AI sections

**Fix:** Tagline → 5-6 feature bullets with bold leads → `cargo add minijinja` → code example → docs link. Move the users/use-cases showcase to the project website. Cut the goals list to the 5 that actually differentiate.

### Composite Anti-Pattern Checklist

| Pattern | Why It Fails | Where Seen |
|---------|-------------|------------|
| Jargon-dense tagline | Visitor can't tell what it does in 5 seconds | openresponses |
| No install / no quick start | Reader can't try it | openresponses, minijinja |
| "What's in this repo" as features | File listing ≠ value proposition | openresponses |
| Non-product content above the fold | Banners, pitches, and donations displace the product | pi-mono, pi coding-agent |
| README as full documentation | 600+ lines, every flag inline, no docs site | pi coding-agent |
| Philosophy section in README | Design rationale ≠ user documentation | pi coding-agent |
| TOC with 30+ entries | Signal that the README is too long | pi coding-agent |
| Monorepo root that hides the product | Main package buried under promotional content | pi-mono |
| Blockquote redirect to subdirectory | If you need this, the README isn't doing its job | pi-mono |
| Prose paragraphs before code | 3 paragraphs of explanation before showing what it looks like | minijinja |
| Giant goals/features list (14+ items) | Unscannable, mixes boilerplate with real differentiators | minijinja |
| No install section for a library | The single most common action (add the dependency) is never shown | minijinja |
| Users/showcase section in README | Belongs on the project website, not the README | minijinja |
