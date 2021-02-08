##/bin/bash

BINDIR="$STORAGEDIR/bin"
CONFDIR="$STORAGEDIR/config"
#NEW_DL=0

playlist_dl () {
  #NEW_DL=0
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$CONFDIR/yt-dlc-playlists.conf" --batch-file "$CONFDIR/youtube_playlist_list.conf" --exec "touch $MEDIADIR/youtube/new.downloads"
}

channel_dl () {
  #NEW_DL=0
  rm -f "$MEDIADIR/youtube/new.downloads"
  youtube-dlc --config-location "$CONFDIR/yt-dlc-channels.conf" --batch-file "$CONFDIR/youtube_channel_list.conf" --exec "touch $MEDIADIR/youtube/new.downloads"
}

echo "Executing the youtube-dlc playlist job."

playlist_dl

if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
  echo "Looping through and executing the playlist job again."
  playlist_dl
else
  echo "All playlist files are downloaded. Executing the youtube-dlc channels job."
  channel_dl
fi

if [[ -e "$MEDIADIR/youtube/new.downloads" ]]; then
  echo "Looping through and executing the channels job again."
  channel_dl
else
  echo "All playlist and channels are currently up to date."
fi
