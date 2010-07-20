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
    log "Publish the local branch to remote repository for '${col_c}git push${col_b}'."
}

source `dirname $0`/git-common.sh

branch="$1"
remote="${2-origin}"

verify_if_remote_exist ${remote}

cmd="git push ${remote} ${branch}:refs/heads/${branch}"
log "Creating new remote branch ${col_g}${branch}${col_b} on ${col_g}${remote}${col_b}: ${col_c}${cmd}"
$cmd || error "Creation of new remote branch ${col_g}${branch}${col_r} on ${col_g}${remote}${col_r} failed!"

cmd="git config branch.${branch}.remote ${remote}"
log "Configuring local branch ${col_g}${branch}${col_b}'s remote as ${col_g}${remote}/${branch}${col_b}: ${col_c}${cmd}"
$cmd || error "Configuring local branch ${col_g}${branch}${col_r}'s remote as ${col_g}${remote}/${branch}${col_r} failed!"

cmd="git config branch.${branch}.merge refs/heads/${branch}"
log "Telling git to merge the remote branch ${col_g}${branch}${col_b} when pulling: ${col_c}${cmd}"
$cmd || error "Telling git to merge the remote branch ${col_g}${branch}${col_r} when pulling failed!"


