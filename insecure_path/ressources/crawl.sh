#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]];
then
    echo "Error: Usage ./crawl.sh [url] [file1] [file2] [file3]";
fi

if [[ -fr "$2" && -fr "$3" && -fr "$4" ]];
then
    echo "...Crawling..."
    while read l1; do
        while read l2; do
            while read l3; do
                echo -n "url : /$1/$l1/$l2/$l3/README --> " >> result.txt
                curl "$1/$l1/$l2/$l3/README" >> result.txt
            done <"$4"
        done <"$3"
    done <"$2"
    exit 1
fi
echo "Error: Invalid files"
exit 1;
