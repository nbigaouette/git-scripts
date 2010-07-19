#!/bin/bash

help() {
    echo "Create a new branch on both local and remote repositories."
}

if [[ -z "$1" ]]; then
    help
    echo "Usage:"
    echo "$ `basename $0` branch_name"
    exit
fi

RemoteBranch="$1"
echo "Creating remote branch $RemoteBranch..."

git push origin origin:refs/heads/$RemoteBranch
git fetch origin
#git branch --track $RemoteBranch origin/$RemoteBranch
#git checkout $RemoteBranch
git checkout --track -b $RemoteBranch origin/$RemoteBranch
git branch -a
