#!/bin/bash

format_date() {
  date "+%m/%d/%Y %H:%M:%S"
}

playlist_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/youtube/playlists.conf" --batch-file "$STORAGEDIR/config/youtube/list_playlists.txt" --exec "touch $MEDIADIR/youtube/new.downloads"
  playlist_check
}

playlist_reverse_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/youtube/playlists.conf" --batch-file "$STORAGEDIR/config/youtube/list_reversed_playlists.txt" --exec "touch $MEDIADIR/youtube/new.downloads" --playlist-reverse
  playlist_reverse_check
}

channel_dl () {
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$STORAGEDIR/config/youtube/channels.conf" --batch-file "$STORAGEDIR/config/youtube/list_channels.txt" --exec "touch $MEDIADIR/youtube/new.downloads"
  channel_check
}

playlist_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo
    echo "$(format_date) - Some new playlist videos were downloaded."
    echo "$(format_date) - Looping through and executing the playlist job again to ensure there is no new content."
    echo
    playlist_dl
  else
    echo
    echo "$(format_date) - All playlist videos were already downloaded. Executing the youtube-dlc channels job."
    echo
    channel_dl
  fi
}

playlist_reverse_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo
    echo "$(format_date) - Some new reverse-playlist videos were downloaded."
    echo "$(format_date) - Looping through and executing the reverse-playlist job again to ensure there is no new content."
    echo
    playlist_reverse_dl
  else
    echo
    echo "$(format_date) - All reverse-playlist videos were already downloaded. Executing the youtube-dlc playlists job."
    echo
    playlist_dl
  fi
}

channel_check () {
  if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
    echo "$(format_date) - Some new channel videos were downloaded."
    echo "$(format_date) - Looping through and executing the channels job again to ensure there is no new content."
    echo
    channel_dl
  else
    echo
    echo "$(format_date) - All playlist and channel videos have been downloaded and are up to date."
    echo
  fi
}

echo
echo "$(format_date) - Beginning the youtube-dlc download and metadata parse jobs."
echo "$(format_date) - Executing the youtube-dlc reverse-playlist job."
echo

playlist_reverse_dl

"$STORAGEDIR/bin/youtube/episode-metadata.sh"

echo "$(format_date) - Executing the show metadata job."

"$STORAGEDIR/bin/youtube/series-metadata.sh"

echo "$(format_date) - Executing the playlist thumbnail job."

"$STORAGEDIR/bin/youtube/playlist-thumbnails.sh"

echo "$(format_date) - Executing the thumbnail hardlink jobs."

"$STORAGEDIR/bin/youtube/thumbnail-convert.sh"

echo "$(format_date) - All youtube-dlc jobs are now complete."
