#!/bin/sh

# Directory to sync to
NVIM_DIR="$HOME/.config/nvim"

# Name of this script
SCRIPT_NAME="$(basename "$0")"

# Folder containing the vanilla config (relative to the script location)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VANILLA_DIR="$SCRIPT_DIR/vanilla-config"

echo "Resetting $NVIM_DIR with vanilla configuration from $VANILLA_DIR..."

# Ensure the target directory exists
mkdir -p "$NVIM_DIR"

# Remove everything in ~/.config/nvim
echo "Clearing old config..."
rm -rf "$NVIM_DIR"/*

# Copy all files from vanilla-config except the script itself if it's inside
echo "Copying new files..."
for file in "$VANILLA_DIR"/*; do
    basefile="$(basename "$file")"
    if [ "$basefile" != "$SCRIPT_NAME" ]; then
        cp -r "$file" "$NVIM_DIR"/
    fi
done

echo "Done! $NVIM_DIR now contains the vanilla configuration."
