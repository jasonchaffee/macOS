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
- **Colored output** - Phase headers, success/failure indicators
- **Summary report** - Shows failures (red ✗) and manual installs (yellow ⚠)

## What's Installed

See [tools.conf](tools.conf) for the full list of tools with descriptions.
