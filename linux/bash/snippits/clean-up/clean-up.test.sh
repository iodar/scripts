#!/bin/bash
# test script for clean-up.sh script

# font attributes
NORMAL="\e[0m"
BOLD="\e[1m"

# colors
DEFAULT="\e[39m"
GREEN="\e[32m"
RED="\e[31m"

# get dir of script and change into
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

# before: create folders to test script
./test-prep.sh

# testrun: execute script
./clean-up.sh --number-of-elements 3 --path .

# assert: only the newest 3 acrhives should remain
REMAINING_ARCHIVES=($(ls *.zip -1 --sort=time))
if [[ ${#REMAINING_ARCHIVES[@]} -eq 3 ]]; then
    echo -e -n "$BOLD$GREEN"
    echo -e -n "Test succesfully run $NORMAL $DEFAULT"
else 
    echo -e -n "$BOLD$RED"
    echo -e -n "Test failed $NORMAL $DEFAULT"
fi

# clean up after run
for archive in ${REMAINING_ARCHIVES[@]}; do
    rm $archive
done

echo -e "$NORMAL $DEFAULT"