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
    echo "$(format_date) - Some new playlist videos were downloaded."
    echo "$(format_date) - Looping through and executing the playlist job again to ensure there is no new content."
    sleep 1
    playlist_dl
  else
    echo "$(format_date) - All playlist videos were already downloaded. Executing the youtube-dlc channels job."
    sleep 1
    channel_dl
  fi
}

channel_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo "$(format_date) - Some new channel videos were downloaded."
    echo "$(format_date) - Looping through and executing the channels job again to ensure there is no new content."
    sleep 1
    channel_dl
  else
    echo "$(format_date) - All playlist and channel videos have been downloaded and are up to date."
    echo "$(format_date) - Executing the episode metadata job. This may take a few moments if a large number of videos have just been downloaded."
    sleep 1
  fi
}

echo "$(format_date) - Beginning the youtube-dlc download and metadata parse jobs."
sleep 1
echo "$(format_date) - Executing the youtube-dlc playlist job."
sleep 1

playlist_dl

"$STORAGEDIR/bin/youtube-episode-metadata.sh"

echo "$(format_date) - Executing the show metadata job."
sleep 1

"$STORAGEDIR/bin/youtube-show-metadata.sh"

echo "$(format_date) - Executing the playlist thumbnail job."
sleep 1

"$STORAGEDIR/bin/youtube-playlist-thumbnail.sh"

echo "$(format_date) - All youtube-dlc jobs are now complete."
