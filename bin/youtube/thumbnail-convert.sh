#!/bin/bash

IFS=$'\n'
count1=0
count2=0
count3=0
titlecount=1
newcount=0

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
        ln "$noext.webp" "$noext.jpg"
        count2=$((count2+1))
    fi
done

echo "$(format_date) - $count2 webp episode posters were hardlinked to jpg. $count1 pre-existing episode posters were skipped."

for d in $(find . -type d -name "* - [PL*" -o -name "* - Videos - [UC*")
do
    cd "$d"
    for i in $(find . -type f -name "*.jpg" -not -name "poster*.jpg" -exec ls {} +)
    do
        file=$(realpath "$i")
        if [[ ! -e "poster-$titlecount.jpg" ]]; then
            ln "$file" "poster-$titlecount.jpg"
            newcount=$((newcount+1))
        else
            count3=$((count3+1))
            :
        fi
        titlecount=$((titlecount+1))
    done
    titlecount=1
    cd ..
done

echo "$(format_date) - $newcount episode posters were hardlinked to series posters. $count3 pre-existing series posters were skipped."
echo

unset IFS
