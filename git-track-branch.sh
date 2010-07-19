#!/bin/bash

help() {
    echo "Create a new local branch that tracks changes in a remote repository."
}

error() {
    echo -e "\e[31;1mERROR: $@"
    exit
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
echo "Checking out branch $RemoteBranch..."

git branch --track $RemoteBranch origin/$RemoteBranch
git checkout $RemoteBranch
git branch -a
