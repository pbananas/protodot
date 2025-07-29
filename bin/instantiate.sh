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

if [[ -z "$PROTODOT_GITHUB_USERNAME" ]]; then
    echo "Error: PROTODOT_GITHUB_USERNAME environment variable required"
    exit 1
fi

# Check if gh CLI is authenticated to correct account
CURRENT_GH_USER=$(gh api user --jq .login 2>/dev/null)
if [[ "$CURRENT_GH_USER" != "$PROTODOT_GITHUB_USERNAME" ]]; then
    echo "Currently authenticated as '$CURRENT_GH_USER', need '$PROTODOT_GITHUB_USERNAME'"
    read -p "Switch to $PROTODOT_GITHUB_USERNAME account? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if ! gh auth switch --user "$PROTODOT_GITHUB_USERNAME" 2>/dev/null; then
            echo "Failed to switch. Run: gh auth login --web --hostname github.com"
            echo "Then authenticate as $PROTODOT_GITHUB_USERNAME"
            exit 1
        fi
        echo "Switched to $PROTODOT_GITHUB_USERNAME"
    else
        echo "Cannot proceed without correct authentication"
        exit 1
    fi
fi

# Get name and email from authenticated GitHub user
GIT_NAME=$(gh api user --jq .name)
GIT_EMAIL=$(gh api user --jq .email)

if [[ -z "$GIT_NAME" || "$GIT_NAME" == "null" ]]; then
    echo "Error: No name found. Set PROTODOT_GIT_NAME or update GitHub profile"
    exit 1
fi

if [[ -z "$GIT_EMAIL" || "$GIT_EMAIL" == "null" ]]; then
    echo "Error: No email found. Set PROTODOT_GIT_EMAIL or make GitHub email public"
    exit 1
fi

cp -r "$DIR" "$DEST"
cd "$DEST" || exit

sed -i "" "s|config/name=\\\"_template\\\"|config/name=\\\"$REPO\\\"|" project.godot
sed -i "" "s|_template|$REPO|g" export_presets.cfg

rm bin/instantiate.sh
rm bin/diff-with-project.sh
rm -rf .git
rm -rf .godot

git init
git config core.sshCommand "ssh -i $PROTODOT_GITHUB_SSH_KEY -F /dev/null"
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_NAME"
git add .
git commit -m "instantiate"
git remote add origin git@github.com:$PROTODOT_GITHUB_USERNAME/$REPO.git

# Check if GitHub repository exists
if gh repo view $PROTODOT_GITHUB_USERNAME/$REPO >/dev/null 2>&1; then
    echo "Repository '$PROTODOT_GITHUB_USERNAME/$REPO' exists. Pushing..."
    git push -u origin main
else
    echo "Repository '$PROTODOT_GITHUB_USERNAME/$REPO' does not exist."
    read -p "Create it now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gh repo create $PROTODOT_GITHUB_USERNAME/$REPO --private
        git push -u origin main
        echo "Repository created and pushed!"
    else
        echo "Skipping GitHub setup. Remember to create the repository and push later."
    fi
fi
