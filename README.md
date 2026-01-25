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
├── tools.conf        # Simple tools configuration
├── lib/              # Shared helper scripts
├── bash/             # Bash config
├── zsh/              # Zsh config + plugins
├── git/              # Git config + global gitignore
├── vim/              # Vim config
├── brew/             # Homebrew bootstrap
└── mise/             # Mise version manager bootstrap
```

## Adding Tools

Simple tools go in `tools.conf`:

```
brew:toolname          # Homebrew formula
brew-cask:appname      # Homebrew cask (GUI apps)
mise:runtime@version   # Mise-managed tool
```

Tools with custom configs get their own directory with `install`/`uninstall` scripts.

## What's Installed

See [tools.conf](tools.conf) for the full list of tools with descriptions.
