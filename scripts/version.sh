#!/usr/bin/env bash
#
# Version Management Script for garage-car-positioning
#
# Updates: VERSION, CHANGELOG.md, ESPHome configs (firmware_version),
#          and creates a git tag (v<version>).
#
# Usage:
#   ./scripts/version.sh              - Show current version
#   ./scripts/version.sh patch        - Increment patch version (bug fixes)
#   ./scripts/version.sh minor        - Increment minor version (new features)
#   ./scripts/version.sh major        - Increment major version (breaking changes)
#   ./scripts/version.sh set <ver>    - Set specific version (e.g., 0.2.0)
#   ./scripts/version.sh help         - Show help

set -e

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

VERSION_FILE="$PROJECT_ROOT/VERSION"
CHANGELOG_FILE="$PROJECT_ROOT/CHANGELOG.md"
ESPHOME_DIR="$PROJECT_ROOT/esphome"

# ESPHome config files to update
ESPHOME_CONFIGS=(
    "$ESPHOME_DIR/all-in-one.yaml"
    "$ESPHOME_DIR/garage-car-sensor.yaml"
    "$ESPHOME_DIR/esp32-garage-door.yaml"
    "$ESPHOME_DIR/simple-wifi.yaml"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current version from VERSION file
get_current_version() {
    if [[ -f "$VERSION_FILE" ]]; then
        cat "$VERSION_FILE" | tr -d '[:space:]'
    else
        echo "0.0.0"
    fi
}

# Parse version into components
parse_version() {
    local version="$1"
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid version format '$version'. Expected: MAJOR.MINOR.PATCH${NC}" >&2
        exit 1
    fi
    echo "$version"
}

# Increment version based on type
increment_version() {
    local version="$1"
    local type="$2"

    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"

    case "$type" in
        patch)
            patch=$((patch + 1))
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        *)
            echo -e "${RED}Error: Invalid increment type '$type'${NC}" >&2
            exit 1
            ;;
    esac

    echo "$major.$minor.$patch"
}

# Update VERSION file
update_version_file() {
    local new_version="$1"
    echo "$new_version" > "$VERSION_FILE"
    echo -e "${GREEN}Updated VERSION file to $new_version${NC}"
}

# Update ESPHome config files
update_esphome_configs() {
    local new_version="$1"

    for config in "${ESPHOME_CONFIGS[@]}"; do
        if [[ -f "$config" ]]; then
            # Update firmware_version substitution
            if grep -q 'firmware_version:' "$config"; then
                sed -i '' "s/firmware_version: \"[0-9]*\.[0-9]*\.[0-9]*\"/firmware_version: \"$new_version\"/" "$config"
                echo -e "${GREEN}Updated $(basename "$config")${NC}"
            else
                echo -e "${YELLOW}Warning: No firmware_version found in $(basename "$config")${NC}"
            fi
        else
            echo -e "${YELLOW}Warning: Config file not found: $config${NC}"
        fi
    done
}

# Update CHANGELOG.md
update_changelog() {
    local new_version="$1"
    local today
    today=$(date +%Y-%m-%d)

    if [[ -f "$CHANGELOG_FILE" ]]; then
        # Check if [Unreleased] section exists
        if grep -q '## \[Unreleased\]' "$CHANGELOG_FILE"; then
            # Insert new version section after [Unreleased]
            sed -i '' "s/## \[Unreleased\]/## [Unreleased]\n\n## [$new_version] - $today/" "$CHANGELOG_FILE"
            echo -e "${GREEN}Updated CHANGELOG.md with version $new_version${NC}"
        else
            echo -e "${YELLOW}Warning: No [Unreleased] section found in CHANGELOG.md${NC}"
        fi
    else
        echo -e "${YELLOW}Warning: CHANGELOG.md not found${NC}"
    fi
}

