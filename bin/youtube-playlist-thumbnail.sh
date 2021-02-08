#!/bin/bash

IFS=$'\n'
count1=0
count2=0
url=

cd "$MEDIADIR/youtube"

# Grab all thumbnails from the playlist level
for i in $(find . -type f \( -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*" \) -not -path "*[UC*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    basepath=$(basename "$folder")
    trim=${basepath%[*}
    playlist=${trim%???}

    if [[ -e "$folder/poster.jpg" ]]; then
        count1=$((count1+1))
        :
    else
        url=$( jq -r '[.thumbnails[] | select(.url|test("hqdefault"))][0] | .url' $i )
        shorturl=${url%\?*}
        curl -o "$folder/poster.jpg" "$shorturl" --silent
        echo "Grabbing playlist thumbnail for $playlist."
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 show metadata files were created and $count1 pre-existing files were skipped."

unset IFS

#        url1=$( jq -r '.thumbnails[] | select(.url|test("maxresdefault")) | .url' $i )
