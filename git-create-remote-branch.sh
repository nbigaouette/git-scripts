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
    log "Create a new branch on both local and remote repositories."
}

source `dirname $0`/git-common.sh

branch="$1"
remote="${2-origin}"

verify_if_remote_exist ${remote}

log "Verifying that branch ${col_g}${branch}${col_b} does NOT exist remotely..."
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
if [[ "${branch_present}" == "true" ]]; then
    error "Branch ${col_g}${branch}${col_r} already exist remotely!"
fi

cmd="git push ${remote} ${remote}:refs/heads/$branch"
log "Creating remote branch ${col_g}${branch}${col_b}: ${col_c}${cmd}"
$cmd || error "Creating remote branch ${col_g}${branch}${col_b} failed!"

cmd="git fetch ${remote}"
log "Fetching ${remote}: ${col_c}${cmd}"
$cmd || error "Fetching ${remote} failed!"

cmd="git checkout --track -b $branch ${remote}/$branch"
log "Creating and switching to local branch ${col_g}${branch}${col_b}: ${col_c}${cmd}"
$cmd || error "Creating and switching to local branch ${col_g}${branch}${col_b} failed!"

cmd="git branch -a"
log "Updated list of all branches: ${col_c}${cmd}"
$cmd

