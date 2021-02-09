#!/bin/bash

IFS=$'\n'
count=0

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*.webp*")
do
    noext=${i%.*.*}
    if [[ -e "$noext.jpg" ]]; then
        :
    else
        cp "$noext.webp" "$noext.jpg"
        count=$((count+1))
    fi
done

echo "$(format_date) - $count episode jpg posters were copied and renamed from webp."
echo
sleep 2

unset IFS
