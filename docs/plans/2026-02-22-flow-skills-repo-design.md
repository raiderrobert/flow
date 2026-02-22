# Flow Skills Repo Design

## Overview

A Claude Code plugin called `flow` that packages 41 existing skills from `~/.claude/skills/` into a distributable plugin repo with multi-platform packaging support.

## Repository Structure

```
flow/
├── .claude-plugin/
│   ├── plugin.json              # Plugin metadata
│   └── marketplace.json         # Self-hosted dev marketplace
├── .cursor-plugin/
│   └── README.md                # Cursor setup instructions
├── .codex/
│   └── README.md                # Codex setup instructions
├── .opencode/
│   └── README.md                # OpenCode setup instructions
├── skills/
│   ├── using-flow/SKILL.md      # Bootstrapper (injected on session start)
│   ├── coding-guidelines/       # Migrated with supporting files
│   ├── m01-ownership/           # Migrated with examples/, patterns/, etc.
│   ├── ... (41 skills total, flat layout)
│   └── writing-prs/SKILL.md
├── agents/                      # Subagent definitions (initially empty)
├── commands/                    # Slash commands (initially empty)
├── hooks/
│   ├── hooks.json               # SessionStart hook config
│   ├── session-start            # Injects using-flow on startup
│   └── run-hook.cmd             # Windows compat wrapper
├── docs/
│   └── plans/
├── tests/                       # Skill validation (future)
├── README.md
├── LICENSE                      # MIT
├── .gitignore
└── .gitattributes
```

## Plugin Configuration

### .claude-plugin/plugin.json

```json
{
  "name": "flow",
  "description": "Rust skills, domain expertise, and development workflows for Claude Code",
  "version": "0.1.0",
  "author": {
    "name": "raiderrobert"
  },
  "homepage": "https://github.com/raiderrobert/flow",
  "repository": "https://github.com/raiderrobert/flow",
  "license": "MIT",
  "keywords": ["skills", "rust", "domain", "workflows", "diecut"]
}
```

### .claude-plugin/marketplace.json

```json
{
  "name": "flow-dev",
  "description": "Development marketplace for flow skills",
  "owner": {
    "name": "raiderrobert"
  },
  "plugins": [
    {
      "name": "flow",
      "description": "Rust skills, domain expertise, and development workflows for Claude Code",
      "version": "0.1.0",
      "source": "./"
    }
  ]
}
```

### hooks/hooks.json

SessionStart hook that runs the `session-start` script on startup, resume, clear, and compact events. The script reads `skills/using-flow/SKILL.md` and injects it as additional session context.

## Migration Strategy

### Direct copies (no modifications)

All 41 skills with a SKILL.md copied as-is from `~/.claude/skills/`, preserving supporting files:

- coding-guidelines (SKILL.md, clippy-lints, index)
- core-actionbook, core-agent-browser, core-dynamic-skills, core-fix-skill-docs
- diecut-create-template, diecut-new
- domain-cli, domain-cloud-native, domain-embedded, domain-fintech, domain-iot, domain-ml, domain-web
- m01-ownership (SKILL.md, comparison.md, examples/, patterns/)
- m02-resource, m03-mutability, m04-zero-cost, m05-type-driven
- m06-error-handling (SKILL.md, examples/, patterns/)
- m07-concurrency (SKILL.md, comparison.md, examples/, patterns/)
- m09-domain, m10-performance (SKILL.md, patterns/), m11-ecosystem, m12-lifecycle, m13-domain-error
- m14-mental-model (SKILL.md, patterns/), m15-anti-pattern (SKILL.md, patterns/)
- meta-cognition-parallel
- rust-call-graph, rust-code-navigator, rust-daily, rust-deps-visualizer, rust-learner
- rust-refactor-helper, rust-router (SKILL.md, examples/, integrations/, patterns/)
- rust-skill-creator, rust-symbol-analyzer, rust-trait-explorer
- unsafe-checker (AGENTS.md, SKILL.md, checklists/, examples/, metadata.json, rules/)
- writing-prs

### Dropped

- `diecut/` — empty directory, no SKILL.md

### New content to create

- `skills/using-flow/SKILL.md` — bootstrapper skill listing all 41 skills with trigger conditions
- Plugin scaffolding (plugin.json, marketplace.json)
- Session-start hook (hooks.json, session-start script, run-hook.cmd)
- Platform stubs (.cursor-plugin, .codex, .opencode READMEs)
- Repo files (README.md, LICENSE, .gitignore, .gitattributes)

## Decisions

- Flat skills directory (no categorized subdirs)
- Claude Code plugin as primary target, multi-platform stubs for future
- GitHub: https://github.com/raiderrobert/flow
- MIT license
