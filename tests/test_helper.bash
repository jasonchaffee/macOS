#!/usr/bin/env bash

# Test helper for bats tests

# Get the directory of the test file
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$TEST_DIR")"
LIB_DIR="${PROJECT_DIR}/lib"

# Create a temporary tools.conf for testing
setup_test_conf() {
    TEST_CONF=$(mktemp)
    export TEST_CONF
}

# Clean up temporary files
teardown_test_conf() {
    [[ -f "$TEST_CONF" ]] && rm -f "$TEST_CONF"
}

# Mock a command to prevent actual execution
mock_command() {
    local cmd=$1
    eval "${cmd}() { echo \"MOCK: ${cmd} \$*\"; return 0; }"
    export -f "$cmd"
}

# Assert that output contains a string
assert_contains() {
    local haystack=$1
    local needle=$2
    if [[ "$haystack" != *"$needle"* ]]; then
        echo "Expected to find: $needle"
        echo "In: $haystack"
        return 1
    fi
}

# Assert that output does not contain a string
assert_not_contains() {
    local haystack=$1
    local needle=$2
    if [[ "$haystack" == *"$needle"* ]]; then
        echo "Expected NOT to find: $needle"
        echo "In: $haystack"
        return 1
    fi
}
