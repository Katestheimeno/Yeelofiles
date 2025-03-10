#!/bin/env bash

THEME_CONF="$HOME/Yeelofiles/sddm/themes/yeelo-sddm/theme.conf"

source ./random_wallpaper
source ./wal_lazygit.sh

# Wait for the wallpaper script to complete and ensure pywal is set
sleep 2


# Check if the theme.conf file exists
if [ ! -f "$THEME_CONF" ]; then
    echo "Theme configuration file not found: $THEME_CONF"
    exit 1
fi


# Read colors from ~/.cache/wal/colors
COLORS=($(cat ~/.cache/wal/colors))

# Extract the colors you need
BACKGROUND="${COLORS[0]}"
MAIN_COLOR="${COLORS[1]}"
ACCENT_COLOR="${COLORS[6]}"

sed -i \
	-e "/^Background=/s|\".*\"|\"$(echo $WAL_WALLPAPER)\"|" \
    -e "/^MainColor=/s|\".*\"|\"$MAIN_COLOR\"|" \
    -e "/^AccentColor=/s|\".*\"|\"$ACCENT_COLOR\"|" \
    "$THEME_CONF"
