#!/bin/sh
# Update all branches from the upstream repository
#
# Usage: ./update-from-upstream.sh
#
# SPDX-FileCopyrightText: 2022 Carles Fernandez-Prades <cfernandez(at)cttc.es>
# SPDX-License-Identifier: MIT

version="1.0"
branches="master langdale kirkstone honister hardknott gatesgarth dunfell zeus warrior thud sumo rocko"

if ! [ -x "$(command -v git)" ]; then
    echo "Please install git before using this script."
    exit 1
fi

display_usage() {
    echo "update-from-upstream.sh v$version - This script pulls all branches from the upstream repo."
    echo " Supported branches: $branches"   
    echo " Usage:"
    echo "  ./update-from-upstream.sh"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    display_usage
    exit 0
fi

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "push-to-repo.sh v$version"
    exit 0
fi

upstream="https://github.com/carlesfernandez/oe-gnss-sdr-manifest"
currentbranch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

if [ -z "$currentbranch" ]; then
    echo "We are not in a git repository. Exiting."
    exit 1
fi

git fetch $upstream 2> /dev/null || echo "Remote $upstream does not appear to be a valid git remote. Exiting." && exit 1

for branch in $branches; do
    git checkout "$branch" || echo "Branch $branch is not known to git. Exiting." && exit 1
    git pull $upstream "$branch" || echo "Something happened when pulling from the $branch branch. Aborting." && exit 1
done

git checkout "$currentbranch"