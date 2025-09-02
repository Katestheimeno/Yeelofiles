
#!/bin/env bash

# Usage:
# ./update_git_usernames.sh OLD_USERNAME NEW_USERNAME [--dry-run]

OLD_USERNAME=$1
NEW_USERNAME=$2
DRY_RUN=false

if [[ "$3" == "--dry-run" ]]; then
    DRY_RUN=true
fi

if [[ -z "$OLD_USERNAME" || -z "$NEW_USERNAME" ]]; then
    echo "Usage: $0 OLD_USERNAME NEW_USERNAME [--dry-run]"
    exit 1
fi

echo "Old username: $OLD_USERNAME"
echo "New username: $NEW_USERNAME"
echo "Dry run: $DRY_RUN"
echo

# Loop through all Git repositories under home
find ~ -type d -name ".git" | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    cd "$repo_dir" || continue
    echo "Checking remotes in $repo_dir"

    git remote -v | grep "$OLD_USERNAME" | awk '{print $1}' | while read remote; do
        old_url=$(git remote get-url "$remote")
        new_url=${old_url/$OLD_USERNAME/$NEW_USERNAME}

        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] $remote: $old_url → $new_url"
        else
            git remote set-url "$remote" "$new_url"
            echo "[UPDATED] $remote: $old_url → $new_url"
        fi
    done
    echo
done
