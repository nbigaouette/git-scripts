#!/bin/bash

RemoteBranch="$1"
echo "Creating remote branch $RemoteBranch..."

git push origin origin:refs/heads/$RemoteBranch
git fetch origin
#git branch --track $RemoteBranch origin/$RemoteBranch
#git checkout $RemoteBranch
git checkout --track -b $RemoteBranch origin/$RemoteBranch
git branch -a
