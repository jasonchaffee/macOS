#!/usr/bin/env bats

# Tests for main install and uninstall scripts

load test_helper

@test "install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/install" ]]
}

@test "uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/uninstall" ]]
}

@test "install script sources colors" {
    grep -q 'source.*lib/colors' "${PROJECT_DIR}/install"
}

@test "uninstall script sources colors" {
    grep -q 'source.*lib/colors' "${PROJECT_DIR}/uninstall"
}

@test "install script has all phases" {
    # Count phases - should have 15 phases
    phase_count=$(grep -c "^# Phase [0-9]*:" "${PROJECT_DIR}/install")
    [[ "$phase_count" -eq 15 ]]
}

@test "uninstall script has all phases" {
    # Count phases - should have 15 phases
    phase_count=$(grep -c "^# Phase [0-9]*:" "${PROJECT_DIR}/uninstall")
    [[ "$phase_count" -eq 15 ]]
}

@test "install script phases are in order" {
    prev=0
    while IFS= read -r line; do
        num=$(echo "$line" | sed 's/.*Phase \([0-9]*\):.*/\1/')
        expected=$((prev + 1))
        if [[ "$num" -ne "$expected" ]]; then
            echo "Phase numbering error: expected $expected, got $num"
            return 1
        fi
        prev=$num
    done < <(grep "^# Phase [0-9]*:" "${PROJECT_DIR}/install")
}

@test "uninstall script phases are in order" {
    prev=0
    while IFS= read -r line; do
        num=$(echo "$line" | sed 's/.*Phase \([0-9]*\):.*/\1/')
        expected=$((prev + 1))
        if [[ "$num" -ne "$expected" ]]; then
            echo "Phase numbering error: expected $expected, got $num"
            return 1
        fi
        prev=$num
    done < <(grep "^# Phase [0-9]*:" "${PROJECT_DIR}/uninstall")
}

@test "install script uses failure_log" {
    grep -q 'failure_log=' "${PROJECT_DIR}/install"
    grep -q '\$failure_log' "${PROJECT_DIR}/install"
}

@test "uninstall script uses failure_log" {
    grep -q 'failure_log=' "${PROJECT_DIR}/uninstall"
    grep -q '\$failure_log' "${PROJECT_DIR}/uninstall"
}

@test "install script has final summary" {
    grep -q 'Install Complete' "${PROJECT_DIR}/install"
}

@test "uninstall script has final summary" {
    grep -q 'Uninstall Complete' "${PROJECT_DIR}/uninstall"
}

@test "install script has green summary banner" {
    grep -q 'GREEN.*Install Complete' "${PROJECT_DIR}/install"
}

@test "uninstall script has green summary banner" {
    grep -q 'GREEN.*Uninstall Complete' "${PROJECT_DIR}/uninstall"
}

@test "install script captures caveats" {
    grep -q 'caveat_log=' "${PROJECT_DIR}/install"
    grep -q 'Caveats' "${PROJECT_DIR}/install"
}

@test "install script adds brew curl to PATH for SSL support" {
    grep -q '/opt/homebrew/opt/curl/bin' "${PROJECT_DIR}/install"
}

@test "curl is first in brew packages for SSL support" {
    first_brew=$(grep '^brew:' "${PROJECT_DIR}/tools.conf" | head -1)
    [[ "$first_brew" == *"curl"* ]]
}

@test "zshrc sources .zshrc.local for machine-specific config" {
    grep -q 'zshrc.local' "${PROJECT_DIR}/zsh/zshrc"
}

# AI tool config tests
@test "antigravity install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/antigravity/install" ]]
}

@test "antigravity uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/antigravity/uninstall" ]]
}

@test "antigravity has config files" {
    [[ -f "${PROJECT_DIR}/antigravity/settings.json" ]]
}

@test "claude install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/claude/install" ]]
}

@test "claude uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/claude/uninstall" ]]
}

@test "claude has config files" {
    [[ -f "${PROJECT_DIR}/claude/settings.json" ]]
    [[ -f "${PROJECT_DIR}/claude/CLAUDE.md" ]]
}

@test "codex install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/codex/install" ]]
}

@test "codex uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/codex/uninstall" ]]
}

@test "codex has config files" {
    [[ -f "${PROJECT_DIR}/codex/config.toml" ]]
}

@test "cursor install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/cursor/install" ]]
}

@test "cursor uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/cursor/uninstall" ]]
}

@test "cursor has config files" {
    [[ -f "${PROJECT_DIR}/cursor/settings.json" ]]
}

@test "gemini install script exists and is executable" {
    [[ -x "${PROJECT_DIR}/gemini/install" ]]
}

@test "gemini uninstall script exists and is executable" {
    [[ -x "${PROJECT_DIR}/gemini/uninstall" ]]
}

@test "gemini has config files" {
    [[ -f "${PROJECT_DIR}/gemini/settings.json" ]]
    [[ -f "${PROJECT_DIR}/gemini/GEMINI.md" ]]
}

@test "AI tool install scripts don't overwrite existing configs" {
    # All AI tool install scripts should check if file exists before copying
    grep -q 'Already exists' "${PROJECT_DIR}/antigravity/install"
    grep -q 'Already exists' "${PROJECT_DIR}/claude/install"
    grep -q 'Already exists' "${PROJECT_DIR}/codex/install"
    grep -q 'Already exists' "${PROJECT_DIR}/cursor/install"
    grep -q 'Already exists' "${PROJECT_DIR}/gemini/install"
}

@test "AI tool uninstall scripts use backup_file" {
    grep -q 'backup_file' "${PROJECT_DIR}/antigravity/uninstall"
    grep -q 'backup_file' "${PROJECT_DIR}/claude/uninstall"
    grep -q 'backup_file' "${PROJECT_DIR}/codex/uninstall"
    grep -q 'backup_file' "${PROJECT_DIR}/cursor/uninstall"
    grep -q 'backup_file' "${PROJECT_DIR}/gemini/uninstall"
}
