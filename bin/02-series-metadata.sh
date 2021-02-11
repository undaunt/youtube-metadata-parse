#!/bin/bash

IFS=$'\n'
count1=0
count2=0
count3=0
count4=0
count5=0
count6=0

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    if [[ -e "$folder/show.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"actors="+.uploader,"studio=YouTube","collections="+.channel' > "$folder/show.metadata"
        count2=$((count2+1))
    fi
done

echo "$(format_date) - $count2 playlist metadata files were created and $count1 pre-existing files were skipped."

for i in $(find . -type f -name "show.metadata")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    cd "$folder"
    for j in $(find . -type f -name "*S01E1 *.info.json" -o -name "*S01E01 *.info.json*" -o -name "*S01E001 *.info.json*" -o -name "*S01E0001 *.info.json*")
    do
        if grep -q "release=" show.metadata; then
            count3=$((count3+1))
            :
        else
            cat "$j"  | jq -r '"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8]' >> show.metadata
            count4=$((count4+1))
        fi
        if grep -q "genres=" show.metadata; then
            :
        else
            cat "$j"  | jq -r '"genres="+(.categories|join(","))' >> show.metadata
        fi
    done
    cd ..
done

echo "$(format_date) - $count4 series metadata files were appended with release dates and genres while $count3 files were already up to date."
echo

unset IFS
