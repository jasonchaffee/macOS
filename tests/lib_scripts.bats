#!/usr/bin/env bats

# Tests for lib scripts existence and basic structure

load test_helper

@test "install-tool script exists and is executable" {
    [[ -x "${LIB_DIR}/install-tool" ]]
}

@test "uninstall-tool script exists and is executable" {
    [[ -x "${LIB_DIR}/uninstall-tool" ]]
}

@test "install-tools script exists and is executable" {
    [[ -x "${LIB_DIR}/install-tools" ]]
}

@test "uninstall-tools script exists and is executable" {
    [[ -x "${LIB_DIR}/uninstall-tools" ]]
}

@test "colors script exists" {
    [[ -f "${LIB_DIR}/colors" ]]
}

@test "colors script defines required color variables" {
    source "${LIB_DIR}/colors"
    [[ -n "$RED" ]]
    [[ -n "$GREEN" ]]
    [[ -n "$YELLOW" ]]
    [[ -n "$BLUE" ]]
    [[ -n "$CYAN" ]]
    [[ -n "$BOLD" ]]
    [[ -n "$NC" ]]
}

@test "install-tool handles all expected types" {
    # Check that install-tool has case statements for all types
    for type in brew brew-cask mise npm mas vscode cursor uv gcloud; do
        if ! grep -q "^[[:space:]]*${type})" "${LIB_DIR}/install-tool"; then
            echo "Missing case for type: $type"
            return 1
        fi
    done
}

@test "uninstall-tool handles all expected types" {
    # Check that uninstall-tool has case statements for all types
    for type in brew brew-cask mise npm mas vscode cursor uv gcloud; do
        if ! grep -q "^[[:space:]]*${type})" "${LIB_DIR}/uninstall-tool"; then
            echo "Missing case for type: $type"
            return 1
        fi
    done
}

@test "install-tool strips comments from entries" {
    grep -q 'entry=\${entry%%#\*}' "${LIB_DIR}/install-tool"
}

@test "uninstall-tool strips comments from entries" {
    grep -q 'entry=\${entry%%#\*}' "${LIB_DIR}/uninstall-tool"
}

@test "install-tools captures error output" {
    # Check that install-tools captures output for error reporting
    grep -q 'tmp_output=' "${LIB_DIR}/install-tools"
    grep -q 'tee.*tmp_output' "${LIB_DIR}/install-tools"
}

@test "uninstall-tools captures error output" {
    # Check that uninstall-tools captures output for error reporting
    grep -q 'tmp_output=' "${LIB_DIR}/uninstall-tools"
    grep -q 'tee.*tmp_output' "${LIB_DIR}/uninstall-tools"
}

@test "install-tools logs error details to failure_log" {
    # Check that error lines are appended to failure log
    grep -q 'error_lines' "${LIB_DIR}/install-tools"
    grep -q '>> \$failure_log' "${LIB_DIR}/install-tools"
}

@test "uninstall-tools logs error details to failure_log" {
    # Check that error lines are appended to failure log
    grep -q 'error_lines' "${LIB_DIR}/uninstall-tools"
    grep -q '>> \$failure_log' "${LIB_DIR}/uninstall-tools"
}

@test "install-tool returns exit code 2 for manual installs" {
    grep -q 'exit 2' "${LIB_DIR}/install-tool"
}

@test "uninstall-tool returns exit code 2 for manual installs" {
    grep -q 'exit 2' "${LIB_DIR}/uninstall-tool"
}
