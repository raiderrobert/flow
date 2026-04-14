# README Structure Reference

Section-by-section rules for writing READMEs. Each section includes what to include, what to avoid, and how to calibrate length to project size.

## 1. Title

```markdown
# project-name
```

- Use the actual package/binary/crate name, not a marketing name
- Match the case users type to install it (`uv` not `UV`, `ruff` not `Ruff` in the H1)
- Optional: centered logo image above the H1 for projects with branding
- Optional: badge row (CI status, version, license, Discord) immediately after H1

**Skip:** Subtitle H2s, "Welcome to..." phrasing, version numbers in the title.

## 2. Tagline

One or two sentences immediately after the title. Plain text, no markup.

**Formula:** `A [qualifier] [thing-type] for [domain/task].`

```markdown
An extremely fast Python package and project manager, written in Rust.
```

```markdown
A project template generator, written in Rust.
```

```markdown
Find out who owns what across your GitHub org.
```

The tagline is the single most important line. It appears in GitHub search results, social previews, and link unfurls. Optimize for skimming.

**Rules:**
- One sentence preferred; a second sentence is fine when it shows what the experience looks like
- No jargon the target audience wouldn't immediately understand
- Name what it replaces or competes with only if the comparison is the primary value prop ("A drop-in replacement for X")
- If the tool is notably fast or small, say so here — this is the one place superlatives earn their keep

**Skip:** "Welcome to project-name!", rhetorical questions, emoji, jargon-dense abstractions.

### Good Taglines

| Tagline | Why It Works |
|---------|--------------|
| A snapshot testing library for Rust. | 7 words. Names the technique, the domain, and the ecosystem. |
| An extremely fast Python linter and code formatter, written in Rust. | Leads with the differentiator (speed). Names what it replaces implicitly (linter + formatter). |
| Find out who owns what across your GitHub org. | Action-oriented — tells you what YOU do with it, not what it is. |
| A "package manager" for paths, both files and dirs. | Quotes around "package manager" signal analogy. Immediately concrete. |
| A CLI integration test runner for command-line applications, inspired by Hurl. | Names the category, the target (CLI apps), and the inspiration for people who know Hurl. |
| Skills and extensions that I use across projects. | Honest and unpretentious — right tone for a personal collection repo. |

### Bad Taglines

| Tagline | What's Wrong | Fix |
|---------|-------------|-----|
| An open-source specification for multi-provider, interoperable LLM interfaces inspired by the OpenAI Responses API. | Jargon-dense. "multi-provider, interoperable LLM interfaces" means nothing to a skimmer. | A spec for building LLM clients that work with any provider. |
| Tools for building AI agents and managing LLM deployments. | So generic it could describe 50 projects. No differentiator. | A terminal coding agent with extensible tools, skills, and themes. |
| A powerful but minimal dependency template engine which is based on the syntax and behavior of the Jinja2 template engine for Python. | 25 words. Buries the key fact (Jinja2-compatible) in a relative clause. "powerful but minimal" is a contradiction that says nothing. | A Jinja2-compatible template engine for Rust with minimal dependencies. |
| Welcome to ProjectName! We're so excited to share this with you. ProjectName is a next-generation framework for... | "Welcome" wastes the most valuable line. "Next-generation" is meaningless. Excitement is not a feature. | Cut entirely. Start with what it does. |
| The Swiss Army knife of X. | Cliché. Every multi-feature tool claims this. Tells you nothing specific. | Name the 2-3 things it actually does. |

## 3. Feature Bullets

An unordered list of 4–10 differentiating features. Each item uses the **bold lead word** pattern:

```markdown
- **Single binary.** No runtime dependencies. Download one file and go.
- **Fast.** 10-100x faster than existing tools.
- **Easy to make.** A config file and a folder, and that's it.
```

**Rules:**
- Bold the first word or short phrase (the scannable hook)
- Follow with a plain-text explanation (one sentence, two max)
- Lead with the strongest differentiator
- Include concrete numbers when possible ("10-100x faster", "800+ built-in rules")
- If a feature replaces known tools, name them ("replaces pip, pipx, poetry")

**Variant — self-explanatory bullets:** When the bold phrase is clear enough on its own, the trailing explanation is optional:

```markdown
- **Simple, readable test syntax**
- **Real shell execution** with persistent state
- **Built-in Language Server (LSP)** for editor integration
```

**Skip:** Generic features everyone expects ("well-tested", "documented"). Features that need a paragraph to explain (put those in a Usage section). Emoji bullets — bold text scans better.

## 4. Install

The first actionable section. Shortest path to a working install first.

```markdown
## Install

\`\`\`bash
curl -fsSL https://example.com/install.sh | sh
\`\`\`

Or with cargo:

\`\`\`bash
cargo install project-name
\`\`\`

Or grab a binary from [GitHub Releases](https://github.com/org/repo/releases).
```

**Rules:**
- Fastest method first (usually `curl | sh` or `pip install`)
- Each method gets its own fenced code block with `bash` language tag
- Include prerequisites only when non-obvious (e.g., "Requires a GitHub token with `read:org` scope")
- For tools that self-update, mention it: `project self-update`
- Link to expanded install docs if >3 methods exist

**For libraries** (crates, PyPI packages, npm modules), the install is usually one command — make it prominent:

```markdown
## Install

\`\`\`bash
cargo add project-name
\`\`\`
```

Do NOT skip the install section for libraries. Even if it's obvious, `cargo add X` / `pip install X` / `npm install X` is the single most common action and should be copy-pasteable.

