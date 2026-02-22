# Installing Flow for OpenCode

Flow provides Rust skills, domain expertise, and development workflows for OpenCode.

## Prerequisites

- [OpenCode](https://github.com/opencode-ai/opencode) installed and configured
- Git

## Installation

```bash
# Clone the repository
git clone https://github.com/raiderrobert/flow.git ~/.config/opencode/flow

# Create the skills directory if it doesn't exist
mkdir -p ~/.config/opencode/skills

# Symlink skills into OpenCode
ln -s ~/.config/opencode/flow/skills ~/.config/opencode/skills/flow
```

After installation, restart OpenCode to pick up the new skills.

## Verify

Confirm the symlink is in place:

```bash
ls -la ~/.config/opencode/skills/flow
```

You should see a symbolic link pointing to `~/.config/opencode/flow/skills`.

## Usage

Once installed, Flow skills are available in your OpenCode sessions. The skills provide Rust development patterns, domain expertise, and structured workflows.

## Updating

Pull the latest changes from the repository:

```bash
cd ~/.config/opencode/flow
git pull origin main
```

Restart OpenCode after updating to load the latest skills.

## Troubleshooting

**Skills not loading after install:**
- Verify the symlink exists: `ls -la ~/.config/opencode/skills/flow`
- Make sure you restarted OpenCode after installation
- Check that the target directory contains skill files: `ls ~/.config/opencode/flow/skills/`

**Symlink errors:**
- Ensure the target directory exists before creating the symlink
- On some systems you may need to remove a broken symlink before recreating it: `rm ~/.config/opencode/skills/flow`

## Uninstalling

```bash
# Remove the symlink
rm ~/.config/opencode/skills/flow

# Remove the cloned repository
rm -rf ~/.config/opencode/flow
```

Restart OpenCode after uninstalling.
