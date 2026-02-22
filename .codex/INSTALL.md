# Installing Flow for Codex

Flow provides Rust skills, domain expertise, and development workflows for Codex.

## Prerequisites

- [Codex](https://github.com/openai/codex) installed and configured
- Git

## Installation

### macOS / Linux

```bash
# Clone the repository
git clone https://github.com/raiderrobert/flow.git ~/.codex/flow

# Create the skills directory if it doesn't exist
mkdir -p ~/.agents/skills

# Symlink skills into Codex
ln -s ~/.codex/flow/skills ~/.agents/skills/flow
```

### Windows (PowerShell)

```powershell
# Clone the repository
git clone https://github.com/raiderrobert/flow.git "$env:USERPROFILE\.codex\flow"

# Create the skills directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"

# Symlink skills into Codex
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.agents\skills\flow" -Target "$env:USERPROFILE\.codex\flow\skills"
```

## Verify

Confirm the symlink is in place:

```bash
# macOS / Linux
ls -la ~/.agents/skills/flow

# Windows (PowerShell)
Get-Item "$env:USERPROFILE\.agents\skills\flow"
```

You should see a symbolic link pointing to `~/.codex/flow/skills`.

## Updating

Pull the latest changes from the repository:

```bash
cd ~/.codex/flow
git pull origin main
```

## Uninstalling

### macOS / Linux

```bash
# Remove the symlink
rm ~/.agents/skills/flow

# Remove the cloned repository
rm -rf ~/.codex/flow
```

### Windows (PowerShell)

```powershell
# Remove the symlink
Remove-Item "$env:USERPROFILE\.agents\skills\flow"

# Remove the cloned repository
Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\flow"
```
