# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains macOS dotfiles and setup scripts. Tools are managed via a config-driven approach for simple installs, with plugin directories for tools requiring custom configuration.

## Commands

```bash
# Full system install
./install

# Full system uninstall
./uninstall
```

## Architecture

### Config-Driven Tools (`tools.conf`)

Simple tools are defined in `tools.conf` with format `<type>:<package>[@version]`:
- `brew:` - Homebrew packages
- `brew-cask:` - Homebrew casks (GUI apps)
- `mise:` - Mise-managed runtimes/tools (supports `@version`)
- `npm:` - NPM global packages

Helper scripts in `lib/` process these entries:
- `lib/install-tool` - Installs a single tool entry
- `lib/uninstall-tool` - Uninstalls a single tool entry

### Plugin Directories

Tools with custom configs keep their own directories:
- `bash/` - bashrc
- `zsh/` - zshrc, zsh_plugins.txt
- `git/` - gitignore, git config commands
- `vim/` - vimrc
- `brew/` - Homebrew bootstrap
- `mise/` - Mise version manager bootstrap

Each plugin has `install` and `uninstall` scripts.

### Install Order

The main `install` script enforces dependency order:
1. **brew** - Homebrew (package manager foundation)
2. **brew packages** - Including curl early for SSL
3. **bash/zsh** - Shell configs
4. **mise** - Runtime version manager
5. **mise tools** - node, python, java, terraform, etc.
6. **npm packages** - Requires node from previous phase
7. **brew casks** - GUI applications
8. **custom configs** - git, vim

### Environment Variables

The `git/install` script uses optional environment variables:
- `GIT_USER_NAME` - Git user name for global config
- `GIT_USER_EMAIL` - Git user email for global config
