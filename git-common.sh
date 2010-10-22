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

col_b="\e[34;1m"
col_r="\e[31;1m"
col_g="\e[32;1m"
col_c="\e[36;1m"
col_n="\e[0m"

function log() {
    echo -e "${col_b}$@${col_n}"
}

function error() {
    echo -e "${col_r}ERROR: $1${col_n}" 1>&2
    [[ "$2" != "dont_exit" ]] && exit
}

function git-scripts-usage() {
    log "Usage:"
    log "$ ${col_c}`basename $0` branch_name remote_name${col_n}"
    log "By default (if not given), \"remote_name\" is \"origin\" but could be something else."
    log " "
    log "Existing (local) branches:"
    git branch
    log "Existing remote branches:"
    remotes=(`git remote`)
    if [[ "${#remotes[*]}" == 0 ]]; then
        echo "None"
    fi
    for r in ${remotes[*]}; do
        log "  On remote \"${col_g}${r}${col_b}\":"
        git fetch ${r}
        remote_branches=(`git branch -r | grep -v HEAD | grep " ${r}" | sed "s|.*/||g"`)
        if [[ "${#remote_branches[*]}" == 0 ]]; then
            echo "    None"
        fi
        for b in ${remote_branches[*]}; do
            log "    ${col_g}${b}"
        done
    done
    [[ "$1" != "dont_exit" ]] && exit
}

function verify_if_remote_exist()
{
    remote="$1"

    git remote prune ${remote}

    log "Verifying if a remote \"${col_g}${remote}${col_b}\" exist"
    remotes=(`git remote`)
    remote_exist="false"
    for r in ${remotes[*]}; do
        if [[ "$r" == "${remote}" ]]; then
            remote_exist="true"
        fi
    done
    if [[ "${remote_exist}" == "true" ]]; then
        log "Remote \"${col_g}${remote}${col_b}\" exist. Continuing."
    else
        error "Remote \"${col_g}${remote}${col_r}\" does not exist." "dont_exit"
        cmd="git remote"
        log "Available remotes:"
        echo "$ ${cmd}"
        $cmd
        exit
    fi
}

[[ -z "$1" ]]  && git-scripts-usage
