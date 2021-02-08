#!/bin/bash

IFS=$'\n'
count1=0
count2=0
url=

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    if [[ -e "$folder/poster.jpg" ]]; then
        count1=$((count1+1))
        :
    else
        url=$( jq -r '[.thumbnails[] | select(.url|test("hqdefault"))][0] | .url' info.json )
        shorturl=${$url%\?*}
        echo "URL is $url."
        echo "Short URL is $shorturl."
        curl -o "$folder/poster.jpg" "$shorturl"
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 show metadata files were created and $count1 pre-existing files were skipped."

unset IFS
