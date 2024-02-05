#!/bin/bash

# Usage check for new arguments pattern
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 --from <from_version> --to <to_version>"
    exit 1
fi

# Parse command line arguments for --from and --to flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --from) FROM_VERSION="$2"; shift ;;
        --to) TO_VERSION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

DATE=$(date +%m-%d) # Gets current date in mm-dd format
BRANCH_NAME="feature/update-to-latest-$DATE" # Include a hyphen before the date

# Path to the directories containing all monorepos
MONOREPOS_DIR=~/clearlink/sites

# Initialize an empty array to hold update summaries
declare -a UPDATE_SUMMARY

# Function to check if package.json contains the from version, accounting for the caret
contains_from_version() {
    jq -e --arg version "$FROM_VERSION" '
        .dependencies | to_entries | .[] | select(.value | test("\\^" + $version))' package.json > /dev/null
}

# Function to add color
color_text() {
  echo -e "\033[$1m$2\033[0m"
}

# Loop through each monorepo in ~/clearlink/sites
for MONOREPO in "$MONOREPOS_DIR"/*; do
    if [ -d "$MONOREPO/sites" ]; then # Ensure it has a 'sites' directory
        # Loop through each child site within the monorepo
        for SITE in "$MONOREPO/sites"/*; do
            if [ -d "$SITE" ]; then
              SITE_NAME=$(basename "$SITE")

                echo "Checking site: $SITE_NAME"
                cd "$SITE"

                # Optional: Stash current changes to ensure a clean state
                git stash push -m "Pre-update stash $(date)"

                # Ensure you're on the master branch and pull the latest changes
                git checkout master
                git pull origin master

                # Now check if the 'package.json' contains the "from" version
                if contains_from_version; then
                    echo "$(color_text "32" "✅ Updating site:") $SITE_NAME from $(color_text "31" "$FROM_VERSION") to $(color_text "32" "$TO_VERSION")"
                    if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
                        git branch -D "$BRANCH_NAME"
                    fi
                    git checkout -b "$BRANCH_NAME"
                    # Update package.json
                    jq --arg to_version "^$TO_VERSION" '(.dependencies["@leshen/gatsby-source-brandy"], .dependencies["@leshen/gatsby-source-dataset-manager"], .dependencies["@leshen/gatsby-theme-contentful"], .dependencies["@leshen/gatsby-theme-leshen"], .dependencies["@leshen/ui"]) |= $to_version' package.json > temp.json && mv temp.json package.json

                    # Add the site and version update info to the summary
                    UPDATE_SUMMARY+=("$SITE_NAME: $(color_text "31" "$FROM_VERSION") to $(color_text "32" "$TO_VERSION")")
                else
                    echo "$(color_text "33" "🚫 Skipping site:") $SITE_NAME, does not match version $FROM_VERSION"
                fi
            fi
        done
        # After updating all applicable child sites within the monorepo, run yarn and git commands at the monorepo level
        cd "$MONOREPO"
        yarn
        git add .
        git commit -m "Updating sites from version $FROM_VERSION to $TO_VERSION"
        # Check if the remote branch exists
        if git ls-remote --heads origin "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
            echo "$(color_text "33" "🗑️ Deleting existing remote branch: $BRANCH_NAME")"
            git push origin --delete "$BRANCH_NAME"
        fi
        # Push the new branch to the remote repository
        echo "Pushing changes to the remote repository"
        git push origin "$BRANCH_NAME"
    fi
done

# Print the update summary
echo "$(color_text "36" "📄 Update Summary:")"
for SUMMARY in "${UPDATE_SUMMARY[@]}"; do
    echo "- $SUMMARY"
done

