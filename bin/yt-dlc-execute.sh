##/bin/bash

BINDIR="$STORAGEDIR/bin"
CONFDIR="$STORAGEDIR/conf"
NEW_DL=0

playlist_dl () {
  youtube-dlc --config-location "$CONFDIR/yt-dlc-playlists.conf" --batch-file "$CONFDIR/youtube_playlist_list.conf" --exec "sh -c 'NEW_DL=1'"
}

channel_dl () {
  youtube-dlc --config-location "$CONFDIR/yt-dlc-channels.conf" --batch-file "$CONFDIR/youtube_channel_list.conf" --exec "sh -c 'NEW_DL=1'"
}

echo "Executing the youtube-dlc playlist job."

playlist_dl

if [[ $NEW_DL == 1 ]]; then
  echo "Looping through and executing the playlist job again."
  playlist_dl
else
  echo "All playlist files are downloaded. Executing the youtube-dlc channels job."
  channel_dl
fi

if [[ $NEW_DL == 1 ]]; then
  echo "Looping through and executing the channels job again."
  channel_dl
else
  echo "All playlist and channels are currently up to date."
fi
