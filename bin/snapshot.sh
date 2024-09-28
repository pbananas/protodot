#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

if ! git diff-index --quiet HEAD --; then
  echo "No changes."
  exit 0
fi

MSG="${1:-wip}"

git add .
git commit -m "$MSG"

if git ls-remote --exit-code origin > /dev/null 2>&1; then
    git push -u origin
fi
