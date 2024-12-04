#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

usage() {
    echo "Usage: $0 [DEST_DIR] [GITHUB_REPO]"
    echo "  DEST_DIR: Destination directory name (required)"
    echo "  GITHUB_REPO: GitHub repository name (optional, defaults to DEST_DIR)"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
elif [ $# -eq 1 ]; then
    DEST=$1
    REPO=$(basename $1)
elif [ $# -eq 2 ]; then
    DEST=$1
    REPO=$2
else
    usage
fi

cp -r "$DIR" "$DEST"
cd "$DEST" || exit

sed -i "" "s|config/name=\\\"_template\\\"|config/name=\\\"$REPO\\\"|" project.godot

rm bin/instantiate.sh
rm bin/diff-with-project.sh
rm -rf .git
rm -rf .godot

git init
git config user.email "itspetebananas@gmail.com"
git config user.name "pbananas"
git add .
git commit -m "instantiate"
git remote add origin git@github.com:pbananas/$REPO.git

read -p "Does the GitHub repository '$REPO' exist? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push -u origin main
else
    echo "Skipping push to GitHub. Remember to create the repository and push later."
fi