**Skip:** Build-from-source instructions as the primary method (put them last or in CONTRIBUTING.md). Platform-specific blocks unless the project genuinely differs per platform.

## 5. Quick Start / Quick Example

The single most common use case, shown with real commands and real output.

```markdown
## Quick Start

\`\`\`bash
project-name new gh:org/templates/rust-cli --output my-project
\`\`\`

Project-name prompts you for variables and generates a ready-to-go project.
```

**Rules:**
- Show the zero-config happy path — no flags, no config files, no setup beyond install
- Use `console` or `bash` language tag; show actual terminal output when it aids comprehension
- One primary example. Additional examples follow as secondary blocks.
- Brief explanation between code blocks (one sentence bridging "what you ran" to "what happened")
- If the tool requires auth or setup, show that inline with a brief note, not a separate section

**DSL/format-driven tools:** When the tool's file format IS the product (test runners, config languages, request formats), show a Quick Example of the format *before* Install. The format sells the tool; install is secondary.

```markdown
## Quick Example

\`\`\`
TEST "echo works"

RUN echo "Hello, World!"
ASSERT exit_code == 0
ASSERT stdout contains "Hello"
\`\`\`

\`\`\`sh
tool run example.ext
\`\`\`

## Install
...
```

**Skip:** Edge cases, advanced flags, exhaustive option lists. Those go in a Usage or Commands section.

## 6. Documentation Link (optional)

When external docs exist, link them prominently:

```markdown
## Documentation

Full documentation: **[project.dev](https://project.dev/)**

- [Getting Started](https://project.dev/getting-started/)
- [Configuration](https://project.dev/configuration/)
- [API Reference](https://project.dev/reference/)
```

This section replaces inline documentation. If you have a docs site, the README should NOT try to be the docs — it's the landing page.

## 7. Usage / Commands (optional)

For CLI tools with multiple subcommands, a compact reference:

```markdown
## Commands

\`\`\`
project init                  Create config file
project add <src@ver> [dest]  Fetch and track a file
project sync                  Fetch all dependencies
project check                 Verify all clean (for CI)
\`\`\`
```

**Rules:**
- Compact table or aligned plaintext — NOT a heading per command
- Include the most common flags inline when they change behavior significantly
- Link to full reference docs if available

## 8. Options (optional)

For tools with many flags, a grouped reference block:

```markdown
## Options

\`\`\`
Global:
  --verbose           Increase output detail
  --format <FMT>      table (default), csv, json

Subcommand-specific:
  --limit <N>         Process only first N items
  --sort <ORDER>      name (default), date, size
\`\`\`
```

Group by scope. Show defaults inline.

## 9. Contributing (optional)

One line linking to CONTRIBUTING.md:

```markdown
## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and workflow.
```

For larger projects, mention Discord/community channels here.

## 10. License

Always present. Always last (or near-last, before acknowledgements/sponsors).

```markdown
## License

[MIT](LICENSE)
```

For dual-license projects, name both and link to both files.

## Scaling by Project Size

| Project Size | Sections to Include | README Target Length |
|-------------|--------------------|--------------------|
| Small tool (<5 commands) | Title, tagline, features, install, quick start, license | 50–150 lines |
| Medium tool (5–20 commands) | Above + commands reference, options, contributing | 150–300 lines |
| Large project (docs site exists) | Above + docs link, FAQ, acknowledgements | 200–400 lines |

**The README is a landing page, not a manual.** Large projects should resist putting full documentation in the README. Link out to the docs site early and often.

**Warning signs your README is too long:**
- Table of Contents with 20+ entries
- CLI reference section longer than 100 lines
- Every keyboard shortcut, flag, and environment variable is inline
- Philosophy or design rationale sections (put in blog post or `docs/`)
- Non-product content above the fold (banners, sponsorship pitches, session-sharing requests)

## Monorepo READMEs

When one package is the main attraction, the root README must make that obvious immediately:

```markdown
# project-name

Tagline for the flagship product.

[Quick install + quick start for the flagship product]

## Packages

| Package | Description |
|---------|-------------|
| **[flagship](packages/flagship)** | The main tool |
| [lib-core](packages/core) | Core library |
| [lib-tui](packages/tui) | Terminal UI |
```

Do NOT bury the product in a blockquote ("Looking for X? See packages/X") below promotional content. If someone lands on your GitHub page, the first 5 lines should tell them what this project does and how to use it.

## Collection / Catalog READMEs

For repos that are curated collections (dotfiles, skill packs, example sets), the README is a catalog, not a landing page:

```markdown
# my-collection

One-line description of what this collects.

## Category A

* [`item-one`](path/to/item-one) - One-line description.
* [`item-two`](path/to/item-two) - One-line description.

## Category B

* [`item-three`](path/to/item-three) - One-line description.
```

**Rules:**
- Each item: link + dash + one-line description. Consistent format throughout.
- Group by category, not alphabetically (unless there's only one category)
- No feature bullets — the catalog IS the feature list
- Install only if there's a package manager install path; skip if it's "clone and copy what you want"

## Hero Image (optional)

For projects with a strong visual hook (benchmarks, UI screenshots):

```markdown
<p align="center">
  <img alt="Description" src="path/to/image.png">
</p>
<p align="center">
  <i>Caption explaining what the image shows.</i>
</p>
```

Place between tagline and feature bullets. Use `<picture>` with `<source>` for dark/light mode variants.
