---
name: diecut
description: "Use when working with diecut templates. Triggers include scaffolding projects, creating projects from templates, building template repositories, configuring template variables, adding conditional files, setting up hooks, or when editing diecut.toml files."
globs: ["**/diecut.toml", "**/*.tera"]
---

# Diecut: Project Scaffolding

Generate projects from templates and create new template repositories using diecut.

---

## Generating Projects

### Quick Reference

| Task | Command |
|------|---------|
| Generate from GitHub | `diecut new gh:user/repo/subpath --output my-project` |
| Generate from local | `diecut new ./my-template --output my-project` |
| Use all defaults | `diecut new <template> --defaults` |
| Set variables | `diecut new <template> -d key=value -d foo=bar` |
| Skip hooks | `diecut new <template> --no-hooks` |
| Preview generation | `diecut new <template> --dry-run -v` |
| Overwrite existing | `diecut new <template> --output dir --overwrite` |

### Common Workflows

**Interactive Generation:**
```bash
diecut new gh:user/templates/python-pkg --output my-package
```

**Non-Interactive (CI/CD):**
```bash
diecut new gh:user/templates/rust-cli \
  --output my-cli \
  -d project_name=my-cli \
  -d author="Your Name" \
  --defaults
```

**Preview Before Generation:**
```bash
diecut new ./my-template --dry-run -v
```

### Template Sources

| Source | Example | Notes |
|--------|---------|-------|
| GitHub | `gh:user/repo` | Caches locally after first use |
| GitHub subpath | `gh:user/repo/subdir` | For multi-template repos |
| Local directory | `./path/to/template` | Absolute or relative paths |
| Cached templates | `diecut list` | View previously used templates |

### Variable Handling

```bash
# Set specific values
diecut new <template> -d name=value

# Multiple values
diecut new <template> -d key1=val1 -d key2=val2

# Use defaults for remaining
diecut new <template> -d key=value --defaults
```

### Security: Hooks

Templates may include post-creation hooks. Skip hooks for untrusted templates:
```bash
diecut new <untrusted-template> --no-hooks
```

---

## Creating Templates

### Required Structure

```
my-template/
  diecut.toml          # Configuration (required)
  template/            # Template files (required, singular!)
    README.md.tera     # Note .tera suffix!
    src/
      main.rs.tera
    .gitignore         # No .tera = copied verbatim
```

**CRITICAL:**
- Directory must be named `template/` (singular)
- `diecut.toml` goes at root (outside template/)
- Files with variables **MUST** have `.tera` suffix
- Static files (no variables) have no `.tera` suffix

### diecut.toml Configuration

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

### Variable Types

| Type | Example | Use Case |
|------|---------|----------|
| `string` | Project name | Text input |
| `bool` | Enable feature? | Yes/no choice |
| `int` | Port number | Whole numbers |
| `float` | Version | Decimals |
| `select` | License type | Pick one from list |
| `multiselect` | Features | Pick multiple from list |

### Tera vs Jinja2 Syntax

**CRITICAL:** Diecut uses Tera, NOT Jinja2. Syntax differs:

```toml
# CORRECT (Tera)
computed = "{{ name | replace(from=' ', to='_') }}"

# WRONG (Jinja2)
computed = "{{ name | replace(' ', '_') }}"
```

**Common filters:**
- `slugify` - converts to lowercase-with-dashes
- `replace(from="x", to="y")` - replace text
- `upper` / `lower` - case conversion
- `~` - string concatenation: `'src/' ~ package_name`

### Input Validation

```toml
[variables.project_name]
type = "string"
validation = '^[a-z][a-z0-9_-]*$'
validation_message = "Must start with lowercase letter, alphanumeric/hyphens/underscores only."
```

### Conditional Files

```toml
[files]
conditional = [
    { pattern = "docker/**", when = "use_docker" },
    { pattern = ".github/**", when = "use_ci and ci_provider == 'github-actions'" }
]
```

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `README.md` in template/ | `README.md.tera` (variables won't work without .tera) |
| `[computed]` section | Use `[variables.name]` with `computed = "..."` field |
| `condition = "..."` | Use `when = "..."` in conditional files |
| `[exclusions]` section | Use `exclude = []` in `[files]` section |
| `post = []` in hooks | Use `post_create = "..."` |
| `replace(' ', '_')` | Use `replace(from=' ', to='_')` (Tera syntax) |
| `templates/` directory | Use `template/` (singular) |

## Testing Templates

```bash
# Test with defaults
diecut new ./my-template --defaults --output test-output

# Preview generation
diecut new ./my-template --dry-run -v

# Test with specific values
diecut new ./my-template -d var1=value1 -d var2=value2 --output test2
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Template not found | Check path/URL, ensure template has diecut.toml |
| Variables not prompted | Template may use defaults, check with --dry-run |
| Output exists | Use --overwrite or delete directory first |
| Hook fails | Use --no-hooks to skip, or fix hook command |
| Cache issues | Check `~/.cache/diecut/` or re-clone template |
