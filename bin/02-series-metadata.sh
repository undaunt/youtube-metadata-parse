#!/bin/bash

IFS=$'\n'
count1=0
count2=0
count3=0
count4=0
count5=0
count6=0
count7=0
count8=0
count9=0

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

cd "$MEDIADIR/youtube"

for i in $(find "$(pwd)" -type f -name "*Channel Info*.info.json" -o -name "*Playlist Info*.info.json*")
do
folder=$(dirname "$i")
  if [[ -e "$folder/show.metadata" ]]; then
    count1=$((count1+1))
  else
    cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"actors="+.uploader,"studio=YouTube","collections="+.channel' > "$folder/show.metadata"
    count2=$((count2+1))
  fi
done

echo "$(format_date) - $count2 series metadata files were created and $count1 pre-existing files were skipped."

for i in $(find "$(pwd)" -type f -name "show.metadata" -not -path "*[UC*")
do
  folder=$(dirname "$i")
  cd "$folder"
  for j in $(find . -type f -name "*.info.json" | sort -n | sed -n '2 p')
  do
    if grep -q "release=" show.metadata; then
      count3=$((count3+1))
    else
      cat "$j"  | jq -r '"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8]' >> show.metadata
      cat "$j"  | jq -r '"genres="+(.categories|join(","))' >> show.metadata
      count4=$((count4+1))
    fi
  done
  cd ..
done

echo "$(format_date) - $count4 playlist metadata files were appended with release dates and genres while $count3 files were already up to date."

for i in $(find "$(pwd)" -type f -name "show.metadata" -path "*Videos*[UC*")
do
  folder=$(dirname "$i")
  cd "$folder"
  year=$(find "$(pwd)" -type d | sort -n | sed -n '2 p')
  cd "$year"
  for j in $(find "$(pwd)" -type f -name "*.info.json" | sort -n | sed -n '1 p')
  do
    if grep -q "release=" "../show.metadata"; then
      count5=$((count5+1))
    else
      cat "$j"  | jq -r '"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8]' >> "../show.metadata"
      cat "$j"  | jq -r '"genres="+(.categories|join(","))' >> "../show.metadata"
      count6=$((count6+1))
    fi
  done
  cd "$MEDIADIR/youtube"
done

for i in $(find "$(pwd)" -type f -name "show.metadata" -path "*Playlists*[UC*")
do
  count9=$((count9+1))
done

echo "$(format_date) - $count6 channel metadata files were appended with release dates and genres while $count5 files were already up to date."
echo "$(format_date) - $count9 channel-level playlist files have no episodic data."

for i in $(find . -type f -name "show.metadata")
do
  actorsline=$(awk '/actors=/{ print NR; exit }' "$i")
  if [[ actorsline -gt 4 ]]; then
  startline=4
  endline=$((actorsline-1))
  status=$(awk '/^[[:blank:]]/' "$i")
  if [[ -z "$status" ]]; then
    for (( j=$startline; j<=$endline; j++ )); do
      sed -i "${j}s/^/\ /" "$i"
    done
    count7=$((count7+1))
  else
    count8=$((count8+1))
  fi
else
  count9=$((count9+1))
fi
done

echo "$(format_date) - $count7 playlist and channel descriptions were indented, $count8 descriptions were previously indented, and $count9 have single line descriptions."
echo

unset IFS
