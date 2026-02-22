---
name: diecut-new
description: Use when generating a new project from a diecut template. Triggers include scaffolding projects, creating projects from templates, or when running diecut new commands.
---

# Diecut: Generate Projects from Templates

## Overview

Diecut generates projects from templates using the `diecut new` command. Templates can be from GitHub, local directories, or multi-template repositories.

## Quick Reference

| Task | Command |
|------|---------|
| Generate from GitHub | `diecut new gh:user/repo/subpath --output my-project` |
| Generate from local | `diecut new ./my-template --output my-project` |
| Use all defaults | `diecut new <template> --defaults` |
| Set variables | `diecut new <template> -d key=value -d foo=bar` |
| Skip hooks | `diecut new <template> --no-hooks` |
| Preview generation | `diecut new <template> --dry-run -v` |
| Overwrite existing | `diecut new <template> --output dir --overwrite` |

## Common Workflows

### Interactive Generation
```bash
diecut new gh:user/templates/python-pkg --output my-package
```
You'll be prompted for each variable defined in the template.

### Non-Interactive (CI/CD)
```bash
diecut new gh:user/templates/rust-cli \
  --output my-cli \
  -d project_name=my-cli \
  -d author="Your Name" \
  --defaults
```
Use `--defaults` for unprovided variables, `-d` for specific values.

### Preview Before Generation
```bash
diecut new ./my-template --dry-run -v
```
Shows what files would be created and their content (with `-v`).

## Template Sources

| Source | Example | Notes |
|--------|---------|-------|
| GitHub | `gh:user/repo` | Caches locally after first use |
| GitHub subpath | `gh:user/repo/subdir` | For multi-template repos |
| Local directory | `./path/to/template` | Absolute or relative paths |
| Cached templates | `diecut list` | View previously used templates |

## Variable Handling

**Set specific values:**
```bash
diecut new <template> -d name=value
```

**Multiple values:**
```bash
diecut new <template> -d key1=val1 -d key2=val2 -d key3=val3
```

**Use defaults for remaining:**
```bash
diecut new <template> -d key=value --defaults
```

## Security: Hooks

Templates may include post-creation hooks that execute commands. Diecut warns you before running hooks from remote templates.

**Skip hooks for untrusted templates:**
```bash
diecut new <untrusted-template> --no-hooks
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Template not found | Check path/URL, ensure template has diecut.toml |
| Variables not prompted | Template may use defaults, check with --dry-run |
| Output exists | Use --overwrite or delete directory first |
| Hook fails | Use --no-hooks to skip, or fix hook command |
| Cache issues | Check `~/.cache/diecut/` or re-clone template |

## Examples

**Python package with specific values:**
```bash
diecut new gh:raiderrobert/diecut-templates/python-pkg \
  --output awesome-lib \
  -d package_name=awesome-lib \
  -d author="Jane Developer" \
  -d license=MIT \
  --defaults
```

**Rust CLI from local template:**
```bash
diecut new ~/templates/rust-cli --output my-tool
```

**Preview what would be generated:**
```bash
diecut new ./my-template --output test-output --dry-run -v
```
