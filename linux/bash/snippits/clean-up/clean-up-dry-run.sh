#!/bin/bash
# shell script to clean up file sorted by date

# global options
EXTENSION=".zip"

# parse cmd line arguments
function parse-args() {
    # array that saves all unrecognized cmd line options
    NOT_RECOGNIZED_ARGS=()
    # cmd line options
    CMD_LINE_OPTIONS="$@"
    while [[ $# -gt 0 ]]; do
        ARG_VALUE="$1"
        
        # iterate over all cmd line arguments and set value
        # to config variables 
        case $ARG_VALUE in 
            -n|--number-of-elements)
            NUMBER_OF_ELEMENTS="$2"
            shift
            shift
            ;;
            -p|--path)
            ARCHIVES_PATH="$2"
            shift
            shift
            ;;
            -h|--help)
            HELP_RUN=1
            shift
            ;;
            *)
            NOT_RECOGNIZED_ARGS+=("$1")
            shift
            ;;
        esac
    done
}

# print info about help an usage
function print-help() {
    echo "usage: $0 -n [NUMBER OF ELEMENTS] -p [PATH TO ARCHIVES]"
    echo -e "\n\t-n|--number-of-elements\t   Number of newest elements to be kept"
    echo -e "\t-p|--path\t\t   Path to archived backup files"
    echo -e "\t-h|--help\t\t   Prints info about usage and help"
}

function check-if-any-archive-exists() {
    local DIR="$1"
    # check if any archive file is found
    if [[ "$DIR" == "." ]]; then
        local LS_EXIT_CODE="$(ls *$EXTENSION > /dev/null 2>&1; echo $?)"
    else
        local LS_EXIT_CODE="$(ls $DIR*$EXTENSION > /dev/null 2>&1; echo $?)"
    fi

    if [[ $LS_EXIT_CODE -eq 0 ]]; then
        local RETURN=0
    else
        local RETURN=1
    fi

    return $RETURN
}

# get sorted list of the archive files
# params
# $1 = path to folder where backup archives are stored
function get-sorted-list-of-archives() {
    local DIR="$1"
    # check if any archive file is found
    echo -n "$(ls $DIR*$EXTENSION --sort=time)"
}

# removes all archives except the first n
# params:
# $1 = number of elements that should be kept
# $2 = path to folder where backup archives are stored
function remove-all-elements-besides-first-n-elements() {
    local NUMBER_OF_ELEMENTS_KEPT="$1"
    local ARCHIVES_PATH="$2"
    # list of all archive files in the choosen directory
    LIST_OF_ELEMENTS=($(get-sorted-list-of-archives $ARCHIVES_PATH))
    echo "List of archives: ${LIST_OF_ELEMENTS[@]}"
    # calculate the index of the last element (length of array minus 1)
    INDEX_LAST_ELEMENT=$(expr ${#LIST_OF_ELEMENTS[@]} - 1)
    # create sequence to iterate over
    REMOVE_SEQ=$(seq $NUMBER_OF_ELEMENTS_KEPT $INDEX_LAST_ELEMENT)
    # iterate over all elements in the list (backup archives)
    # exclude the first N elements to keep the newest N backup archives
    # remove all remainig elements
    for ELEMENT in $REMOVE_SEQ; do
        # normalise path of archive
        ARCHIVE_FILE_NAME=${LIST_OF_ELEMENTS[ELEMENT]}
        echo "doing task: rm $ARCHIVE_FILE_NAME"
    done
}

function main {
    parse-args "$@"
    # echo "-n $NUMBER_OF_ELEMENTS"
    # echo "-p $ARCHIVES_PATH"
    if [[ "${#NOT_RECOGNIZED_ARGS[@]}" -gt 0 ]]; then
        echo -n "the following options where not recognized:"
        for option in "${NOT_RECOGNIZED_ARGS[@]}"; do
            echo -n "'$option'"
        done
        echo -e "\n"
    fi

    if [[ $HELP_RUN -eq 1 ]] || ([[ -z ${NUMBER_OF_ELEMENTS:+x} ]] || [[ -z ${ARCHIVES_PATH:+x} ]]); then
        print-help
    elif [[ $(check-if-any-archive-exists "$ARCHIVES_PATH"; echo $?) -ne 0 ]]; then
            echo "No files with extension '$EXTENSION' found at $ARCHIVES_PATH"
        else
            remove-all-elements-besides-first-n-elements "$NUMBER_OF_ELEMENTS" "$ARCHIVES_PATH"
    fi
}

main "$@"