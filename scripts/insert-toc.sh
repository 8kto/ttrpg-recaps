#!/bin/bash
#
# insert-toc.sh - Generate and insert a Markdown Table of Contents into a Readme file
#
# Usage:
#   ./insert-toc.sh <path/to/Readme.md> <path/to/reports_directory>
#
# Description:
#   - Scans all report-*.md files in the given directory
#   - Extracts the first H1 heading (# ...)
#   - Generates a Markdown TOC with links
#   - Replaces content between <!-- cmd[toc] --> and <!-- /cmd[toc] -->
#
# Example:
#   ./insert-toc.sh ./Readme.md ./reports/

set -e

TOC_TAG_BEGIN="<!-- cmd[toc] -->"
TOC_TAG_END="<!-- /cmd[toc] -->"

print_help() {
    sed -n '2,17p' "$0"
}

exit_with_error() {
    echo "Error: $1" >&2
    exit "$2"
}

validate_args() {
    if [[ $# -ne 2 ]]; then
        exit_with_error "Expected 2 arguments: <Readme.md> <reports_directory>" 1
    fi
    if [[ ! -f "$README" ]]; then
        exit_with_error "Readme file '$README' not found." 2
    fi
    if [[ ! -d "$REPORT_DIR" ]]; then
        exit_with_error "Reports directory '$REPORT_DIR' not found." 3
    fi
    if ! grep -Fq "$TOC_TAG_BEGIN" "$README"; then
        exit_with_error "Start tag '$TOC_TAG_BEGIN' not found in $README" 4
    fi
    if ! grep -Fq "$TOC_TAG_END" "$README"; then
        exit_with_error "End tag '$TOC_TAG_END' not found in $README" 5
    fi
}

extract_title() {
    local file="$1"
    grep -m1 '^# ' "$file" | sed 's/^# //'
}

generate_toc() {
    local dir="$1"
    local toc_file="$2"
    > "$toc_file"
    for file in "$dir"/report-*.md; do
        [[ -f "$file" ]] || continue
        local title
        title=$(extract_title "$file")
        local basename
        basename=$(basename "$file")
        [[ -n "$title" ]] && printf -- "- [%s](./%s)\n" "$title" "$basename" >> "$toc_file"
    done
}

replace_toc_block() {
    local input="$1"
    local toc_file="$2"
    local output="${input}.tmp"
    local inside=0

    > "$output"

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "$TOC_TAG_BEGIN" ]]; then
            echo "$line" >> "$output"
            cat "$toc_file" >> "$output"
            inside=1
            continue
        fi
        if [[ "$line" == "$TOC_TAG_END" ]]; then
            inside=0
            echo "$line" >> "$output"
            continue
        fi
        [[ $inside -eq 1 ]] && continue
        echo "$line" >> "$output"
    done < "$input"

    mv "$output" "$input"
}

main() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        print_help
        exit 0
    fi

    README="$1"
    REPORT_DIR="$2"

    validate_args "$@"

    TOC_TMP=$(mktemp)
    generate_toc "$REPORT_DIR" "$TOC_TMP"
    replace_toc_block "$README" "$TOC_TMP"
    rm -f "$TOC_TMP"
}

main "$@"
