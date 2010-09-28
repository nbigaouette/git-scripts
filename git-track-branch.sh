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

function git-scripts-help() {
    branch=${1}
    remote=${2}
    log "Create a new local branch that tracks changes in a remote repository."
    log "Details:"
    log "  \$ ${col_c}git fetch ${remote}${col_b}"
    log "If branch does not exist:"
    log "  \$ ${col_c}git branch --track ${branch} ${remote}/${branch}${col_b}"
    log "If branch does exist:"
    log "  \$ ${col_c}git branch --set-upstream ${branch} ${remote}/${branch}${col_b}"
}

source `dirname $0`/git-common.sh

# Dry run (-v = verbose, -n = rsync's dry-run, -p = Gentoo's 'pretend')
if [[ "$1" == "--dry-run" || "$1" == "-v" || "$1" == "-n" || "$1" == "-p" ]]; then
    git-scripts-help ${2-BRANCH} ${3-origin}
    exit
fi

branch="$1"
remote="${2-origin}"

verify_if_remote_exist ${remote}

log "Verifying that branch ${col_g}${branch}${col_b} exist remotely..."
cmd="git fetch ${remote}"
log "Fetching ${remote}: ${col_c}${cmd}"
$cmd || error "Can't fetch ${remote}!"
branches=(`git branch -r | grep -v HEAD | sed "s|.*/||g"`)
branch_present="false"
for b in ${branches[*]}; do
    if [[ "${b}" == "${branch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "false" ]]; then
    error "Branch ${col_g}${branch}${col_r} does not exist remotely!"
fi

log "Verifying that branch ${col_g}${branch}${col_b} does not exist locally..."
branches=(`git branch | sed "s|.* ||g"`)
branch_present="false"
for b in ${branches[*]}; do
    if [[ "${b}" == "${branch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "true" ]]; then
    log "${col_r}Branch ${col_g}${branch}${col_r} exist locally!${col_n}"
    log "Do you want to set it so it tracks the remote branch? [y/N]"
    read answer
    if [[ "${answer}" != "y" && "${answer}" != "yes" ]]; then
        log "Exiting."
        exit
    fi

    cmd="git branch --set-upstream ${branch} ${remote}/${branch}"
    log "Setting local branch to track remote one: ${col_c}${cmd}"
    $cmd || error "Setting branch ${branch} to track remote one failed!"
else
    cmd="git branch --track ${branch} ${remote}/${branch}"
    log "Creating local branch ${col_g}${branch}${col_b} to track remote branch: ${col_c}${cmd}"
    $cmd || error "Creation of local tracking branch ${col_g}${branch}${col_b} failed!"
fi

cmd="git checkout ${branch}"
log "Switching to local branch ${col_g}${branch}${col_b}: ${col_c}${cmd}"
$cmd || error "Checkout of local branch ${col_g}${branch}${col_b} failed!"

cmd="git branch -a"
log "Updated list of all branches: ${col_c}${cmd}"
$cmd
