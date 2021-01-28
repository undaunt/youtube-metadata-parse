##/bin/bash
YT_DIR="/mnt/storage/media/youtube/"
IFS=$'\n'

cd "$YT_DIR"

for i in $(find -type f -name "*.info.json")
do
    noext=${i%.*.*}
    if [[ -e "$noext.metadata" ]]; then
        #echo "Skipping, metadata already exists."
        :
    else
        #echo "Creating metadata for `basename \"$noext\"`."
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"release="+.upload_date[0:4]+"-"+.upload_date[4:6]+"-"+.upload_date[6:8],"writers="+.uploader,"directors="+.uploader' > "$noext.metadata"
    fi
done
unset IFS
