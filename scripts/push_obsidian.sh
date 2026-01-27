#!/bin/bash

# Set your Obsidian vault path
VAULT_DIR="$HOME/Obsidian"

# Change to the vault directory
cd "$VAULT_DIR" || exit

# Add changes
git add .

# Commit with timestamp
COMMIT_MESSAGE="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Push to the remote repository
git push origin main
