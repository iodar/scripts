#!/bin/bash
# test script for clean-up.sh script

# font attributes
NORMAL="\e[0m"
BOLD="\e[1m"

# colors
DEFAULT="\e[39m"
GREEN="\e[32m"
RED="\e[31m"

# Test results and test names
TEST_NAMES=()
TEST_RESULTS=()

function getTestNames() {
    TEST_NAMES+=($(grep '^function test_' $0 | awk '{print $2}' | sed 's|()||'))
}

function normaliseTestResult() {
    TEST_RESULT_CODE="$1"
    
    case "$TEST_RESULT_CODE" in
        0)
        echo -n " ... OK"
        shift
        ;;
        *)
        echo -n " ... FAILED"
        shift
        ;;
    esac
}

# get dir of script and change into
function changeIntoCurrentDir() {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    cd "$DIR"
}

function setColorSuccessful() {
    echo -e -n "$BOLD$GREEN"
}

function setColorFailed() {
    echo -e -n "$BOLD$RED"
}

function resetColorAndFontFormat() {
    echo -e -n "$NORMAL$DEFAULT"
}

function test_scriptShouldRemoveAllArchivesExceptConfiguredAmount() {
    # before: create folders to test script
    ./test-prep.sh

    # testrun: execute script
    ./clean-up.sh --number-of-elements 3 --path .

    # assert: only the newest 3 acrhives should remain
    REMAINING_ARCHIVES=($(ls *.zip -1 --sort=time))
    if [[ ${#REMAINING_ARCHIVES[@]} -eq 3 ]]; then
        # setColorSuccessful
        # echo -e -n "Test succesfully run"
        # resetColorAndFontFormat
        local TEST_RESULT=0
    else
        # setColorFailed
        # echo -e -n "Test failed"
        # resetColorAndFontFormat
        local TEST_RESULT=1
    fi

    # clean up after run
    for archive in ${REMAINING_ARCHIVES[@]}; do
        rm $archive
    done

    return $TEST_RESULT
}

function runTests() {
    getTestNames
    changeIntoCurrentDir
    TEST_RESULTS+=($(test_scriptShouldRemoveAllArchivesExceptConfiguredAmount; echo $?))
}

function printTestResults() {
    local LAST_INDEX_OF_TEST_RESULTS=$(expr ${#TEST_RESULTS[@]} - 1)
    local ALL_TEST_SEQ=$(seq 0 $LAST_INDEX_OF_TEST_RESULTS)
    for TEST_INDEX in $ALL_TEST_SEQ; do
        local TEST_NAME=${#TEST_NAMES[TEST_INDEX]}
        local TEST_RESULT=${#TEST_RESULTS[TEST_INDEX]}
        setColorSuccessful
        echo -e "$TEST_NAME$TEST_RESULT"
        resetColorAndFontFormat
    done
}

runTests
printTestResults