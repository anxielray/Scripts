# 🧾 Beginner’s Guide to the Git Commit Script

## 📌 What is this script for?

This script helps **automate your Git commit process** by:
- Prompting you interactively for useful commit details
- Collecting changes and impacts in a structured way
- Formatting the commit message in *Markdown italics*
- Showing a preview of the commit message
- Making the Git commit and pushing to your repo

---

## 🧰 Requirements

Before using this script, make sure you have:

- **Git installed**
- A **Git repository initialized** (`git init`)
- Some **staged or unstaged changes** in your working directory
- Saved the script to a file, e.g., `commit-helper.sh`
- Given it execute permission:
  ```bash
  chmod +x commit-helper.sh
```

Then you can run it with:

```sh
./commit-helper.sh
```

## 🔍 Step-by-Step Breakdown of the Script

### 1. 👋 Prompting the User

```sh
read -p "Component (e.g., refactor(rectangle, triangle)): " COMPONENT
read -p "Summary (short description of the change): " SUMMARY
```



- `read -p` shows a prompt and saves the user input.

-  `COMPONENT:` Describes the type and scope of the commit (e.g., fix(button), feat(api))

- `SUMMARY:` A brief message, like “fix input border glitch”

### 2. 📝 Collecting List of Changes

```sh
echo ""
echo "Enter the list of changes (type 'done' to finish):"
CHANGES=()
while true; do
    read -p "- " CHANGE
    [[ "$CHANGE" == "done" ]] && break
    CHANGES+=("$CHANGE")
done
```

- Prompts the user to enter each change one by one.

- Typing done ends the input.

- Entries are saved into the CHANGES array.

✅ Example Input:

```sh
- Refactored rectangle logic
- Improved triangle rendering
- done
```

### 3. 💥 Collecting List of Impacts

```sh
echo ""
echo "Enter the list of impacts (type 'done' to finish):"
IMPACTS=()
while true; do
    read -p "- " IMPACT
    [[ "$IMPACT" == "done" ]] && break
    IMPACTS+=("$IMPACT")
done
```

- Similar to changes, but for describing consequences or results of the changes.

- Saved into the IMPACTS array.

✅ Example Input:

```sh
- Improved performance
- Might break existing triangle usage
- done
```

### 4. 📊 Git Diff Stats

```sh
STATS=$(git diff --shortstat)
FILES_CHANGED=$(echo "$STATS" | grep -o '[0-9]* file' | grep -o '[0-9]*')
INSERTIONS=$(echo "$STATS" | grep -o '[0-9]* insertions' | grep -o '[0-9]*')
DELETIONS=$(echo "$STATS" | grep -o '[0-9]* deletions' | grep -o '[0-9]*')
```

- Analyzes what has changed in the repo.

- Extracts:

   - Number of files changed

   - Insertions

   - Deletions

### 5. 🆔 Getting the Commit Hash

```sh
COMMIT_HASH=$(git rev-parse --short HEAD)
```

- Retrieves the short hash of the latest commit.

- This is included in the final commit message.


### 6. ✍️ Building the Commit Message

```sh
FULL_MESSAGE="_${COMPONENT}: ${SUMMARY}_\n\n"
FULL_MESSAGE+="_Changes:_\n"
for CHANGE in "${CHANGES[@]}"; do
    FULL_MESSAGE+="_- $CHANGE_\n"
done

FULL_MESSAGE+="\n_Impact:_\n"
for IMPACT in "${IMPACTS[@]}"; do
    FULL_MESSAGE+="_- $IMPACT_\n"
done

FULL_MESSAGE+="\n_${FILES_CHANGED:-0} files changed, ${INSERTIONS:-0} insertions(+), ${DELETIONS:-0} deletions(-)_\n"
FULL_MESSAGE+="_🔗 Commit Hash: $COMMIT_HASH_"
```

- Builds a Markdown-formatted commit message:

  - Italic style using underscores _

  - Bullet points for changes and impacts

  - Git diff stats

  - Commit hash

### 7. 👀 Preview the Commit Message

```sh
echo -e "\nFinal Commit Message:\n"
echo -e "$FULL_MESSAGE"
```

- Displays the generated message for you to review before proceeding.

### 8. ✅ Confirm and Proceed


```sh
read -p "Do you want to proceed with this commit? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Commit canceled."
    exit 1
fi
```

- Lets you cancel if the preview isn't right.

### 9. 📤 Commit and Push

```sh
git add .
git commit -m "$FULL_MESSAGE"
git push
```



- Stages all changes (git add .)

- Commits with the generated message

- Pushes to the current remote branch

### 10. 🥳 Done!

```sh
echo -e "\n✅ Changes committed and pushed successfully!"
```

- Prints confirmation message

### 🚀 Example Output

```sh
Component (e.g., refactor(rectangle, triangle)): feat(math)
Summary (short description of the change): added new geometry utils
Enter the list of changes (type 'done' to finish):
- Added `calculateArea` function
- Updated `isTriangle` logic
- done

Enter the list of impacts (type 'done' to finish):
- Increased test coverage
- Small performance gain
- done
```

Final Commit Message Preview:

```markdown
feat(math): added new geometry utils

Changes:
- Added `calculateArea` function
- Updated `isTriangle` logic

Impact:
- Increased test coverage
- Small performance gain

2 files changed, 24 insertions(+), 2 deletions(-)
🔗 Commit Hash: ab12cd3
```

## 🧠 Pro Tips

- Use this script to standardize your commits across a team

- You can modify the formatting style (e.g., use bold or emojis)

- Integrate with a pre-commit hook for automation


### 🧼 To Reset

- If you want to run again but cancel midway, just press Ctrl+C anytime before confirming the commit.

