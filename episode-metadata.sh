##/bin/bash
YT_DIR="/mnt/storage/media/youtube/"
IFS=$'\n'
count1=0
count2=0

cd "$YT_DIR"

for i in $(find . -type f -name "*.info.json" -not -name "*Channel Info*" -not -name "*Playlist Info*")
do
    noext=${i%.*.*}
    if [[ -e "$noext.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8],"writers=","directors="+.uploader' > "$noext.metadata"
        count2=$((count2+1))
    fi
done

echo "$count2 metadata files were created and $count1 pre-existing files were skipped."

unset IFS
