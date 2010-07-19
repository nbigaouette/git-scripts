#!/bin/bash

RemoteBranch="$1"
echo "Creating remote branch $1..."

git push origin implicit:refs/heads/$RemoteBranch
git fetch origin
git branch --track $RemoteBranch origin/$RemoteBranch
git checkout $RemoteBranch
