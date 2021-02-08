#!/bin/bash

IFS=$'\n'
count1=0
count2=0

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    if [[ -e "$folder/show.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"release=","actors="+.uploader,"studio=YouTube","genres="+(.tags|join(",")),"collections="+.channel' > "$folder/show.metadata"
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 show metadata files were created and $count1 pre-existing files were skipped."

unset IFS
