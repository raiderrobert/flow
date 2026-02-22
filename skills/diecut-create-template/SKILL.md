---
name: diecut-create-template
description: Use when creating new diecut templates. Triggers include building template repositories, configuring template variables, adding conditional files, setting up hooks, or when editing diecut.toml files.
---

# Diecut: Create Templates

## Overview

Diecut templates use Tera (NOT Jinja2) for templating. Templates require specific directory structure, file naming (.tera suffix), and TOML configuration syntax.

## Required Structure

```
my-template/
├── diecut.toml          # Configuration (required)
└── template/            # Template files (required, singular!)
    ├── README.md.tera   # ← Note .tera suffix!
    ├── src/
    │   └── main.rs.tera
    └── .gitignore       # No .tera = copied verbatim
```

**CRITICAL:**
- Directory must be named `template/` (singular)
- `diecut.toml` goes at root (outside template/)
- Files with variables **MUST** have `.tera` suffix
- Static files (no variables) have no `.tera` suffix

## Quick Reference

| Component | Requirement |
|-----------|-------------|
| Directory structure | `template/` subdirectory at root |
| Configuration | `diecut.toml` at root |
| Templated files | **MUST** have `.tera` suffix |
| Static files | No `.tera` suffix (copied as-is) |
| Directory names | Can use `{{ var }}` (e.g., `{{project_name}}/src/`) |
| Template syntax | Tera: `{{ var }}`, NOT Jinja2 |

## diecut.toml Sections

**CRITICAL:** Use exact section names. Don't invent sections.

```toml
[template]
name = "template-name"

# Regular variable
[variables.project_name]
type = "string"
prompt = "Project name"
default = "my-project"

# Computed variable (NO prompt field)
[variables.project_slug]
type = "string"
computed = "{{ project_name | slugify }}"

# Conditional variable
[variables.ci_provider]
type = "select"
prompt = "CI provider"
choices = ["github-actions", "gitlab-ci"]
when = "{{ use_ci }}"

# File configuration
[files]
exclude = ["*.pyc", "__pycache__/**"]
copy_without_render = ["assets/**/*.png"]
conditional = [
    { pattern = ".github/**", when = "use_ci and ci_provider == 'github-actions'" }
]

# Hooks (NOTE: post_create not post!)
[hooks]
post_create = "git init && git add -A && git commit -m 'Initial commit'"
```

## Variable Types

| Type | Example | Use Case |
|------|---------|----------|
| `string` | Project name | Text input |
| `bool` | Enable feature? | Yes/no choice |
| `int` | Port number | Whole numbers |
| `float` | Version | Decimals |
| `select` | License type | Pick one from list |
| `multiselect` | Features | Pick multiple from list |

## Computed Variables

Variables derived from other variables without prompting:

```toml
[variables.project_slug]
type = "string"
computed = "{{ project_name | slugify }}"

[variables.python_package]
type = "string"
computed = "{{ project_slug | replace(from='-', to='_') }}"
```

**Can chain dependencies** - diecut uses iterative evaluation to resolve them in correct order.

## Conditional Files

Include files only when conditions are met:

```toml
[files]
conditional = [
    { pattern = "docker/**", when = "use_docker" },
    { pattern = ".github/**", when = "use_ci and ci_provider == 'github-actions'" }
]
```

## Tera vs Jinja2 Syntax

**CRITICAL:** Diecut uses Tera, NOT Jinja2. Syntax differs:

```toml
# ✅ CORRECT (Tera)
computed = "{{ name | replace(from=' ', to='_') }}"

# ❌ WRONG (Jinja2)
computed = "{{ name | replace(' ', '_') }}"
```

**Common filters:**
- `slugify` - converts to lowercase-with-dashes
- `replace(from="x", to="y")` - replace text
- `upper` / `lower` - case conversion
- `~` - string concatenation: `'src/' ~ package_name`

## Input Validation

```toml
[variables.project_name]
type = "string"
validation = '^[a-z][a-z0-9_-]*$'
validation_message = "Must start with lowercase letter, alphanumeric/hyphens/underscores only."
```

## Hooks

Commands executed after project generation:

```toml
[hooks]
post_create = "git init && git add -A && git commit -m 'Initial commit'"
```

**Multiple commands:** Chain with `&&`
**Security:** Users see warning and can skip with `--no-hooks`

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| ❌ `README.md` in template/ | ✅ `README.md.tera` (variables won't work without .tera) |
| ❌ `[computed]` section | ✅ Use `[variables.name]` with `computed = "..."` field |
| ❌ `condition = "..."` | ✅ Use `when = "..."` in conditional files |
| ❌ `[exclusions]` section | ✅ Use `exclude = []` in `[files]` section |
| ❌ `post = []` in hooks | ✅ Use `post_create = "..."` |
| ❌ `replace(' ', '_')` | ✅ Use `replace(from=' ', to='_')` (Tera syntax) |
| ❌ `templates/` directory | ✅ Use `template/` (singular) |

## Complete Example

**Goal:** Python package with author, license, optional Docker support.

**diecut.toml:**
```toml
[template]
name = "python-pkg"

[variables.package_name]
type = "string"
prompt = "Package name"
validation = '^[a-z][a-z0-9_]*$'
validation_message = "Lowercase letters, numbers, underscores only"

[variables.author]
type = "string"
prompt = "Author name"

[variables.license]
type = "select"
prompt = "License"
choices = ["MIT", "Apache-2.0", "GPL-3.0"]
default = "MIT"

[variables.use_docker]
type = "bool"
prompt = "Include Docker support?"
default = false

[variables.package_slug]
type = "string"
computed = "{{ package_name | replace(from='-', to='_') }}"

[files]
exclude = ["*.pyc", "__pycache__/**", ".DS_Store"]
conditional = [
    { pattern = "Dockerfile.tera", when = "use_docker" },
    { pattern = ".dockerignore", when = "use_docker" }
]

[hooks]
post_create = "python -m venv venv && source venv/bin/activate && pip install -e ."
```

**Directory structure:**
```
python-pkg/
├── diecut.toml
└── template/
    ├── pyproject.toml.tera
    ├── README.md.tera
    ├── src/
    │   └── {{ package_slug }}/
    │       └── __init__.py.tera
    ├── Dockerfile.tera         # Only if use_docker=true
    └── .dockerignore           # Only if use_docker=true
```

**pyproject.toml.tera:**
```toml
[project]
name = "{{ package_name }}"
authors = [{ name = "{{ author }}" }]
license = { text = "{{ license }}" }
```

## Testing Templates

```bash
# Test with defaults
diecut new ./my-template --defaults --output test-output

# Preview generation
diecut new ./my-template --dry-run -v

# Test with specific values
diecut new ./my-template -d var1=value1 -d var2=value2 --output test2
```

## Red Flags - STOP and Check

- File in template/ without .tera suffix (variables won't work)
- Using `[computed]` section (doesn't exist)
- Using Jinja2 filter syntax `replace('x', 'y')`
- Inventing TOML sections not in spec
- Using `post =` instead of `post_create =`
- Directory named `templates/` (should be singular)

**All of these mean: Check the syntax reference above.**
