#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# Check if all required arguments are provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <project_dir>"
    exit 1
fi

PROJECT_DIR=$1

EXCLUDE_FILES="project.godot"
EXCLUDE_DIRS=".git .godot addons"

build_find_command() {
    cmd="find \"$1\" "

    for dir in $EXCLUDE_DIRS; do
        cmd="$cmd -path \"*/$dir\" -prune -o"
    done

    for file in $EXCLUDE_FILES; do
        cmd="$cmd -name \"$file\" -prune -o"
    done

    cmd="$cmd -type f -print"
    echo "$cmd"
}

find_cmd=$(build_find_command "$DIR")

# Find files in the template directory and compare them with the project directory
eval "$find_cmd" | while read -r template_file; do
    # Get the relative path of the file
    rel_path="${template_file#$DIR/}"
    project_file="$PROJECT_DIR/$rel_path"

    echo "Comparing:"
    echo "  Template: $template_file"
    echo "  Project:  $project_file"

    # Check if the file exists in the project directory
    if [ -f "$project_file" ]; then
        # Perform diff and output if there are differences
        if ! cmp -s "$template_file" "$project_file"; then
            echo "Differences found in: $rel_path"
            diff -u "$template_file" "$project_file"
            echo
        fi
    fi
done
