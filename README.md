# youtube-metadata-parse

A simple script to execute [youtube-dlc](https://github.com/pukkandan/yt-dlp) against a user's predefined playlists, reverse chronological playlists, and then channels, ensuring all playlists are populated before non-playlist videos from any channels.

After all files are downloaded, multiple sub-scripts will run to create metadata files for each episode as compatible with https://bitbucket.org/mjarends/extendedpersonalmedia-agent.bundle. They will:

* Create a .metadata file for each video, based on that video playlist .info.json file
* Create series and channel .metadata files, based off the separate playlist.info.json files (or channel playlist files).
* Hardlink the poster from every episode as alternate series posters.
* Hardlink and rename any .webp poster to .jpg to be detected by the Plex agent.

To get these scripts to work, do the following:

* Update both MEDIADIR and STORAGEDIR to required locations for content and bin/config files as required.
* Populate the channel and playlist list files referenced on lines 7 & 13 of yt-dlc-execute.sh - one channel or playlist per line.
* Run youtube-for-plex.sh.

# To do

* append with sed (or similar) the categories and tags data from a show's episode files into the show.metadata (currently pulling only first episode)

If anyone can assist with the to-do list, please feel free to open an issue or a pull request.
