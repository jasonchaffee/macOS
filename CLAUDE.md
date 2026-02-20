# CLAUDE.md - macOS

Dotfiles and setup scripts for macOS. Config-driven tool management with plugin directories for custom configs.

## Commands
```bash
./install                               # Full system install
./uninstall                             # Full system uninstall
./test                                  # Run all tests (bats-core)
./test tests/parse_entry.bats           # Run specific test file
```

## Architecture

- `tools.conf` defines simple tools as `<type>:<package>[@version]`
- `lib/` has shared helpers: `install-tool`, `uninstall-tool`, `install-tools`, `uninstall-tools`, `colors`
- Plugin directories (`bash/`, `zsh/`, `git/`, `vim/`, `brew/`, `mise/`) have their own `install`/`uninstall` scripts
- Install order enforces dependencies (brew -> mise -> runtimes -> tools -> configs)

### Exit Codes (`lib/install-tool`, `lib/uninstall-tool`)
- `0` - Success (or already installed/not installed)
- `1` - Failure
- `2` - Manual install detected (app in /Applications but not managed by brew)

### Environment Variables
- `GIT_USER_NAME` / `GIT_USER_EMAIL` - Used by `git/install` for global git config

## References
- [README.md](README.md) - Structure, tool types, features, backups, machine-specific config
- [tools.conf](tools.conf) - Full tool list with descriptions
