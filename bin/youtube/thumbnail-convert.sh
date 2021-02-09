#!/bin/bash

IFS=$'\n'
count1=0
count2=0
titlecount=1

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*.webp")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    noext=${file%.*}
    if [[ -e "$noext.jpg" ]]; then
        count1=$((count1+1))
        :
    else
        cp "$noext.webp" "$noext.jpg"
        count2=$((count2+1))
    fi
done

echo "$(format_date) - $count2 episode jpg posters were copied & renamed from webp. $count1 existing episode posters were skipped."
echo

for i in $(find . -type f -name "*.jpg" -not -name "poster.jpg")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    noext=${file%.*}
    if [[ ! -e "poster-$titlecount.jpg" ]]; then # if poster-1 doesn't exist
        ln "$noext.jpg" "poster-$titlecount.jpg" # hardlink EP1.poster to poster-1.jpg
        titlecount=$((titlecount+1)) # bump title to 2
    else
        count3=$((count3+1))
        :
    fi
done

finalcount=$((titlecount-1))

echo "$(format_date) - $finalcount episode posters were hardlinked to series posters. $count3 existing series posters were skipped."
echo

unset IFS
