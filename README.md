# macOS

Dotfiles and setup scripts for macOS.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/jasonchaffee/macOS.git
cd macOS

# Run full install
./install
```

## Structure

```
macOS/
├── install           # Main install script
├── uninstall         # Main uninstall script
├── tools.conf        # Tools configuration
├── lib/              # Shared helper scripts
├── bash/             # Bash config
├── zsh/              # Zsh config + plugins
├── git/              # Git config + global gitignore
├── vim/              # Vim config
├── brew/             # Homebrew bootstrap
└── mise/             # Mise version manager bootstrap
```

## Adding Tools

Add tools to `tools.conf`:

```bash
brew:toolname          # Homebrew formula
brew-cask:appname      # Homebrew cask (GUI apps)
mise:runtime@version   # Mise-managed tool
npm:package            # NPM global package
mas:123456789          # Mac App Store app (use app ID)
vscode:publisher.ext   # VS Code extension
cursor:publisher.ext   # Cursor extension
uv:pytool              # Python CLI tool (via uv)
gcloud:component       # Google Cloud SDK component
```

Tools with custom configs get their own directory with `install`/`uninstall` scripts.

## Testing

```bash
# Run all tests
./test

# Run a specific test file
./test tests/parse_entry.bats
```

Tests use [bats-core](https://github.com/bats-core/bats-core) (installed via `brew:bats-core`).

## Features

- **Smart detection** - Skips already-installed tools (no unnecessary downloads)
- **Manual install detection** - Identifies apps installed outside of brew
- **Timestamped backups** - All config files backed up to `~/.dotfiles_backups/` before changes
- **Merge/Replace prompts** - When config files differ, choose to Replace, Keep, Merge, or Diff
- **Machine-specific config** - `~/.zshrc.local` for secrets and work settings (not tracked)
- **Modern CLI aliases** - Replaces legacy commands with faster alternatives (see zsh/zshrc)
- **Colored summary** - Green border on success, red on failure, yellow summary section

## Backups

Config files are backed up with timestamps before any changes:

```
~/.dotfiles_backups/
├── .zshrc/
│   ├── 20250201_103045
│   └── 20250201_114532
├── .gitconfig/
│   └── 20250201_103045
└── ...
```

If a config file differs from the repo version, you'll be prompted:
1. **Replace** - Use repo version (current backed up)
2. **Keep** - Keep current version, skip repo version
3. **Merge** - Open VS Code/vimdiff to merge manually
4. **Diff** - Show differences first, then ask again

## Machine-Specific Config

For secrets, API keys, and work-specific settings, create `~/.zshrc.local`:

```bash
# Example ~/.zshrc.local (not tracked in git)
export API_KEY="your-secret-key"
export NODE_EXTRA_CA_CERTS="/path/to/certs.pem"
```

This file is sourced by `~/.zshrc` if it exists.

## What's Installed

See [tools.conf](tools.conf) for the full list of tools with descriptions.
