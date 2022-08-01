#!/usr/bin/env bash

set -eux pipefail

BRANCH_TO_DELETE=`git branch --show-current`
MAIN_EXISTS=`git show-ref refs/heads/main`
if [ -n "$MAIN_EXISTS" ]; then
  git switch main
else
  git switch master
fi

git pull

if [ -f yarn.lock ]; then
  yarn
fi

echo ""
git remote prune origin
git branch -D "$BRANCH_TO_DELETE"
git branch

