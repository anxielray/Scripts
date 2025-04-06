#!/bin/bash

# Prompt user for input
read -p "Component (e.g., refactor(rectangle, triangle)): " COMPONENT
read -p "Summary (short description of the change): " SUMMARY

echo ""
echo "Enter the list of changes (type 'done' to finish):"
CHANGES=()
while true; do
    read -p "- " CHANGE
    [[ "$CHANGE" == "done" ]] && break
    CHANGES+=("$CHANGE")
done

echo ""
echo "Enter the list of impacts (type 'done' to finish):"
IMPACTS=()
while true; do
    read -p "- " IMPACT
    [[ "$IMPACT" == "done" ]] && break
    IMPACTS+=("$IMPACT")
done

# Get git diff stats
STATS=$(git diff --shortstat)
FILES_CHANGED=$(echo "$STATS" | grep -o '[0-9]* file' | grep -o '[0-9]*')
INSERTIONS=$(echo "$STATS" | grep -o '[0-9]* insertions' | grep -o '[0-9]*')
DELETIONS=$(echo "$STATS" | grep -o '[0-9]* deletions' | grep -o '[0-9]*')

# Get latest commit hash
COMMIT_HASH=$(git rev-parse --short HEAD)

# Construct full commit message
FULL_MESSAGE="_${COMPONENT}: ${SUMMARY}
\n"
FULL_MESSAGE+="_Changes:
"
for CHANGE in "${CHANGES[@]}"; do
    FULL_MESSAGE+="_- $CHANGE
    "
done

FULL_MESSAGE+="
Impact:"
for IMPACT in "${IMPACTS[@]}"; do
    FULL_MESSAGE+="- $IMPACT
    "
done

FULL_MESSAGE+="
${FILES_CHANGED:-0} files changed, ${INSERTIONS:-0} insertions(+), ${DELETIONS:-0} deletions(-)
"
FULL_MESSAGE+="_🔗 Commit Hash: $COMMIT_HASH_"

# Show preview
echo -e "\nFinal Commit Message:\n"
echo -e "$FULL_MESSAGE"

# Confirm before committing
read -p "Do you want to proceed with this commit? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Commit canceled."
    exit 1
fi

# Stage all changes
git add .

# Commit using the full message
git commit -m "$FULL_MESSAGE"

# Push to remote
git push

echo -e "\n✅ Changes committed and pushed successfully!"
