#!/bin/env bash

# Path to the colors file and LazyGit config file
COLORS_FILE="$HOME/.cache/wal/colors"
CONFIG_FILE="$HOME/Yeelofiles/lazygit/.config/lazygit/config.yml"

# Check if files exist
if [[ ! -f "$COLORS_FILE" ]]; then
    echo "Error: Colors file not found at $COLORS_FILE"
    exit 1
fi
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

# Read the first 9 colors from the colors file
COLORS=($(head -n 9 "$COLORS_FILE"))

# Validate colors
for color in "${COLORS[@]}"; do
    if [[ ! "$color" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
        echo "Error: Invalid color format in $COLORS_FILE"
        exit 1
    fi
done

# Define keys and their corresponding color indices
declare -A KEY_COLOR_MAP=(
    ["activeBorderColor"]=1
    ["inactiveBorderColor"]=6
    ["searchingActiveBorderColor"]=3
    ["optionsTextColor"]=4
    ["selectedLineBgColor"]=3
    ["cherryPickedCommitFgColor"]=4
    ["cherryPickedCommitBgColor"]=2
    ["markedBaseCommitFgColor"]=4
    ["markedBaseCommitBgColor"]=1
    ["unstagedChangesColor"]=0
    ["defaultFgColor"]=6
)

# Update the config file while preserving indentation
for key in "${!KEY_COLOR_MAP[@]}"; do
    color_index="${KEY_COLOR_MAP[$key]}"
    color="${COLORS[$color_index]}"

    # Use sed to replace only the color value, preserving indentation
    sed -i -E -e "/^ *$key:/ {n; s|^( *- ).*|\1\"$color\"|}" "$CONFIG_FILE"
done
