#!/usr/bin/env bats

# Tests for entry parsing logic used in install-tool and uninstall-tool

load test_helper

# Test parsing logic extracted from install-tool
parse_entry() {
    local entry=$1
    # Strip comments and whitespace
    entry=${entry%%#*}
    entry=${entry%% *}
    entry=${entry%%	*}

    type=${entry%%:*}
    package_with_version=${entry#*:}
    package=${package_with_version%%@*}
    version=${package_with_version#*@}
    [[ "$version" == "$package" ]] && version="latest"

    echo "type=$type package=$package version=$version"
}

@test "parse simple brew entry" {
    result=$(parse_entry "brew:curl")
    [[ "$result" == "type=brew package=curl version=latest" ]]
}

@test "parse brew-cask entry" {
    result=$(parse_entry "brew-cask:visual-studio-code")
    [[ "$result" == "type=brew-cask package=visual-studio-code version=latest" ]]
}

@test "parse mise entry with version" {
    result=$(parse_entry "mise:node@20")
    [[ "$result" == "type=mise package=node version=20" ]]
}

@test "parse mise entry with complex version" {
    result=$(parse_entry "mise:java@zulu")
    [[ "$result" == "type=mise package=java version=zulu" ]]
}

@test "parse entry with inline comment" {
    result=$(parse_entry "brew:curl # URL transfer tool")
    [[ "$result" == "type=brew package=curl version=latest" ]]
}

@test "parse entry with tab before comment" {
    result=$(parse_entry $'brew:curl\t# comment')
    [[ "$result" == "type=brew package=curl version=latest" ]]
}

@test "parse npm entry" {
    result=$(parse_entry "npm:typescript")
    [[ "$result" == "type=npm package=typescript version=latest" ]]
}

@test "parse mas entry with app ID" {
    result=$(parse_entry "mas:123456789")
    [[ "$result" == "type=mas package=123456789 version=latest" ]]
}

@test "parse vscode extension" {
    result=$(parse_entry "vscode:ms-python.python")
    [[ "$result" == "type=vscode package=ms-python.python version=latest" ]]
}

@test "parse gcloud component" {
    result=$(parse_entry "gcloud:beta")
    [[ "$result" == "type=gcloud package=beta version=latest" ]]
}

@test "parse uv tool" {
    result=$(parse_entry "uv:ruff")
    [[ "$result" == "type=uv package=ruff version=latest" ]]
}
