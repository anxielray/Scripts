# Check what's too big
git log --oneline --graph --all -10
git ls-tree -r -t -l --full-name HEAD | sort -nr | head -10

# Push recent commits only
git push origin HEAD~5:main  # Last 5 commits
git push origin main         # Now full history
