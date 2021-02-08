# youtube-metadata-parse

A simple script to execute [youtube-dlc](https://github.com/pukkandan/yt-dlp) against a user's predefined playlists, and then channels, ensuring all playlists are populated before non-playlist videos from any channels.

Then, after downloading all files, scrape .json.info files to create a .metadata file for each episode and show. These metadata files can be used to populate the fields required by https://bitbucket.org/mjarends/extendedpersonalmedia-agent.bundle.

Currently, it creates a metadata file per episode with the same name as the JSON file within a given playlist or channel folder. It also creates a show.metadata file in each playlist or channel folder.

* Update both MEDIADIR and STORAGEDIR to required locations for content and bin/config files as required.
* Populate the channel and playlist list files - one channel or playlist per line.
* Run yt-dlc-execute.sh.

# To do

* Pull the date of the first episode in a playlist to populate release date on show metadata
* Same as above, but with a check on the channel (date based) seasons for the first season release date
* append with sed (or similar) the categories and tags data from a show's episode files into the show.metadata

If anyone can assist with the to-do list, please feel free to open an issue or a pull request. I'll be uploading my current youtube-dlc configuration soon for reference purposes.
