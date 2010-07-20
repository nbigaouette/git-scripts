#!/bin/bash

# Copyright 2009 Nicolas Bigaouette <nbigaouette @t gmail com>
# This file is part of git-scripts.
# http://github.com/nbigaouette/git-scripts
#
# git-scripts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# git-scripts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with git-scripts. If not, see <http://www.gnu.org/licenses/>.

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
    echo " "
    echo "Existing branches:"
    git branch -a
    exit
fi

RemoteBranch="$1"

col_b="\e[34;1m"
col_r="\e[31;1m"
col_g="\e[32;1m"
col_n="\e[0m"

log "Verifying that branch ${col_g}${RemoteBranch}${col_b} does NOT exist remotely..."
cmd="git fetch origin"
log "Fetching origin: ${col_g}${cmd}"
$cmd || error "Can't fetch origin!"
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

cmd="git push origin origin:refs/heads/$RemoteBranch"
log "Creating remote branch ${col_g}${RemoteBranch}${col_b}: ${col_g}${cmd}"
$cmd || error "Creating remote branch ${col_g}${RemoteBranch}${col_b} failed!"

cmd="git fetch origin"
log "Fetching origin: ${col_g}${cmd}"
$cmd || error "Fetching origin failed!"

cmd="git checkout --track -b $RemoteBranch origin/$RemoteBranch"
log "Creating and switching to local branch ${col_g}${RemoteBranch}${col_b}: ${col_g}${cmd}"
$cmd || error "Creating and switching to local branch ${col_g}${RemoteBranch}${col_b} failed!"

cmd="git branch -a"
log "Updated list of all branches: ${col_g}${cmd}"
$cmd

