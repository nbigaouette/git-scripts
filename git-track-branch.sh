#!/bin/bash

if [[ "x$1" == "x" ]]; then
	echo "Usage: $0 branch_name"
	echo "Available branches:"
	git branch -r | sed -e "s|origin/||g" | grep -v "HEAD"
	exit
fi

RemoteBranch="$1"
echo "Checking out branch $RemoteBranch..."

git branch --track $RemoteBranch origin/$RemoteBranch
git checkout $RemoteBranch
git branch -a
