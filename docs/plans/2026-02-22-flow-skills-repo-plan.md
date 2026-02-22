# Flow Skills Repo Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Set up the `flow` Claude Code plugin repo with all scaffolding, hooks, and 41 migrated skills.

**Architecture:** Mirror the superpowers plugin structure — flat `skills/` directory, session-start hook for bootstrapping, multi-platform packaging stubs. Skills are copied as-is from `~/.claude/skills/`.

**Tech Stack:** Bash (file operations), Claude Code plugin system (YAML frontmatter SKILL.md files, hooks.json)

---

### Task 1: Repo scaffolding files

**Files:**
- Create: `.gitignore`
- Create: `.gitattributes`
- Create: `LICENSE`

**Step 1: Create .gitignore**

```
.worktrees/
.private-journal/
.claude/
.DS_Store
```

**Step 2: Create .gitattributes**

```
# Ensure shell scripts always have LF line endings
*.sh text eol=lf
hooks/session-start text eol=lf

# Ensure the polyglot wrapper keeps LF
*.cmd text eol=lf

# Common text files
*.md text eol=lf
*.json text eol=lf

# Explicitly mark binary files
*.png binary
*.jpg binary
*.gif binary
```

**Step 3: Create LICENSE (MIT, 2026, raiderrobert)**

Standard MIT license text with `Copyright (c) 2026 raiderrobert`.

**Step 4: Commit**

```bash
git add .gitignore .gitattributes LICENSE
git commit -m "chore: add repo scaffolding"
```

---

### Task 2: Plugin configuration

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`

**Step 1: Create .claude-plugin/plugin.json**

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

**Step 2: Create .claude-plugin/marketplace.json**

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

**Step 3: Commit**

```bash
git add .claude-plugin/
git commit -m "chore: add Claude Code plugin configuration"
```

---

### Task 3: Session-start hooks

**Files:**
- Create: `hooks/hooks.json`
- Create: `hooks/session-start`
- Create: `hooks/run-hook.cmd`

**Step 1: Create hooks/hooks.json**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "'${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd' session-start",
            "async": false
          }
        ]
      }
    ]
  }
}
```

**Step 2: Create hooks/session-start**

Bash script modeled on superpowers' session-start. Key differences:
- Reads `skills/using-flow/SKILL.md` instead of `using-superpowers`
- Context says "You have flow skills" instead of "You have superpowers"
- References `flow:using-flow` skill
- No legacy directory warning (this is a fresh plugin)

```bash
#!/usr/bin/env bash
# SessionStart hook for flow plugin

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

using_flow_content=$(cat "${PLUGIN_ROOT}/skills/using-flow/SKILL.md" 2>&1 || echo "Error reading using-flow skill")

escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_flow_escaped=$(escape_for_json "$using_flow_content")
session_context="<EXTREMELY_IMPORTANT>\nYou have flow skills.\n\n**Below is the full content of your 'flow:using-flow' skill - your introduction to using flow skills. For all other skills, use the 'Skill' tool:**\n\n${using_flow_escaped}\n</EXTREMELY_IMPORTANT>"

cat <<EOF
{
  "additional_context": "${session_context}",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${session_context}"
  }
}
EOF

exit 0
```

**Step 3: Create hooks/run-hook.cmd**

Copy the superpowers polyglot wrapper verbatim — it's a generic cross-platform bash launcher with no plugin-specific content.

**Step 4: Make session-start executable**

```bash
chmod +x hooks/session-start
```

**Step 5: Commit**

```bash
git add hooks/
git commit -m "feat: add session-start hook for flow bootstrapping"
```

---

### Task 4: Platform stubs

**Files:**
- Create: `.cursor-plugin/plugin.json`
- Create: `.codex/INSTALL.md`
- Create: `.opencode/INSTALL.md`

**Step 1: Create .cursor-plugin/plugin.json**

Same structure as superpowers but with flow metadata:

