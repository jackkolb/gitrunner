#!/bin/bash

# save current directory
ROOT_DIR="$(pwd)"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting gitrunner (firstrun: $firstrun)"

# check if required files exist
if [[ ! -f repositories.txt ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: repositories.txt not found."
    exit 1
fi

if [[ ! -f proc.txt ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: proc.txt not found."
    exit 1
fi

# loop over each repo listed in repositories.txt
while IFS= read -r repo || [[ -n "$repo" ]]; do
    # set the runproc flag
    runproc=false
    if [[ "$repo" == \** ]]; then
        repo="${repo#\*}"   # Remove the leading '*'
        if [[ "$firstrun" == true ]]; then
            runproc=true           # Set the other variable to true
        fi
    fi

    # skip empty lines
    [[ -z "$repo" ]] && continue

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Processing repository: $repo"

    REPO_PATH="$ROOT_DIR/$repo"

    if [[ ! -d "$REPO_PATH" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Warning: Directory $repo does not exist. Skipping."
        continue
    fi

    cd "$REPO_PATH" || continue

    # run git pull and capture output
    PULL_OUTPUT=$(git pull)

    echo "$PULL_OUTPUT"

    if [[ "$PULL_OUTPUT" == *"Already up to date."* || "$PULL_OUTPUT" == *"Already up-to-date."* ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No changes in $repo."
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Changes detected in $repo."
        runproc=true
    fi

    if [[ "$runproc" == true ]]; then
        # find matching line in proc.txt
        PROC_CMD=$(grep "^$repo:" "$ROOT_DIR/proc.txt" | cut -d':' -f2-)

        if [[ -n "$PROC_CMD" ]]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running command for $repo: $PROC_CMD"
            eval "$PROC_CMD"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] No command found in proc.txt for $repo."
        fi
    fi

    # return to root directory
    cd "$ROOT_DIR" || exit 1

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Finished processing $repo"

done < repositories.txt
