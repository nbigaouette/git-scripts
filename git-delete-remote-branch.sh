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
    echo "Delete a remote branch and its local tracking branch, if present."
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


    exit
fi

RemoteBranch="$1"

col_b="\e[34;1m"
col_r="\e[31;1m"
col_g="\e[32;1m"
col_n="\e[0m"

log "Suppression of local branch ${col_g}${RemoteBranch}${col_b}..."
git branch -d ${RemoteBranch} \
    || error "Suppression of local branch ${col_g}${RemoteBranch}${col_r} failed!"

log "Suppression of remote branch ${col_g}${RemoteBranch}${col_b}..."
git push origin :heads/${RemoteBranch} \
    || error "Suppression of remote branch ${col_g}${RemoteBranch}${col_b} failed!"

log "Updated list of all branches:"
git branch -a