```json
{
  "name": "flow",
  "displayName": "Flow",
  "description": "Rust skills, domain expertise, and development workflows",
  "version": "0.1.0",
  "author": {
    "name": "raiderrobert"
  },
  "homepage": "https://github.com/raiderrobert/flow",
  "repository": "https://github.com/raiderrobert/flow",
  "license": "MIT",
  "keywords": ["skills", "rust", "domain", "workflows", "diecut"],
  "skills": "./skills/",
  "agents": "./agents/",
  "commands": "./commands/",
  "hooks": "./hooks/hooks.json"
}
```

**Step 2: Create .codex/INSTALL.md**

Codex installation instructions: clone to `~/.codex/flow`, symlink `skills/` to `~/.agents/skills/flow`.

**Step 3: Create .opencode/INSTALL.md**

OpenCode installation instructions: clone to `~/.config/opencode/flow`, symlink skills and plugin.

**Step 4: Commit**

```bash
git add .cursor-plugin/ .codex/ .opencode/
git commit -m "chore: add platform stubs for Cursor, Codex, OpenCode"
```

---

### Task 5: Migrate all 41 skills

**Files:**
- Create: `skills/<name>/` for each of 41 skills (copied from `~/.claude/skills/`)

**Step 1: Copy all skills**

```bash
for dir in ~/.claude/skills/*/; do
  name=$(basename "$dir")
  # Skip empty diecut/ dir
  if [ "$name" = "diecut" ]; then continue; fi
  # Skip if no SKILL.md
  if [ ! -f "$dir/SKILL.md" ]; then continue; fi
  cp -r "$dir" skills/"$name"
done
```

**Step 2: Verify count**

```bash
ls -d skills/*/SKILL.md | wc -l
```

Expected: 41

**Step 3: Commit**

```bash
git add skills/
git commit -m "feat: migrate 41 skills from ~/.claude/skills/"
```

---

### Task 6: Create using-flow bootstrapper skill

**Files:**
- Create: `skills/using-flow/SKILL.md`

**Step 1: Write SKILL.md**

The bootstrapper skill with YAML frontmatter (`name: using-flow`, `description: ...`). Content tells the agent:
- How to access skills (use the `Skill` tool)
- When to invoke skills (before any response, if even 1% chance applies)
- Lists all 41 available flow skills with their trigger conditions (extracted from each skill's description)
- Skill priority: process skills first, then domain/implementation skills
- Red flags table (rationalizations for skipping skills)

Model the structure on `using-superpowers/SKILL.md` but replace the skill catalog with flow's 41 skills.

**Step 2: Commit**

```bash
git add skills/using-flow/
git commit -m "feat: add using-flow bootstrapper skill"
```

---

### Task 7: Empty directories and README

**Files:**
- Create: `agents/.gitkeep`
- Create: `commands/.gitkeep`
- Create: `tests/.gitkeep`

**Step 1: Create .gitkeep files**

```bash
touch agents/.gitkeep commands/.gitkeep tests/.gitkeep
```

**Step 2: Create README.md**

Top-level README with:
- Project name and one-line description
- Installation instructions (Claude Code plugin install)
- Skills catalog (table of all 41 skills grouped by category)
- Alternative platform instructions (links to .codex/INSTALL.md, .opencode/INSTALL.md)
- License (MIT)

**Step 3: Commit**

```bash
git add agents/ commands/ tests/ README.md
git commit -m "docs: add README and empty agent/command/test dirs"
```

---

### Task 8: Final verification

**Step 1: Verify directory structure matches design**

```bash
find . -not -path './.git/*' -not -path './.git' | sort
```

Confirm it matches the structure from the design doc.

**Step 2: Verify plugin.json is valid JSON**

```bash
python3 -m json.tool .claude-plugin/plugin.json > /dev/null
python3 -m json.tool .claude-plugin/marketplace.json > /dev/null
python3 -m json.tool hooks/hooks.json > /dev/null
```

**Step 3: Verify session-start hook runs**

```bash
CLAUDE_PLUGIN_ROOT=. bash hooks/session-start | python3 -m json.tool > /dev/null
```

Expected: exits 0, valid JSON output.

**Step 4: Verify git log**

```bash
git log --oneline
```

Expected: 7 commits (scaffolding, plugin config, hooks, platform stubs, skill migration, bootstrapper, README).
