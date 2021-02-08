#!/bin/bash

IFS=$'\n'
count1=0
count2=0

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

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
        echo "$(format_date) - Grabbing playlist thumbnail for $playlist."
        curl -o "$folder/poster.jpg" "$shorturl"
        count2=$((count2+1))
    fi
done

echo "$(format_date) - $count2 playlist poster thumbnails were downloaded and $count1 pre-existing posters were skipped."
echo "$(format_date) - Executing the channel thumbnail job."

for i in $(find . -type f \( -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*" \) -path "*[UC*")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    channel=$(echo `basename "$folder"` | awk '{print substr( $0, 1, length($0)-39 ) }')

    if [[ -e "$folder/poster.jpg" ]]; then
        count1=$((count1+1))
        :
    else
        url=$( jq -r '[.thumbnails[] | .url][0]' )
        shorturl=${url%\=*}
        echo "$(format_date) - Grabbing channel thumbnail for $channel."
        curl -o "$folder/poster.jpg" "$shorturl"
        count2=$((count2+1))
    fi
done
echo "$(format_date) - $count2 channel poster thumbnails were downloaded and $count1 pre-existing posters were skipped."

unset IFS
