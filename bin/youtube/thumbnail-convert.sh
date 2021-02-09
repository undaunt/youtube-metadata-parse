#!/bin/bash

IFS=$'\n'
count1=0
count2=0
count3=0
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
        ln "$noext.webp" "$noext.jpg"
        count2=$((count2+1))
    fi
done

echo "$(format_date) - $count2 webp episode posters were hardlinked to jpg. $count1 existing episode posters were skipped."
echo

for d in $(find . -type d -name "* - [PL*" -o -name "* - Videos - [UC*")
do
    echo "d is $d"
    folder=$(realpath "$d")
    echo "folder is $folder"
    cd "$folder"
    for i in $(find . -type f -name "*.jpg" -not -name "poster*.jpg")
    do
        echo "i is $i"
        file=$(realpath "$i")
        echo "file is $file"
        noext=${file%.*}
        echo "noext is $noext"
        echo "poster-count is poster-$titlecount.jpg"
        if [[ ! -e "poster-$titlecount.jpg" ]]; then
            echo "link $file to $folder/poster-$titlecount.jpg"
            ln "$file" "$folder/poster-$titlecount.jpg"
            titlecount=$((titlecount+1))
            echo "titlecount is now $titlecount"
        else
            count3=$((count3+1))
            :
        fi
    done
    titlecount=1
    echo "titlecount back to 1 - $titlecount"
done

finalcount=$((titlecount-1))

echo "$(format_date) - $finalcount episode posters were hardlinked to series posters. $count3 existing series posters were skipped."
echo

unset IFS
