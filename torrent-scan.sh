#!/bin/bash

# Look for any .torrent files in the watch directory.
# (Transmission can't see files added on a share written
# outside of the running container.)
for file in /download/Torrents/*.torrent
do
    # Add the file if it's still there (Transmission hasn't found it)
    if [ "$file" != "/download/Torrents/*.torrent" ]; then
        echo [`date +%Y-%m-%d\ %H:%M:%S.%3N\ %Z`] "$file" added to queue \(torrent-scan.sh\). >> /config/transmission.log
        /usr/bin/transmission-remote localhost:9091 -a "$file"
        mv "$file" "$file".added
        sleep 1
    fi
done
