#!/bin/bash

IFS=$'\n'
count1=0
count2=0
time=$(date +'%m/%d/%Y %r')

cd "$MEDIADIR/youtube"

for i in $(find . -type f \( -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*" \) -not -path "*[UC*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    playlist=$(echo `basename "$folder"` | awk '{print substr( $0, 1, length($0)-39 ) }')

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

echo "$time - $count2 show metadata files were created and $count1 pre-existing files were skipped."

unset IFS
