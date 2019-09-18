#!/bin/bash
# shell script to create files for testing clean-up.sh

# get current dir where script is located in 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

DATES=("20190918140810" "20190918140811" "20190918140812" "20190918140814" "20190918140815" "20190918140816" "20190918140817" "20190918140818" "20190918140819" "20190918140820")

function get_date_string {
    echo -n "$(date +"%Y%m%d%H%M%S")"
}

function create_fake_file_name {
    FILE_DATE_INDEX="$1"
    FILE_NAME_PREFIX='confluence'
    FILE_NAME_DATE=${DATES[FILE_DATE_INDEX]}
    FILE_NAME_POSTFIX='backup.zip'
    echo -n "$FILE_NAME_PREFIX-$FILE_NAME_DATE-$FILE_NAME_POSTFIX"
}

function main {
    for i in `seq 0 9`; do
        touch "$(create_fake_file_name $i)"
    done
}
echo "creating test folders in $DIR"
main
echo "... done"