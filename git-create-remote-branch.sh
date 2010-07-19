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
