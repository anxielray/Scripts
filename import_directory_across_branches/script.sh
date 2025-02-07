#!/bin/bash

git fetch origin
git checkout your-destination-branch
git diff COMMIT_HASH~1 COMMIT_HASH -- path/to/folder > folder.patch
git apply folder.patch

# second alternative; [$1]: The source-branch. [$2]: path/to/folder. [$3]: new path/to/folder
# git checkout $1 -- $2
# git add $3
# git commit -m "[Import]: Imported folder from source-branch"