# Create git tag
create_git_tag() {
    local version="$1"
    local tag="v$version"

    # Check if we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${YELLOW}Warning: Not in a git repository, skipping tag creation${NC}"
        return
    fi

    # Check if tag already exists
    if git tag -l "$tag" | grep -q "$tag"; then
        echo -e "${YELLOW}Warning: Git tag $tag already exists, skipping${NC}"
        return
    fi

    git tag "$tag"
    echo -e "${GREEN}Created git tag: $tag${NC}"
}

# Show help
show_help() {
    cat << EOF
${BLUE}garage-car-positioning Version Management${NC}

Usage:
  ./scripts/version.sh              Show current version
  ./scripts/version.sh patch        Increment patch (bug fixes: 0.1.1 → 0.1.2)
  ./scripts/version.sh minor        Increment minor (features: 0.1.1 → 0.2.0)
  ./scripts/version.sh major        Increment major (breaking: 0.1.1 → 1.0.0)
  ./scripts/version.sh set <ver>    Set specific version (e.g., 0.2.0)
  ./scripts/version.sh help         Show this help

Semantic Versioning:
  MAJOR.MINOR.PATCH
  - MAJOR: Incompatible changes
  - MINOR: Backward-compatible new features
  - PATCH: Backward-compatible bug fixes

Files updated:
  - VERSION
  - CHANGELOG.md (Unreleased → version header)
  - esphome/*.yaml (firmware_version substitution)
  - Git tag v<version> created locally

After bumping, commit and push:
  git add -A && git commit -m "chore: bump version to <version>"
  git push && git push --tags
EOF
}

# Show current version info
show_version() {
    local current_version
    current_version=$(get_current_version)

    echo -e "${BLUE}garage-car-positioning${NC}"
    echo -e "Current version: ${GREEN}$current_version${NC}"
    echo ""
    echo "ESPHome configs:"
    for config in "${ESPHOME_CONFIGS[@]}"; do
        if [[ -f "$config" ]]; then
            local config_version
            config_version=$(grep 'firmware_version:' "$config" 2>/dev/null | sed 's/.*"\([0-9.]*\)".*/\1/' || echo "not found")
            echo "  $(basename "$config"): $config_version"
        fi
    done
    echo ""
    echo "Run './scripts/version.sh help' for usage information."
}

# Main function
main() {
    local command="${1:-}"
    local current_version
    current_version=$(get_current_version)

    case "$command" in
        ""|"show")
            show_version
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "patch"|"minor"|"major")
            local new_version
            new_version=$(increment_version "$current_version" "$command")

            echo -e "${BLUE}Updating version: $current_version → $new_version${NC}"
            echo ""

            update_version_file "$new_version"
            update_esphome_configs "$new_version"
            update_changelog "$new_version"
            create_git_tag "$new_version"

            echo ""
            echo -e "${GREEN}✓ Version updated to $new_version${NC}"

            case "$command" in
                major)
                    echo -e "${YELLOW}⚠️  MAJOR version bump - ensure breaking changes are documented!${NC}"
                    ;;
                minor)
                    echo -e "${BLUE}✨ MINOR version bump - new features added${NC}"
                    ;;
                patch)
                    echo -e "${GREEN}🐛 PATCH version bump - bug fixes${NC}"
                    ;;
            esac

            echo ""
            echo "Next steps:"
            echo "  git add -A && git commit -m \"chore: bump version to $new_version\""
            echo "  git push && git push --tags"
            ;;
        "set")
            local new_version="${2:-}"
            if [[ -z "$new_version" ]]; then
                echo -e "${RED}Error: Please specify a version to set${NC}"
                echo "Usage: ./scripts/version.sh set <version>"
                exit 1
            fi

            # Validate version format
            parse_version "$new_version" > /dev/null

            echo -e "${BLUE}Setting version: $current_version → $new_version${NC}"
            echo ""

            update_version_file "$new_version"
            update_esphome_configs "$new_version"
            create_git_tag "$new_version"

            echo ""
            echo -e "${GREEN}✓ Version set to $new_version${NC}"
            ;;
        *)
            echo -e "${RED}Error: Unknown command '$command'${NC}"
            echo "Run './scripts/version.sh help' for usage information."
            exit 1
            ;;
    esac
}

main "$@"
