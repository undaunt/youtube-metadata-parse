#!/bin/bash

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

playlist_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/yt-dlc-playlists.conf" --batch-file "$STORAGEDIR/config/youtube_playlist_list.conf" --exec "touch $MEDIADIR/youtube/new.downloads"
  playlist_check
}

channel_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/yt-dlc-channels.conf" --batch-file "$STORAGEDIR/config/youtube_channel_list.conf" --exec "touch $MEDIADIR/youtube/new.downloads"
  channel_check
}

playlist_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo "$(format_date) - Looping through and executing the playlist job again."
    playlist_dl
  else
    echo "$(format_date) - All playlist files are downloaded. Executing the youtube-dlc channels job."
    channel_dl
  fi
}

channel_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo "$(format_date) - Looping through and executing the channels job again."
    channel_dl
  else
    echo "$(format_date) - All playlist and channels are currently up to date."
    echo "$(format_date) - Executing the episode metadata job."
  fi
}

echo $(format_date) - Executing the youtube-dlc playlist job.

playlist_dl

"$STORAGEDIR/bin/youtube-episode-metadata.sh"

echo "$(format_date) - Executing the show metadata job."

"$STORAGEDIR/bin/youtube-show-metadata.sh"

echo "$(format_date) - All youtube-dlc jobs are now complete."
