#!/bin/bash

help() {
    echo "Delete a remote branch and its local tracking branch, if present."
}

error() {
    echo -e "\e[31;1mERROR: $@"
    exit
}

if [[ -z "$1" ]]; then
    help
    echo "Usage:"
    echo "$ `basename $0` branch_name"
    exit
fi

RemoteBranch="$1"

b="\e[34;1m"

echo -e "${b}Suppression of local branch ${RemoteBranch}...\e[0m"
git branch -d ${RemoteBranch} || error "Suppression of local branch failed!"

echo -e "${b}Suppression of remote branch ${RemoteBranch}...\e[0m"
git push origin :heads/${RemoteBranch} || error "Suppression of remote branch failed!"

echo -e "${b}Updated list of all branches:\e[0m"
git branch -a
