#!/usr/bin/env bats

# Tests for tools.conf format and content

load test_helper

@test "tools.conf exists" {
    [[ -f "${PROJECT_DIR}/tools.conf" ]]
}

@test "tools.conf has no syntax errors (valid format)" {
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Each non-comment line should match type:package pattern
        if [[ ! "$line" =~ ^[a-z-]+:[a-zA-Z0-9@._-]+ ]]; then
            echo "Invalid line: $line"
            return 1
        fi
    done < "${PROJECT_DIR}/tools.conf"
}

@test "tools.conf contains only valid types" {
    valid_types="brew|brew-cask|mise|npm|mas|vscode|cursor|uv|gcloud"

    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        type=${line%%:*}
        if [[ ! "$type" =~ ^($valid_types)$ ]]; then
            echo "Invalid type '$type' in line: $line"
            return 1
        fi
    done < "${PROJECT_DIR}/tools.conf"
}

@test "no duplicate entries in tools.conf" {
    # Extract package entries (type:package without version or comments)
    entries=$(grep -v '^#' "${PROJECT_DIR}/tools.conf" | grep -v '^$' | sed 's/#.*//' | sed 's/@.*//' | sed 's/[[:space:]]*$//' | sort)
    unique_entries=$(echo "$entries" | uniq)

    if [[ "$entries" != "$unique_entries" ]]; then
        echo "Duplicate entries found:"
        echo "$entries" | uniq -d
        return 1
    fi
}

@test "brew entries exist" {
    grep -q "^brew:" "${PROJECT_DIR}/tools.conf"
}

@test "mise entries exist" {
    grep -q "^mise:" "${PROJECT_DIR}/tools.conf"
}

@test "brew-cask entries exist" {
    grep -q "^brew-cask:" "${PROJECT_DIR}/tools.conf"
}
