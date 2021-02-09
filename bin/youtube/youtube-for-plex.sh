#!/bin/bash

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

playlist_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/youtube/playlists.conf" --batch-file "$STORAGEDIR/config/youtube/playlist_list.txt" --exec "touch $MEDIADIR/youtube/new.downloads"
  playlist_check
}

channel_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/youtube/channels.conf" --batch-file "$STORAGEDIR/config/youtube/channel_list.txt" --exec "touch $MEDIADIR/youtube/new.downloads"
  channel_check
}

playlist_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo
    echo "$(format_date) - Some new playlist videos were downloaded."
    echo "$(format_date) - Looping through and executing the playlist job again to ensure there is no new content."
    echo
    sleep 2
    playlist_dl
  else
    echo
    echo "$(format_date) - All playlist videos were already downloaded. Executing the youtube-dlc channels job."
    echo
    sleep 2
    channel_dl
  fi
}

channel_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo "$(format_date) - Some new channel videos were downloaded."
    echo "$(format_date) - Looping through and executing the channels job again to ensure there is no new content."
    echo
    sleep 2
    channel_dl
  else
    echo
    echo "$(format_date) - All playlist and channel videos have been downloaded and are up to date."
    echo
    echo "$(format_date) - Executing the episode metadata job. This may take a few moments if a large number of videos have just been downloaded."
    sleep 2
  fi
}

echo
echo "$(format_date) - Beginning the youtube-dlc download and metadata parse jobs."
sleep 2
echo "$(format_date) - Executing the youtube-dlc playlist job."
echo
sleep 2

playlist_dl

"$STORAGEDIR/bin/youtube/episode-metadata.sh"

echo "$(format_date) - Executing the show metadata job."
sleep 2

"$STORAGEDIR/bin/youtube/series-metadata.sh"

echo "$(format_date) - Executing the playlist thumbnail job."
sleep 2

"$STORAGEDIR/bin/youtube/playlist-thumbnails.sh"

echo "$(format_date) - All youtube-dlc jobs are now complete."
