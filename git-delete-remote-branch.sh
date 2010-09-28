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
    log "Delete a remote branch and its local tracking branch, if present."
    log "Details:"
    log "  \$ ${col_c}git push ${remote} :heads/${branch}${col_b}"
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

log "Verifying that branch ${col_g}${branch}${col_b} exist locally..."
branches=(`git branch | sed "s|.* ||g"`)
branch_present="false"
for b in ${branches[*]}; do
    if [[ "${b}" == "${branch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "true" ]]; then
    log "Local branch ${col_g}${branch}${col_b} exist. Do you want to delete it? [y/N]"
    read answer
    if [[ "${answer}" == "y" || "${answer}" == "yes" ]]; then
        cmd="git checkout master"
        log "Making sure we are on branch \"master\": ${col_c}${cmd}"
        $cmd || error "Going to branch \"master\" failed!"

        cmd="git branch -d ${branch}"
        log "Suppression of local branch ${col_g}${branch}${col_b}: ${col_c}${cmd}"
        $cmd || error "Suppression of local branch ${col_g}${branch}${col_r} failed!"
    fi
else
    log "Local branch ${col_g}${branch}${col_b} does not exist. Continuing."
fi

cmd="git fetch ${remote}"
log "Fetching ${remote}: ${col_c}${cmd}"
$cmd || error "Can't fetch ${remote}!"

branches=(`git branch -r | grep ${remote} | grep -v HEAD | sed "s|.*/||g"`)
branch_present="false"
for b in ${branches[*]}; do
    if [[ "${b}" == "${branch}" ]]; then
        branch_present="true"
    fi
done
if [[ "${branch_present}" == "false" ]]; then
    error "Branch ${col_g}${branch}${col_r} does not exist remotely!" "dont_exit"
    git branch -a
    exit
fi

cmd="git push ${remote} :heads/${branch}"
log "Suppression of remote branch ${col_g}${branch}${col_b}: ${col_c}${cmd}"
$cmd || error "Suppression of remote branch ${col_g}${branch}${col_r} failed!"

cmd="git branch -a"
log "Updated list of all branches: ${col_c}${cmd}"
$cmd
