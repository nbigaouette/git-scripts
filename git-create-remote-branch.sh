#!/bin/bash

help() {
    echo "Create a new branch on both local and remote repositories."
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


    exit
fi

RemoteBranch="$1"

col_b="\e[34;1m"
col_r="\e[31;1m"
col_g="\e[32;1m"
col_n="\e[0m"

log "Verifying that branch ${col_g}${RemoteBranch}${col_b} does NOT exist remotely..."
log "    Fetching origin..."
git fetch origin || error "Can't fetch origin!"
branches=(`git branch -a | grep remotes | grep -v HEAD | sed "s|.*/||g"`)
branch_present="false"
for branch in ${branches[*]}; do
    if [[ "${branch}" == "${RemoteBranch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "true" ]]; then
    error "Branch ${col_g}${RemoteBranch}${col_b} already exist remotely!"
fi

log "Creating remote branch ${col_g}${RemoteBranch}${col_b}..."
git push origin origin:refs/heads/$RemoteBranch \
    || error "Creating remote branch ${col_g}${RemoteBranch}${col_b} failed!"

log "Fetching origin..."
git fetch origin \
    || error "Fetching origin failed!"

log "Creating and switching to local branch ${col_g}${RemoteBranch}${col_b}..."
git checkout --track -b $RemoteBranch origin/$RemoteBranch \
    || error "Creating and switching to local branch ${col_g}${RemoteBranch}${col_b} failed!"

log "Updated list of all branches:"
git branch -a
