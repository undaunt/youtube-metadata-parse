##/bin/bash
YT_DIR="/mnt/storage/media/youtube/"
IFS=$'\n'
count1=0
count2=0

cd "$YT_DIR"

for i in $(find . -type f -name "*Channel Info*.info.json")
do
    folder=$(realpath $i)
    if [[ -e "show.metadata" ]]; then
        count1=$((count1+1))
        :
    else
        cat "$i"  | jq -r '"[metadata]","title="+.title,"summary="+.description,"release=","studio=YouTube","genres="+(.tags|join(",")),"collections="+.channel,"actors="+.uploader' > "($folder/show.metadata)"
        count2=$((count2+1))
    fi
done

time=$(date +'%m/%d/%Y %r')

echo "$time - $count2 metadata files were created and $count1 pre-existing files were skipped."

unset IFS
