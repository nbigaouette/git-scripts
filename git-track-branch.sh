#!/bin/bash

help() {
    echo "Create a new local branch that tracks changes in a remote repository."
}

error() {
    echo -e "${col_r}ERROR: $@${col_n}"
    exit
}

log() {
    echo -e "${col_b}$@${col_n}"
}

if [[ -z "$1" ]]; then
    help
    echo "Usage:"
    echo "$ `basename $0` branch_name"
    echo "Available branches:"
    git branch -r | sed -e "s|origin/||g" | grep -v "HEAD"
    exit
fi

RemoteBranch="$1"

col_b="\e[34;1m"
col_r="\e[31;1m"
col_g="\e[32;1m"
col_n="\e[0m"

log "Verifying that branch ${col_g}${RemoteBranch}${col_b} exist remotely..."
branches=(`git branch -a | grep remotes | grep -v HEAD | sed "s|.*/||g"`)
branch_present="false"
for branch in ${branches[*]}; do
    if [[ "${branch}" == "${RemoteBranch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "false" ]]; then
    error "Branch ${col_g}${RemoteBranch}${col_b} does not exist remotely!"
fi

log "Creating local branch ${col_g}${RemoteBranch}${col_b} to track remote branch..."
git branch --track $RemoteBranch origin/$RemoteBranch \
    || error "Creation of local tracking branch ${col_g}${RemoteBranch}${col_b} failed!"

log "Switching to local branch ${col_g}${RemoteBranch}${col_b}..."
git checkout $RemoteBranch \
    || error "Checkout of local branch ${col_g}${RemoteBranch}${col_b} failed!"

log "Updated list of all branches:"
git branch -a
