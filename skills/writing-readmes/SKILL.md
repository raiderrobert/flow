---
name: writing-readmes
description: "Use when writing, rewriting, reviewing, or improving a project README. Ensures READMEs follow a proven structure: title, tagline, features, install, quick start, docs, license. Triggers: write readme, improve readme, readme review, project readme, readme template, readme structure, new repo readme, readme audit."
---

# Writing READMEs

## Overview

A README answers three questions in order: **what is this**, **how do I get it**, **how do I use it**. Everything else is optional. The structure below is extracted from high-quality open source READMEs across project sizes.

## Routing

| Topic | Reference |
|-------|-----------|
| Section-by-section structure and rules | [structure.md](structure.md) |
| Calibration examples (small tool vs. large project) | [examples.md](examples.md) |

## Quick Reference

**Required sections, in order:**

1. **Title** — `# project-name` (matches the package/binary name)
2. **Tagline** — one sentence, no jargon, says what it does
3. **Feature bullets** — bold lead word, dash, short explanation
4. **Install** — simplest method first, then alternatives
5. **Quick Start** — the single most common use case, real commands
6. **License** — one line with link

**Optional sections (add only when they earn their place):**

- Documentation link (when external docs exist)
- Commands/Usage reference (when >3 commands)
- Contributing (link to CONTRIBUTING.md)
- Acknowledgements (when built on others' work)
- FAQ (when users repeatedly ask the same questions)
- Badges (when the project has CI, versioning, community channels)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Long preamble before install/usage | Lead with tagline + feature bullets, not backstory |
| Feature list without bold lead words | `**Fast.** 10x faster than X` not `It is 10x faster than X` |
| Install section buried below fold | Install comes right after feature bullets |
| Pseudo-code instead of real commands | Show actual `cargo install`, `pip install`, `curl` commands |
| Multiple install methods without hierarchy | Simplest/fastest method first, alternatives below |
| Quick Start that requires configuration | Show the zero-config happy path first |
| README is the full documentation | 600+ line README with every flag inline — link to docs site, README is a landing page |
| Missing license section | Always include — even if just `[MIT](LICENSE)` |
| Explaining what the ecosystem is | Don't explain Python, Rust, Git — say what YOUR tool does |
| Non-product content above the fold | Banners, pitches, and sponsorship blocks before Quick Start |
| Jargon-dense abstract tagline | "Multi-provider interoperable interfaces" — visitor can't tell what it does in 5 seconds |
| Monorepo root that hides the product | "Looking for X? See packages/X" blockquote — lead with what the project is famous for |
| Philosophy section in README | Design rationale belongs in a blog post or `docs/philosophy.md` |
| No install section for a library | Even if obvious, `cargo add X` / `pip install X` should be copy-pasteable |
| Prose paragraphs before code example | Show what it looks like first, explain after |
