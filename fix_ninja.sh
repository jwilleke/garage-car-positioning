#!/bin/bash
# Fix script for PlatformIO ninja tool architecture mismatch on Apple Silicon
# This script replaces x86_64 ninja with arm64 version when PlatformIO overwrites it

NINJA_PATH="$HOME/.platformio/packages/tool-ninja/ninja"
ARM64_NINJA="/tmp/ninja-arm64"

# Download arm64 ninja if not present
if [ ! -f "$ARM64_NINJA" ]; then
    echo "Downloading arm64 ninja..."
    cd /tmp
    curl -L -o ninja-mac.zip https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-mac.zip
    unzip -q ninja-mac.zip
    lipo ninja -extract arm64 -output ninja-arm64
    chmod +x ninja-arm64
    rm -f ninja ninja-mac.zip
fi

# Replace ninja if it's x86_64
if [ -f "$NINJA_PATH" ]; then
    ARCH=$(file "$NINJA_PATH" | grep -o "x86_64\|arm64" | head -1)
    if [ "$ARCH" = "x86_64" ]; then
        echo "Replacing x86_64 ninja with arm64 version..."
        cp "$ARM64_NINJA" "$NINJA_PATH"
        chmod 555 "$NINJA_PATH"
    fi
fi
