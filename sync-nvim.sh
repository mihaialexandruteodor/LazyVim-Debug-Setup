#!/bin/sh

# Directory to sync to
NVIM_DIR="$HOME/.config/nvim"

# Name of this script
SCRIPT_NAME="$(basename "$0")"

echo "Syncing files to $NVIM_DIR..."

# Ensure the target directory exists
mkdir -p "$NVIM_DIR"

# Remove everything in ~/.config/nvim
echo "🧹  Clearing old config..."
rm -rf "$NVIM_DIR"/*

# Copy all files except the script, README.md, and .gitignore
echo "📦  Copying new files..."
for file in *; do
    if [ "$file" != "$SCRIPT_NAME" ] && [ "$file" != "README.md" ] && [ "$file" != ".gitignore" ] && [ "$file" != "LICENSE" ]; then
        cp -r "$file" "$NVIM_DIR"/
    fi
done

echo "Done! Config replaced in $NVIM_DIR."
