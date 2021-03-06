#!/bin/bash

IFS=$'\n'
count1=0
count2=0
count3=0
count4=0
count5=0

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

echo "$(format_date) - Executing the episode metadata job. This may take a few moments if a large number of videos have just been downloaded."

cd "$MEDIADIR/youtube"

for i in $(find . -type f -name "*.info.json" -not -name "*Channel Info*" -not -name "*Playlist Info*")
do
  noext=${i%.*.*}
  if [[ -e "$noext.metadata" ]]; then
    count1=$((count1+1))
  else
    cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8],"directors="+.uploader' > "$noext.metadata"
    count2=$((count2+1))
  fi
done

echo "$(format_date) - $count2 episode metadata files were created and $count1 pre-existing files were skipped."

for i in $(find . -type f -name "*.metadata" -not -name "show.metadata")
do
  releaseline=$(awk '/release=/{ print NR; exit }' "$i")
  if [[ releaseline -gt 4 ]]; then
    startline=4
    endline=$((releaseline-1))
    status=$(awk '/^[[:blank:]]/' "$i")
    if [[ -z "$status" ]]; then
      for (( j=$startline; j<=$endline; j++ )); do
        sed -i "${j}s/^/\ /" "$i"
      done
      count3=$((count3+1))
    else
      count4=$((count4+1))
    fi
  else
    count5=$((count5+1))
  fi
done

echo "$(format_date) - $count3 episode descriptions were indented, $count4 descriptions were previously indented, and $count5 episodes have single line descriptions."
echo

unset IFS
