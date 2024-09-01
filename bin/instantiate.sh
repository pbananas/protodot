#!/usr/bin/env bash

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
    REPO=$1
elif [ $# -eq 2 ]; then
    DEST=$1
    REPO=$2
else
    usage
fi

DIR=$(basename $PWD)

cd ..
cp -r "$DIR" "$DEST"
cd "$DEST" || exit

sed -i 's/config\/name="_template"/config\/name="'"$REPO"'"/' project.godot
rm bin/instantiate.sh

rm -rf .git
git init
git add .
git commit -m "instantiate"
git remote add origin git@github.com:rfunduk/$REPO.git

read -p "Does the GitHub repository '$REPO' exist? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push -u origin main
else
    echo "Skipping push to GitHub. Remember to create the repository and push later."
fi

