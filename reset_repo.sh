#!/usr/bin/env bash
BRANCH=$1
if [ "${BRANCH}" = "" ]; then
    echo 'Must specify branch!'
    exit
fi
UPPER_BRANCH=`echo "${BRANCH}" | tr [a-z] [A-Z]`
UPPER_TAGS=`git tag --list "${UPPER_BRANCH}*"`

TAGS=`git tag --list  "${BRANCH}*"`
TAGS+=${UPPER_TAGS[@]}

if [ "${BRANCH}" = "cism" ]; then
    GLC_TAGS=`git tag --list glc*`
    TAGS=( "${TAGS[@]}" ${GLC_TAGS[@]} )
    echo ${TAGS}
fi

# ROOT_CHANGESET=68ed9d5b728

# ww3 specific license file
ROOT_CHANGESET=6ce7fc207a2cd152e

for tag in ${TAGS[@]}; do
    git tag -d ${tag}
done

git add --update
git stash
git checkout ${BRANCH}
git reset --hard ${ROOT_CHANGESET}
git checkout master
git reset --hard ${ROOT_CHANGESET}
git checkout cesm2git
git stash pop
git add --update

