#!/bin/env bash

# Usage:
# ./update_git_usernames.sh OLD_USERNAME NEW_USERNAME [--dry-run] [--verbose]

OLD_USERNAME=$1
NEW_USERNAME=$2
DRY_RUN=false
VERBOSE=false

# Parse optional flags
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --verbose) VERBOSE=true ;;
    esac
done

if [[ -z "$OLD_USERNAME" || -z "$NEW_USERNAME" ]]; then
    echo -e "\e[31mUsage:\e[0m $0 OLD_USERNAME NEW_USERNAME [--dry-run] [--verbose]"
    exit 1
fi

# Color codes
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

echo -e "${BLUE}Old username:${RESET} $OLD_USERNAME"
echo -e "${BLUE}New username:${RESET} $NEW_USERNAME"
echo -e "${BLUE}Dry run:${RESET} $DRY_RUN"
echo -e "${BLUE}Verbose:${RESET} $VERBOSE"
echo

# Counter for number of updates
count=0

# Loop through all Git repositories under home
find ~ -type d -name ".git" | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    cd "$repo_dir" || continue

    # Find remotes containing the old username
    remotes=$(git remote -v | grep "$OLD_USERNAME" | awk '{print $1}' | sort | uniq)
    if [[ -n "$remotes" ]]; then
        for remote in $remotes; do
            old_url=$(git remote get-url "$remote")
            new_url=${old_url/$OLD_USERNAME/$NEW_USERNAME}

            if [ "$DRY_RUN" = true ]; then
                [ "$VERBOSE" = true ] && echo -e "${YELLOW}[DRY-RUN]${RESET} $remote: $old_url → $new_url"
            else
                git remote set-url "$remote" "$new_url"
                [ "$VERBOSE" = true ] && echo -e "${GREEN}[UPDATED]${RESET} $remote: $old_url → $new_url"
            fi

            # Increment counter
            count=$((count + 1))
        done
    fi
done

# Print summary if not verbose
if [ "$VERBOSE" = false ]; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} Total references that would be updated: $count"
    else
        echo -e "${GREEN}[UPDATED]${RESET} Total references updated: $count"
    fi
fi

