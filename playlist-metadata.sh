##/bin/bash
YT_DIR="/mnt/storage/media/youtube/"
IFS=$'\n'
count1=0
count2=0

cd "$YT_DIR"

for i in $(find . -type f -name "*Playlist Info*.info.json")
do
    file=$(realpath "$i")
    folder=$(dirname "$file")
    if [[ -e "$folder/show.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary=","release=","studio=YouTube","genres=","collections="+.channel,"actors="+.uploader' > "$folder/show.metadata"
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 metadata files were created and $count1 pre-existing files were skipped."

unset IFS
