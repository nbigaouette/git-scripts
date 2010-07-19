#!/bin/bash

help() {
    echo "Delete a remote branch and its local tracking branch, if present."
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

log "Suppression of local branch ${col_g}${RemoteBranch}${col_b}..."
git branch -d ${RemoteBranch} || error "Suppression of local branch ${col_g}${RemoteBranch}${col_r} failed!"

log "Suppression of remote branch ${col_g}${RemoteBranch}${col_b}..."
git push origin :heads/${RemoteBranch} || error "Suppression of remote branch failed!"

log "Updated list of all branches:"
git branch -a
