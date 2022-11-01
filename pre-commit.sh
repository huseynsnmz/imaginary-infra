#!/usr/bin/env bash

# uncomment for debugging the script
#set -x

# exit if any command fails
set -eo pipefail

# check required binaries
BINARIES=("terraform" "ansible" "ansible-lint")

for i in "${BINARIES[@]}"; do
    if ! [ -x "$(command -v "$i")" ]; then
        echo "ERROR: $i is not installed!" >&2
        exit 1
    fi
done


# find all changed files and compute the diff
CHANGED=$(git diff --name-only --cached --diff-filter=ACMR)

# run linter or formatter based on file extension
# (trusting pipefail for exiting when something gives an error)
case "$CHANGED" in
    *.yml)
        ansible-lint "$CHANGED";;
    *.tf|*.tfvars)
        terraform fmt "$CHANGED";;
    *) ;;
esac
