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
    # Count phases - should have 13 phases
    phase_count=$(grep -c "^# Phase [0-9]*:" "${PROJECT_DIR}/install")
    [[ "$phase_count" -eq 13 ]]
}

@test "uninstall script has all phases" {
    # Count phases - should have 13 phases
    phase_count=$(grep -c "^# Phase [0-9]*:" "${PROJECT_DIR}/uninstall")
    [[ "$phase_count" -eq 13 ]]
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

@test "zshrc sources .zshrc.local for machine-specific config" {
    grep -q 'zshrc.local' "${PROJECT_DIR}/zsh/zshrc"
}
