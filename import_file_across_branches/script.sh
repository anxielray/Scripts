#!bin/bash

echo "provide 4 arguments 1; repository url 2; remote branch to clone 3; file 4; local file"
# Fetch the remote branch; [$1]: Repository name. [$2]: remote branch name
git fetch $1 $2

# Get the commit hash of the latest commit on the remote branch 
COMMIT_HASH=$(git rev-parse origin/$2)

# Get the file from the remote branch and write into a new file [$3]: The name of the file that you want to copy. [$4]: The new local file.
git show $COMMIT_HASH:$3 > $4

# Make the script executable
chmod 777 $4

