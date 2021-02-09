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
    folder2=$(basename "$d")
    echo "folder is $folder2"
    echo
    cd "$folder2"
    ls
#    for i in $(find . -type f -name "*.jpg" -not -name "poster*.jpg" -exec ls {} +)
#    do
#        file=$(realpath "$i")
#        if [[ ! -e "poster-$titlecount.jpg" ]]; then
#            echo "link $file to $folder/poster-$titlecount.jpg"
#            ln "$file" "$folder/poster-$titlecount.jpg"
#        else
#            count3=$((count3+1))
#            :
#        fi
#        titlecount=$((titlecount+1))
#    done
#    titlecount=1
done

#finalcount=$((titlecount-1))

#echo "$(format_date) - $finalcount episode posters were hardlinked to series posters. $count3 existing series posters were skipped."
#echo

unset IFS
