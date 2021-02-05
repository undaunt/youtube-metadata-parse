##/bin/bash
YT_DIR="/mnt/storage/media/youtube/"
IFS=$'\n'
count1=0
count2=0

cd "$YT_DIR"

for i in $(find . -type f -name "*Playlist Info*.info.json")
do
    noext=${i%.*.*}
    if [[ -e "$noext.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary=","release=","studio="+.channel,"genres=","collections="+.uploader,"actors="' > "$noext.metadata"
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 metadata files were created and $count1 pre-existing files were skipped."

unset IFS
